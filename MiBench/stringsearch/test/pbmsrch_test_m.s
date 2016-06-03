	.file	1 "pbmsrch_test.c"
	.section .mdebug.meabi32
	.previous
	.data
	.space	0x10000

	.align	2
	.type	table,@object
	.size	table,1024
table:
	.word	0
	.space	1020
	.data
	.align	2
	.type	len,@object
	.size	len,4
len:
	.word	0
	.align	2
	.type	findme,@object
	.size	findme,4
findme:
	.word	0
	.align	2
$LC0:
	.ascii	"abb\000"
	.align	2
$LC1:
	.ascii	"you\000"
	.align	2
$LC2:
	.ascii	"not\000"
	.align	2
$LC3:
	.ascii	"it\000"
	.align	2
$LC4:
	.ascii	"dad\000"
	.align	2
$LC5:
	.ascii	"yoo\000"
	.align	2
$LC6:
	.ascii	"hoo\000"
	.data
	.align	2
$LC7:
	.word	$LC0
	.word	$LC1
	.word	$LC2
	.word	$LC3
	.word	$LC4
	.word	$LC5
	.word	$LC6
	.word	0
	.data
	.align	2
$LC8:
	.ascii	"cabbie\000"
	.align	2
$LC9:
	.ascii	"your\000"
	.data
	.align	2
$LC10:
	.ascii	"It isn't here\000"
	.align	2
$LC11:
	.ascii	"But it is here\000"
	.data
	.align	2
$LC12:
	.ascii	"hodad\000"
	.align	2
$LC13:
	.ascii	"yoohoo\000"
	.data
	.align	2
$LC14:
	.word	$LC8
	.word	$LC9
	.word	$LC10
	.word	$LC11
	.word	$LC12
	.word	$LC13
	.word	$LC13
	.align	2
$LC15:
	.word	1
	.word	0
	.word	-1
	.word	4
	.word	2
	.word	0
	.word	3
	.align	2
$LC16:
	.ascii	"CHECK FAILED !!\n\000"
	.align	2
$LC17:
	.ascii	"CHECK PASSED !!\n\000"
	.text
	.space	0x10000

	.align	2
	.globl	main
	.ent	main
main:
	lui	$sp,0x10

	ori	$sp,$sp,0x0

	.frame	$sp,128,$31		# vars= 96, regs= 6/0, args= 0, extra= 0
	.mask	0x801f0000,-12
	.fmask	0x00000000,0
	subu	$sp,$sp,128
	lui	$5,%hi($LC7) # high
	lui	$15,%hi($LC14) # high
	sw	$20,112($sp)
	sw	$18,104($sp)
	sw	$31,116($sp)
	sw	$19,108($sp)
	sw	$17,100($sp)
	sw	$16,96($sp)
	addiu	$3,$5,%lo($LC7) # low
	addiu	$7,$15,%lo($LC14) # low
	lw	$17,28($3)
	lw	$6,4($3)
	lw	$8,8($3)
	lui	$18,%hi($LC15) # high
	lw	$11,%lo($LC14)($15)
	lw	$25,12($3)
	lw	$9,16($3)
	lw	$10,20($3)
	lw	$16,24($3)
	lw	$2,4($7)
	lw	$12,8($7)
	lw	$13,12($7)
	addiu	$20,$18,%lo($LC15) # low
	lw	$24,%lo($LC7)($5)
	lw	$19,24($7)
	lw	$15,%lo($LC15)($18)
	lw	$14,16($7)
	lw	$18,20($7)
	sw	$6,4($sp)
	lw	$7,4($20)
	sw	$8,8($sp)
	sw	$17,28($sp)
	sw	$25,12($sp)
	sw	$9,16($sp)
	sw	$10,20($sp)
	sw	$16,24($sp)
	sw	$11,32($sp)
	sw	$2,36($sp)
	sw	$12,40($sp)
	sw	$13,44($sp)
	lw	$8,24($20)
	lw	$3,8($20)
	lw	$4,12($20)
	lw	$5,16($20)
	lw	$6,20($20)
	sw	$14,48($sp)
	sw	$18,52($sp)
	sw	$19,56($sp)
	sw	$15,64($sp)
	sw	$24,0($sp)
	sw	$7,68($sp)
	sw	$3,72($sp)
	sw	$4,76($sp)
	sw	$5,80($sp)
	sw	$6,84($sp)
	sw	$8,88($sp)
	.set	noreorder
	.set	nomacro
	beq	$24,$0,$L11
	move	$17,$0
	.set	macro
	.set	reorder

	move	$16,$0
	lui	$18,%hi($LC16) # high
	li	$19,-16777216			# 0xffffffffff000000
