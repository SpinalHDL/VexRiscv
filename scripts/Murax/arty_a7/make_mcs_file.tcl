
# Input file
set source_bit_file     "./latest.bit"

# Output file
set output_mcs_file "./latest.mcs"

# Delete target file
file delete -force $output_mcs_file

# Determine if the user has built the project and has the target source file
# If not, then use the reference bit file shipped with the project
if { ![file exists $source_bit_file] } {
    puts "\n********************************************"
    puts "INFO - File $source_bit_file doesn't exist as project has not been built\n"
    puts "********************************************/n"
    error
}

# Create MCS file for base board QSPI flash memory
write_cfgmem -force -format MCS -size 16 -interface SPIx4 -loadbit " up 0 $source_bit_file" $output_mcs_file

# Check MCS was correctly made
if { ![file exists $output_mcs_file] } {
    puts "ERROR - $output_bit_file not made"
    return -1
} else {
    puts "\n********************************************"
    puts "  $output_mcs_file correctly generated"
    puts "********************************************\n"
}
