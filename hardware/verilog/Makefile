SSE=$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v

xillidemo.bit: $(SSE) xillydemo.cmd_log xillydemo.xst
	bash xillydemo.cmd_log

src/ScaleSpaceExtrema.v:
	cd src && ln -s $(SSE)

$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v:
	make -C $(CHISEL_SIFT) zedboard

clean:
	rm -f src/ScaleSpaceExtrema.v && \
  find *.* ! -name 'xillydemo.xise' -a ! -name 'xillydemo.cmd_log' -a ! -name 'xillydemo.xst' -a ! -name 'xillydemo.prj' -delete && \
  find ./ -type d ! -name 'src' -a ! -name '.' -exec rm -r {} \;
