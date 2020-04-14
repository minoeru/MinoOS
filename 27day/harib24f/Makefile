OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o mouse.o keyboard.o memory.o sheet.o timer.o mtask.o window.o console.o file.o

OBJS_API =	api001.o api002.o api003.o api004.o api005.o api006.o \
			api007.o api008.o api009.o api010.o api011.o api012.o \
			api013.o api014.o api015.o api016.o api017.o api018.o \
			api019.o api020.o

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

bootpack.hrb : $(OBJS_BOOTPACK) hrb.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T hrb.ld -g $(OBJS_BOOTPACK) -o $@

a.hrb : a.o $(OBJS_API) a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g a.o $(OBJS_API) -o $@
 
hello3.hrb : hello3.o a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g hello3.o $(OBJS_API) -o $@

hello4.hrb : hello4.o a.ld
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g hello4.o $(OBJS_API) -o $@	

hello5.hrb : hello5.nas Makefile
	nasm $< -o $@ -l hello5.lst

winhelo.hrb : winhelo.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g winhelo.o $(OBJS_API) -o $@

winhelo2.hrb : winhelo2.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g winhelo2.o $(OBJS_API) -o $@

winhelo3.hrb : winhelo3.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g winhelo3.o $(OBJS_API) -o $@

star1.hrb : star1.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g star1.o $(OBJS_API) -o $@

stars.hrb : stars.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g stars.o $(OBJS_API) -o $@

stars2.hrb : stars2.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g stars2.o $(OBJS_API) -o $@

lines.hrb : lines.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g lines.o $(OBJS_API) -o $@

walk.hrb : walk.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g walk.o $(OBJS_API) -o $@

noodle.hrb : noodle.o 
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g mysprintf.o noodle.o $(OBJS_API) -o $@

beepdown.hrb : beepdown.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g beepdown.o $(OBJS_API) -o $@

color.hrb : color.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g color.o $(OBJS_API) -o $@

color2.hrb : color2.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T a.ld -g color2.o $(OBJS_API) -o $@

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys a.hrb hello3.hrb hello4.hrb hello5.hrb winhelo.hrb winhelo2.hrb winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb noodle.hrb beepdown.hrb color.hrb color2.hrb Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ipl10.nas Makefile a.hrb hello3.hrb hello4.hrb hello5.hrb winhelo.hrb winhelo2.hrb winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb noodle.hrb beepdown.hrb color.hrb color2.hrb ::

# 一般規則

%.o : %.c
	$(GCC) $(CFLAGS) -c $*.c -o $*.o

%.o : %.nas
	nasm -g -f elf $*.nas -o $*.o

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