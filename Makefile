CHISEL_SIFT=/home/abuchan/projects/chisel-sift

netlist: hardware/system/system.xmp
	make -C hardware/system -f system.make netlist

image: image_sdcard.sh xillinux.img
	./image_sdcard.sh xillinux.img

program:

clean:
	make -C hardware/system -f system.make clean
