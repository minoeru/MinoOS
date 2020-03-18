run :
	nasm helloos.nas -o helloos.img
	qemu-system-i386 -drive file=helloos.img,format=raw,if=floppy -boot a

clean :
	rm -f helloos.img