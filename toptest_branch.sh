#!/bin/sh

#ncverilog -s +gui +access+r \
verilog \
	./*[!t].v \
	./top_branch_test.v \
	&

