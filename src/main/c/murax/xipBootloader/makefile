CFLAGS= -march=rv32i  -mabi=ilp32 -g -O3 -MD
LFLAGS= -nostdlib  -mcmodel=medany -nostartfiles -ffreestanding -fPIC -fPIE


all: crt.S demo.S
	riscv64-unknown-elf-gcc -c $(CFLAGS) -o crt.o crt.S
	riscv64-unknown-elf-gcc $(CFLAGS) -o crt.elf crt.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping.ld,-Map,crt.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d crt.elf > crt.asm
	riscv64-unknown-elf-objcopy -O binary crt.elf crt.bin

	riscv64-unknown-elf-gcc -c $(CFLAGS) -o demo.o demo.S
	riscv64-unknown-elf-gcc $(CFLAGS) -o demo.elf demo.o $(LFLAGS)  -Wl,-Bstatic,-T,mapping.ld,-Map,demo.map,--print-memory-usage
	riscv64-unknown-elf-objdump -S -d demo.elf > demo.asm
	riscv64-unknown-elf-objcopy -O binary demo.elf demo.bin



clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf
	rm -f *.asm
	rm -f *.map