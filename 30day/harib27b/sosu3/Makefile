APP      = sosu3

OBJS_API =	../apilib/api001.o ../apilib/api002.o ../apilib/api003.o ../apilib/api004.o ../apilib/api005.o ../apilib/api006.o \
			../apilib/api007.o ../apilib/api008.o ../apilib/api009.o ../apilib/api010.o ../apilib/api011.o ../apilib/api012.o \
			../apilib/api013.o ../apilib/api014.o ../apilib/api015.o ../apilib/api016.o ../apilib/api017.o ../apilib/api018.o \
			../apilib/api019.o ../apilib/api020.o

APILIBPATH   = ../apilib/
HARIBOTEPATH = ../haribote/

MAKE 		= make -r
DEL 		= rm -f

GCC = /usr/local/i386elfgcc/bin/i386-elf-gcc
CFLAGS = -m32 -fno-builtin

#デフォルト動作

default :
	$(MAKE) $(APP).hrb
	
mysprintf.o : mysprintf.c
	$(GCC) $(CFLAGS) -c mysprintf.c -o mysprintf.o

#ファイル生成規則


$(APP).hrb : $(APP).o Makefile ../app_make.txt mysprintf.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T ../a.ld -g mysprintf.o $(APP).o $(OBJS_API) -o $@

haribote.img : ipl10.bin haribote.sys a.hrb hello3.hrb hello4.hrb hello5.hrb winhelo.hrb winhelo2.hrb winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb beepdown.hrb color.hrb color2.hrb Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ipl10.nas Makefile a.hrb hello3.hrb hello4.hrb hello5.hrb winhelo.hrb winhelo2.hrb winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb beepdown.hrb color.hrb color2.hrb ::

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