[BITS 32]               ;32bitモード用の機械語を作らせる

        GLOBAL  api_putchar

[SECTION .text]

api_putchar:            ;void api_putchar(int c);
        MOV     EDX,1
        MOV     AL,[ESP+4]  ;c
        int     0x40
        RET