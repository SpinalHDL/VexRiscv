# Coherent interface specification

Features : 
- 3 interface (write, read, probe) composed of 7 streams
- Two data paths (read + write), but allow dirty/clean sharing by reusing the write data path
- Allow multi level coherent interconnect
- No ordering, but provide barrier
- Allow cache-full and cache-less agents

## A few hint to help reading the spec

In order to make the spec more readable, there is some definitions :

### Stream

A stream is a primitive interface which carry transactions using a valid/ready handshake.

### Memory copy

To talk in a non abstract way, in a system with multiple caches, a given memory address can potentialy be loaded in multiple caches at the same time. So let's define that : 

- The DDR memory is named `main memory`
- Each cache line can be loaded with a part of the main memory, let's name that a `memory copy`

### Master / Interconnect / Slave

A master could be for instance a CPU cache, the side of the interconnect toward the main memory or toward a more general interconnect.

A slave could be main memory, the side of the interconnect toward a CPU cache or toward a less general interconnect. 

The spec will try to stay abstract and define the coherent interface as something which can be used between two agents (cpu, interconnect, main memory)

## Memory copy status

Memory copy, in other words, cache line, have more states than non coherent systems :

| Name          | Description |
|---------------|-------------|
| Valid/Invalid | Line loaded or not |
| Shared/Unique | shared => multiple copy of the cache line in different caches, unique => no other caches has a copy of the line |
| Owner/Lodger  | lodger => copy of the line, but no other responsibility, owner => the given cache is responsible to write back dirty data and answer probes with the data |
| Clean/Dirty   | clean => match main memory, dirty => main memory need updates |

All combination of those cache flag are valid. But if a cache line is invalid, the other status have no meaning.

Later in the spec, memory copy state can be described for example as :

- VSOC for (Valid, Shared, Owner, Clean)
- V-OC for (Valid, Shared or Unique, Owner, Clean)
- !V-OC for NOT (Valid, Shared or Unique, Owner, Clean)
- ...

## Coherent interface

One full coherent interface is composed of 3 inner interfaces, them-self composed of 7 stream described bellow as `interfaceName (Side -> StreamName -> Side -> StreamName -> ...)` 
- write (M -> writeCmd -> S -> writeRsp -> M)
- read  (M -> readCmd- > S -> readRsp -> M -> readAck -> S)
- probe (S -> probeCmd -> M -> probeRsp -> S)

### Read interface

Used by masters to obtain new memory copies and make copies unique (used to write them).

Composed of 3 stream :

| Name    | Direction | Description |
|---------|-----------|----------|
| readCmd | M -> S    | Emit memory read and cache management commands |
| readRsp | M <- S    | Return some data and/or a status from readCmd |
| readAck | M -> S    | Return ACK from readRsp to syncronize the interconnect status |

### Write interface

Used by masters to write data back to the memory and notify the interconnect of memory copies eviction (used to keep potential directories updated).

Composed of 2 stream :

| Name    | Direction | Description |
|---------|-----------|----------|
| writeCmd | M -> S    | Emit memory writes and cache management commands |
| writeRsp | M <- S    | Return a status from writeCmd |

### Probe interface

Used by the interconnect to order master to change their memory copies status and get memory copies owners data. 

Composed of 2 stream :

| Name     | Direction | Description |
|----------|-----------|----------|
| probeCmd | M <- S    | Used for cache management |
| probeRsp | M -> S    | Acknowledgment |

## Transactions

This chapter define transactions moving over the 3 previously defined interface (read/write/probe).
 
### Read commands

Emitted on the readCmd channel (master -> slave)

| Command     | Initial state | Description | Usage example |
|-------------|---------------|----------|------|
| readShared  | I---          | Get a memory copy as V--- | Want to read a uncached address |
| readUnique  | I---          | Get a memory copy as VUO- | Want to write a uncached address |
| readOnce    | I---          | Get a memory copy without coherency tracking | Instruction cache read |
| makeUnique  | VS--          | Make other memory copy as I--- and make yourself VUO- | Want to write into a shared line |
| readBarrier | N/A           | Ensure that the visibility of the memory operations of this channel do not cross the barrier | ISA fence |

makeUnique should be designed with care. There is a few corner cases : 
- While a master has a inflight makeUnique, a probe can change its state, in such case, the makeUnique become weak and invalidation is canceled. This is usefull for multi level coherent interconnects.
- Multi level coherent interconnect should be careful to properly move the ownership and not lose dirty data

I'm not sure yet if we should add some barrier transactions to enforce

### Read responses

Emitted on the readRsp channel (master <- slave)

readSuccess, readError, data shared/unique clean/dirty owner/notOwner

| Responses   | From command | Description |
|-------------|---------------|----------|
| readSuccess | makeUnique, readBarrier | - |
| readError   | readShared, readUnique, readOnce | Bad address |
| readData    | readShared, readUnique, readOnce | Data + coherency status (V---) |

### Read ack

Emitted on the readAck channel (master -> slave), it carry no information, just a notification that the master received the read response

| Name         | From command | Description |
|--------------|---------------|----------|
| readSuccess  | * | - |

### Write commands

Write commands can be emitted on the writeCmd channel (master -> slave)

| Name         | Initial state | Description | Usage example |
|--------------|---------------|----------|----------|
| writeInvalid | V-O-          | Write the memory copy and update it status to I--- | Need to free the dirty cache line |
| writeShare   | V-O-          | Write the memory copy but keep it as VSO- | A probe makeShared asked it |
| writeUnique  | VUO-          | Write the memory copy but keep it as VUO- | A probe probeOnce need to read the data |
| evict        | V---, !V-OD   | Notify the interconnect that the cache line is now I--- | Need to free a clean cache line |
| writeBarrier | N/A           | Ensure that the visibility of the memory operations of this channel do not cross the barrier | ISA fence |

### Write responses

Emitted on the writeRsp channel (master <- slave), it carry no information, just a notification that the corresponding command is done.

| Name         | From command | Description |
|--------------|---------------|----------|
| writeSuccess   | * | - |

### Probe commands

Probe commands can be emitted on the probeCmd channel (slave -> master)

| Name        | Description  | Usage example |
|-------------|-------------|---------------|
| makeInvalid | Make the memory copy I--- | Another cache want to make his shared copy unique to write it |
| makeShared  | Make the memory copy VS-- | Another cache want to read a memory block, so unique copy need to be shared |
| probeOnce   | Read the V-O- memory copy | A non coherent agent did a readOnce  |

makeInvalid and makeShared could result into one of the following probeSuccess, writeInvalid, writeShare

probeOnce can result into one of the following probeSuccess, writeShare, writeUnique

To help the slave matching the writeInvalid and writeShare generated from a probe, those request are tagged with a matching ID.  

### Probe responses

Emitted on the probeRsp channel (master -> slave), it carry no information, just a notification that the corresponding command is done.

| Name         | From command | Description |
|--------------|---------------|----------|
| probeSuccess   | * | - |


## Channel interlocking

This is a delicate subject as if everything was permited, it would be easy to end up with deadlocks.

There is the streams priority (top => high priority, bottom => low priority) A lower priority stream should not block a higher priority stream in order to avoid deadlocks.
- writeCmd, writeRsp, readRsp, readAck, probeRsp. Nothing should realy block them excepted bandwidth
- probeCmd. Can be blocked by inflight/generated writes
- readCmd. Can be blocked by inflight/generated probes

In other words : 

Masters can emit writeCmd and wait their writeRsp completion before answering probes commands.
Slaves can emit probeCmd and wait their proveRsp completion before answering reads.
Slaves can emit readRsp and wait on their readAck completion before doing anything else