$L7:
	addu	$20,$16,$sp
	lw	$4,0($20)
	.set	noreorder
	.set	nomacro
	jal	init_search
	addu	$17,$17,1
	.set	macro
	.set	reorder

	lw	$4,32($20)
	jal	strsearch
	lw	$24,64($20)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$2,$24,$L4
	addiu	$4,$18,%lo($LC16) # low
	.set	macro
	.set	reorder

	jal	myputs
	#.set	volatile
	sw	$0,0($19)
	#.set	novolatile
$L4:
	sll	$13,$17,2
	addu	$14,$13,$sp
	lw	$4,0($14)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$4,$0,$L7
	move	$16,$13
	.set	macro
	.set	reorder

$L11:
	li	$19,7			# 0x7
	.set	noreorder
	.set	nomacro
	beq	$17,$19,$L13
	lui	$2,%hi($LC16) # high
	.set	macro
	.set	reorder

	addiu	$4,$2,%lo($LC16) # low
$L12:
	jal	myputs
	lw	$31,116($sp)
	lw	$20,112($sp)
	lw	$19,108($sp)
	lw	$18,104($sp)
	lw	$17,100($sp)
	lw	$16,96($sp)
	move	$2,$0
	#.set	volatile
	sw	$0,-16777216
	#.set	novolatile
	.set	noreorder
	.set	nomacro
	j	$31
	addu	$sp,$sp,128
	.set	macro
	.set	reorder

$L13:
	lui	$12,%hi($LC17) # high
	.set	noreorder
	.set	nomacro
	b	$L12
	addiu	$4,$12,%lo($LC17) # low
	.set	macro
	.set	reorder

	.end	main
	.align	2
	.globl	myputs
	.ent	myputs
myputs:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	lb	$3,0($4)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L22
	move	$5,$0
	.set	macro
	.set	reorder

	move	$3,$4
	li	$6,-268435456			# 0xfffffffff0000000
$L20:
	lb	$8,0($3)
	addu	$5,$5,1
	addu	$3,$4,$5
	#.set	volatile
	sb	$8,0($6)
	#.set	novolatile
	lb	$7,0($3)
	#nop
	bne	$7,$0,$L20
$L22:
	.set	noreorder
	.set	nomacro
	j	$31
	move	$2,$5
	.set	macro
	.set	reorder

	.end	myputs
	.align	2
	.globl	init_search
	.ent	init_search
init_search:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	lb	$3,0($4)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L40
	move	$5,$0
	.set	macro
	.set	reorder

$L27:
	addu	$5,$5,1
	addu	$3,$4,$5
	lb	$6,0($3)
	#nop
	bne	$6,$0,$L27
$L40:
	move	$6,$5
	sw	$5,len
	lui	$5,%hi(table) # high
	addiu	$3,$5,%lo(table) # low
	move	$5,$0
$L33:
	addu	$5,$5,1
	sltu	$7,$5,256
	sw	$6,0($3)
	.set	noreorder
	.set	nomacro
	bne	$7,$0,$L33
	addu	$3,$3,4
	.set	macro
	.set	reorder

	move	$7,$6
	.set	noreorder
	.set	nomacro
	beq	$6,$0,$L44
	move	$5,$0
	.set	macro
	.set	reorder

	lui	$9,%hi(table) # high
	addiu	$8,$9,%lo(table) # low
	addu	$6,$6,-1
$L38:
	addu	$13,$4,$5
	lbu	$12,0($13)
	addu	$5,$5,1
	sll	$11,$12,2
	addu	$2,$11,$8
	sltu	$10,$5,$7
	sw	$6,0($2)
	.set	noreorder
	.set	nomacro
	bne	$10,$0,$L38
	addu	$6,$6,-1
	.set	macro
	.set	reorder

$L44:
	sw	$4,findme
	j	$31
	.end	init_search
	.align	2
	.globl	strsearch
	.ent	strsearch
strsearch:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	lw	$13,len
	lb	$3,0($4)
	addu	$9,$13,-1
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L72
	move	$11,$0
	.set	macro
	.set	reorder

$L49:
	addu	$11,$11,1
	addu	$3,$4,$11
	lb	$6,0($3)
	#nop
	bne	$6,$0,$L49
$L72:
	sltu	$3,$9,$11
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L74
	lui	$7,%hi(table) # high
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L55
	addiu	$14,$7,%lo(table) # low
	.set	macro
	.set	reorder

