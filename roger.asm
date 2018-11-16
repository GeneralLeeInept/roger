	; Roger - a frogger-a-like for the Atari 800XL
	icl "equates.asm"

.struct RegisterSav
    a	.byte
    x	.byte
    y	.byte
.ends

.struct ScrollLine
    fine	.byte
    coarse	.byte
.ends

	org $80
registers	RegisterSav
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
	mwa #dli.begin_playfield VDSLST
	mva #192 NMIEN
	
	; 
	mva #$08 COLOR1
	mva #$00 COLOR2
	
	rts
	.endp
	
	.local dli
jumptable_lo
	.byte	<begin_playfield
	.byte	<scroll_log1
	.byte	<scroll_log2
	.byte	<scroll_log3
	.byte	<begin_bank
	.byte	<scroll_road1
	.byte	<scroll_road2
	.byte	<scroll_road3
	.byte	<begin_footpath

jumptable_hi
	.byte	>begin_playfield
	.byte	>scroll_log1
	.byte	>scroll_log2
	.byte	>scroll_log3
	.byte	>begin_bank
	.byte	>scroll_road1
	.byte	>scroll_road2
	.byte	>scroll_road3
	.byte	>begin_footpath

jumptable_idx
	.byte	0

	.macro beginhandler
	  sta registers.a
	  stx registers.x
	.endm
	
	.macro endhandler
	  inc jumptable_idx
	  ldx jumptable_idx
	  lda jumptable_lo,x
	  sta VDSLST
	  lda jumptable_hi,x
	  sta VDSLST+1
	  lda registers.a
	  ldx registers.x
	  rti
	.endm
	
	.macro set_colbk col
	  lda :col
	  sta WSYNC
	  sta COLBK
	.endm
	
	.macro set_hscroll amt
	  lda :amt
	  eor #15
	  sta WSYNC
	  sta HSCROL
	.endm
	
	.macro set_colbk_hscroll col amt
	  lda :col
	  ldx :amt
	  sta WSYNC
	  sta COLBK
	  stx HSCROL
	.endm
	
	.proc begin_playfield
	; switch to custom character set
	beginhandler
	lda #$83
	ldx #>(charset)
	sta WSYNC
	sta COLBK
	stx CHBASE
	endhandler
	.endp

	.proc scroll_log1
	beginhandler
	set_hscroll scroll_state[0].fine
	endhandler
	.endp

	.proc scroll_log2
	beginhandler
	set_hscroll scroll_state[1].fine
	endhandler
	.endp

	.proc scroll_log3
	beginhandler
	set_hscroll scroll_state[0].fine
	endhandler
	.endp

	.proc begin_bank
	beginhandler
	set_colbk #$C6
	endhandler
	.endp
	
	.proc scroll_road1
	beginhandler
	set_colbk_hscroll #$04 scroll_state[1].fine
	endhandler
	.endp
	
	.proc scroll_road2
	beginhandler
	set_colbk #$08
	;set_hscroll scroll_state[4].fine
	endhandler
	.endp

	.proc scroll_road3
	beginhandler
	set_colbk #$04
	;set_hscroll scroll_state[5].fine
	endhandler
	.endp
	
	.proc begin_footpath
	beginhandler
	set_colbk #$0e
	endhandler
	.endp
	
	.endl	; dli
		
	.proc vblank_handler
	mwa #dli.begin_playfield VDSLST
	mva #0 dli.jumptable_idx
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
	