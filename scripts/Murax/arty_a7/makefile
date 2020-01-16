ROOT=../../..
SWBASE=$(ROOT)/src/main/c/murax
SOCSW=hello_world
SOCMEMSRC=$(SWBASE)/$(SOCSW)/build/$(SOCSW).v
SOCMEM=build/soc.mem

TOP=Murax

all : build/latest.bit

../../../$(TOP).v : toplevel.v
	(cd ../../..; sbt "runMain vexriscv.demo.Murax_arty")

.PHONY: $(SOCMEMSRC)
$(SOCMEMSRC):
	mkdir -p build
	make -C $(SWBASE)/$(SOCSW)

$(SOCMEM) : $(SOCMEMSRC)
	cp -u $(SOCMEMSRC) $(SOCMEM)

build/vivado_project/fpga.runs/impl_1/toplevel.bit : toplevel.v arty_a7.xdc ../../../$(TOP).v
	mkdir -p build
	./make_vivado_project
	cp build/vivado_project/fpga.runs/impl_1/toplevel.bit build/latest.bit

build/soc.mmi: build/vivado_project/fpga.runs/impl_1/toplevel.bit
	./make_mmi_files

build/latest_soc_sw.bit : $(SOCMEM) build/soc.mmi
	rm -f updatemem.jou updatemem.log
	updatemem -force --meminfo build/soc.mmi --data $(SOCMEM) --bit build/latest.bit --proc dummy --out build/latest_soc_sw.bit
	cp build/latest_soc_sw.bit build/latest.bit

build/latest.bit : build/latest_soc_sw.bit

build/latest.mcs : build/latest.bit
	./make_mcs_file

prog : build/latest.bit
	./write_fpga

flash : build/latest.mcs
	./write_flash

clean-soc-sw:
	make -C $(SWBASE)/$(SOCSW) clean-all

soc-sw: clean-soc-sw $(SOCMEM)

.PHONY: clean
clean :
	rm -rf build
	mkdir build
	rm -f updatemem.jou
	rm -f updatemem.log

clean-sw: clean-soc-sw

clean-all : clean clean-sw
	rm -f ../../../$(TOP).v
	rm -f ../../../$(TOP).v_*
