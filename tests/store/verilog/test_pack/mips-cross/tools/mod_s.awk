#!/usr/bin/gawk -f

##----------------------------------------------##
# This program
#   (1) insert instructions that initialize stack pointer
#   (2) insert '.space' instruction to move instruction to user space
#   (3) insert '.space' instruction to move data to user space
#
# usage: mod_s.awk -v OUTPUT=<output file> <assemble code>
##----------------------------------------------##

BEGIN {
    inst_offset_addr = 0x10000  # start address of user space of instruction memory
    data_offset_addr = 0x10000  # start address of user space of data memory
    sp_init = 0x100000          # initial value of stack pointer

    data_section_names[0] = ".bss"
    data_section_names[1] = ".rdata"
    data_section_names[2] = ".sdata"

    taboo_pseudo_insts[0] = ".comm"
    taboo_pseudo_insts[1] = ".lcomm"

    # if OUTPUT is not set
    if (OUTPUT == "") {
        OUTPUT = "/dev/stdout"
    }

    # initialize
    f1 = 0  # flag for (1)
    f2 = 0  # flag for (2)
    f3 = 0  # flag for (3)

    tpi_error = 0
}

{
    for (i = 0; data_section_names[i] != ""; i++) {
        if ($1 == data_section_names[i]) {
            print "warning: " NR ": convert '" data_section_names[i] "' to '.data'." > "/dev/stderr"
            gsub($1, ".data", $0)
        }
    }

    for (i = 0; taboo_pseudo_insts[i] != ""; i++) {
        if ($1 == taboo_pseudo_insts[i]) {
            print "error: " NR ": you can't use '" taboo_pseudo_insts[i] "'" > "/dev/stderr"
            tpi_error = 1
        }
    }

    print $0 > OUTPUT

    if (f1 == 0 && $1 == "main:") {
        upper = sp_init / 0x10000  # upper 16bit
        lower = sp_init % 0x10000  # lower 16bit
        # insert instructions that initialize stack pointer
        str_tmp = sprintf("\tlui\t$sp,0x%x\n", upper)
        print str_tmp > OUTPUT
        str_tmp = sprintf("\tori\t$sp,$sp,0x%x\n", lower)
        print str_tmp > OUTPUT
        f1 = 1  # finished (1)
    }

    if (f2 == 0 && $1 == ".text") {
        str_tmp = sprintf("\t.space\t0x%x\n", data_offset_addr)
        print str_tmp > OUTPUT
        f2 = 1  # finished (2)
    }

    if (f3 == 0 && $1 == ".data") {
        str_tmp = sprintf("\t.space\t0x%x\n", data_offset_addr)
        print str_tmp > OUTPUT
        f3 = 1  # finished (3)
    }
}

END {
    if (f1 == 0) {
        print "error: cannot find main function" > "/dev/stderr"
    }

    if (f2 == 0) {
        print "error: cannot find text segment" > "/dev/stderr"
    }

    if (f3 == 0) {
        print "warning: cannot find data segment" >  "/dev/stderr"
    }

    if (f1 == 0 || f2 == 0 || tpi_error == 1) {
        if (OUTPUT != "/dev/stdout") {
            system("rm -f " OUTPUT)
        }
        exit 1
    }
}
