; Atari 800 memory map equates

; OS page zero
RTCLOK	= $0012

; Shadow registers
VDSLST	= $0200
SDMCTL	= $022F
SDLSTL	= $0230
COLOR0	= $02C4          	
COLOR1	= $02C5          	
COLOR2	= $02C6          	
COLOR3	= $02C7
COLOR4	= $02C8          	

; GTIA
HPOSP0	= $D000
HPOSP1	= $D001
COLPM0	= $D012          	
COLPM1	= $D013          	
COLPM2	= $D014          	
COLPM3	= $D015          	
COLPF0	= $D016          	
COLPF1	= $D017          	
COLPF2	= $D018          	
COLPF3	= $D019          	
COLBK	= $D01A
PRIOR	= $D01B
GRACTL	= $D01D

; ANTIC
HSCROL	= $D404
PMBASE	= $D407
CHBASE	= $D409
WSYNC  	= $D40A
VCOUNT	= $D40B
NMIEN 	= $D40E

; OS Vector
SETVBV	= $E45C
XITVBV	= $E462
