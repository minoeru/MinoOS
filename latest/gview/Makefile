APP      = gview

OBJS_API =	../apilib/api001.o ../apilib/api002.o ../apilib/api003.o ../apilib/api004.o ../apilib/api005.o ../apilib/api006.o \
			../apilib/api007.o ../apilib/api008.o ../apilib/api009.o ../apilib/api010.o ../apilib/api011.o ../apilib/api012.o \
			../apilib/api013.o ../apilib/api014.o ../apilib/api015.o ../apilib/api016.o ../apilib/api017.o ../apilib/api018.o \
			../apilib/api019.o ../apilib/api020.o ../apilib/api021.o ../apilib/api022.o ../apilib/api023.o ../apilib/api024.o \
			../apilib/api025.o ../apilib/api026.o ../apilib/api027.o ../apilib/alloca.o


APILIBPATH   = ../apilib/
HARIBOTEPATH = ../haribote/

MAKE 		= make -r
DEL 		= rm -f

GCC = /usr/local/i386elfgcc/bin/i386-elf-gcc
CFLAGS = -m32 -fno-builtin

#デフォルト動作

default :
	$(MAKE) $(APP).hrb

#ファイル生成規則


$(APP).hrb : $(APP).o Makefile ../app_make.txt jpeg.o bmp.o
	$(GCC) $(CFLAGS) -march=i486 -nostdlib -T ../a.ld -g jpeg.o $(APP).o bmp.o $(OBJS_API) -o $@


# 一般規則

%.o : %.c
	$(GCC) $(CFLAGS) -c $*.c -o $*.o

%.o : %.nasm
	nasm -g -f elf $*.nas -o $*.o

#コマンド


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