#include "VVexRiscv.h"
#include "VVexRiscv_VexRiscv.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint8_t memory[1024 * 1024];

uint32_t hti(char c) {
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 10;
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 10;
	return c - '0';
}

uint32_t hToI(char *c, uint32_t size) {
	uint32_t value = 0;
	for (uint32_t i = 0; i < size; i++) {
		value += hti(c[i]) << ((size - i - 1) * 4);
	}
	return value;
}

void loadHex(const char* path) {
	FILE *fp = fopen(path, "r");
	fseek(fp, 0, SEEK_END);
	uint32_t size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	char* content = new char[size];
	fread(content, 1, size, fp);

	int offset = 0;
	char* line = content;
	while (1) {
		if (line[0] == ':') {
			uint32_t byteCount = hToI(line + 1, 2);
			uint32_t nextAddr = hToI(line + 3, 4) + offset;
			uint32_t key = hToI(line + 7, 2);
			//printf("%d %d %d\n", byteCount, nextAddr,key);
			switch (key) {
			case 0:
				for (uint32_t i = 0; i < byteCount; i++) {
					memory[nextAddr + i] = hToI(line + 9 + i * 2, 2);
					//printf("%x %x %c%c\n",nextAddr + i,hToI(line + 9 + i*2,2),line[9 + i * 2],line[9 + i * 2+1]);
				}
				break;
			case 2:
				offset = hToI(line + 9, 4) << 4;
				break;
			case 4:
				offset = hToI(line + 9, 4) << 16;
				break;

			}
		}

		while (*line != '\n' && size != 0) {
			line++;
			size--;
		}
		if (size <= 1)
			break;
		line++;
		size--;
	}

	delete content;
}


#define testA1ReagFileWriteRef {1,10},{2,20},{3,40},{4,60}
#define testA2ReagFileWriteRef {5,1},{7,3}
uint32_t regFileWriteRefIndex = 0;
uint32_t regFileWriteRefArray[][2] = {
	testA1ReagFileWriteRef,
	testA1ReagFileWriteRef,
	testA2ReagFileWriteRef,
	testA2ReagFileWriteRef
};

#define TEXTIFY(A) #A

#define assertEq(x,ref) if(x != ref) {\
	printf("\n*** %s is %d but should be %d ***\n\n",TEXTIFY(x),x,ref);\
	error = 1;\
}

int main(int argc, char **argv, char **env) {
	int i;
	int clk;
	int error = 0;
	printf("start\n");
	loadHex("testA.hex");
	Verilated::commandArgs(argc, argv);
	// init top verilog instance
	VVexRiscv* top = new VVexRiscv;
	// init trace dump
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open("sim.vcd");

	// Reset
	top->clk = 1;
	top->reset = 1;
	top->iCmd_ready = 1;
	top->dCmd_ready = 1;
	for (uint32_t i = 0; i < 16; i++) {
		tfp->dump(i);
		top->eval();
	}
	top->reset = 0;

	// run simulation for 100 clock periods
	for (i = 16; i < 600; i+=2) {

		uint32_t iRsp_inst_next = top->iRsp_inst;
		if (top->iCmd_valid) {
			assert((top->iCmd_payload_pc & 3) == 0);
			uint8_t* ptr = memory + top->iCmd_payload_pc;
			iRsp_inst_next = (ptr[0] << 0) | (ptr[1] << 8) | (ptr[2] << 16) | (ptr[3] << 24);
		}

		if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address, regFileWriteRefArray[regFileWriteRefIndex][0]);
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data, regFileWriteRefArray[regFileWriteRefIndex][1]);
			printf("%d\n",i);

			regFileWriteRefIndex++;
			if(regFileWriteRefIndex == sizeof(regFileWriteRefArray)/sizeof(regFileWriteRefArray[0])){
				tfp->dump(i);
				tfp->dump(i+1);
				printf("SUCCESS\n");
				break;
			}
		}

		if(error) {
			tfp->dump(i);
			tfp->dump(i+1);
			break;
		}
		// dump variables into VCD file and toggle clock
		for (clk = 0; clk < 2; clk++) {
			tfp->dump(i+ clk);
			top->clk = !top->clk;

			top->eval();
		}

		top->iRsp_inst = iRsp_inst_next;

		if (Verilated::gotFinish())
			exit(0);
	}

	tfp->close();
	printf("done\n");
	exit(0);
}
