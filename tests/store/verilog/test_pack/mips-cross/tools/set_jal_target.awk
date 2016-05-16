#!/usr/bin/gawk -f

##----------------------------------------------##
#  set jal instruction's target addr
#
#  usage: set_jal_target -v INPUT=<disassembled program> -v OUTPUT=<output file> <disassembled program>
##----------------------------------------------##

BEGIN {

    JAL_LIST = "jal_list"

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

    # get jal targets in order
    i = 0
    while (getline < JAL_LIST > 0) {
        if ($2 == "R_MIPS_26") {
            jal_str[i] = $0
            jal_PCs[i] = $1
            jal_targets[i] = $3
            i++
        }
    }
    n = i

    # get functions's start addr
    in_text = 0  # 0: out of text segment  1: in text segment
    while (getline < INPUT > 0) {
        if (in_text == 1) {  # if in text segment
            if ($2 ~ "<*>:") {  # if function start
                addr = $1
                # convert addr. hex to decimal
                addr_dec = 0
                for (i = 1; i <= length(addr); i++) {
                    addr_dec *= 16
                    addr_dec += htd[substr(addr, i, 1)]
                }
                func_addrs[substr($2, 2, length($2) - 3)] = addr_dec  # get function's start addr
            }
        }

        if ($2 == ".text") {
            in_text = 1  # enter text segment
        }

        if ($2 == ".data" || $2 == ".rdata" || $2 == ".sdata" || $2 == ".bss") {
            in_text = 0  # leave text segment
        }

    }

    i = 0
    in_text = 0
}

{
    if (in_text == 1 && $3 == "jal") {   # if in text segment and jal instruction
        if (i == n) {
            print "error: do not match the number of jal instructions between " INPUT " and " JAL_LIST > "/dev/stderr"
            if (OUTPUT != "/dev/stdout") {
                system("rm -f " OUTPUT)
            }
            exit 1
        }

        if (jal_PCs[i] != $1) {
            print "error: " NR ": do not match jal instruction PC ???" > "/dev/stderr"
            print INPUT ": " $0 > "/dev/stderr"
            print JAL_LIST ": " jal_str[i] > "/dev/stderr"
            if (OUTPUT != "/dev/stdout") {
                system("rm -f " OUTPUT)
            }
            exit 1
        }

        target_addr = func_addrs[jal_targets[i]]

        if (target_addr == "") {
            print "error: " NR ": no such function: '" jal_targets[i] "'" > "/dev/stderr"
            if (OUTPUT != "/dev/stdout") {
                system("rm -f " OUTPUT)
            }
            exit 1
        }

        addr = $1
        # convert addr. hex to decimal
        addr_dec = 0
        for (j = 1; j <= length(addr); j++) {
            addr_dec *= 16
            addr_dec += htd[substr(addr, j, 1)]
        }

        if (addr_dec - (addr_dec % 0x10000000) != target_addr - (target_addr % 0x10000000)) {  # inst addr upper 4bits do not match target addr upper 6bit
            print "error: " NR ": can't set jal target addr. because upper 4bits do not match that of inst addr" > "/dev/stderr"
            print "instruction's addr: " sprintf("0x%08x", addr_dec) > "/dev/stderr"
            print "jal target addr   : " sprintf("0x%08x", target_addr) > "/dev/stderr"
            if (OUTPUT != "/dev/stdout") {
                system("rm -f " OUTPUT)
            }
            exit 1
        }

        jal_new = sprintf("%08x", 0x0c000000 + (target_addr / 4))
        print "   " $1 "\t" jal_new " \tjal\t" sprintf("0x%x", target_addr) " <" jal_targets[i] ">\t# modified" > OUTPUT
        i++
    } else {
        print $0 > OUTPUT
    }

    if ($2 == ".text") {
        in_text = 1  # enter text segment
    }

    if ($2 == ".data" || $2 == ".rdata" || $2 == ".sdata" || $2 == ".bss") {
        in_text = 0  # leave text segment
    }

}

END {
    if (i != n) {
        print "error: do not match the number of jal instructions between " INPUT " and " JAL_LIST > "/dev/stderr"
        if (OUTPUT != "/dev/stdout") {
            system("rm -f " OUTPUT)
        }
        exit 1
    }
}
