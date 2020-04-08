OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o mouse.o keyboard.o memory.o sheet.o timer.o mtask.o window.o console.o file.o 

MAKE 		= make -r
DEL 		= rm -f

GCC = /usr/local/i386elfgcc/bin/i386-elf-gcc
CFLAGS = -m32 -fno-builtin

#デフォルト動作

default :
	$(MAKE) img
	
#ファイル生成規則

convHankakuTxt : convHankakuTxt.c
	gcc $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl10.bin : ipl10.nas
	nasm $< -o $@ -l ipl10.lst

asmhead.bin : asmhead.nas
	nasm $< -o $@ -l asmhead.lst

naskfunc.o : naskfunc.nas          # naskfunc.nasのバイナリファイル作成
	nasm -g -f elf $< -o $@ -l naskfunc.lst

bootpack.hrb : $(OBJS_BOOTPACK) hrb.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T hrb.ld -g $(OBJS_BOOTPACK) -o $@

hello.hrb : hello.nas Makefile
	nasm $< -o $@ -l hello.lst

hello2.hrb : hello2.nas Makefile
	nasm $< -o $@ -l hello2.lst
 


a_nask.o : a_nask.nas
	nasm -g -f elf a_nask.nas -o a_nask.o

a.hrb : a.o a_nask.o a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g a.o a_nask.o -o $@

hello3.hrb : hello3.o a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g hello3.o a_nask.o -o $@

crack1.hrb : crack1.o a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g crack1.o a_nask.o -o $@

crack2.hrb : crack2.nas Makefile
	nasm $< -o $@ -l crack2.lst


haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys hello.hrb hello2.hrb a.hrb hello3.hrb crack1.hrb crack2.hrb Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ipl10.nas Makefile hello.hrb hello2.hrb a.hrb hello3.hrb crack1.hrb crack2.hrb ::

# 一般規則

%.o : %.c
	$(GCC) $(CFLAGS) -c $*.c -o $*.o


#コマンド

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -m 32 -drive file=haribote.img,format=raw,if=floppy -boot a

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