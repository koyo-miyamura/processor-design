##------   �ꥻ�åȤ��㳰����  -----##
# @7c00
reset:
	ori	$16,	$0,	0x8000  # 0x8000���Ϥ��ͤ򥫥��󥿤Ȥ����Ѥ���
	sw	$0,     0x0($16)        # �����󥿤ν����
	rfe

##------   level xx �γ��������ߤ��㳰����   ------##
# @yy00 (yy = xx << 2)
OINT_level_xx:
	ori	$16,	$0,	0x8000
	lw	$8,	0x0000($16)    # �����󥿤����ͤ������
	addi    $8,	$8,	1      # ������䤹
	sw      $8,     0x00yy($16)    # 0x80yy ���Ϥ˽񤭹���
	sw	$8,	0x0000($16)    # �����󥿤ι���
	rfe