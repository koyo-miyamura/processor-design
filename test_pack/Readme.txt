�E�e�R���|�[�l���g�̊T�v

top_test.v : top���W���[���̃e�X�g�t�B�N�X�`���{��
            �p�����[�^�̐���
                IN_TOTAL     : �V���~���[�V��������(clock cycle)
                CYCLE        : �N���b�N�T�C�N������(ns)
                HALF_CYCLE   : �N���b�N�T�C�N�����Ԃ̔���(ns)
                IMEM_SIZE    : ���߃������̃T�C�Y(Byte)
                DMEM_SIZE    : �f�[�^�������̃T�C�Y(Byte)
                IMEM_LATENCY : ���߃������̃��C�e���V(clock cycle)
                DMEM_LATENCY : �f�[�^�������̃��C�e���V(clock cycle)
                STDOUT_ADDR  : ���̃A�h���X�ɑ΂�sb���߂����s����Ɗi�[���ꂽ�l�𕶎��Ƃ��ďo��
                EXIT_ADDR    : ���̃A�h���X�ɑ΂��X�g�A���߂����s����ƃV�~�����[�V�������I��

            ��܂��ȓ���̐���
	      �P�D���߃���������уf�[�^�������̓��e�����炩���ߏ��������t�@�C��(Imem.dat�CDmem.dat)����ǂݍ��݂܂��D
           	  ���߃������ɓǂݍ��ރt�@�C���́C���s���閽�߂�16�i���ŏ����ꂽ���̂ł��D

	      �Q�D��񃊃Z�b�g���s���C
    	          ���̌�C1�N���b�N���ƂɃ��[�v��for���[�v������āC�K���ȃN���b�N��(IN_TOTAL)�ŏI�����܂��D

	      �R�D�N���b�N�T�C�N�����ɁC�������̓ǂݏo���⏑�����݂�����΂��ꂼ���task�ŏ������܂��D

	      �S�Dfor���[�v���I�������C�v���Z�b�T�����̃��W�X�^�t�@�C���Ɋi�[���ꂽ�f�[�^�ƁC
    	          �������Ɋi�[���ꂽ�f�[�^�����ꂼ��t�@�C���ɏ����o���܂�(Dmem_out.dat, Reg_out.dat)�D

            ���ؕ��@
              ����ꂽ���W�X�^�ƃ������̃f�[�^�����炩���ߏ����������ꂼ��̊��Ғl�t�@�C���Ɣ�r���āC
              (UNIX�R�}���h��diff��p����)
              �v���Z�b�T�̋��������������ǂ������؂��܂��D

            �O�̃o�[�W��������̕ύX�_
              top_test.v �͎O�����񂩂璸���� top �� test_fixture �ɁC
                1. ���߃������C�f�[�^�������̃��C�e���V�̒��ߋ@�\
                2. �v���O��������o�͂��s�����߂� STDOUT_ADDR �̕t��
                3. �v���O�������疾���I�� verilog �̃V�~�����[�V�������I�������邽�߂� EXIT_ADDR �̕t��
              ���s�������̂ł��D

top_test_ml1.v : top���W���[���̃e�X�g�t�B�N�X�`���{�́D
                 ���������C�e���V���P�ɌŒ�D(ACKI_n�CACKD_n �����0)

mips-cross   : �e�X�g�v���O�����C�݌v�����v���Z�b�T�p�ɃR���p�C�����邽�߂̃X�N���v�g�Q
 |
 |- asm : �A�Z���u������ŏ������e�X�g�v���O����(���Ғl�t�@�C���Ƃ��� Dmem_e.dat�CReg_e.dat���܂�)
 |
 |- c : c����ŏ������e�X�g�v���O����(CHECK PASSED!!�ƕ\�����ꂽ�琬���CCHECK FAILED!!�ƕ\�����ꂽ�玸�s)
 |
 |- Makefile.defaults : c����ŏ������v���O�����p�� Makefile
 |
 |- Makefile-asm.defaults: �A�Z���u������ŏ������v���O�����p�� Makefile
 |
 |- tools : �݌v�����v���Z�b�T�p�̖��߃������C�f�[�^�������̓��e�𐶐����邽�߂̃X�N���v�g�Ȃ�
     |      Makefile.defaults�CMakefile-asm.defaults �̒��Ŏg�p
     |
     |- convimem.sh  : verilog�p�̖��߃������L�q���f�B�X�A�Z���u������X�N���v�g
     |
     |- convdmem.awk : verilog�p�̃f�[�^�������L�q���f�B�X�A�Z���u������X�N���v�g
     |
     |- mod_s.awk : 'mipsisa32-elf-gcc -S -Tidt32.ld hoge.c' �Ő������ꂽ�A�Z���u���R�[�h(hoge.s)�ɑ΂��C
     |              (1) main�֐��ɃX�^�b�N�|�C���^�̏������L�q��}��
     |              (2) ���߂� 0x10000 ����n�܂�悤�ɂ���
     |              (3) �f�[�^�� 0x10000 ����n�܂�悤�ɂ���
     |              ���s���X�N���v�g
     |
     |- set_jal_target.awk : 'mipsisa32-elf-objdump -D -z hoge' �Ńf�B�X�A�Z���u�����ꂽ���̂ɑ΂��C
     |                       jal����(�֐��Ăяo��)�̃^�[�Q�b�g��ݒ肷��X�N���v�g
     |
     |- offdb.awk : 'mipsisa32-elf-objdump -D -z hoge' �Ńf�B�X�A�Z���u�����ꂽ���̂ɑ΂��C
     |              �x������𖳌�������X�N���v�g
     |              ��̓I�ɂ́C
     |              (1) ���򖽗�(�W�����v����)�Ƃ��̌㑱���߂Ƃ̓���ւ�
     |              (2) ���򖽗߂̏ꍇ�C�I�t�Z�b�g�l��1���炷(PC�̒l���ς�����̂�)
     |              ������Ă���
     |
     |- getmem.awk : 'mipsisa32-elf-objdump -D -z hoge' �Ńf�B�X�A�Z���u�����ꂽ���̂���C
     |               ���[�U�̈�(0x10000�`)�̖��߂ƃf�[�^�����o�� verilog �œǂ߂�`���ɂ��āC
     |               Imem_u.dat�CDmem_u.dat �ɏo��
     |
     |- Imem_s.dat : �X�[�p�o�C�U�̈�(0x0 �` 0x10000)�̖��߃������̓��e
     |               �ȒP�Ȋ��荞�ݏ������[�`�����܂ށD�ڂ����� './convimem.sh Imem_s.dat' �Ƃ���ē��e�����Ă��������D
     |
     |- Dmem_s.dat : �X�[�p�o�C�U�̈�(0x0 �` 0x10000)�̃f�[�^�������̓��e


�E�e�X�g�v���O�����̃R���p�C���Ǝ��s���@
  �ŏ��ɁCMakefile.defaults �� Makefile-asm.default �̒���
    TOOLS_DIR = ${HOME}/test_pack/mips-cross/tools
  �̕�����K�؂ɐݒ肷��D(�f�t�H���g�� /home/hoge/test_pack/mips-cross/tools)

  �e�X�g�v���O������ make �ŃR���p�C�����܂��D
  ����ŁCImem.dat, Dmem.dat ���ł���͂��ł��D
  'make clean'�Ƒłƒ��ԃt�@�C����Imem.dat�CDmem.dat�Ȃǂ��������Ƃ��ł��܂��D
  �܂��Cmake�Ŏ��s����Ƃ���'make clean'�Ƒł������Ƃ�make���s���Ƃ��܂��������Ƃ�����܂��D

  �܂��́Ctest_pack/mips-cross/asm �̉��̃e�X�g�v���O�����Ō��؂��s���Ƃ����Ǝv���܂�.
  �������߂̃e�X�g�v���O�������s����
  load -> store -> p2 -> p4 -> p5 -> p3 -> Interrupt


�E�A�Z���u������ŏ������e�X�g�v���O�����̐���
load: ���[�h���߂̃e�X�g�v���O����
store: �X�g�A���߂̃e�X�g�v���O����
p2: ���낢��D
p3: �S���߂̃e�X�g�D�Z�p���荞�݂��܂ށD
p4: �S���Z���߂̃e�X�g�D�Z�p���荞�݂��܂ށD
p5: �S���򖽗߁C�S�W�����v���߂̃e�X�g

Interrupt: ���荞�݂̃e�X�g���s���v���O����
 |- IF: IF�X�e�[�W�̊��荞�ݏ����̃e�X�g
 |   |- Ile : ���߃A�N�Z�X�E�������ی�ᔽ
 |   |- Mis : ���߃A�N�Z�X�E�~�X�A���C�������g
 |
 |- ID: ID�X�e�[�W�̊��荞�ݏ����̃e�X�g
 |   |- UDI : ����`����
 |   |- TMR : �������ߗ�O
 |
 |- EX: �Z�p���荞�݂̃e�X�g
 |
 |- MEM: MEM�X�e�[�W�̊��荞�ݏ����p�̃e�X�g���s���v���O����
 |   |- load  : load ���߂̃f�[�^�A�N�Z�X�E�~�X�A���C�������g�C�f�[�^�A�N�Z�X�E�������ی�ᔽ���荞�݂̃e�X�g
 |   |- store : load ���߂̃f�[�^�A�N�Z�X�E�~�X�A���C�������g�C�f�[�^�A�N�Z�X�E�������ی�ᔽ���荞�݂̃e�X�g
 |
 |- OUT: �}�X�N�\�O�����荞�݂̃e�X�g�v���O����. 
         top �̃e�X�g���W���[��(top_test.v)�� top_oint_test.v �ɕς��Ă���Ă�������


�Ec ����ŏ������̃e�X�g�v���O�����̐���
�v���O�����̐���
  hello  : "Hello World!" �Əo�͂���v���O����
  prime  : �f�������߂�v���O����
  napier : ���R�ΐ��̒�e ���v�Z����v���O����
  pi     : �~�������v�Z����v���O����
  sort   : �\�[�g�̃v���O����

�f�B���N�g���̐���
  ans   : �����̐����p�̃v���O����
  large : �傫�ȓ���
  mid   : �����炢�̓���
  small : �����ȓ���
  test  : �����ȓ��́D���ʂ��ڍׂɏo�͂���

���s����Ƃ��̒���
  (1) top_test.v �� IN_TOTAL ���\���傫��
      IN_TOTAL ���������ƃv���O�������s���I���O�ɃV�~�����[�V�������I����Ă��܂�
  (2) top_test.v �̈ȉ��̕����̃R�����g�A�E�g
      ========================================
       initial begin
           $monitor($stime," PC=%h", IAD);
           $shm_open("waves.shm");
           $shm_probe("AS");
       end
     ========================================

      $monitor: �����Ȃ��ƃv���O�����̕����̏o�͂�monitor�ɂ��o�͂ɍ������Ă��܂�
      $shm_open, $shm_probe: waveform �̃t�@�C��(waves.shm/*)������Ȃ��悤�ɂ���
                             ���s���Ԃ�������waveform�̃t�@�C�������Ȃ�傫���Ȃ��Ă��܂�

���̑�
  gcc -DDEBUG hoge.c -o hoge �Ƃ��Ε��ʂɎ��s�ł���o�C�i���𐶐��ł���悤�ɂ��Ă܂�


�E�A�Z���u������ŏ������v���O������verilog�p�ɃR���p�C������ɂ�
��{�I�ɁC�e�X�g�v���O�����̃\�[�X�R�[�h��Makefile��^�����ď����΂ł��܂��D
���̂Ƃ��C�ȉ��̂悤�ɏ����Ă��������D
==============================
	.text
main:
	# �v���O�����{��

	.data
	# �f�[�^
==============================


�Ec����ŏ������v���O������verilog�p�ɃR���p�C������ɂ�
��{�I�ɁC�e�X�g�v���O�����̃\�[�X�R�[�h��Makefile��^�����ď����΂ł��܂��D
���̂Ƃ��C�ȉ��̐��������Ă�������
    1�D�֐��͎����Ŗ����I�ɏ��������̂����g��Ȃ�
         printf�Cscanf�Cstrlen�Cstrcmp �Ȃǂ͎g���Ȃ��D
    2. �֐��̖{�̂� main �֐��̂��Ƃɏ����D
         main �֐��̐擪�A�h���X���m����  0x10000 �ɂȂ�悤�ɂ��邽��
    3. �O���[�o���ϐ��ɂ͕K�� 'static' ������
         static �����Ȃ��ƂȂ񂾂����܂������Ȃ�...
    4. �O���[�o���Ȕz��͕K������������
         ���������Ȃ��ƂȂ񂾂����܂������Ȃ�...
    5. �֐��|�C���^�ɂ��֐��̌Ăяo�����s��Ȃ�
         �֐��|�C���^�ɂ��֐��Ăяo�����s���ƁC�A�h���X 0 �ɔ��ł��܂�

�E�Ō��
�o�O���������獡���܂ł��񍐉������D

