	.local ANTIC
FS	= $10
VS	= $20
LMS	= $40
DLI	= $80
	.endl
	
	; Dlist - 240 scanlines
	.local dlist
	.use ANTIC
	
	; Overscan (8 + 4 scanlines)
	.byte $70, $30
	
	; Score area - 1 mode 2 line (8 scanlines)
	.byte $02 + LMS + DLI, .LO(screenmem), .HI(screenmem)
	
	; Lilypads - 2 mode 4 lines (16 scanlines)
	.byte $04
	.byte $04 + DLI
	
	; River - 9 mode 4 lines (72 scanlines)
	.byte $04 + FS + LMS
river1	.byte .LO(screenmem.river1), .HI(screenmem.river1)
	.byte $04 + FS + LMS
river2	.byte .LO(screenmem.river2), .HI(screenmem.river2)
	.byte $04 + FS + LMS + DLI
river3	.byte .LO(screenmem.river3), .HI(screenmem.river3)
	.byte $04 + FS + LMS
river4	.byte .LO(screenmem.river4), .HI(screenmem.river4)
	.byte $04 + FS + LMS
river5	.byte .LO(screenmem.river5), .HI(screenmem.river5)
	.byte $04 + FS + LMS + DLI
river6	.byte .LO(screenmem.river6), .HI(screenmem.river6)
	.byte $04 + FS + LMS
river7	.byte .LO(screenmem.river7), .HI(screenmem.river7)
	.byte $04 + FS + LMS
river8	.byte .LO(screenmem.river8), .HI(screenmem.river8)
	.byte $04 + FS + LMS
river9	.byte .LO(screenmem.river9), .HI(screenmem.river9)

	;.byte $41, .LO(dlist), .HI(dlist)

	; River bank - 3 mode 4 lines (24 scanlines)
	.byte $04 + LMS, .LO(screenmem.riverbank), .HI(screenmem.riverbank)
	.byte $04
	.byte $04
	
	; Road - 9 mode 4 lines (72 scanlines)
	.byte $04 + LMS, .LO(screenmem.road1), .HI(screenmem.road1)
	.byte $04 + LMS, .LO(screenmem.road2), .HI(screenmem.road2)
	.byte $04 + LMS, .LO(screenmem.road3), .HI(screenmem.road3)
	.byte $04 + LMS, .LO(screenmem.road4), .HI(screenmem.road4)
	.byte $04 + LMS, .LO(screenmem.road5), .HI(screenmem.road5)
	.byte $04 + LMS, .LO(screenmem.road6), .HI(screenmem.road6)
	.byte $04 + LMS, .LO(screenmem.road7), .HI(screenmem.road7)
	.byte $04 + LMS, .LO(screenmem.road8), .HI(screenmem.road8)
	.byte $04 + LMS, .LO(screenmem.road9), .HI(screenmem.road9)
	
	; Footpath - 3 mode 4 lines (24 scanlines)
	.byte $04 + LMS, .LO(screenmem.footpath), .HI(screenmem.footpath)
	.byte $04
	.byte $04
	
	; End
	.byte $41, .LO(dlist), .HI(dlist)
	
	.endl ; dlist

	; Screen memory
	.align $1000
	.local screenmem
scoreline
	.byte "    SCORE 9999    LIVES 9    HI 9999    "
lilypads
	.byte $00,$00,$00,$00,$00,$00,$00,$01,$02,$00,$00,$00,$00,$00,$00,$01,$02,$00,$00,$00,$00,$00,$00,$01,$02,$00,$00,$00,$00,$00,$00,$01,$02,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$03,$04,$00,$00,$00,$00,$00,$00,$03,$04,$00,$00,$00,$00,$00,$00,$03,$04,$00,$00,$00,$00,$00,$00,$03,$04,$00,$00,$00,$00,$00,$00,$00

	.align $100
river1	.byte $00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F
river1_end
	.ds $28
	
	.align $100
river2	.byte $00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20
river2_end
	.ds $28
	
	.align $100
river3	.byte $00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21
river3_end
	.ds $28
	
	.align $100
river4	.byte $00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F
river4_end
	.ds $28
	
	.align $100
river5	.byte $00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20
river5_end
	.ds $28
	
	.align $100
river6	.byte $00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21
river6_end
	.ds $28
	
	.align $100
river7	.byte $00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F,$00,$01,$04,$07,$0A,$0D,$10,$13,$16,$19,$1C,$1F
river7_end
	.ds $28
	
	.align $100
river8	.byte $00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20,$00,$02,$05,$08,$0B,$0E,$11,$14,$17,$1A,$1D,$20
river8_end
	.ds $28
	
	.align $100
river9	.byte $00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21,$00,$03,$06,$09,$0C,$0F,$12,$15,$18,$1B,$1E,$21
river9_end
	.ds $28
	
	.align $100
riverbank
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.align $100
	; Car characters range from $22..$6A in 3 rows 
road1	.byte $22,$25,$28,$2B,$2E,$31,$34,$37,$3A,$3D,$40,$43,$46,$49,$4C,$4F,$52,$55,$58,$5B,$5E,$61,$64,$67,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road2	.byte $23,$26,$29,$2C,$2F,$32,$35,$38,$3B,$3E,$41,$44,$47,$4A,$4D,$50,$53,$56,$59,$5C,$5F,$62,$65,$68,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road3	.byte $24,$27,$2A,$2D,$30,$33,$36,$39,$3C,$3F,$42,$45,$48,$4B,$4E,$51,$54,$57,$5A,$5D,$60,$63,$66,$69,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	
road4	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road5	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road6	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	
road7	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road8	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
road9	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	

	.align $100
footpath
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

	.endl ; screenmem
	