	.text
main:
	lui	$8,	1
	addi	$8,	$8,	5
	lw	$10,	0x0($8)    # ����ܡ��ߥ����饤�����
	                           # ����ܡ������ݸ��ȿ
	.data
	.word	0xffffffff	# @10000
	.word	0xffffffff	# @10004
	.word	0xffffffff	# @10008
