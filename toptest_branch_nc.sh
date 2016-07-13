
#!/bin/sh

ncverilog -s +gui +access+r \
	/home/koyo/verilog/*[!t].v \
	/home/koyo/verilog/top_branch_test.v \
	&
