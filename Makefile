netlist: hardware/system/system.xmp
	make -C hardware/system -f system.make netlist

coregen: hardware/coregen/coregen.cgp hardware/coregen/*.xco
	make -C hardware/coregen

bitstream: $(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v hardware/verilog/src/*
	make -C hardware/verilog

image: image_sdcard.sh xillinux.img
	./image_sdcard.sh xillinux.img

program:

clean:
	make -C hardware/system -f system.make clean &&
	make -C hardware/coregen clean &&
	make -C hardware/verilog clean
