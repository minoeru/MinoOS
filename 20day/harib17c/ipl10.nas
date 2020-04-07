; haribote-ipl
; TAB=4

CYLS	EQU		10				;CYLSに定数10を代入
		ORG		0x7c00			;このプログラムがどこに読み込まれるか

; 標準的なFATL2フォーマットフロッピーディスクのための記述

		JMP		entry
		DB		0x90
		DB		"MINO-IPL"		; ブートセクタの名前(8byte)
		DW		512				; 1セクタの大きさ
		DB		1				; クラスタの大きさ
		DW		1				; FATがどこから始まるか
		DB		2				; FATの個数
		DW		224				; ルートディレクトリ領域の大きさ
		DW		2880			; このドライブの大きさ
		DB		0xf0			; メディアのタイプ
		DW		9				; FAT領域の長さ
		DW		18				; 1トラックにいくつのセクタがあるか
		DW		2				; ヘッドの数
		DD		0				; パーティションを使っていないので0
		DD		2880			; このドライブの大きさをもう一度書く
		DB		0,0,0x29		; この値にしておくと良い
		DD		0xffffffff		; ボリュームシリアル番号
		DB		"MinoOS     "	; ディスクの名前(11byte)
		DB		"FAT12   "		; フォーマットの名前(8byte)
		RESB	18				; とりあえず18byte開けておく

; プログラム本体

entry:
		MOV		AX,0			;レジスタ初期化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; ディスクを読む
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			;シリンダ0
		MOV		DH,0			;ヘッド0
		MOV		CL,2			;セクタ2
readloop:
		MOV		SI,0			;失敗回数を数えるレジスタ
retry:
		MOV		AH,0x02			;AH=0x02 :ディスク読み込み
		MOV 	AL,1			;1セクタ
		MOV		BX,0
		MOV 	DL,0x00 		;Aドライブ
		INT 	0x13			;ディスクBIOS呼び出し
		JNC		next			;エラーが起きなければnextへ
		ADD		SI,1			;SIに1を足す
		CMP 	SI,5			;SIと5を比較
		JAE		error			;SI >= 5 ならerrorへ
		MOV		AH,0x00			
		MOV		DL,0x00			;Aドライブ
		INT 	0x13			;ドライブのリセット
		JMP		retry
next:
		MOV		AX,ES			;アドレスを0x200進める
		ADD 	AX,0x0020
		MOV		ES,AX			;ADD ES,0x020の代わり
		ADD		CL,1			;CLに1を足す
		CMP 	CL,18			;CLと18を比較
		JBE		readloop
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB 		readloop		;DH < 2だったらreadloopへ
		MOV 	DH,0
		ADD 	CH,1
		CMP		CH,CYLS
		JB 		readloop		;CH < CYLSだったらreadloopへ

; 読み終わったのでharibote.sysを実行

		MOV		[0x0ff0],CH		; IPLがどこまで読んだのかをメモ
		JMP		0xc200


error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]			;MOV AL.BYTE[SI]と同じ
		ADD		SI,1			;SIに1を足す
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			;一文字表示ファンクション
		MOV		BX,15			;カラーコード
		INT		0x10			;ビデオBIOS呼び出し
		JMP		putloop
fin:
		HLT					;何か起こるまでCPUを停止
		JMP		fin			;無限ループ
msg:
		DB		0x0a, 0x0a		; 改行*2
		DB		"minoeru_dayo"
		DB		0x0a			; 改行
		DB		0

		RESB	0x1fe-($-$$)	; 0x001feまでを0x00で埋める命令

		DB		0x55, 0xaa