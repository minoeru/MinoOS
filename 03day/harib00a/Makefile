MAKE 		= make -r
DEL 		= rm -f

#デフォルト動作

default :
	$(MAKE) img
	
#ファイル生成規則

ipl.bin : ipl.nas Makefile
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin Makefile
	mformat -f 1440 -C -B ipl.bin -i helloos.img ::

#コマンド

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) helloos.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a


clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst

src_only :
	$(MAKE) clean
	-$(DEL) helloos.img