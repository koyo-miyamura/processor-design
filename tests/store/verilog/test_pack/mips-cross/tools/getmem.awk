#!/usr/bin/gawk -f

##-------------------------------------##
# output instruction memory to Imem_u.dat
# output data memory to Dmem_u.dat
#
# usage: getmem.awk <disassembled program>
##-------------------------------------##

BEGIN {
    # if warning is on, print warning
    warning = "off"  # on or off

    inst_offset_addr = 0x10000  # start address of user space of instruction memory
    data_offset_addr = 0x10000  # start address of user space of data memory

    IMEM_OUT="Imem_u.dat"
    DMEM_OUT="Dmem_u.dat"

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

    # hex to binary
    htb["0"] = "0000"
    htb["1"] = "0001"
    htb["2"] = "0010"
    htb["3"] = "0011"
    htb["4"] = "0100"
    htb["5"] = "0101"
    htb["6"] = "0110"
    htb["7"] = "0111"
    htb["8"] = "1000"
    htb["9"] = "1001"
    htb["a"] = "1010"
    htb["b"] = "1011"
    htb["c"] = "1100"
    htb["d"] = "1101"
    htb["e"] = "1110"
    htb["f"] = "1111"

    # implemented instructions
    op["000000"] = "func" # -> check fnc
    op["000001"] = "bal" # -> check rt
    op["000010"] = "j"
    op["000011"] = "jal"
    op["000100"] = "beq"
    op["000101"] = "bne"
    op["000110"] = "blez"
    op["000111"] = "bgtz"
    op["001000"] = "addi"
    op["001001"] = "addiu"
    op["001010"] = "slti"
    op["001011"] = "sltiu"
    op["001100"] = "andi"
    op["001101"] = "ori"
    op["001110"] = "xori"
    op["001111"] = "lui"
    op["010000"] = "rfe"
    op["100000"] = "lb"
    op["100001"] = "lh"
    op["100011"] = "lw"
    op["100100"] = "lbu"
    op["100101"] = "lhu"
    op["101000"] = "sb"
    op["101001"] = "sh"
    op["101011"] = "sw"

    fnc["000000"] = "sll"
    fnc["000010"] = "srl"
    fnc["000011"] = "sra"
    fnc["000100"] = "sllv"
    fnc["000110"] = "srlv"
    fnc["000111"] = "srav"
    fnc["001000"] = "jr"
    fnc["001001"] = "jalr"
    fnc["100000"] = "add"
    fnc["100001"] = "addu"
    fnc["100010"] = "sub"
    fnc["100011"] = "subu"
    fnc["100100"] = "and"
    fnc["100101"] = "or"
    fnc["100110"] = "xor"
    fnc["100111"] = "nor"
    fnc["101010"] = "slt"
    fnc["101011"] = "sltu"

    rt["00001"] = "bgez"
    rt["10001"] = "bgezal"
    rt["10000"] = "bltzal"
    rt["00000"] = "bltz"

    # initialize
    print "// User Space" > IMEM_OUT  # write into 'new' Imem_u.dat (not append to existing Imem_u.dat)
    print "// User Space" > DMEM_OUT  # write into 'new' Dmem_u.dat (not append existing Dmem_u.dat)
    in_text = 0  # 0: out of text segment  1: in text segment
    in_data = 0  # 0: out of data segment  1: in data segment
    error = 0    # flag for error
}

{
    if (in_data == 1) {  # if in data segment
        if ($1 ~ /^([0-9]|[a-f])+:$/) {
            addr = substr($1, 1, length($1)-1)
            # convert addr. hex to decimal
            addr_dec = 0
            for (i = 1; i <= length(addr); i++) {
                addr_dec *= 16
                addr_dec += htd[substr(addr, i, 1)]
            }

	    if (addr_dec >= data_offset_addr) {  # if in user memory space
                print "@" addr > DMEM_OUT   # output to Dmem_u.dat
                data = $2
                print substr(data, 1, 2) > DMEM_OUT  #
                print substr(data, 3, 2) > DMEM_OUT  # output to Dmem_u.dat
                print substr(data, 5, 2) > DMEM_OUT  #
                print substr(data, 7, 2) > DMEM_OUT  #
            }
        }
    }

    if (in_text == 1) {  # if in text segment
        if ($1 ~ /^([0-9]|[a-f])+:$/) {
            inst_bin = htb[substr($2, 1, 1)] htb[substr($2, 2, 1)] htb[substr($2, 3, 1)] htb[substr($2, 4, 1)] htb[substr($2, 5, 1)] htb[substr($2, 6, 1)] htb[substr($2, 7, 1)] htb[substr($2, 8, 1)]
            op_field = substr(inst_bin, 1, 6)
            rt_field = substr(inst_bin, 12, 5)
            func_field = substr(inst_bin, 27, 6)
            inst_name =""

	    if (op_field in op) {
                if (op[op_field] == "func") {
                    if (func_field in fnc) {
                        inst_name = fnc[func_field]
                    }
                } else if (op[op_field] == "bal") {
                    if (rt_field in rt) {
                        inst_name = rt[rt_field]
                    }
                } else {
                    inst_name = op[op_field]
                }
            }

            if (inst_name == "") {
                # unimplemented instruction
                print "error: " NR ": unimplemented instruction '" $3 "' was detected"> "/dev/stderr"
                print "> " $0 > "/dev/stderr"
                print $3 ": op = " op_field "  func = " func_field "  Rt = " rt_field > "/dev/stderr"
                error = 1
                inst_name = $3
            }

            addr = substr($1, 1, length($1)-1)
            # convert addr. hex to decimal
            addr_dec = 0
            for (i = 1; i <= length(addr); i++) {
                addr_dec *= 16
                addr_dec += htd[substr(addr, i, 1)]
            }

            if (addr_dec >= inst_offset_addr) {  # if in user memory space

                if (warning == "on" && inst_name != $3) {  # does not match instruction name that disassembler printed
                    if (inst_name != "sll" || $3 != "nop") {  # do not print "nop is sll", because it occurs too many times
                        print "warning: " NR ": " $1 " " $3 " is " inst_name  # $1 is addr, and $3 is instruction name that disassembler printed
                    }
                }

                print "@" addr > IMEM_OUT  # output to Imem_u.dat
                inst = $2	  
                print substr(inst, 1, 2) > IMEM_OUT  #
                print substr(inst, 3, 2) > IMEM_OUT  # output to Imem_u.dat
                print substr(inst, 5, 2) > IMEM_OUT  #
                print substr(inst, 7, 2) > IMEM_OUT  #
            }
        }
    }

    if ($NF ~ /.text.*/){
        in_text = 1  # enter text segment
        in_data = 0  # leave data segment
    }

    if ($NF ~  /.data.*/ || $NF ~ /.rdata.*/ || $NF ~ /.sdata.*/ || $NF == /.bss.*/) {
        in_text = 0  # leave text segment
        in_data = 1  # enter data segment
    }

}

END {
    if (error == 1) {
        system("rm -f " IMEM_OUT " " DMEM_OUT)
        exit 1
    }
}
