
# Input files
set mmi_file            "./soc.mmi"
set elf_file            "./soc.elf"
set source_bit_file     "./soc.bit"

# Output files
set output_bit_file "./soc_latest_sw.bit"

# Enable to turn on debug
set updatemem_debug 0

# Assemble bit file that can be downloaded to device directly
# Combine the original bit file, mmi file, and software elf to create the full bitstream

# Delete target file
file delete -force $output_bit_file

# Determine if the user has built the project and has the target source file
# If not, then use the reference bit file shipped with the project
if { ![file exists $source_bit_file] } {
    puts "\n********************************************"
    puts "INFO - File $source_bit_file doesn't exist as project has not been built"
    puts "       Using $reference_bit_file instead\n"
    puts "********************************************/n"
    set source_bit_file $reference_bit_file
}

# Banner message to console as there is no output for a few seconds
puts "  Running updatemem ..."

if { $updatemem_debug } {
    set error [catch {exec updatemem --debug --force --meminfo $mmi_file --data $elf_file --bit $source_bit_file --proc dummy --out $output_bit_file} result]
} else {
    set error [catch {exec updatemem --force --meminfo $mmi_file --data $elf_file --bit $source_bit_file --proc dummy --out $output_bit_file} result]
}

# Print the stdout from updatemem
puts $result

# Updatemem returns 0 even when there is an error, so cannot trap on error.  Having deleted output file to start, then
# detect if it now exists, else exit.
if { ![file exists $output_bit_file] } {
    puts "ERROR - $output_bit_file not made"
    return -1
} else {
    puts "\n********************************************"
    puts "  $output_bit_file correctly generated"
    puts "********************************************\n"
}
