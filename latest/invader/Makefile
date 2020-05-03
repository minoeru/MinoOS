APP      = invader
APILIBPATH   = ../apilib

OBJS_API =	$(APILIBPATH)/api001.o $(APILIBPATH)/api002.o $(APILIBPATH)/api003.o $(APILIBPATH)/api004.o $(APILIBPATH)/api005.o $(APILIBPATH)/api006.o \
			$(APILIBPATH)/api007.o $(APILIBPATH)/api008.o $(APILIBPATH)/api009.o $(APILIBPATH)/api010.o $(APILIBPATH)/api011.o $(APILIBPATH)/api012.o \
			$(APILIBPATH)/api013.o $(APILIBPATH)/api014.o $(APILIBPATH)/api015.o $(APILIBPATH)/api016.o $(APILIBPATH)/api017.o $(APILIBPATH)/api018.o \
			$(APILIBPATH)/api019.o $(APILIBPATH)/api020.o $(APILIBPATH)/api021.o $(APILIBPATH)/api022.o $(APILIBPATH)/api023.o $(APILIBPATH)/api024.o \
			$(APILIBPATH)/api025.o $(APILIBPATH)/api026.o $(APILIBPATH)/api027.o $(APILIBPATH)/alloca.o

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


# 一般規則

%.o : %.c
	$(GCC) $(CFLAGS) -c $*.c -o $*.o

#コマンド

clean :
	-$(DEL) *.o
	-$(DEL) *.hrb
	-$(DEL) hankaku.c
	-$(DEL) convHankakuTxt

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img