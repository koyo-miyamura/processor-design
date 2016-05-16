#!/usr/bin/gawk -f

# convert verilog dmem description to assemble dmem description
# 
# usage: convmem.awk <verilog mem file>
#
# ex.
# input file
# ========
# @10000
# 00
# 00
# 00
# 03
# @10004
# 00
# 00
# 00
# 05
# @10008
# xx
# xx
# xx
# xx
# @10010
# 7f
# xx
# ff
# ff
# ========
#
# output file
# ========================================
#	.data
#	.space	0x10000
#	.word	0x3		# @10000
#	.word	0x5		# @10004
#	.word	0x0		# @10008
#	.space	0x4
#	.word	0x7f00ffff	# @10010
# ========================================
#

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
    print "\t.data"
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
