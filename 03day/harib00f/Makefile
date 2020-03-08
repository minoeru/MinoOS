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

haribote.sys : haribote.nas Makefile
	nasm haribote.nas -o haribote.sys

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
	$(COPY) haribote.img ../../z_tools/qemu/fdimage0.bin
	$(MAKE) -C ../../z_tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: haribote.img

clean :
	-$(DEL) ipl.bin
	-$(DEL) haribote.sys

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img