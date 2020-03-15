; naskfunc
; TAB=4

;[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード ; NASMではエラーが出るのでこの行削除
[BITS 32]						; 32ビットモード用の機械語を作らせる


; オブジェクトファイルのための情報

;[FILE "naskfunc.nas"]			; ソースファイル名情報 ; NASMではエラーが出るのでこの行削除

		GLOBAL	io_hlt			; このプログラムに含まれる関数名;NASMではエラーが出るので修正
		GLOBAL	io_cli,io_sti,io_stihlt	;間をあけない
		GLOBAL	io_in8,io_in16,io_in32
		GLOBAL	io_out8,io_out16,io_out32
		GLOBAL	io_load_eflags,io_store_eflags
		GLOBAL	load_gdtr,load_idtr
		GLOBAL	asm_inthandler21,asm_inthandler27,asm_inthandler2c
		EXTERN	inthandler21,inthandler27,inthandler2c



; 以下は実際の関数

[SECTION .text]		; オブジェクトファイルではこれを書いてからプログラムを書く

io_hlt:	; void io_hlt(void);	; NASMではエラーが出るので修正
		HLT
		RET

io_cli:	; void io_cli(void);	;割り込み禁止
		CLI
		RET

io_sti:	; void io_sti(void);	;割り込み許可
		STI
		RET

io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

io_in8: ; int io_in8(int port);
		MOV		EDX,[ESP+4]		;port
		MOV 	EAX,0
		IN 		AL,DX
		RET

io_in16: ; int io_in16(int port);
		MOV		EDX,[ESP+4]		;port
		MOV 	EAX,0
		IN 		AL,DX
		RET

io_in32: ; int io_in32(int port);
		MOV		EDX,[ESP+4]		;port
		IN 		AL,DX
		RET

io_out8: ; void io_out8(int port, int data);
		MOV		EDX,[ESP+4] 	;port
		MOV		AL,[ESP+8]		;data
		OUT		DX,AL
		RET

io_out16: ; void io_out16(int port, int data);
		MOV 	EDX,[ESP+4]		;port
		MOV 	EAX,[ESP+8]		;data
		OUT		DX,AX
		RET

io_out32: ; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]
		MOV		EAX,[ESP+8]
		OUT		DX,EAX
		RET

io_load_eflags: ; int io_load_eflags(void);
		PUSHFD					; PUSH EFLAGS
		POP		EAX
		RET

io_store_eflags: ; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD					;POP EFLAGSという意味
		RET

load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD