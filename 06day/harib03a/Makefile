MAKE 		= make -r
DEL 		= rm -f

#デフォルト動作

default :
	$(MAKE) img
	
#ファイル生成規則

convHankakuTxt : convHankakuTxt.c
	gcc convHankakuTxt.c -o convHankakuTxt

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

hankaku.o : hankaku.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -c -m32 hankaku.c -o hankaku.o

mysprintf.o : mysprintf.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -c -m32 -fno-builtin mysprintf.c -o mysprintf.o

ipl10.bin : ipl10.nas Makefile
	nasm ipl10.nas -o ipl10.bin -l ipl10.lst

asmhead.bin : asmhead.nas Makefile
	nasm asmhead.nas -o asmhead.bin -l asmhead.lst

naskfunc.o : naskfunc.nas Makefile          # naskfunc.nasのバイナリファイル作成
	nasm -g -f elf naskfunc.nas -o naskfunc.o -l naskfunc.lst

bootpack.o : bootpack.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -c -m32 -fno-builtin bootpack.c -o bootpack.o

graphic.o : graphic.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -c -m32 graphic.c -o graphic.o

dsctbl.o : dsctbl.c
	/usr/local/i386elfgcc/bin/i386-elf-gcc -c -m32 dsctbl.c -o dsctbl.o

bootpack.hrb : bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o hrb.ld Makefile
	/usr/local/i386elfgcc/bin/i386-elf-gcc -march=i486 -m32 -fno-builtin -nostdlib -T hrb.ld -g bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.c -o bootpack.hrb

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::

#コマンド

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -boot a

clean :
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.o
	-$(DEL) *.sys
	-$(DEL) *.hrb
	-$(DEL) hankaku.c
	-$(DEL) convHankakuTxt

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img