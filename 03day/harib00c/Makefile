TOOLPATH 	= ../../z_tools/
MAKE 		= make -r
IMGTOL 		= $(TOOLPATH)imgtol
COPY 		= cp
DEL 		= rm -f

#デフォルト動作

default :
	$(MAKE) img
	
#ファイル生成規則

ipl.bin : ipl.nas Makefile
	nasm ipl.nas -o ipl.bin 

helloos.img : ipl.bin Makefile
	mformat -f 1440 -C -B ipl.bin -i helloos.img ::

#コマンド

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) helloos.img

run :
	$(MAKE) img
	$(COPY) helloos.img ../../z_tools/qemu/fdimage0.bin
	$(MAKE) -C ../../z_tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: helloos.img

clean :
	-$(DEL) ipl.bin

src_only :
	$(MAKE) clean
	-$(DEL) helloos.img