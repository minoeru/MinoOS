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
	nasm ipl.nas -o ipl.bin -l ipl10.lst

haribote.sys : haribote.nas Makefile
	nasm haribote.nas -o haribote.sys -l haribote.lst

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::

#コマンド

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -boot a

install :
	$(MAKE) img
	$(IMGTOL) w a: haribote.img

clean :
	-$(DEL) ipl10.bin
	-$(DEL) ipl10.lst
	-$(DEL) haribote.sys
	-$(DEL) haribote.lst

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img