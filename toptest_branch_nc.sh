
#!/bin/sh

ncverilog -s +gui +access+r \
	./*[!t].v \
	./top_branch_test.v \
	&
