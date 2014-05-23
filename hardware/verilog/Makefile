src/ScaleSpaceExtrema.v: $(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v
	cd src && ln -s $(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v

$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v:
	make -C $(CHISEL_SIFT) zedboard

clean:
	rm -f src/ScaleSpaceExtrema.v