$L79:
	addu	$2,$4,$9
	lbu	$10,0($2)
	#nop
	sll	$5,$10,2
	addu	$8,$5,$14
	lw	$5,0($8)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$5,$0,$L77
	lui	$12,%hi(table) # high
	.set	macro
	.set	reorder

	addiu	$6,$12,%lo(table) # low
$L58:
	addu	$9,$9,$5
	sltu	$15,$9,$11
	.set	noreorder
	.set	nomacro
	beq	$15,$0,$L55
	addu	$3,$4,$9
	.set	macro
	.set	reorder

	lbu	$7,0($3)
	#nop
	sll	$25,$7,2
	addu	$24,$25,$6
	lw	$5,0($24)
	#nop
	bne	$5,$0,$L58
$L77:
	subu	$3,$9,$13
$L80:
	addu	$6,$4,$3
	lw	$12,findme
	addu	$10,$6,1
	move	$5,$0
	addu	$8,$13,-1
	sltu	$15,$5,$8
$L81:
	addu	$6,$12,$5
	.set	noreorder
	.set	nomacro
	beq	$15,$0,$L62
	addu	$7,$10,$5
	.set	macro
	.set	reorder

	lb	$3,0($6)
	lb	$24,0($7)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$3,$24,$L62
	addu	$5,$5,1
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$3,$0,$L81
	sltu	$15,$5,$8
	.set	macro
	.set	reorder

$L62:
	lb	$6,0($6)
	lb	$5,0($7)
	#nop
	slt	$8,$5,$6
	.set	noreorder
	.set	nomacro
	bne	$8,$0,$L67
	li	$3,1			# 0x1
	.set	macro
	.set	reorder

	slt	$10,$6,$5
	subu	$3,$0,$10
$L67:
	bne	$3,$0,$L60
	subu	$4,$9,$13
	.set	noreorder
	.set	nomacro
	j	$31
	addu	$2,$4,1
	.set	macro
	.set	reorder

$L60:
	addu	$9,$9,1
	sltu	$5,$9,$11
$L82:
	bne	$5,$0,$L79
$L74:
	.set	noreorder
	.set	nomacro
	j	$31
	li	$2,-1			# 0xffffffffffffffff
	.set	macro
	.set	reorder

$L55:
	.set	noreorder
	.set	nomacro
	bne	$5,$0,$L82
	sltu	$5,$9,$11
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	b	$L80
	subu	$3,$9,$13
	.set	macro
	.set	reorder

	.end	strsearch
	.align	2
	.globl	myputchar
	.ent	myputchar
myputchar:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	sll	$3,$4,24
	sra	$2,$3,24
	#.set	volatile
	sb	$2,-268435456
	#.set	novolatile
	j	$31
	.end	myputchar
	.align	2
	.globl	mystrlen
	.ent	mystrlen
mystrlen:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	lb	$3,0($4)
	#nop
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L90
	move	$5,$0
	.set	macro
	.set	reorder

$L88:
	addu	$5,$5,1
	addu	$3,$4,$5
	lb	$6,0($3)
	#nop
	bne	$6,$0,$L88
$L90:
	.set	noreorder
	.set	nomacro
	j	$31
	move	$2,$5
	.set	macro
	.set	reorder

	.end	mystrlen
	.align	2
	.globl	mystrncmp
	.ent	mystrncmp
mystrncmp:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, extra= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	addu	$6,$6,-1
	move	$7,$0
	sltu	$3,$7,$6
$L101:
	addu	$8,$4,$7
	.set	noreorder
	.set	nomacro
	beq	$3,$0,$L93
	addu	$9,$5,$7
	.set	macro
	.set	reorder

	lb	$3,0($8)
	lb	$10,0($9)
	#nop
	.set	noreorder
	.set	nomacro
	bne	$3,$10,$L93
	addu	$7,$7,1
	.set	macro
	.set	reorder

	.set	noreorder
	.set	nomacro
	bne	$3,$0,$L101
	sltu	$3,$7,$6
	.set	macro
	.set	reorder

$L93:
	lb	$5,0($8)
	lb	$4,0($9)
	#nop
	slt	$6,$4,$5
	.set	noreorder
	.set	nomacro
	bne	$6,$0,$L91
	li	$3,1			# 0x1
	.set	macro
	.set	reorder

	slt	$2,$5,$4
	subu	$3,$0,$2
$L91:
	.set	noreorder
	.set	nomacro
	j	$31
	move	$2,$3
	.set	macro
	.set	reorder

	.end	mystrncmp
