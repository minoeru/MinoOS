[BITS 32]
		MOV		EAX,1*8			; OS用のセグメント番号
		MOV		DS,AX			; DBに突っ込む
		MOV		BYTE [0x102600],0
		RETF