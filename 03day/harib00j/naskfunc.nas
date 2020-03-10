; naskfunc
; TAB=4

;[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード ; NASMではエラーが出るのでこの行削除
[BITS 32]						; 32ビットモード用の機械語を作らせる


; オブジェクトファイルのための情報

;[FILE "naskfunc.nas"]			; ソースファイル名情報 ; NASMではエラーが出るのでこの行削除

		;GLOBAL	_io_hlt			; このプログラムに含まれる関数名
		GLOBAL	io_hlt			; NASMではエラーが出るので修正


; 以下は実際の関数

[SECTION .text]		; オブジェクトファイルではこれを書いてからプログラムを書く

;_io_hlt:	; void io_hlt(void);
io_hlt:	; void io_hlt(void);	; NASMではエラーが出るので修正
		HLT
		RET