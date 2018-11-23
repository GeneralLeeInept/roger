; Roger - a frogger-a-like for the Atari 800XL
;
; @com.wudsn.ide.asm.mainsourcefile=roger.asm
; @com.wudsn.ide.asm.outputfileextension=.xex

	icl "equates.asm"

	run main

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
copysrc		.word $0000
copydest	.word $0000
registers	RegisterSav
scroll_state	dta ScrollLine [9]
	
	org $2000

	.local vars
scroll_delay	.byte 4
animtime	.byte 15
	.endl	; vars

	.proc init
	
	; Duplicate start of each scrolling line to its end for continuous infinite scrolling
	ldx #0
	
copy_loop
	mva screenmem.river1,x screenmem.river1+(.len screenmem.river1),x
	mva screenmem.river2,x screenmem.river2+(.len screenmem.river2),x
	mva screenmem.river3,x screenmem.river3+(.len screenmem.river3),x
	mva screenmem.river4,x screenmem.river4+(.len screenmem.river4),x
	mva screenmem.river5,x screenmem.river5+(.len screenmem.river5),x
	mva screenmem.river6,x screenmem.river6+(.len screenmem.river6),x
	mva screenmem.river7,x screenmem.river7+(.len screenmem.river7),x
	mva screenmem.river8,x screenmem.river8+(.len screenmem.river8),x
	mva screenmem.river9,x screenmem.river9+(.len screenmem.river9),x
	mva screenmem.river10,x screenmem.river10+(.len screenmem.river10),x
	mva screenmem.road1,x screenmem.road1+(.len screenmem.road1),x
	mva screenmem.road2,x screenmem.road2+(.len screenmem.road2),x
	mva screenmem.road3,x screenmem.road3+(.len screenmem.road3),x
	mva screenmem.road4,x screenmem.road4+(.len screenmem.road4),x
	mva screenmem.road5,x screenmem.road5+(.len screenmem.road5),x
	mva screenmem.road6,x screenmem.road6+(.len screenmem.road6),x
	mva screenmem.road7,x screenmem.road7+(.len screenmem.road7),x
	mva screenmem.road8,x screenmem.road8+(.len screenmem.road8),x
	inx
	cpx #60
	bne copy_loop
	
	; Point to display list
@	mwa #dlist SDLSTL
	
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

	; init scrolling
	mva #0 scroll_state[0].fine
	mva #<(.len screenmem.river1) scroll_state[0].coarse
	mva #15 scroll_state[1].fine
	mva #0 scroll_state[1].coarse
	
	rts
	
	.endp	; init

	.proc main
	
	; Disable ANTIC DMA
	mva #0 SDMCTL

	jsr init

	; Enable ANTIC DMA - wide playfield, player DMA, single line player resolution
	mva #%111011 SDMCTL	
	
	; Loop
	jmp *

	.endp	; main
	
	.local dli
	
	.proc begin_playfield
	sta registers.a
	stx registers.x
	ldx #>(charsets.river)
	sta WSYNC
	stx CHBASE
	mwa #dli.river1 VDSLST
	lda registers.a
	ldx registers.x
	rti
	.endp	; begin_playfield

	.proc river1
	sta registers.a
	stx registers.x
	lda scroll_state[0].fine
	ldx #$85
	sta WSYNC
	stx COLBK
	sta HSCROL
	mwa #dli.river2 VDSLST
	lda registers.a
	ldx registers.x
	rti
	.endp	; river1

	.proc river2
	sta registers.a
	lda scroll_state[1].fine
	eor #15
	sta WSYNC
	sta HSCROL
	mwa #dli.river3 VDSLST
	lda registers.a
	rti
	.endp	; river2

	.proc river3
	sta registers.a
	lda scroll_state[2].fine
	eor #15
	sta WSYNC
	sta HSCROL
	mwa #dli.river4 VDSLST
	lda registers.a
	rti
	.endp	; river3

	.proc river4
	sta registers.a
	lda scroll_state[3].fine
	eor #15
	sta WSYNC
	sta HSCROL
	mwa #dli.river5 VDSLST
	lda registers.a
	rti
	.endp	; river4

	.proc river5
	sta registers.a
	lda scroll_state[4].fine
	eor #15
	sta WSYNC
	sta HSCROL
	mwa #dli.bank VDSLST
	lda registers.a
	rti
	.endp	; river5
	
	.proc bank
	sta registers.a
	lda #$C6
	sta WSYNC
	sta COLBK
	mwa #dli.road1 VDSLST
	lda registers.a
	rti
	.endp	; bank
	
	.proc road1
	sta registers.a
	lda #$08
	sta WSYNC
	sta COLBK
	mwa #dli.road2 VDSLST
	lda registers.a
	rti
	.endp	; road1
	
	.proc road2
	sta registers.a
	lda #$06
	sta WSYNC
	sta COLBK
	mwa #dli.road3 VDSLST
	lda registers.a
	rti
	.endp	; road2

	.proc road3
	sta registers.a
	lda #$08
	sta WSYNC
	sta COLBK
	mwa #dli.road4 VDSLST
	lda registers.a
	rti
	.endp	; road3
		
	.proc road4
	sta registers.a
	lda #$06
	sta WSYNC
	sta COLBK
	mwa #dli.path VDSLST
	lda registers.a
	rti
	.endp	; road4
	
	.proc path
	sta registers.a
	lda #$0B
	sta WSYNC
	sta COLBK
	lda registers.a
	rti
	.endp
	
	.endl	; dli
		
	.proc vblank_handler
	mwa #dli.begin_playfield VDSLST
	dec vars.animtime
	beq animate_playfield
	jmp check_scroll
	
