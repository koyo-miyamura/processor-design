	.text
main:
	xor	$8,	$8,	$8
	lui	$8,	0x7fff
	ori	$8,	0xffff
	xor	$9,	$9,	$9
	ori	$9,	0xffff
	add	$10,	$8,	$9
	lui	$8,	1
	sw	$10,	0($8)
Loop:
	beq	$0,	$0,	Loop
