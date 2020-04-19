default : 
	make -r tek.o
	make -r autodec_c.o


tek.o : tek.c
	gcc  -m32 -fno-builtin -c tek.c -o tek.o

autodec_c.o : autodec_c.c
	gcc -m32 -fno-builtin -c autodec_c -o autodec_c.o