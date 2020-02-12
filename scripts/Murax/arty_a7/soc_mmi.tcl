#script to update the init values of RAM without re-synthesis

if {![info exists mmi_file]} {
     # Set MMI output file name
     set mmi_file "soc.mmi"
}
if {![info exists part]} {
    set part     "xc7a35ticsg324-1L"
}

# Function to swap bits
proc swap_bits { bit } {

    if { $bit > 23 } {return [expr {24 + (31 - $bit)}]}
    if { $bit > 15 } {return [expr {16 + (23 - $bit)}]}
    if { $bit > 7  } {return [expr {8  + (15 - $bit)}]}
    return [expr {7 - $bit}]
}

# If run from batch file, will need to open project, then open the run
# open_run impl_1

# Find all the RAMs, place in a list
set rams [get_cells -hier -regexp {.*core/system_ram/.*} -filter {REF_NAME == RAMB36E1 || REF_NAME == RAMB18E1}]

puts "[llength $rams] RAMs in total"
foreach m $rams {puts $m}

set mems [dict create]
foreach m $rams {
    set numbers [regexp -all -inline -- {[0-9]+} $m]
    dict set mems $numbers $m
}
set keys [dict keys $mems]
#set keys [lsort -integer $keys]
set rams []
foreach key $keys {
    set m [dict get $mems $key]
    puts "$key -> $m"
    lappend rams $m
}

puts "after sort:"
foreach m $rams {puts $m}
puts $rams

if { [llength $rams] == 0 } {
    puts "Error - no memories found"
    return -1
}

if { [expr {[llength $rams] % 4}] != 0 } {
    puts "Error - Number of memories not divisible by 4"
    return -1
}

set size_bytes [expr {4096*[llength $rams]}]
puts "Instruction memory size $size_bytes"

# Currently only support memory sizes between 16kB, (one byte per mem), and 128kB, (one bit per mem)
if { ($size_bytes < (4*4096)) || ($size_bytes > (32*4096)) } {
    puts "Error - Memory size of $size_bytes out of range"
    puts "        Script only supports memory sizes between 16kB and 128kB"
    return -1
}

# Create and open target mmi file
set fp [open $mmi_file {WRONLY CREAT TRUNC}]
if { $fp == 0 } {
    puts "Error - Unable to open $mmi_file for writing"
    return -1
}

# Write the file header
puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts $fp "<MemInfo Version=\"1\" Minor=\"15\">"
puts $fp "    <Processor Endianness=\"ignored\" InstPath=\"dummy\">"
puts $fp "        <AddressSpace Name=\"soc_side\" Begin=\"[expr {0x80000000}]\" End=\"[expr {0x80000000 + $size_bytes-1}]\">"
puts $fp "            <BusBlock>"

# Calculate the expected number of bits per memory
set mem_bits [expr {32/[llength $rams]}]

puts "mem_bits = $mem_bits"

set mem_info [dict create]

set i 0
foreach ram $rams {
    # Get the RAM location
    set loc_val [get_property LOC [get_cells $ram]]
    regexp {(RAMB.+_)([0-9XY]+)} $loc_val full ram_name loc_xy

    set memi [dict create ram $ram loc $loc_xy]

    set numbers [regexp -all -inline -- {[0-9]+} $ram]
    if { [llength $numbers] == 2 } {
        dict lappend mem_info [lindex $numbers 0] $memi
    } else {
        dict lappend mem_info [expr $i/4] $memi
    }
    incr i
}

set sorted_mem_info [dict create]
foreach {idx mems} $mem_info {
    foreach mem [lreverse $mems] {
        dict lappend sorted_mem_info $idx $mem
    }
}
foreach mems $sorted_mem_info {
    foreach mem $mems {
        puts $mem
    }
}

set lsb 0
set memlen [ expr 4096*8 / $mem_bits ]
foreach {idx mems} $sorted_mem_info {
    puts "idx=$idx"
    foreach mem $mems {
        puts "mem=$mem"
        set ram [dict get $mem ram]
        set loc [dict get $mem loc]
        set msb [expr $lsb+$mem_bits-1]
        set addr_start 0
        set addr_end [expr $memlen-1]
        puts "ram=$ram loc=$loc lsb=$lsb msb=$msb addr_start=$addr_start addr_end=$addr_end"
        puts $fp "                <!-- $ram -->"
        puts $fp "                <BitLane MemType=\"RAMB36\" Placement=\"$loc\">"
        puts $fp "                    <DataWidth MSB=\"$msb\" LSB=\"$lsb\"/>"
        puts $fp "                    <!--not used!--><AddressRange Begin=\"$addr_start\" End=\"$addr_end\"/>"
        puts $fp "                    <Parity ON=\"false\" NumBits=\"0\"/>"
        puts $fp "                </BitLane>"

        set lsb [expr ($msb+1)%32]
    }
}

puts $fp "            </BusBlock>"
puts $fp "        </AddressSpace>"
puts $fp "    </Processor>"
puts $fp "    <Config>"
puts $fp "        <Option Name=\"Part\" Val=\"$part\"/>"
puts $fp "    </Config>"
puts $fp "    <DRC>"
puts $fp "      <Rule Name=\"RDADDRCHANGE\" Val=\"false\"/>"
puts $fp "    </DRC>"
puts $fp "</MemInfo>"

close $fp
