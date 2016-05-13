
#!/bin/sh

ncverilog -s +gui +access+r \
	/home/koyo/verilog/*[!t].v \
	/home/koyo/verilog/top_test.v \
	&
