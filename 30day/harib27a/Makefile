MAKE 		= make -r
DEL 		= rm -f

#デフォルト動作

default :
	$(MAKE) img

haribote.img : haribote/ipl20.bin haribote/haribote.sys Makefile a/a.hrb hello3/hello3.hrb hello4/hello4.hrb hello5/hello5.hrb winhelo/winhelo.hrb winhelo2/winhelo2.hrb winhelo3/winhelo3.hrb star1/star1.hrb stars/stars.hrb stars2/stars2.hrb lines/lines.hrb walk/walk.hrb beepdown/beepdown.hrb color/color.hrb color2/color2.hrb sosu/sosu.hrb sosu2/sosu2.hrb sosu3/sosu3.hrb typeipl/typeipl.hrb type/type.hrb iroha/iroha.hrb nihongo/nihongo.fnt chklang/chklang.hrb notrec/notrec.hrb bball/bball.hrb invader/invader.hrb  #calc/calc.hrb
	mformat -f 1440 -C -B haribote/ipl20.bin -i haribote/haribote.img ::
	mcopy -i haribote/haribote.img haribote/haribote.sys haribote/ipl20.nas Makefile a/a.hrb hello3/hello3.hrb hello4/hello4.hrb hello5/hello5.hrb winhelo/winhelo.hrb winhelo2/winhelo2.hrb winhelo3/winhelo3.hrb star1/star1.hrb stars/stars.hrb stars2/stars2.hrb lines/lines.hrb walk/walk.hrb beepdown/beepdown.hrb color/color.hrb color2/color2.hrb sosu/sosu.hrb sosu2/sosu2.hrb sosu3/sosu3.hrb typeipl/typeipl.hrb type/type.hrb iroha/iroha.hrb nihongo/nihongo.fnt chklang/chklang.hrb notrec/notrec.hrb bball/bball.hrb invader/invader.hrb ::
#コマンド

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=haribote/haribote.img,format=raw,if=floppy -boot a

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