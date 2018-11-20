	icl "equates.asm"
	
	org $2000
	
	
	.local spritetab
	.local frog
bits
	ins "frog.chr"
	
frames
	.he 00 10 20 30 40 50 60 70 80 90 A0 B0

	.endl	; frog
	.endl	; spritetab

;
; copy_sprite
;
;	Y - vertical position of top row of sprite
;	X - sprite frame
;
;	Copy frog sprite data into P0 & P1
;
	.proc copy_sprite
	clc
	lda spritetab.frog.frames,x
	adc #<spritetab.frog.bits
	sta $80
	lda #0
	adc #>spritetab.frog.bits
	sta $81
	clc
	lda spritetab.frog.frames,x
	adc #<(spritetab.frog.bits+192)
	sta $82
	lda #0
	adc #>(spritetab.frog.bits+192)
	sta $83
	
	clc
	tya
	adc #<pmdata.player0
	sta $84
	lda #0
	adc #>pmdata.player0
	sta $85
	
	clc
	tya
	adc #<pmdata.player1
	sta $86
	lda #0
	adc #>pmdata.player1
	sta $87

	mva #16 $88
	ldy #00
	
copy_loop
	dec $88
	bmi done
	lda ($80),y
	sta ($84),y
	lda ($82),y
	sta ($86),y
	inc $80
	bne @+
	inc $81
@	inc $82
	bne @+
	inc $83
@	inc $84
	inc $86
	jmp copy_loop

done
	rts
	.endp	; copy_sprite
	
	.proc main

	mva #0 SDMCTL
	mva #128 HPOSP0
	mva #136 HPOSP1
	mva #>pmdata PMBASE
	
	mva #3 GRACTL
	mva #63 SDMCTL
	
	lda #$00
	sta $89
	sta $90
	
loop
	clc
	lda RTCLOK+2
	adc #$08
@	cmp RTCLOK+2
	bne @- 	
	
	ldx $90
	cpx #3
	bmi @+
	ldx #$0
	stx $90
@	ldy $89
	jsr copy_sprite

	dec $89
	inc $90
	jmp loop
	
	.endp	; main
	
	.align $800
	.local pmdata
unused	.ds $300
missile	.ds $100
player0	.ds $100
player1	.ds $100
player2	.ds $100
player3	.ds $100
	.endl	; pmdata
	
	run main
	