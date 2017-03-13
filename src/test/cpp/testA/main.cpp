#include "VVexRiscv.h"
#include "VVexRiscv_VexRiscv.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <stdint.h>
#include <cstring>
#include <string.h>

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

void loadHexImpl(string path) {
	FILE *fp = fopen(&path[0], "r");
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
	error = 1; \
	throw std::exception();\
}

class success : public std::exception { };

class Workspace{
public:


	string name;
	VVexRiscv* top;
	int i;
	int error;

	Workspace(string name){
		error = 0;
		this->name = name;
		top = new VVexRiscv;
	}

	virtual ~Workspace(){
		delete top;
	}

	Workspace* loadHex(string path){
		loadHexImpl(path);
		return this;
	}

	virtual void checks(){}
	void pass(){ throw success();}

	Workspace* run(uint32_t timeout = 1000){
		cout << "Start " << name << endl;

		// init trace dump
		Verilated::traceEverOn(true);
		VerilatedVcdC* tfp = new VerilatedVcdC;
		top->trace(tfp, 99);
		tfp->open((string(name)+ ".vcd").c_str());

		// Reset
		top->clk = 1;
		top->reset = 0;
		top->iCmd_ready = 1;
		top->dCmd_ready = 1;
		top->eval();
		top->reset = 1;
		top->eval();
		tfp->dump(0);
		top->reset = 0;
		top->eval();


		try {
			// run simulation for 100 clock periods
			for (i = 16; i < timeout*2; i+=2) {

				uint32_t iRsp_inst_next = top->iRsp_inst;
				if (top->iCmd_valid) {
					assertEq(top->iCmd_payload_pc & 3,0);
					//printf("%d\n",top->iCmd_payload_pc);
					uint8_t* ptr = memory + top->iCmd_payload_pc;
					iRsp_inst_next = (ptr[0] << 0) | (ptr[1] << 8) | (ptr[2] << 16) | (ptr[3] << 24);
				}

				checks();



				// dump variables into VCD file and toggle clock
				for (uint32_t clk = 0; clk < 2; clk++) {
					tfp->dump(i+ clk);
					top->clk = !top->clk;

					top->eval();
				}

				top->iRsp_inst = iRsp_inst_next;

				if (Verilated::gotFinish())
					exit(0);
			}
		} catch (const success e) {
			printf("SUCCESS\n");
		} catch (const std::exception& e) {
			std::cout << e.what();
		}



		tfp->dump(i);
		tfp->dump(i+1);
		tfp->close();
		return this;
	}
};

class TestA : public Workspace{
public:
	TestA() : Workspace("testA") {
		loadHex("../../resources/hex/testA.hex");
	}

	virtual void checks(){
		if(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_valid == 1 && top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address != 0){
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_address, regFileWriteRefArray[regFileWriteRefIndex][0]);
			assertEq(top->VexRiscv->writeBack_RegFilePlugin_regFileWrite_payload_data, regFileWriteRefArray[regFileWriteRefIndex][1]);
			//printf("%d\n",i);

			regFileWriteRefIndex++;
			if(regFileWriteRefIndex == sizeof(regFileWriteRefArray)/sizeof(regFileWriteRefArray[0])){
				pass();
			}
		}
	}
};

class RiscvTest : public Workspace{
public:
	RiscvTest(string name) : Workspace(name) {
		loadHex("../../resources/hex/" + name + ".hex");
	}

	virtual void checks(){

	}
};


string riscvTestMain[] = {
	"rv32ui-p-add.hex",
	"rv32ui-p-addi.hex",
	"rv32ui-p-and.hex",
	"rv32ui-p-andi.hex",
	"rv32ui-p-auipc.hex",
	"rv32ui-p-beq.hex",
	"rv32ui-p-bge.hex",
	"rv32ui-p-bgeu.hex",
	"rv32ui-p-blt.hex",
	"rv32ui-p-bltu.hex",
	"rv32ui-p-bne.hex",
	"rv32ui-p-j.hex",
	"rv32ui-p-jal.hex",
	"rv32ui-p-jalr.hex",
	"rv32ui-p-or.hex",
	"rv32ui-p-ori.hex",
	"rv32ui-p-simple.hex",
	"rv32ui-p-sll.hex",
	"rv32ui-p-slli.hex",
	"rv32ui-p-slt.hex",
	"rv32ui-p-slti.hex",
	"rv32ui-p-sra.hex",
	"rv32ui-p-srai.hex",
	"rv32ui-p-srl.hex",
	"rv32ui-p-srli.hex",
	"rv32ui-p-sub.hex",
	"rv32ui-p-xor.hex",
	"rv32ui-p-xori.hex"
};

string riscvTestMemory[] = {
	"rv32ui-p-lb.hex",
	"rv32ui-p-lbu.hex",
	"rv32ui-p-lh.hex",
	"rv32ui-p-lhu.hex",
	"rv32ui-p-lui.hex",
	"rv32ui-p-lw.hex",
	"rv32ui-p-sb.hex",
	"rv32ui-p-sh.hex",
	"rv32ui-p-sw.hex"
};



//isaTestsMulDiv = ["rv32ui-p-mul.hex",
//                  "rv32ui-p-mulh.hex",
//                  "rv32ui-p-mulhsu.hex",
//                  "rv32ui-p-mulhu.hex",
//                  "rv32ui-p-div.hex",
//                  "rv32ui-p-divu.hex",
//                  "rv32ui-p-rem.hex",
//                  "rv32ui-p-remu.hex"]


int main(int argc, char **argv, char **env) {
	Verilated::randReset(2);
	Verilated::commandArgs(argc, argv);
	printf("BOOT\n");
	TestA().run();

	for(const string &name : riscvTestMain){
		RiscvTest(name).run();
	}

	printf("exit\n");
	exit(0);
}
