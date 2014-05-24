SSE=$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v

xillidemo.bit: src/ScaleSpaceExtrema.v xillydemo.cmd_log xillydemo.xst
	mkdir -p xst/projnav.tmp && \
	bash xillydemo.cmd_log

src/ScaleSpaceExtrema.v:
	cd src && ln -s $(SSE)

$(CHISEL_SIFT)/verilog/ScaleSpaceExtrema.v:
	make -C $(CHISEL_SIFT) zedboard

clean:
	rm -f src/ScaleSpaceExtrema.v && \
  find *.* ! -name 'xillydemo.xise' -a ! -name 'xillydemo.cmd_log' -a ! -name 'xillydemo.xst' -a ! -name 'xillydemo.prj' -a ! -name 'xillydemo.ut' -delete && \
  rm -rf xst _ngo xlnx_auto_0_xdb _xmsgs
