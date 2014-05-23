SSE=$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v

.PHONY: netlist coregen bitstream bootfile image program clean all

all: program

hardware/system/implementation/system.ngc: hardware/system/system.xmp hardware/system/system.make
	make -C hardware/system -f system.make netlist

netlist: hardware/system/implementation/system.ngc

hardware/coregen/coregen.log: hardware/coregen/coregen.cgp hardware/coregen/*.xco
	make -C hardware/coregen

coregen: hardware/coregen/coregen.log

hardware/verilog/xillydemo.bit: netlist coregen hardware/cores/*.ngc $(SSE) hardware/verilog/src/*
	make -C hardware/verilog

bitstream: hardware/verilog/xillydemo.bit

hardware/boot/boot.bin: hardware/verilog/xillydemo.bit
	make -C hardware/boot

bootfile: hardware/boot/boot.bin

image: image_sdcard.sh xillinux.img
	./image_sdcard.sh xillinux.img

program: program_sdcard.sh bootfile
	./program_sdcard.sh hardware/boot/boot.bin

clean:
	make -C hardware/system -f system.make clean && \
	make -C hardware/coregen clean && \
	make -C hardware/verilog clean && \
	make -C hardware/boot clean
