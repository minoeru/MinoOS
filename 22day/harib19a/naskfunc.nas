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
		GLOBAL  load_cr0, store_cr0
		GLOBAL	load_tr
		GLOBAL	asm_inthandler20,asm_inthandler21,asm_inthandler27,asm_inthandler2c,asm_inthandler0d
		GLOBAL  memtest_sub
		GLOBAL	farjmp,farcall
		GLOBAL  asm_hrb_api,start_app
		EXTERN	inthandler20,inthandler21,inthandler27,inthandler2c,inthandler0d
		EXTERN  hrb_api



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

load_cr0:		; int load_cr0(void);
		MOV		EAX,CR0
		RET

store_cr0:		; void store_cr0(int cr0);
		MOV		EAX,[ESP+4]
		MOV		CR0,EAX
		RET

load_tr:		; void load_tr(int tr);
		LTR		[ESP+4]			; tr
		RET

asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler20
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

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

asm_inthandler0d:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler0d
		CMP		EAX,0		; ここだけ違う
		JNE		end_app		; ここだけ違う
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; INT 0x0d では、これが必要
		IRETD

memtest_sub: ; unsigned int memtest_sub(unsigned int start, unsigned int end)
		PUSH	EDI			;(EBX, ESI, EDIも使いたいので)
		PUSH	ESI
		PUSH	EBX
		MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
		MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
		MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
		MOV		EBX,EAX
		ADD		EBX,0xffc				; p = i + 0xffc;
		MOV		EDX,[EBX]				; old = *p;
		MOV		[EBX],ESI				; *p = pat0;
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
		JNE		mts_fin
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
		JNE		mts_fin
		MOV		[EBX],EDX				; *p = old;
		ADD		EAX,0x1000				; i += 0x1000;
		CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET
mts_fin:
		MOV		[EBX],EDX				; *p = old;
		POP		EBX
		POP		ESI
		POP		EDI
		RET

farjmp:									; void farjmp(int eip, int cs);
		JMP 	FAR [ESP+4]				; eip, cs
		RET

farcall:		; void farcall(int eip, int cs);
		CALL	FAR	[ESP+4]				; eip, cs
		RET

asm_hrb_api:
		STI
		PUSH	DS
		PUSH	ES
		PUSHAD		; 保存のためのPUSH
		PUSHAD		; hrb_apiにわたすためのPUSH
		MOV		AX,SS
		MOV		DS,AX		; OS用のセグメントをDSとESにも入れる
		MOV		ES,AX
		CALL	hrb_api
		CMP		EAX,0		; EAXが0でなければアプリ終了処理
		JNE		end_app
		ADD		ESP,32
		POPAD
		POP		ES
		POP		DS
		IRETD
end_app:
;	EAXはtss.esp0の番地
		MOV		ESP,[EAX]
		POPAD
		RET					; cmd_appへ帰る

start_app:		; void start_app(int eip, int cs, int esp, int ds, int *tss_esp0);
		PUSHAD		; 32ビットレジスタを全部保存しておく
		MOV		EAX,[ESP+36]	; アプリ用のEIP
		MOV		ECX,[ESP+40]	; アプリ用のCS
		MOV		EDX,[ESP+44]	; アプリ用のESP
		MOV		EBX,[ESP+48]	; アプリ用のDS/SS
		MOV		EBP,[ESP+52]	; tss.esp0の番地
		MOV		[EBP  ],ESP		; OS用のESPを保存
		MOV		[EBP+4],SS		; OS用のSSを保存
		MOV		ES,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
;	以下はRETFでアプリに行かせるためのスタック調整
		OR		ECX,3			; アプリ用のセグメント番号に3をORする
		OR		EBX,3			; アプリ用のセグメント番号に3をORする
		PUSH	EBX				; アプリのSS
		PUSH	EDX				; アプリのESP
		PUSH	ECX				; アプリのCS
		PUSH	EAX				; アプリのEIP
		RETF
;	アプリが終了してもここには来ない