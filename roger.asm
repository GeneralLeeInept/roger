	; Roger - a frogger-a-like for the Atari 800XL
	icl "equates.asm"
	
.struct ScrollLine
    fine .byte
    coarse .byte
.ends

	org $80
scroll_delay	.byte 4
scroll_state	dta ScrollLine [5] (0,0) (1,1) (0,0) (1,1) (0,0) (1,1)
	
	org $2000
	
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
	
	; Setup DLI handler
	mwa #dli.handler VDSLST
	mva #192 NMIEN
	
	; 
	mva #$08 COLOR1
	mva #$00 COLOR2
	
	rts
	.endp
	
	.local dli
	.proc begin_playfield
	; switch to custom character set
	mva #$83 COLBK
	lda #>(charset)
	sta WSYNC
	sta CHBASE
	jmp exithandler
	.endp

	.macro set_hscroll amt
	  lda :amt
	  eor #15
	  sta WSYNC
	  sta HSCROL
	.endm
	
	.proc scroll_log1
	set_hscroll scroll_state[0].fine
	jmp exithandler
	.endp

	.proc scroll_log2
	set_hscroll scroll_state[1].fine
	jmp exithandler
	.endp

	.proc scroll_log3
	set_hscroll scroll_state[0].fine
	jmp exithandler
	.endp

	.proc begin_bank
	mva #$C6 COLBK
	jmp exithandler
	.endp
	
	.proc scroll_road1
	mva #$04 COLBK
	;set_hscroll scroll_state[1].fine
	jmp exithandler
	.endp
	
	.proc scroll_road2
	mva #$08 COLBK
	;set_hscroll scroll_state[4].fine
	jmp exithandler
	.endp

	.proc scroll_road3
	mva #$04 COLBK
	;set_hscroll scroll_state[5].fine
	jmp exithandler
	.endp
	
	.proc begin_footpath
	mva #$0E COLBK
	jmp exithandler
	.endp
	
jumptable
	.word	begin_playfield-1
	.word	scroll_log1-1
	.word	scroll_log2-1
	.word	scroll_log3-1
	.word	begin_bank-1
	.word	scroll_road1-1
	.word	scroll_road2-1
	.word	scroll_road3-1
	.word	begin_footpath-1
idx	.byte	0

	.proc handler
	pha
	txa
	pha
	lda idx
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
	inc scroll_state[0].fine
	lda scroll_state[0].fine
	cmp #4
	bcs @+
	sec
	sbc #4
	sta scroll_state[0].fine
	inc scroll_state[0].coarse
	lda scroll_state[0].coarse
	cmp #(screenmem.river1_end - screenmem.river1)
	bne @+
	lda #0
	sta scroll_state[0].coarse
@	lda scroll_state[0].coarse
	sta dlist.river1
	sta dlist.river2
	sta dlist.river3
	;
	; - Scroll log2
	dec scroll_state[1].fine
	lda scroll_state[1].fine
	bne @+
	clc
	adc #4
	sta scroll_state[1].fine
	dec scroll_state[1].coarse
	lda scroll_state[1].coarse
	cmp #0
	bne @+
	lda #(screenmem.river4_end - screenmem.river4)
	sta scroll_state[1].coarse
@	lda scroll_state[1].coarse
	sta dlist.river4
	sta dlist.river5
	sta dlist.river6
	;
	; - Scroll log3
	inc scroll_state[2].fine
	lda scroll_state[2].fine
	cmp #4
	bcs @+
	sec
	sbc #4
	sta scroll_state[2].fine
	inc scroll_state[2].coarse
	lda scroll_state[2].coarse
	cmp #(screenmem.river7_end - screenmem.river7)
	bne @+
	lda #0
	sta scroll_state[2].coarse
@	lda scroll_state[2].coarse
	sta dlist.river7
	sta dlist.river8
	sta dlist.river9

	lda #4
	sta scroll_delay

exit
	jmp XITVBV
	.endp	; vblank_handler 

	; Graphics
	icl "graphics.asm"
	icl "charset.asm"
	
	run main
	