animate_playfield
	mva #15 vars.animtime
	
	; Animate turtles
	inc turtles.frame
	ldx turtles.frame
	lda turtles.sequence,x
	bpl @+
	ldx #0
	stx turtles.frame	
	lda turtles.sequence,x
@	tax
	lda turtles.framesl,x
	sta copysrc
	lda turtles.framesh,x
	sta copysrc+1
	mwa turtles.chars copydest
	ldy #$40
	
@	dey
	bmi check_scroll
	lda (copysrc),y 
	sta (copydest),y
	jmp @-
	 
check_scroll
	dec vars.scroll_delay
	beq scroll_playfield
	jmp exit
	
scroll_playfield
	; river row 1 - scroll left to right
	inc scroll_state[0].fine
	lda scroll_state[0].fine
	cmp #4
	bmi @+1
	lda #0
	sta scroll_state[0].fine
	dec scroll_state[0].coarse
	lda scroll_state[0].coarse
	bne @+
	lda #(.len screenmem.river1)
	sta scroll_state[0].coarse
@	sta dlist.river+1
	sta dlist.river+4

	; river row 2 - scroll right to left
@	inc scroll_state[1].fine
	lda scroll_state[1].fine
	cmp #16
	bmi @+1
	lda #12
	sta scroll_state[1].fine
	inc scroll_state[1].coarse
	lda scroll_state[1].coarse 
	cmp #<(.len screenmem.river2)
	bmi @+
	lda #0
	sta scroll_state[1].coarse
@	sta dlist.river+7
	sta dlist.river+10
	
@	mva #4 vars.scroll_delay

exit
	jmp XITVBV
	.endp	; vblank_handler 

	; character sets
	.local charsets	
	.align $400
river	ins "river.chr"
	.endl
	
	; Graphics
	icl "graphics.asm"
 	
 	; Turtles
	.local turtles
bits	ins "turtle_strip.chr"
framesl	.byte <(bits+$00),<(bits+$40),<(bits+$80),<(bits+$C0),<(bits+$100),<(bits+$140)
framesh	.byte >(bits+$00),>(bits+$40),>(bits+$80),>(bits+$C0),>(bits+$100),>(bits+$140)
chars	.word charsets.river+$88
sequence
	.byte 5, 5, 5, 5, 5, 4, 3, 2, 1, 0, 0, 0, 0, 1, 2, 3, 4, 5, $ff
frame	.byte 0

	.endl 
