#!/bin/bash

# convert verilog imem description to disassembled file
#
# usage: convimem.sh <verilog Imem file> [output file]
#
# ex.
# input file
# ========
# @10000
# 3c
# 1d
# 00
# 10
# @10004
# 37
# bd
# 00
# 00
# @10008
# 00
# 00
# 80
# 20
# @1000c
# 3c
# 10
# 00
# 01
# @10010
# 8e
# 08
# 00
# 00
# @10014
# ae
# 08
# 00
# 04
# @10018
# a6
# 08
# 00
# 08
# @1001c
# a6
# 08
# 00
# 0a
# @10020
# a2
# 08
# 00
# 0c
# @10024
# a2
# 08
# 00
# 0d
# @10028
# a2
# 08
# 00
# 0e
# @1002c
# a2
# 08
# 00
# 0f
# @10030
# 00
# 00
# 00
# 00
# @10034
# 10
# 00
# ff
# fe
# ========
#
# output file
# ====================================================
# 00000000 <.text>:
# 	...
#    10000:	3c1d0010 	lui	sp,0x10
#    10004:	37bd0000 	ori	sp,sp,0x0
#    10008:	00008020 	add	s0,zero,zero
#    1000c:	3c100001 	lui	s0,0x1
#    10010:	8e080000 	lw	t0,0(s0)
#    10014:	ae080004 	sw	t0,4(s0)
#    10018:	a6080008 	sh	t0,8(s0)
#    1001c:	a608000a 	sh	t0,10(s0)
#    10020:	a208000c 	sb	t0,12(s0)
#    10024:	a208000d 	sb	t0,13(s0)
#    10028:	a208000e 	sb	t0,14(s0)
#    1002c:	a208000f 	sb	t0,15(s0)
#    10030:	00000000 	nop
#    10034:	1000fffe 	b	0x10030
# ====================================================
#

COMMAND=convimem.sh

AS=mipsisa32-elf-as
OBJDUMP=mipsisa32-elf-objdump

if [ -z $1 ]
then
    echo "usage: $COMMAND <verilog Imem file> [output file]" >&2
elif [ -f $1 ]
then
    TMP_FILE1=`mktemp`
# ------------------- awk script ------------------- #
if gawk '
BEGIN {

    # hex to decimal
    htd["0"] = 0
    htd["1"] = 1
    htd["2"] = 2
    htd["3"] = 3
    htd["4"] = 4
    htd["5"] = 5
    htd["6"] = 6
    htd["7"] = 7
    htd["8"] = 8
    htd["9"] = 9
    htd["a"] = 10
    htd["b"] = 11
    htd["c"] = 12
    htd["d"] = 13
    htd["e"] = 14
    htd["f"] = 15

    count = 4
    last_addr_dec = 0
    data = ""
    print "\t.text"
}

{
    if (substr($1, 1, 2) == "//") {     # if comment
      print "#" substr($0, 3, length($0) - 2)
    } else {
        if (substr($1, 1, 1) == "@") {
            if (count != 4) {
                print "error: " NR ": " sprintf("addr = 0x%x", addr_dec) ": not separated by word !!" > "/dev/stderr"
                exit 1
            }

            new_addr = substr($1, 2, length($1)-1)

            # convert addr. hex to decimal for executing space
            new_addr_dec = 0
            for (i = 1; i <= length(new_addr); i++) {
                new_addr_dec *= 16
                new_addr_dec += htd[substr(new_addr, i, 1)]
            }

            if (new_addr_dec < addr_dec) {
                print "error: " NR ": not inorder mem data !!" > "/dev/stderr"
                print "current addr = 0x" sprintf("%x", addr_dec) > "/dev/stderr"
                print "new addr = 0x" sprintf("%x", new_addr_dec) > "/dev/stderr"
                exit 1
            }

            # get space size
            if (new_addr_dec != addr_dec) {
                space = sprintf("%x", new_addr_dec - addr_dec)
                print "\t.space\t0x" space
            }
            # update last addr
            addr_dec = new_addr_dec
        } else if (count > 0) {
            if (length($1) != 2) {
                print "error: " NR ": " sprintf("addr = 0x%x", addr_dec) ": not byte mem data !!" > "/dev/stderr"
                print "> " $0 > "/dev/stderr"
                exit 1
            }

            data = data $1
            addr_dec++
            count--

            if (count == 0) {
                gsub("x", "0", data)
                # convert data. hex to decimal for remove redundant 0
                data_dec = 0
                for (i = 1; i <= length(data); i++) {
                    data_dec *= 16
                    data_dec += htd[substr(data, i, 1)]
                }
                data_hex = sprintf("%x", data_dec)

                printf("\t.word\t")
                if (length(data_hex) > 5)
                    print "0x" data_hex "\t# @" sprintf("%x", addr_dec -4)
                else
                    print "0x" data_hex "\t\t# @" sprintf("%x", addr_dec - 4)
                count = 4
                data = ""
            }
        }
    }
}
' $1 > $TMP_FILE1
# -------------------------------------------------- #
    then
        TMP_FILE2=`mktemp`
        if $AS $TMP_FILE1 -o $TMP_FILE2
        then
            if [ -z $2 ]
            then
                $OBJDUMP -d $TMP_FILE2
            else
                $OBJDUMP -d $TMP_FILE2 > $2
            fi
        fi
    fi
else
    echo "$COMMAND: cannot stat $1" >&2
fi
