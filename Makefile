netlist: hardware/system/system.xmp
	make -C hardware/system -f system.make netlist

coregen: hardware/coregen/coregen.cgp hardware/coregen/*.xco
	make -C hardware/coregen

bitstream: $(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v hardware/verilog/src/*
	make -C hardware/verilog

hardware/boot/boot.bin: hardware/verilog/xillydemo.bit
	make -C hardware/boot

bootfile: hardware/boot/boot.bin

image: image_sdcard.sh xillinux.img
	./image_sdcard.sh xillinux.img

program: program_sdcard.sh bootfile
	./program_sdcard.sh hardware/boot/boot.bin

clean:
	make -C hardware/system -f system.make clean &&
	make -C hardware/coregen clean &&
	make -C hardware/verilog clean &&
	make -C hardware/boot clean
