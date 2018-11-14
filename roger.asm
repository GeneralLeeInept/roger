	; Roger - a frogger-a-like for the Atari 800XL
	icl "equates.inc"
		
	; Graphics
	org $4000
	icl "graphics.asm"
	icl "charset.asm"
	
	org $2000
	
	; Variables
.struct ScrollLine
	fine	.byte
	coarse	.byte
.ends

scroll_delay		.byte 4

logs 			dta ScrollLine [3] (0, 0) (1, 1) (0, 0)
cars			dta ScrollLine [3] (1, 1) (0, 0) (1, 1)

	; Program
	.proc main

	; Turn off screen
	mva #0 SDMCTL

	jsr init

	; Turn screen on
	mva #$22 SDMCTL	
	
	; Loop
	jmp *
	.endp

	.proc init
	; Duplicate start of each scrolling line to its end for continuous infinite scrolling
	ldx #0
copy_loop
	mva screenmem.river1,x screenmem.river1_end,x
	mva screenmem.river2,x screenmem.river2_end,x
	mva screenmem.river3,x screenmem.river3_end,x
	mva screenmem.river4,x screenmem.river4_end,x
	mva screenmem.river5,x screenmem.river5_end,x
	mva screenmem.river6,x screenmem.river6_end,x
	mva screenmem.river7,x screenmem.river7_end,x
	mva screenmem.river8,x screenmem.river8_end,x
	mva screenmem.river9,x screenmem.river9_end,x
	inx
	cpx #60
	bne copy_loop
	
	; Point to display list
	mwa #dlist SDLSTL
	
	; Setup VBLANK handler
	lda #07
	ldx #.HI(vblank_handler)
	ldy #.LO(vblank_handler)
	jsr SETVBV
	
	; setup DLI handler
	mwa #dli.handler VDSLST
	mva #192 NMIEN
	
	rts
	.endp
	
	.local dli
	.proc begin_playfield
	; switch to custom character set
	lda #>(charset)
	sta WSYNC
	sta CHBASE
	jmp exithandler
	.endp

	.proc scroll
	eor #15
	sta WSYNC
	sta HSCROL
	jmp exithandler
	.endp
	
	.proc scroll_log1
	; set fine scroll for log1
	lda logs[0].fine
	jmp scroll
	.endp

	.proc scroll_log2
	; set fine scroll for log2
	lda logs[1].fine
	jmp scroll
	.endp

	.proc scroll_log3
	; set fine scroll for log3
	lda logs[2].fine
	jmp scroll
	.endp

jumptable
	.word	begin_playfield-1
	.word	scroll_log1-1
	.word	scroll_log2-1
	.word	scroll_log3-1
	
idx	.byte	0

	.proc handler
	pha
	txa
	pha
	lda idx
	and #3
	asl
	tax
	lda jumptable+1,x
	pha
	lda jumptable,x
	pha
	rts
	.endp

	.proc exithandler
	inc idx
	pla
	tax
	pla
	rti
	.endp
	
	.endl	; dli
		
	.proc vblank_handler
	; Update playfield
	mva #0 dli.idx
	dec scroll_delay
	beq scroll_playfield
	jmp exit
	
scroll_playfield
	;
	; - Scroll log1
	inc logs[0].fine
	lda logs[0].fine
	cmp #4
	bcs @+
	sec
	sbc #4
	sta logs[0].fine
	inc logs[0].coarse
	lda logs[0].coarse
	cmp #(screenmem.river1_end - screenmem.river1)
	bne @+
	lda #0
	sta logs[0].coarse
@	lda logs[0].coarse
	sta dlist.river1
	sta dlist.river2
	sta dlist.river3
	;
	; - Scroll log2
	dec logs[1].fine
	lda logs[1].fine
	bne @+
	clc
	adc #4
	sta logs[1].fine
	dec logs[1].coarse
	lda logs[1].coarse
	cmp #0
	bne @+
	lda #(screenmem.river4_end - screenmem.river4)
	sta logs[1].coarse
@	lda logs[1].coarse
	sta dlist.river4
	sta dlist.river5
	sta dlist.river6
	;
	; - Scroll log3
	inc logs[2].fine
	lda logs[2].fine
	cmp #4
	bcs @+
	sec
	sbc #4
	sta logs[2].fine
	inc logs[2].coarse
	lda logs[2].coarse
	cmp #(screenmem.river7_end - screenmem.river7)
	bne @+
	lda #0
	sta logs[2].coarse
@	lda logs[2].coarse
	sta dlist.river7
	sta dlist.river8
	sta dlist.river9

	lda #4
	sta scroll_delay

exit
	jmp XITVBV
	.endp	; vblank_handler 
	
	run main
	