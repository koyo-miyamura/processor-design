#!/usr/bin/gawk -f

##-------------------------------------------------------------##
# turn off delayed branch
#    1. swap branch (or jump) instruction and next instruction
#    2. decrement branch offset (because branch instruction's addr changed by swapping.)
#
# usage: offdb -v OUTPUT=<output file> <disassembled program>
##-------------------------------------------------------------##

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

    # if OUTPUT is not set
    if (OUTPUT == "") {
        OUTPUT = "/dev/stdout"
    }

    # initialize
    in_text = 0       # whether or not in text segment
    last_inst_br = 0  # whether or not last instruction is branch (or jump)
}

{
    if (in_text == 1) {  # if in text segment
        if ($1 ~ /^([0-9]|[a-f])+:$/) {
            inst_head = substr($3, 1, 1)  # get instruction's first charactor
            if (inst_head == "b" || inst_head =="j") {  # if this instruction is branch or jump
                if (last_inst_br == 1) {
                    print "error: " NR ": consective branch detected." > "/dev/stderr"
                    print "-------------------------------------------------------------" > "/dev/stderr"
                    print last_inst > "/dev/stderr"
                    print $0 > "/dev/stderr"
                    print "-------------------------------------------------------------" > "/dev/stderr"

                    if (OUTPUT != "/dev/stdout") {
                        system("rm -f " OUTPUT)
                    }
                    exit 1
                } else {
                    last_inst_br = 1  # set last-instruction-is-branch flag
                    if (inst_head == "b") {
                        branch_offset = 0
                        for (i = 5; i <= 8; i++) {
                            branch_offset *= 16
                            branch_offset += htd[substr($2, i, 1)]
                        }
                        branch_offset--  # decrement branch offset, because addr
		        new_branch_offset_hex = sprintf("%04x", branch_offset)
                        new_inst = substr($2, 1, 4) new_branch_offset_hex  # change branch offset (change lower 16bit)
                        gsub($2 " ", new_inst " ", $0)
                    }
                    last_inst = $0   # do not print, and remember this instruction
                    last_addr = $1   # remember addr + ":"
                }
            } else {
                if (last_inst_br == 1) {  # if last instruction is branch or jump, swap instruction
                    cur_inst = $0
                    cur_addr = $1
                    gsub(cur_addr, last_addr, cur_inst)    # change addr ( cur_addr in cur_inst is replaced by last_addr )
                    gsub(last_addr, cur_addr, last_inst)   # change addr ( last_addr in last_inst is replaced by cur_addr )
                    print cur_inst > OUTPUT
                    print last_inst > OUTPUT
                    last_inst_br = 0  # clear last-instruction-is-branch flag
                } else {
                    print $0 > OUTPUT
                }
            }
        } else if ($2 == ".data") {
            print $0 > OUTPUT
            in_text = 0  # leave text segment
        } else {
            print $0 > OUTPUT
        }
    } else {
        if ($2 == ".text") {
            in_text = 1  # enter text segment
        }
        print $0 > OUTPUT
    }
}
