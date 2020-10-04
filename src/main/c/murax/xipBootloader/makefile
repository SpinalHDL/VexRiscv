CFLAGS= -march=rv32i  -mabi=ilp32 -g -O3 -MD
LFLAGS= -nostdlib  -mcmodel=medany -nostartfiles -ffreestanding -fPIC -fPIE


all: crt.S demo.S
	riscv64-unknown-elf-gcc -c $(CFLAGS) -o crt.o crt.S
	riscv64-unknown-elf-gcc $(CFLAGS) -o crt.elf crt.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping_rom.ld,-Map,crt.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d crt.elf > crt.asm
	riscv64-unknown-elf-objcopy -O binary crt.elf crt.bin

	riscv64-unknown-elf-gcc $(CFLAGS) -o crt_ram.elf crt.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping.ld,-Map,crt_ram.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d crt_ram.elf > crt_ram.asm
	riscv64-unknown-elf-objcopy -O binary crt_ram.elf crt_ram.bin

	riscv64-unknown-elf-gcc -c $(CFLAGS) -o demo.o demo.S
	riscv64-unknown-elf-gcc $(CFLAGS) -o demo.elf demo.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping.ld,-Map,demo.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d demo.elf > demo.asm
	riscv64-unknown-elf-objcopy -O binary demo.elf demo.bin

	riscv64-unknown-elf-gcc $(CFLAGS) -o demo_rom.elf demo.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping_rom.ld,-Map,demo_rom.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d demo_rom.elf > demo_rom.asm
	riscv64-unknown-elf-objcopy -O binary demo_rom.elf demo_rom.bin

	riscv64-unknown-elf-gcc $(CFLAGS) -o demo_xip.elf demo.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping_xip.ld,-Map,demo_xip.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d demo_xip.elf > demo_xip.asm
	riscv64-unknown-elf-objcopy -O binary demo_xip.elf demo_xip.bin

clean-for-commit:
	rm -f *.o
	rm -f *.elf
	rm -f *.asm
	rm -f *.map
	rm -f *.d
	rm demo_rom.bin demo.bin crt_ram.bin

clean: clean-for-commit
	rm -f *.bin
