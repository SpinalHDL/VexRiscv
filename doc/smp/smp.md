# Coherent interface specification

Features : 
- 3 buses (write, read, probe) composed of 7 streams
- Two data paths (read + write), but allow dirty/clean sharing by reusing the write data path
- Allow multi level coherent interconnect
- No ordering, but provide barrier


## Memory copy flags

| Name          | Description |
|---------------|-------------|
| Valid/Invalid | Line loaded or not |
| Shared/Unique | shared => multiple copy of the cache line in different caches, unique => no other caches has a copy of the line |
| Owner/Lodger  | lodger => copy of the line, but no other responsibility, owner => the given cache is responsible to write back dirty data and answer probes with the data |
| Clean/Dirty   | clean => match main memory, dirty => main memory need updates |

All combination of those cache flag are valid. But if a cache line is invalid, the other flags have no meaning.

Later in the spec, memory copy state can be described as :

- VSOC for (Valid, Shared, Owner, Clean)
- V-OC for (Valid, Shared or Unique, Owner, Clean)
- !V-OC for NOT (Valid, Shared or Unique, Owner, Clean)

## buses

One full interface is composed of 3 buses
- write (M -> S)
- read  (M -> S)
- probe (M <- S)

### Read bus

Composed of 3 stream :

| Name    | Direction | Description |
|---------|-----------|----------|
| readCmd | M -> S    | Emit memory read and cache management commands |
| readRsp | M <- S    | Return some data and/or a status from readCmd |
| readAck | M -> S    | Return ACK from readRsp |

### Write bus

Composed of 2 stream :

| Name    | Direction | Description |
|---------|-----------|----------|
| writeCmd | M -> S    | Emit memory writes and cache management commands |
| writeRsp | M <- S    | Return a status from writeCmd |

### Probe bus

| Name     | Direction | Description |
|----------|-----------|----------|
| probeCmd | M <- S    | Used for cache management |
| probeRsp | M -> S    | Acknowledgment |

## Transactions

This chapter define transactions moving over the 3 previously defined buses.
 
### Read commands

Emitted on the readCmd channel (master -> slave)

| Command     | Initial state | Description | Usage example |
|-------------|---------------|----------|------|
| readShared  | I---          | Get a memory copy as V--- | Want to read a uncached address |
| readUnique  | I---          | Get a memory copy as VUO- | Want to write a uncached address |
| readOnce    | I---          | Get a memory copy without coherency tracking | Instruction cache read |
| makeInvalid | VS--          | Make other memory copy as I--- and make yourself VUO- | Want to write into a shared line |
| readBarrier | N/A           | Ensure that the visibility of the memory operations of this channel do not cross the barrier | ISA fence |

makeInvalid should be designed with care. There is a few corner cases : 
- While a master has a inflight makeInvalid, a probe can change its state.
- Multi level coherent interconnect should be careful to properly move the ownership and not lose dirty data

I'm not sure yet if we should add some barrier transactions to enforce

### Read responses

Emitted on the readRsp channel (master <- slave)

success, abort, error, data shared/unique clean/dirty owner/notOwner

| Responses | From command | Description |
|-----------|---------------|----------|
| success   | makeInvalid, readBarrier | - |
| abort     | makeInvalid | A concurrent makeInvalid toke over |
| error     | readShared, readUnique, readOnce | Bad address |
| readData  | readShared, readUnique, readOnce | Data + coherency flags (V???) |

### Read ack

Emitted on the readAck channel (master -> slave), it carry no information, just a notification that the master received the read response

| Name         | From command | Description |
|--------------|---------------|----------|
| readSuccess   | * | - |

### Write commands

Write commands can be emitted on the writeCmd channel (master -> slave)

| Name         | Initial state | Description | Usage example |
|--------------|---------------|----------|----------|
| writeInvalid | V-O-          | Write the memory copy and update it status to I--- | Need to free the dirty cache line |
| writeShare   | V-O-          | Write the memory copy but keep it as VSO- | A probe makeShared asked it |
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

Both makeInvalid and makeShared could result into one of the following probeSuccess, writeInvalid, writeShare. 

To help the slave matching the writeInvalid and writeShare generated from a probe, those request are tagged with a matching ID.  

### Probe responses

Emitted on the probeRsp channel (master -> slave), it carry no information, just a notification that the corresponding command is done.

| Name         | From command | Description |
|--------------|---------------|----------|
| probeSuccess   | * | - |


## Channel interlocking

There is the streams priority (top => high priority, bottom => low priority )
- writeCmd, writeRsp, readRsp, readAck, probeRsp. Nothing should realy block them excepted bandwidth
- probeCmd. Can be blocked by inflight/generated writes
- readCmd. Can be blocked by inflight/generated probes

In other words : 

Masters can wait the completion of inflight writes before answering probes.
Slaves can emit probes and wait their completion before answering reads.
Slaves can wait on readAck incomming from generated readRsp before at all times
