	.text
	.space	0x10000

main:
	lui	$sp,0x10

	ori	$sp,$sp,0x0

	add	$16,	$0,	$0
	lui	$16,	1
	lw	$8,	0x0($16)
	sw	$8,	0x4($16)
	sh	$8,	0x8($16)
	sh	$8,	0xa($16)
	sb	$8,	0xc($16)
	sb	$8,	0xd($16)
	sb	$8,	0xe($16)
	sb	$8,	0xf($16)
Loop:
	beq	$0,	$0,	Loop

	.data
	.space	0x10000

	.word	0x1028182	# @10000

