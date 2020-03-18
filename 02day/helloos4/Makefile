ipl.bin : ipl.nas Makefile
	nasm ipl.nas -o ipl.bin -l ipl.lst

helloos.img : ipl.bin Makefile
	mformat -f 1440 -C -B ipl.bin -i helloos.img ::

img :
	make -r helloos.img

run :
	make img
	qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a

clean :
	rm -f helloos.img
	rm -f ipl.bin
	rm -f ipl.lst