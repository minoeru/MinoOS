[BITS 32]
	MOV		AL,'A'
	INT    0x40
fin:
	HLT
	JMP fin