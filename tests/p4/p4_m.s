	.text
	.space	0x10000

main:
	lui	$sp,0x10

	ori	$sp,$sp,0x0

	andi	$16,	$16,	0
	lui	$16,	 1

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5
	lw	$10,	0x8($16)	# -3
	lw	$11,	0xc($16)	# -5

##----------------------------- add ------------------------------##
	add	$12,	$8,	$9	# 3 + 5
	sw	$12,	0x100($16)

	add	$12,	$9,	$10	# 5 + (-3)
	sw	$12,	0x104($16)

	add	$12,	$8,	$11	# 3 + (-5)
	sw	$12,	0x108($16)

	add	$12,	$10,	$9	# (-3) + 5
	sw	$12,	0x10c($16)
	
	add	$12,	$11,	$8	# (-5) + 3
	sw	$12,	0x110($16)

	add	$12,	$10,	$11	# (-3) + (-5)
	sw	$12,	0x114($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	add	$12,	$9,	$8	# 0x7fffffff + 3
	sw	$12,	0x118($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x14($16)	# 0x80000000
	
	add	$12,	$9,	$8	# 0x80000000 + (-3)
	sw	$12,	0x11c($16)
##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- addu ------------------------------##
	addu	$12,	$8,	$9	# 3 + 5
	sw	$12,	0x200($16)

	addu	$12,	$9,	$10	# 5 + (-3)
	sw	$12,	0x204($16)

	addu	$12,	$8,	$11	# 3 + (-5)
	sw	$12,	0x208($16)

	addu	$12,	$10,	$9	# (-3) + 5
	sw	$12,	0x20c($16)
	
	addu	$12,	$11,	$8	# (-5) + 3
	sw	$12,	0x210($16)

	addu	$12,	$10,	$11	# (-3) + (-5)
	sw	$12,	0x214($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	addu	$12,	$9,	$8	# 0x7fffffff + 3
	sw	$12,	0x218($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x14($16)	# 0x80000000
	
	addu	$12,	$9,	$8	# 0x80000000 + (-3)
	sw	$12,	0x21c($16)
##-----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- addi ------------------------------##
	addi	$12,	$8,	5	# 3 + 5
	sw	$12,	0x300($16)

	addi	$12,	$9,	-3	# 5 + (-3)
	sw	$12,	0x304($16)

	addi	$12,	$8,	-5	# 3 + (-5)
	sw	$12,	0x308($16)

	addi	$12,	$10,	5	# (-3) + 5
	sw	$12,	0x30c($16)
	
	addi	$12,	$11,	3	# (-5) + 3
	sw	$12,	0x310($16)

	addi	$12,	$10,	-5	# (-3) + (-5)
	sw	$12,	0x314($16)

	lw	$9,	0x10($16)	# 0x7fffffff
	
	addi	$12,	$9,	3	# 0x7fffffff + 3
	sw	$12,	0x318($16)

	lw	$9,	0x14($16)	# 0x80000000
	
	addi	$12,	$9,	-3	# 0x80000000 + (-3)
	sw	$12,	0x31c($16)
##-----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- addiu ------------------------------##
	addiu	$12,	$8,	5	# 3 + 5
	sw	$12,	0x400($16)

	addiu	$12,	$9,	-3	# 5 + (-3)
	sw	$12,	0x404($16)

	addiu	$12,	$8,	-5	# 3 + (-5)
	sw	$12,	0x408($16)

	addiu	$12,	$10,	5	# (-3) + 5
	sw	$12,	0x40c($16)
	
	addiu	$12,	$11,	3	# (-5) + 3
	sw	$12,	0x410($16)

	addiu	$12,	$10,	-5	# (-3) + (-5)
	sw	$12,	0x414($16)

	lw	$9,	0x10($16)	# 0x7fffffff
	
	addiu	$12,	$9,	3	# 0x7fffffff + 3
	sw	$12,	0x418($16)

	lw	$9,	0x14($16)	# 0x80000000
	
	addiu	$12,	$9,	-3	# 0x80000000 + (-3)
	sw	$12,	0x41c($16)
##-----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- sub -------------------------------##
	sub	$12,	$9,	$8	# 5 - 3
	sw	$12,	0x500($16)

	sub	$12,	$8,	$9	# 3 - 5
	sw	$12,	0x504($16)

	sub	$12,	$8,	$11	# 3 - (-5)
	sw	$12,	0x508($16)

	sub	$12,	$10,	$9	# (-3) - 5
	sw	$12,	0x50c($16)
	
	sub	$12,	$10,	$11	# (-3) - (-5)
	sw	$12,	0x510($16)

	sub	$12,	$11,	$10	# (-5) - (-3)
	sw	$12,	0x514($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	sub	$12,	$9,	$8	# 0x7fffffff - (-3)
	sw	$12,	0x518($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x14($16)	# 0x80000000
	
	sub	$12,	$9,	$8	# 0x80000000 - 3
	sw	$12,	0x51c($16)
##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- subu -----------------------------##
	subu	$12,	$9,	$8	# 5 - 3
	sw	$12,	0x600($16)

	subu	$12,	$8,	$9	# 3 - 5
	sw	$12,	0x604($16)

	subu	$12,	$8,	$11	# 3 - (-5)
	sw	$12,	0x608($16)

	subu	$12,	$10,	$9	# (-3) - 5
	sw	$12,	0x60c($16)
	
	subu	$12,	$10,	$11	# (-3) - (-5)
	sw	$12,	0x610($16)

	subu	$12,	$11,	$10	# (-5) - (-3)
	sw	$12,	0x614($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	subu	$12,	$9,	$8	# 0x7fffffff - (-3)
	sw	$12,	0x618($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x14($16)	# 0x80000000
	
	subu	$12,	$9,	$8	# 0x80000000 - 3
	sw	$12,	0x61c($16)
##----------------------------------------------------------------##

	lw	$8,	0x18($16)	# 0xff00ff00
	lw	$9,	0x1c($16)	# 0xf0f0f0f0

##-------------------------- and, andi ---------------------------##

	and	$12,	$8,	$9	# 0xff00ff00 & 0xf0f0f0f0
	sw	$12,	0x700($16)
	andi	$12,	$8,	0xf0f0  # 0xff00ff00 & 0xf0f0
	sw	$12,	0x704($16)

##----------------------------------------------------------------##

##--------------------------- or, ori ----------------------------##

	or	$12,	$8,	$9	# 0xff00ff00 | 0xf0f0f0f0
	sw	$12,	0x800($16)
	ori	$12,	$8,	0xf0f0  # 0xff00ff00 | 0xf0f0
	sw	$12,	0x804($16)

##----------------------------------------------------------------##

##-------------------------- xor, xori ---------------------------##

	xor	$12,	$8,	$9	# 0xff00ff00 ^ 0xf0f0f0f0
	sw	$12,	0x900($16)
	xori	$12,	$8,	0xf0f0  # 0xff00ff00 ^ 0xf0f0
	sw	$12,	0x904($16)

##----------------------------------------------------------------##

##----------------------------- nor ------------------------------##

	nor	$12,	$8,	$9	# ~(0xff00ff00 | 0xf0f0f0f0)
	sw	$12,	0xa00($16)

##----------------------------------------------------------------##

	lw	$8,	0x20($16)	# 0xf0f00f0f
	lw	$9,	0x24($16)	# 0x0f0ff0f0

##------------------------ sll, srl ,sra -------------------------##

	sll	$12,	$8,	15	# 0xf0f00f0f << 15
	sw	$12,	0xb00($16)
	sll	$12,	$9,	16	# 0x0f0ff0f0 << 16
	sw	$12,	0xb04($16)

	srl	$12,	$8,	15	# 0xf0f00f0f >> 15
	sw	$12,	0xb08($16)
	srl	$12,	$9,	16	# 0x0f0ff0f0 >> 16
	sw	$12,	0xb0c($16)

	sra	$12,	$8,	15	# 0xf0f00f0f >>> 15
	sw	$12,	0xb10($16)
	sra	$12,	$9,	16	# 0x0f0ff0f0 >>> 16
	sw	$12,	0xb14($16)

##----------------------------------------------------------------##

	lw	$10,	0x28($16)	# 15
	lw	$11,	0x2c($16)	# 54

##---------------------- sllv, srlv ,srav ------------------------##

	sllv	$12,	$8,	$10	# 0xf0f00f0f << 15
	sw	$12,	0xc00($16)
	sllv	$12,	$9,	$10	# 0x0f0ff0f0 << 15
	sw	$12,	0xc04($16)
	sllv	$12,	$8,	$11	# 0xf0f00f0f << 54
	sw	$12,	0xc08($16)
	sllv	$12,	$9,	$11	# 0x0f0ff0f0 << 54
	sw	$12,	0xc0c($16)	

	srlv	$12,	$8,	$10	# 0xf0f00f0f >> 15
	sw	$12,	0xc10($16)
	srlv	$12,	$9,	$10	# 0x0f0ff0f0 >> 15
	sw	$12,	0xc14($16)
	srl	$12,	$8,	$11	# 0xf0f00f0f >> 54
	sw	$12,	0xc18($16)
	srlv	$12,	$9,	$11	# 0x0f0ff0f0 >> 54
	sw	$12,	0xc1c($16)

	srav	$12,	$8,	$10	# 0xf0f00f0f >>> 15
	sw	$12,	0xc20($16)
	srav	$12,	$9,	$10	# 0x0f0ff0f0 >>> 15
	sw	$12,	0xc24($16)
	srav	$12,	$8,	$11	# 0xf0f00f0f >>> 54
	sw	$12,	0xc28($16)
	srav	$12,	$9,	$11	# 0x0f0ff0f0 >>> 54
	sw	$12,	0xc2c($16)

##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5
	lw	$10,	0x8($16)	# -3
	lw	$11,	0xc($16)	# -5

##----------------------------- slt -----------------------------##
	slt	$12,	$9,	$8	# 5 < 3
	sw	$12,	0xd00($16)

	slt	$12,	$8,	$9	# 3 < 5
	sw	$12,	0xd04($16)

	slt	$12,	$8,	$11	# 3 < (-5)
	sw	$12,	0xd08($16)

	slt	$12,	$10,	$9	# (-3) < 5
	sw	$12,	0xd0c($16)
	
	slt	$12,	$10,	$11	# (-3) < (-5)
	sw	$12,	0xd10($16)

	slt	$12,	$11,	$10	# (-5) < (-3)
	sw	$12,	0xd14($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	slt	$12,	$9,	$8	# 0x7fffffff < (-3)
	sw	$12,	0xd18($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x14($16)	# 0x80000000
	
	slt	$12,	$9,	$8	# 0x80000000 < 3
	sw	$12,	0xd1c($16)
##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- sltu -----------------------------##
	sltu	$12,	$9,	$8	# 5 < 3
	sw	$12,	0xe00($16)

	sltu	$12,	$8,	$9	# 3 < 5
	sw	$12,	0xe04($16)

	sltu	$12,	$8,	$11	# 3 < (-5)
	sw	$12,	0xe08($16)

	sltu	$12,	$10,	$9	# (-3) < 5
	sw	$12,	0xe0c($16)
	
	sltu	$12,	$10,	$11	# (-3) < (-5)
	sw	$12,	0xe10($16)

	sltu	$12,	$11,	$10	# (-5) < (-3)
	sw	$12,	0xe14($16)

	lw	$8,	0x8($16)	# -3
	lw	$9,	0x10($16)	# 0x7fffffff
	
	sltu	$12,	$9,	$8	# 0x7fffffff < (-3)
	sw	$12,	0xe18($16)

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x14($16)	# 0x80000000
	
	sltu	$12,	$9,	$8	# 0x80000000 < 3
	sw	$12,	0xe1c($16)
##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- slti -----------------------------##
	slti	$12,	$9,	3	# 5 < 3
	sw	$12,	0xf00($16)

	slti	$12,	$8,	5	# 3 < 5
	sw	$12,	0xf04($16)

	slti	$12,	$8,	-5	# 3 < (-5)
	sw	$12,	0xf08($16)

	slti	$12,	$10,	5	# (-3) < 5
	sw	$12,	0xf0c($16)
	
	slti	$12,	$10,	-5	# (-3) < (-5)
	sw	$12,	0xf10($16)

	slti	$12,	$11,	-3	# (-5) < (-3)
	sw	$12,	0xf14($16)

	lw	$9,	0x10($16)	# 0x7fffffff
	
	slti	$12,	$9,	-3	# 0x7fffffff < (-3)
	sw	$12,	0xf18($16)

	lw	$9,	0x14($16)	# 0x80000000

	slti	$12,	$9,	3	# 0x80000000 < 3
	sw	$12,	0xf1c($16)
##----------------------------------------------------------------##

	lw	$8,	0x0($16)	# 3
	lw	$9,	0x4($16)	# 5

##----------------------------- sltiu -----------------------------##
	sltiu	$12,	$9,	3	# 5 < 3
	sw	$12,	0x1000($16)

	sltiu	$12,	$8,	5	# 3 < 5
	sw	$12,	0x1004($16)

	sltiu	$12,	$8,	-5	# 3 < (-5)
	sw	$12,	0x1008($16)

	sltiu	$12,	$10,	5	# (-3) < 5
	sw	$12,	0x100c($16)
	
	sltiu	$12,	$10,	-5	# (-3) < (-5)
	sw	$12,	0x1010($16)

	sltiu	$12,	$11,	-3	# (-5) < (-3)
	sw	$12,	0x1014($16)

	lw	$9,	0x10($16)	# 0x7fffffff
	
	sltiu	$12,	$9,	-3	# 0x7fffffff < (-3)
	sw	$12,	0x1018($16)

	lw	$9,	0x14($16)	# 0x80000000

	sltiu	$12,	$9,	3	# 0x80000000 < 3
	sw	$12,	0x101c($16)
##----------------------------------------------------------------##

Loop:
	beq	$0,	$0,	Loop

	.data
	.space	0x10000

	.word	0x3		# @10000
	.word	0x5		# @10004
	.word	0xfffffffd	# @10008
	.word	0xfffffffb	# @1000c
	.word	0x7fffffff	# @10010
	.word	0x80000000	# @10014
	.word	0xff00ff00	# @10018
	.word	0xf0f0f0f0	# @1001c
	.word	0xf0f00f0f	# @10020
	.word	0xf0ff0f0	# @10024
	.word	0xf		# @10028
	.word	0x36		# @1002c
