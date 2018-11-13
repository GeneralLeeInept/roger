	; Roger - a frogger-a-like for the Atari 800XL

	icl "SystemEquates.asm"

	; Memory mapped registers
;screenptr = $B0

	; Graphics
	org $4000
	icl "Graphics.asm"
	icl "Sprites.asm"
	icl "CharSet.asm"
		
	org $2000
	
	; Variables
scroll_delay		.byte 4

	.local log1
fine_scroll		.byte 0
coarse_scroll		.byte 0
	.endl
	
log2_fine_scroll	.byte 1
log3_fine_scroll	.byte 0
car1_fine_scroll	.byte 1
car2_fine_scroll	.byte 0
car3_fine_scroll	.byte 1
log2_coarse_scroll	.byte 1
log3_coarse_scroll	.byte 0
car1_coarse_scroll	.byte 1
car2_coarse_scroll	.byte 0
car3_coarse_scroll	.byte 1

	; Program
	.proc main

	; Setup graphics
	mva #0 SDMCTL

	; Copy first 40 bytes of each scrolling line into end buffer
	ldx #40
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
	dex
	bne copy_loop
	
	; Point to display list
	mwa #dlist SDLSTL
	
	; Setup VBLANK handler
	lda #07
	ldx #.HI(vblank_handler)
	ldy #.LO(vblank_handler)
	jsr SETVBV
	
	; setup DLI handler
	mwa #dlist_playfield VDSLST
	mva #192 NMIEN

	; Enable ANTIC DMA
	mva #$22 SDMCTL	
	
	; Loop
	jmp *
	.endp
	
	.proc dlist_playfield
	; switch to custom character set
	pha
	lda #.HI(charset)
	sta WSYNC
	sta CHBASE
	; chain to next DLI handler
	mwa #dlist_log1 VDSLST
	pla
	rti
	.endp

	.proc dlist_log1
	; set fine scroll for log1
	pha
	lda #15
	sec
	sbc log1.fine_scroll
	sta WSYNC
	sta HSCROL
	; chain to next DLI handler
	mwa #dlist_log2 VDSLST
	pla
	rti
	.endp

	.proc dlist_log2
	; set fine scroll for log2
	pha
	lda #15
	sec
	sbc log2_fine_scroll
	sta WSYNC
	sta HSCROL
	; chain to next DLI handler
	mwa #dlist_log3 VDSLST
	pla
	rti
	.endp

	.proc dlist_log3
	pha
	; set fine scroll for log3
	lda #15
	sec
	sbc log3_fine_scroll
	sta WSYNC
	sta HSCROL
	; chain to next DLI handler
	mwa #dlist_playfield VDSLST
	pla
	rti
	.endp
	
	.proc vblank_handler
	; Update playfield
	dec scroll_delay
	beq scroll_playfield
	jmp exit
	
scroll_playfield
	lda #4
	sta scroll_delay
	;
	; - Scroll log1
	inc log1.fine_scroll
	lda log1.fine_scroll
	cmp #4
	bcs @+
	sec
	sbc #4
	sta log1.fine_scroll
	inc log1.coarse_scroll
	lda log1.coarse_scroll
	cmp #(screenmem.river1_end - screenmem.river1)
	bne @+
	lda #0
	sta log1.coarse_scroll
@	lda log1.coarse_scroll
	sta dlist.river1
	sta dlist.river2
	sta dlist.river3
	;
	; - Scroll log2
	dec log2_fine_scroll
	bne @+
	lda log2_fine_scroll
	clc
	adc #4
	sta log2_fine_scroll
	dec log2_coarse_scroll
	lda log2_coarse_scroll
	cmp #0
	bne @+
	lda #(screenmem.river4_end - screenmem.river4)
	sta log2_coarse_scroll
@	lda log2_coarse_scroll
	sta dlist.river4
	sta dlist.river5
	sta dlist.river6
	;
	; - Scroll log3
	inc log3_fine_scroll
	lda log3_fine_scroll
	cmp #4
	bcs @+
	sec
	sbc #4
	sta log3_fine_scroll
	inc log3_coarse_scroll
	lda log3_coarse_scroll
	cmp #(screenmem.river7_end - screenmem.river7)
	bne @+
	lda #0
	sta log3_coarse_scroll
@	lda log3_coarse_scroll
	sta dlist.river7
	sta dlist.river8
	sta dlist.river9

exit
	jmp XITVBV
	.endp
		
	run main
	