		dc.b	$0A
		dc.b	"                Lea     ScrollBBase+($b*64)+(27*2),A1", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM    ", $0D, $0A
		dc.b	"                Move.w  #AsciiOffset+CHR_Palette0+CHR_HighPri,D5 ; Color is different if in impulse.", $0D, $0A, $0D, $0A
		dc.b	"                Bra     @DoneSeperators", $0D, $0A, $0D, $0A
		dc.b	"@NotImpulse:", $0D, $0A
		dc.b	"                Move.w  #AsciiOffset+CHR_Palette3+CHR_HighPri+'.',D0        ; Place decimal points and '/' seperators.", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($5*64)+(28*2),A1           ", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM     ", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($7*64)+(27*2),A1", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM     ", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($d*64)+(28*2),A1", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM     ", $0D, $0A
		dc.b	"                Move.w  #AsciiOffset+CHR_Palette3+CHR_HighPri+'/',D0  ", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($9*64)+(27*2),A1", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM    ", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($b*64)+(27*2),A1", $0D, $0A
		dc.b	"                Jsr     Word_2GVRAM    ", $0D, $0A
		dc.b	"                Move.w  #AsciiOffset+CHR_Palette3+CHR_HighPri,D5 ; Set up character color.", $0D, $0A, $0D, $0A
		dc.b	"@DoneSeperators:", $0D, $0A
		dc.b	"                Move.w  CurrentDistance,D7                      ; Get whole part of DISTANCE.", $0D, $0A
		dc.b	"                Moveq   #3,D6                                   ; Three characters.", $0D, $0A
		dc.b	"                Moveq   #'$',D2                                 ; Lead with a spaces.", $0D, $0A
		dc.b	"                Lea     ScrollBBase+($5*64)+(25*2),A1           ; Screen destination.", $0D, $0A
		dc.b	"                Jsr     PrintVal                                ; Print it.", $0D, $0A
		dc.b	"                Move.w  CurrentDistance+2,D7                    ; Get fractional part of DISTANCE.", $0D, $0A
		dc.b	"                Moveq   #2,D6                                   ; Two digits.", $0D, $0A
		dc.b	"                Move.w  #'0'"