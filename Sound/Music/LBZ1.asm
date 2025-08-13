s3p13_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     s3p13_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $10

	smpsHeaderDAC       s3p13_DAC
	smpsHeaderFM        s3p13_FM1,	$18, $12
	smpsHeaderFM        s3p13_FM2,	$00, $16
	smpsHeaderFM        s3p13_FM3,	$00, $17
	smpsHeaderFM        s3p13_FM4,	$00, $19
	smpsHeaderFM        s3p13_FM5,	$00, $19
	smpsHeaderPSG       s3p13_PSG1,	$00, $05, $00, sTone_0C
	smpsHeaderPSG       s3p13_PSG2,	$00, $05, $00, sTone_0C
	smpsHeaderPSG       s3p13_PSG3,	$00, $03, $00, sTone_0C

; Unreachable
	smpsStop
	smpsStop

; DAC Data
s3p13_DAC:
	dc.b	dSnareS3, $18, dSnareS3, $30, dSnareS3, $08, dSnareS3, $08, dSnareS3, $08, dSnareS3, $10
	dc.b	dSnareS3, $08, dSnareS3, $30, dSnareS3, $08, dSnareS3, $08, dSnareS3, $08, dSnareS3, $10
	dc.b	dSnareS3, $08, dSnareS3, $30, dSnareS3, $08, dSnareS3, $08, dSnareS3, $08, dSnareS3, $10
	dc.b	dSnareS3, $08, dSnareS3, $48

s3p13_Jump00:
	dc.b	dKickS3, $18, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3
	dc.b	dKickS3, dKickS3, dKickS3, dKickS3, dSnareS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3
	dc.b	dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dSnareS3, dKickS3, dKickS3, dKickS3
	dc.b	dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3
	dc.b	dSnareS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3, dKickS3
	dc.b	dKickS3, dKickS3, dKickS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	$0C, dSnareS3, dSnareS3, dSnareS3, dKickS3, $18, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, $0C, dSnareS3
	smpsJump            s3p13_Jump00

; Unreachable
	smpsStop

; FM1 Data
s3p13_FM1:
	smpsSetvoice        $0A
	smpsDetune          $FC
	smpsModSet          $0F, $01, $06, $06
	smpsCall            s3p13_Call04

s3p13_Jump05:
	smpsSetvoice        $00
	smpsCall            s3p13_Call05
	smpsJump            s3p13_Jump05

; Unreachable
	smpsStop

s3p13_Call04:
	dc.b	nBb0, $05, nRst, $13, nBb0, $2D, nRst, $03, nBb0, $05, nRst, $03
	dc.b	nBb0, $05, nRst, $03, nBb0, $05, nRst, $03, nBb0, $05, nRst, $0B
	dc.b	nBb0, $05, nRst, $03, nBb0, $2D, nRst, $03, nBb0, $05, nRst, $03
	dc.b	nBb0, $05, nRst, $03, nBb0, $05, nRst, $03, nBb0, $05, nRst, $0B
	dc.b	nBb0, $05, nRst, $03, nBb0, $2D, nRst, $03, nBb0, $05, nRst, $03
	dc.b	nBb0, $05, nRst, $03, nBb0, $05, nRst, $03, nF1, $05, nRst, $0B
	dc.b	nF1, $05, nRst, $03, nF1, $45, nRst, $03
	smpsReturn

s3p13_Call05:
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nBb0, $03, nRst, $09
	dc.b	nBb0, $03, nRst, $09, nBb0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nG0, $03, nRst, $09, nG0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nG0, $03, nRst, $09, nG0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nG0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nG0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nG0, $03, nRst, $09, nG0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nG0, $03, nRst, $09, nG0, $03, nRst, $09, nG0, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nCs1, $03, nRst, $09, nCs1, $03, nRst, $09
	dc.b	nCs1, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nEb1, $03, nRst, $09
	dc.b	nEb1, $03, nRst, $09, nEb1, $03, nRst, $09, nAb1, $03, nRst, $09
	dc.b	nAb1, $03, nRst, $09, nAb1, $03, nRst, $09, nAb1, $03, nRst, $09
	dc.b	nFs1, $03, nRst, $09, nFs1, $03, nRst, $09, nFs1, $03, nRst, $09
	dc.b	nFs1, $03, nRst, $09, nF1, $03, nRst, $09, nF1, $03, nRst, $09
	dc.b	nF1, $03, nRst, $09, nF1, $03, nRst, $09, nE1, $03, nRst, $09
	dc.b	nE1, $03, nRst, $09, nE1, $03, nRst, $09, nE1, $03, nRst, $09
	dc.b	nEb1, $08, nRst, $04, nD1, $14, nRst, $04, nF1, $08, nRst, $04
	dc.b	nE1, $14, nRst, $04, nAb1, $08, nRst, $04, nG1, $14, nRst, $04
	dc.b	nBb1, $08, nRst, $04, nA1, $14, nRst, $04, nB1, $14, nRst, $04
	dc.b	nBb1, $14, nRst, $04, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	dc.b	nAb0, $03, nRst, $09, nAb0, $03, nRst, $09, nAb0, $03, nRst, $09
	smpsReturn

; Unreachable
	smpsStop

; FM2 Data
s3p13_FM2:
	smpsSetvoice        $0A
	smpsDetune          $04
	smpsModSet          $0F, $01, $06, $06
	smpsCall            s3p13_Call02
	smpsSetvoice        $0A
	smpsDetune          $04
	smpsModSet          $0F, $01, $06, $06

s3p13_Jump04:
	smpsSetvoice        $0A
	smpsDetune          $04
	smpsModSet          $0F, $01, $06, $06
	smpsCall            s3p13_Call03
	smpsJump            s3p13_Jump04

s3p13_Call02:
	dc.b	nD4, $04, nRst, $14, nD4, $2F, nRst, $01, nEb4, $08, nD4, $07
	dc.b	nRst, $01, nC4, $08, nBb3, $03, nRst, $0D, nD4, $03, nRst, $05
	dc.b	nD4, $30, nEb4, $07, nRst, $01, nD4, $08, nC4, $05, nRst, $03
	dc.b	nBb3, $05, nRst, $0B, nD4, $03, nRst, $05, nD4, $30, nC4, $06
	dc.b	nRst, $02, nD4, $06, nRst, $02, nEb4, $07, nRst, $01, nD4, $02
	dc.b	nRst, $0E, nA3, $03, nRst, $05, nA3, $3A, nRst, $0E
	smpsReturn

s3p13_Call03:
	dc.b	nEb3, $38, nRst, $04, nBb3, $08, nRst, $04, nEb4, $08, nRst, $04
	dc.b	nBb3, $08, nRst, $04, nCs4, $14, nRst, $04, nC4, $14, nRst, $04
	dc.b	nAb3, $14, nRst, $04, nAb3, $08, nRst, $04, nC4, $08, nRst, $04
	dc.b	nBb3, $20, nRst, $04, nEb3, $60, $38, nRst, $04, nEb3, $38, nRst
	dc.b	$04, nBb3, $08, nRst, $04, nEb4, $08, nRst, $04, nBb3, $08, nRst
	dc.b	$04, nCs4, $14, nRst, $04, nC4, $14, nRst, $04, nAb3, $14, nRst
	dc.b	$04, nAb3, $08, nRst, $04, nC4, $08, nRst, $04, nBb3, $60, $5C
	dc.b	nRst, $04, nEb3, $38, nRst, $04, nBb3, $08, nRst, $04, nEb4, $08
	dc.b	nRst, $04, nBb3, $08, nRst, $04, nCs4, $14, nRst, $04, nC4, $14
	dc.b	nRst, $04, nAb3, $14, nRst, $04, nAb3, $08, nRst, $04, nC4, $08
	dc.b	nRst, $04, nBb3, $20, nRst, $04, nEb3, $60, $38, nRst, $04, nEb3
	dc.b	$38, nRst, $04, nBb3, $08, nRst, $04, nEb4, $08, nRst, $04, nBb3
	dc.b	$08, nRst, $04, nCs4, $14, nRst, $04, nC4, $14, nRst, $04, nAb3
	dc.b	$14, nRst, $04, nAb3, $08, nRst, $04, nC4, $08, nRst, $04, nBb3
	dc.b	$60, $5C, nRst, $04, nBb3, $2C, nRst, $04, nG3, $08, nRst, $04
	dc.b	nBb3, $08, nRst, $04, nD4, $08, nRst, $04, nBb3, $08, nRst, $04
	dc.b	nEb4, $08, nRst, $04, nD4, $08, nRst, $04, nC4, $08, nRst, $04
	dc.b	nBb3, $20, nRst, $04, nBb3, $08, nRst, $04, nC4, $08, nRst, $04
	dc.b	nD4, $08, nRst, $04, nBb3, $08, nRst, $04, nG3, $08, nRst, $04
	dc.b	nBb3, $14, nRst, $04, nG3, $08, nRst, $04, nBb3, $08, nRst, $04
	dc.b	nC4, $60, $08, nRst, $04, nBb3, $2C, nRst, $04, nBb3, $08, nRst
	dc.b	$04, nC4, $08, nRst, $04, nD4, $08, nRst, $04, nBb3, $08, nRst
	dc.b	$04, nG4, $08, nRst, $04, nF4, $08, nRst, $04, nEb4, $08, nRst
	dc.b	$04, nBb3, $08, nRst, $04, nC4, $08, nRst, $04, nD4, $08, nRst
	dc.b	$04, nEb4, $08, nRst, $04, nF4, $08, nRst, $04, nD4, $20, nRst
	dc.b	$04, nC4, $08, nRst, $04, nC4, $60, $2C, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nBb4, $08
	dc.b	nRst, $04, nC5, $08, nRst, $04, nAb4, $20, nRst, $04, nF4, $14
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nBb4, $08, nRst, $04, nC5, $08
	dc.b	nRst, $04, nAb4, $14, nRst, $04, nAb4, $08, nRst, $04, nBb4, $08
	dc.b	nRst, $04, nC5, $08, nRst, $04, nC5, $08, nRst, $04, nBb4, $08
	dc.b	nRst, $04, nG4, $08, nRst, $04, nEb4, $38, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08
	dc.b	nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nBb4, $08
	dc.b	nRst, $04, nC5, $08, nRst, $04, nAb4, $20, nRst, $1C, nAb4, $08
	dc.b	nRst, $04, nG4, $08, nRst, $10, nBb4, $08, nRst, $04, nA4, $08
	dc.b	nRst, $10, nC5, $08, nRst, $04, nB4, $08, nRst, $10, nCs5, $08
	dc.b	nRst, $04, nC5, $08, nRst, $10, nE5, $14, nRst, $04, nEb5, $14
	dc.b	nRst, $04, nAb4, $60, $38, nRst, $04, nAb4, $03, nRst, nBb4, nRst
	dc.b	nC5, nRst, nBb4, nRst, nAb4, nRst, nG4, nRst, nAb4, $20, nRst, $04
	dc.b	nEb4, $08, nRst, $04, nEb4, $2C, nRst, $04, nF4, $08, nRst, $04
	dc.b	nF4, $08, nRst, $04, nG4, $08, nRst, $04, nAb4, $08, nRst, $10
	dc.b	nBb4, $20, nRst, $04
	smpsReturn

; Unreachable
	smpsStop

; FM3 Data
s3p13_FM3:
	dc.b	nRst, $0C
	smpsFMAlterVol      $06
	smpsSetvoice        $0A
	smpsDetune          $FC
	smpsModSet          $0F, $01, $06, $06
	smpsCall            s3p13_Call02
	smpsFMAlterVol      $02
	smpsSetvoice        $0A
	smpsDetune          $FC
	smpsModSet          $0F, $01, $06, $06

s3p13_Jump03:
	smpsCall            s3p13_Call03
	smpsJump            s3p13_Jump03

; Unreachable
	smpsStop

; FM4 Data
s3p13_FM4:
	smpsSetvoice        $08
	smpsDetune          $03
	smpsModSet          $03, $01, $FD, $05
	smpsPan             panLeft, $00
	smpsCall            s3p13_Call00

s3p13_Jump02:
	smpsCall            s3p13_Call01
	smpsJump            s3p13_Jump02

; Unreachable
	smpsStop

; FM5 Data
s3p13_FM5:
	smpsSetvoice        $08
	smpsDetune          $FD
	smpsModSet          $03, $01, $03, $05
	smpsPan             panRight, $00
	smpsCall            s3p13_Call00

s3p13_Jump01:
	smpsCall            s3p13_Call01
	smpsJump            s3p13_Jump01

; Unreachable
	smpsStop

s3p13_Call00:
	dc.b	nF4, $05, nRst, $13, nF4, $2F, nRst, $01, nG4, $08, nF4, $07
	dc.b	nRst, $01, nEb4, $08, nD4, $04, nRst, $0C, nF4, $03, nRst, $05
	dc.b	nF4, $30, nG4, $08, nF4, $07, nRst, $01, nEb4, $08, nD4, $07
	dc.b	nRst, $09, nF4, $04, nRst, nF4, $30, nEb4, $08, nF4, nG4, nF4
	dc.b	$05, nRst, $0B, nC4, $04, nRst, nC4, $46, nRst, $02
	smpsReturn

s3p13_Call01:
	dc.b	nRst, $60, nRst, nRst, $3C, nBb3, $0C, nEb4, nBb3, $0B, nRst, $01
	dc.b	nCs4, $18, nC4, $17, nRst, $01, nAb3, $13, nRst, $05, nAb3, $0A
	dc.b	nRst, $02, nC4, $0C, nBb3, $24, nEb3, $60, $3A, nRst, $32, nBb3
	dc.b	$0C, nC4, $0B, nRst, $01, nD4, $0B, nRst, $01, nEb4, $0B, nRst
	dc.b	$01, nF4, $0C, nBb4, $54, nRst, $60, nRst, nRst, $3C, nBb3, $0B
	dc.b	nRst, $01, nEb4, $0B, nRst, $01, nBb3, $0A, nRst, $02, nCs4, $17
	dc.b	nRst, $01, nC4, $17, nRst, $01, nAb3, $15, nRst, $03, nAb3, $0B
	dc.b	nRst, $01, nC4, $0C, nBb3, $22, nRst, $02, nEb3, $60, $3B, nRst
	dc.b	$31, nBb3, $0B, nRst, $01, nC4, $0C, nD4, $0B, nRst, $01, nEb4
	dc.b	$0C, nF4, $0B, nRst, $01, nBb4, $48, nA4, $0B, nRst, $01, nG4
	dc.b	$5F, nRst, $01, nEb4, $5F, nRst, $01, nD4, $24, nF4, $16, nRst
	dc.b	$02, nF3, $0B, nRst, $01, nBb3, $0B, nRst, $01, nA3, $54, nRst
	dc.b	$18, nG4, $60, nEb4, nD4, $24, nF4, $3A, nRst, $02, nE4, $24
	dc.b	nG4, $39, nRst, $03, nAb4, nRst, $09, nEb4, $02, nRst, $0A, nC4
	dc.b	$03, nRst, $09, nAb4, $04, nRst, $08, nEb4, $03, nRst, $09, nC4
	dc.b	$03, nRst, $09, nAb4, $03, nRst, $09, nEb4, $04, nRst, $08, nF4
	dc.b	$03, nRst, $09, nCs4, $03, nRst, $09, nAb3, $03, nRst, $09, nF4
	dc.b	$04, nRst, $08, nCs4, $03, nRst, $09, nAb3, $04, nRst, $08, nF4
	dc.b	$04, nRst, $08, nCs4, $04, nRst, $08, nAb4, $03, nRst, $09, nEb4
	dc.b	$03, nRst, $09, nC4, $03, nRst, $09, nAb4, $04, nRst, $08, nEb4
	dc.b	$05, nRst, $07, nC4, $05, nRst, $07, nAb4, $04, nRst, $08, nEb4
	dc.b	$03, nRst, $09, nBb4, $04, nRst, $08, nG4, $03, nRst, $09, nEb4
	dc.b	$03, nRst, $09, nBb4, $05, nRst, $07, nG4, $03, nRst, $09, nEb4
	dc.b	$04, nRst, $08, nBb4, $04, nRst, $08, nG4, $02, nRst, $22, nAb4
	dc.b	$18, nRst, nFs4, $17, nRst, $19, nF4, $17, nRst, $19, nE4, $17
	dc.b	nRst, $01, nAb4, $03, nRst, $09, nG4, $04, nRst, $08, nFs4, $04
	dc.b	nRst, $08, nF4, $05, nRst, $07, nE4, $04, nRst, $08, nEb4, $05
	dc.b	nRst, $07, nD4, $04, nRst, $08, nCs4, $05, nRst, $07, nC4, $05
	dc.b	nRst, $07, nB3, $04, nRst, $08, nBb3, $06, nRst, nA3, $05, nRst
	dc.b	$07, nAb3, $14, nRst, $04, nG3, $0E, nRst, $0A, nAb4, $04, nRst
	dc.b	$08, nEb4, $03, nRst, $09, nC4, $04, nRst, $08, nAb4, $05, nRst
	dc.b	$07, nEb4, $04, nRst, $08, nC4, $05, nRst, $07, nAb4, $05, nRst
	dc.b	$07, nEb4, $06, nRst, nF4, $04, nRst, $08, nCs4, $04, nRst, $08
	dc.b	nAb3, $04, nRst, $08, nF4, $05, nRst, $07, nCs4, $04, nRst, $08
	dc.b	nAb3, $05, nRst, $07, nF4, $06, nRst, nCs4, $05, nRst, $07, nAb4
	dc.b	$04, nRst, $08, nEb4, $04, nRst, $08, nC4, $05, nRst, $07, nAb4
	dc.b	$05, nRst, $07, nEb4, $04, nRst, $08, nC4, $06, nRst, nAb4, $04
	dc.b	nRst, $08, nEb4, $05, nRst, $07, nCs4, $16, nRst, $02, nEb4, $0C
	dc.b	nF4, $07, nRst, $11, nG4, $24
	smpsJump            s3p13_Call01

; Unreachable
	smpsStop

; PSG3 Data
s3p13_PSG3:
	smpsPSGvoice        sTone_02
	smpsPSGform         $E7
	dc.b	nMaxPSG1, $18, nMaxPSG1, $30, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $10
	dc.b	nMaxPSG1, $08, nMaxPSG1, $30, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $10
	dc.b	nMaxPSG1, $08, nMaxPSG1, $30, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $08, nMaxPSG1, $10
	dc.b	nMaxPSG1, $08, nMaxPSG1, $48

s3p13_Jump07:
	dc.b	nMaxPSG1, $0C, nMaxPSG1, $06, nMaxPSG1, nMaxPSG1, $0C, nMaxPSG1, $06, nMaxPSG1, nMaxPSG1, $0C
	dc.b	nMaxPSG1, $06, nMaxPSG1, nMaxPSG1, $0C, nMaxPSG1, $06, nMaxPSG1
	smpsJump            s3p13_Jump07

; Unreachable
	smpsStop

; PSG1 Data
s3p13_PSG1:
	smpsPSGvoice        sTone_0A
	smpsDetune          $FF
	smpsChangeTransposition $F4
	smpsCall            s3p13_Call06
	smpsChangeTransposition $0C
	smpsJump            s3p13_Jump06

; PSG2 Data
s3p13_PSG2:
	smpsPSGvoice        sTone_0A
	smpsDetune          $00
	smpsChangeTransposition $F4
	smpsCall            s3p13_Call06
	smpsChangeTransposition $0C
	smpsJump            s3p13_Jump06

s3p13_Call06:
	dc.b	nF5, $05, nRst, $13, nF5, $2F, nRst, $01, nG5, $08, nF5, $07
	dc.b	nRst, $01, nEb5, $08, nD5, $04, nRst, $0C, nF5, $03, nRst, $05
	dc.b	nF5, $30, nG5, $08, nF5, $07, nRst, $01, nEb5, $08, nD5, $07
	dc.b	nRst, $09, nF5, $04, nRst, nF5, $30, nEb5, $08, nF5, nG5, nF5
	dc.b	$05, nRst, $0B, nC5, $04, nRst, nC5, $46, nRst, $02
	smpsReturn

s3p13_Jump06:
	dc.b	nRst, $60, nRst, nRst, $54, nBb1, $01, nRst, $05, nBb1, $02, nRst
	dc.b	$04, nBb1, $02, nRst, $22, nAb1, $01, nRst, $05, nAb1, $01, nRst
	dc.b	$05, nAb1, $01, nRst, $60, nRst, nRst, nRst, $23, nBb1, $01, nRst
	dc.b	$05, nBb1, $02, nRst, $04, nBb1, $02, nRst, $22, nAb1, $01, nRst
	dc.b	$05, nAb1, $01, nRst, $05, nAb1, $01, nRst, $60, nRst, nRst, nRst
	dc.b	$23, nBb1, $01, nRst, $05, nBb1, $02, nRst, $04, nBb1, $02, nRst
	dc.b	$22, nAb1, $01, nRst, $05, nAb1, $01, nRst, $05, nAb1, $01, nRst
	dc.b	$60, nRst, nRst, nRst, $47, nAb1, $01, nRst, $05, nAb1, $01, nRst
	dc.b	$05, nAb1, $01, nRst, $05, nAb1, $01, nRst, $05, nAb1, $01, nRst
	dc.b	$0B, nEb1, $02, nRst, $0A, nEb1, $02, nRst, $60, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, $16
	smpsJump            s3p13_Jump06

; Unreachable
	smpsStop

s3p13_Voices:
;	Voice $00
;	$3C
;	$01, $00, $00, $00, 	$1F, $1F, $15, $1F, 	$11, $0D, $12, $05
;	$07, $04, $09, $02, 	$55, $3A, $25, $1A, 	$1A, $80, $07, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $15, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $12, $0D, $11
	smpsVcDecayRate2    $02, $09, $04, $07
	smpsVcDecayLevel    $01, $02, $03, $05
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $80, $07, $80, $1A

;	Voice $01
;	$3D
;	$01, $01, $01, $01, 	$94, $19, $19, $19, 	$0F, $0D, $0D, $0D
;	$07, $04, $04, $04, 	$25, $1A, $1A, $1A, 	$15, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $02
	smpsVcAttackRate    $19, $19, $19, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0D, $0D, $0F
	smpsVcDecayRate2    $04, $04, $04, $07
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $80, $80, $80, $15

;	Voice $02
;	$03
;	$00, $D7, $33, $02, 	$5F, $9F, $5F, $1F, 	$13, $0F, $0A, $0A
;	$10, $0F, $02, $09, 	$35, $15, $25, $1A, 	$13, $16, $15, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $0D, $00
	smpsVcCoarseFreq    $02, $03, $07, $00
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0F, $13
	smpsVcDecayRate2    $09, $02, $0F, $10
	smpsVcDecayLevel    $01, $02, $01, $03
	smpsVcReleaseRate   $0A, $05, $05, $05
	smpsVcTotalLevel    $80, $15, $16, $13

;	Voice $03
;	$34
;	$70, $72, $31, $31, 	$1F, $1F, $1F, $1F, 	$10, $06, $06, $06
;	$01, $06, $06, $06, 	$35, $1A, $15, $1A, 	$10, $80, $18, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $01, $02, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $06, $06, $10
	smpsVcDecayRate2    $06, $06, $06, $01
	smpsVcDecayLevel    $01, $01, $01, $03
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $80, $18, $80, $10

;	Voice $04
;	$3E
;	$77, $71, $32, $31, 	$1F, $1F, $1F, $1F, 	$0D, $06, $00, $00
;	$08, $06, $00, $00, 	$15, $0A, $0A, $0A, 	$1B, $80, $80, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $02, $01, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $06, $0D
	smpsVcDecayRate2    $00, $00, $06, $08
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $80, $80, $80, $1B

;	Voice $05
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $80, $29, $87
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $04, $03
	smpsVcCoarseFreq    $04, $0E, $01, $03
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0E, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $87, $29, $80, $23

;	Voice $06
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $07, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $27, $28, $18

;	Voice $07
;	$3C
;	$32, $32, $71, $42, 	$1F, $18, $1F, $1E, 	$07, $1F, $07, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $1F, $0F, 	$1E, $80, $0C, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $03, $03
	smpsVcCoarseFreq    $02, $01, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1E, $1F, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $07, $1F, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $0C, $80, $1E

;	Voice $08
;	$3C
;	$71, $72, $3F, $34, 	$8D, $52, $9F, $1F, 	$09, $00, $00, $0D
;	$00, $00, $00, $00, 	$23, $08, $02, $F7, 	$15, $80, $1D, $87
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $0F, $02, $01
	smpsVcRateScale     $00, $02, $01, $02
	smpsVcAttackRate    $1F, $1F, $12, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $00, $00, $09
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $00, $00, $02
	smpsVcReleaseRate   $07, $02, $08, $03
	smpsVcTotalLevel    $87, $1D, $80, $15

;	Voice $09
;	$3D
;	$01, $01, $00, $00, 	$8E, $52, $14, $4C, 	$08, $08, $0E, $03
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1B, $80, $80, $9B
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $01, $01
	smpsVcRateScale     $01, $00, $01, $02
	smpsVcAttackRate    $0C, $14, $12, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $08, $08
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $9B, $80, $80, $1B

;	Voice $0A
;	$3A
;	$31, $53, $31, $41, 	$8D, $4F, $15, $52, 	$06, $08, $07, $04
;	$02, $00, $00, $00, 	$1F, $1F, $2F, $2F, 	$19, $20, $2A, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $03, $05, $03
	smpsVcCoarseFreq    $01, $01, $03, $01
	smpsVcRateScale     $01, $00, $01, $02
	smpsVcAttackRate    $12, $15, $0F, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $07, $08, $06
	smpsVcDecayRate2    $00, $00, $00, $02
	smpsVcDecayLevel    $02, $02, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $2A, $20, $19

;	Voice $0B
;	$3C
;	$36, $31, $76, $71, 	$94, $9F, $96, $9F, 	$12, $00, $14, $0F
;	$04, $0A, $04, $0D, 	$2F, $0F, $4F, $2F, 	$33, $80, $1A, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $03, $03
	smpsVcCoarseFreq    $01, $06, $01, $06
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $1F, $16, $1F, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $14, $00, $12
	smpsVcDecayRate2    $0D, $04, $0A, $04
	smpsVcDecayLevel    $02, $04, $00, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1A, $80, $33

;	Voice $0C
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $90, $29, $97
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $04, $03
	smpsVcCoarseFreq    $04, $0E, $01, $03
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0E, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $97, $29, $90, $23

;	Voice $0D
;	$38
;	$63, $31, $31, $31, 	$10, $13, $1A, $1B, 	$0E, $00, $00, $00
;	$00, $00, $00, $00, 	$3F, $0F, $0F, $0F, 	$1A, $19, $1A, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $06
	smpsVcCoarseFreq    $01, $01, $01, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1B, $1A, $13, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1A, $19, $1A

;	Voice $0E
;	$3A
;	$31, $25, $73, $41, 	$5F, $1F, $1F, $9C, 	$08, $05, $04, $1E
;	$03, $04, $02, $06, 	$2F, $2F, $1F, $0F, 	$29, $27, $1F, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $02, $03
	smpsVcCoarseFreq    $01, $03, $05, $01
	smpsVcRateScale     $02, $00, $00, $01
	smpsVcAttackRate    $1C, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1E, $04, $05, $08
	smpsVcDecayRate2    $06, $02, $04, $03
	smpsVcDecayLevel    $00, $01, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1F, $27, $29

;	Voice $0F
;	$04
;	$71, $41, $31, $31, 	$12, $12, $12, $12, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $04, $07
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $12, $12, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $23, $80, $23

;	Voice $10
;	$14
;	$75, $72, $35, $32, 	$9F, $9F, $9F, $9F, 	$05, $05, $00, $0A
;	$05, $05, $07, $05, 	$2F, $FF, $0F, $2F, 	$1E, $80, $14, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $05, $02, $05
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $05, $05
	smpsVcDecayRate2    $05, $07, $05, $05
	smpsVcDecayLevel    $02, $00, $0F, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $14, $80, $1E

;	Voice $11
;	$3D
;	$01, $00, $01, $02, 	$12, $1F, $1F, $14, 	$07, $02, $02, $0A
;	$05, $05, $05, $05, 	$2F, $2F, $2F, $AF, 	$1C, $80, $82, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $1F, $1F, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $02, $02, $07
	smpsVcDecayRate2    $05, $05, $05, $05
	smpsVcDecayLevel    $0A, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $82, $80, $1C

;	Voice $12
;	$1C
;	$73, $72, $33, $32, 	$94, $99, $94, $99, 	$08, $0A, $08, $0A
;	$00, $05, $00, $05, 	$3F, $4F, $3F, $4F, 	$1E, $80, $19, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $03, $02, $03
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $19, $14, $19, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $08, $0A, $08
	smpsVcDecayRate2    $05, $00, $05, $00
	smpsVcDecayLevel    $04, $03, $04, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $19, $80, $1E

;	Voice $13
;	$31
;	$33, $01, $00, $00, 	$9F, $1F, $1F, $1F, 	$0D, $0A, $0A, $0A
;	$0A, $07, $07, $07, 	$FF, $AF, $AF, $AF, 	$1E, $1E, $1E, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $03
	smpsVcCoarseFreq    $00, $00, $01, $03
	smpsVcRateScale     $00, $00, $00, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0A, $0D
	smpsVcDecayRate2    $07, $07, $07, $0A
	smpsVcDecayLevel    $0A, $0A, $0A, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1E, $1E, $1E

;	Voice $14
;	$3A
;	$70, $76, $30, $71, 	$1F, $95, $1F, $1F, 	$0E, $0F, $05, $0C
;	$07, $06, $06, $07, 	$2F, $4F, $1F, $5F, 	$21, $12, $28, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $07, $07
	smpsVcCoarseFreq    $01, $00, $06, $00
	smpsVcRateScale     $00, $00, $02, $00
	smpsVcAttackRate    $1F, $1F, $15, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $05, $0F, $0E
	smpsVcDecayRate2    $07, $06, $06, $07
	smpsVcDecayLevel    $05, $01, $04, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $28, $12, $21

;	Voice $15
;	$28
;	$71, $00, $30, $01, 	$1F, $1F, $1D, $1F, 	$13, $13, $06, $05
;	$03, $03, $02, $05, 	$4F, $4F, $2F, $3F, 	$0E, $14, $1E, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $00, $07
	smpsVcCoarseFreq    $01, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1D, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $06, $13, $13
	smpsVcDecayRate2    $05, $02, $03, $03
	smpsVcDecayLevel    $03, $02, $04, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $1E, $14, $0E

;	Voice $16
;	$3E
;	$38, $01, $7A, $34, 	$59, $D9, $5F, $9C, 	$0F, $04, $0F, $0A
;	$02, $02, $05, $05, 	$AF, $AF, $66, $66, 	$28, $80, $A3, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $00, $03
	smpsVcCoarseFreq    $04, $0A, $01, $08
	smpsVcRateScale     $02, $01, $03, $01
	smpsVcAttackRate    $1C, $1F, $19, $19
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0F, $04, $0F
	smpsVcDecayRate2    $05, $05, $02, $02
	smpsVcDecayLevel    $06, $06, $0A, $0A
	smpsVcReleaseRate   $06, $06, $0F, $0F
	smpsVcTotalLevel    $80, $A3, $80, $28

;	Voice $17
;	$39
;	$32, $31, $72, $71, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$1B, $32, $28, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $03, $03
	smpsVcCoarseFreq    $01, $02, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $28, $32, $1B

;	Voice $18
;	$07
;	$34, $74, $32, $71, 	$1F, $1F, $1F, $1F, 	$0A, $0A, $05, $03
;	$00, $00, $00, $00, 	$3F, $3F, $2F, $2F, 	$8A, $8A, $80, $80
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $07, $03
	smpsVcCoarseFreq    $01, $02, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $05, $0A, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $02, $02, $03, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $80, $8A, $8A

;	Voice $19
;	$3A
;	$31, $37, $31, $31, 	$8D, $8D, $8E, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$17, $28, $26, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0E, $0D, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $26, $28, $17

;	Voice $1A
;	$3B
;	$3A, $31, $71, $74, 	$DF, $1F, $1F, $DF, 	$00, $0A, $0A, $05
;	$00, $05, $05, $03, 	$0F, $5F, $1F, $5F, 	$32, $1E, $0F, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $03, $03
	smpsVcCoarseFreq    $04, $01, $01, $0A
	smpsVcRateScale     $03, $00, $00, $03
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $0A, $0A, $00
	smpsVcDecayRate2    $03, $05, $05, $00
	smpsVcDecayLevel    $05, $01, $05, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $0F, $1E, $32

;	Voice $1B
;	$3A
;	$32, $56, $32, $42, 	$8D, $4F, $15, $52, 	$06, $08, $07, $04
;	$02, $00, $00, $00, 	$1F, $1F, $2F, $2F, 	$19, $20, $2A, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $03, $05, $03
	smpsVcCoarseFreq    $02, $02, $06, $02
	smpsVcRateScale     $01, $00, $01, $02
	smpsVcAttackRate    $12, $15, $0F, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $07, $08, $06
	smpsVcDecayRate2    $00, $00, $00, $02
	smpsVcDecayLevel    $02, $02, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $2A, $20, $19

;	Voice $1C
;	$2C
;	$71, $74, $32, $32, 	$1F, $12, $1F, $12, 	$00, $0A, $00, $0A
;	$00, $00, $00, $00, 	$0F, $1F, $0F, $1F, 	$16, $80, $17, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $02, $04, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $0A, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $01, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $17, $80, $16

;	Voice $1D
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $8F
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $07, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $8F, $27, $28, $18

;	Voice $1E
;	$36
;	$7A, $32, $51, $11, 	$1F, $1F, $59, $1C, 	$0A, $0D, $06, $0A
;	$07, $00, $02, $02, 	$AF, $5F, $5F, $5F, 	$1E, $8B, $81, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $05, $03, $07
	smpsVcCoarseFreq    $01, $01, $02, $0A
	smpsVcRateScale     $00, $01, $00, $00
	smpsVcAttackRate    $1C, $19, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $06, $0D, $0A
	smpsVcDecayRate2    $02, $02, $00, $07
	smpsVcDecayLevel    $05, $05, $05, $0A
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $81, $8B, $1E

;	Voice $1F
;	$3C
;	$71, $72, $3F, $34, 	$8D, $52, $9F, $1F, 	$09, $00, $00, $0D
;	$00, $00, $00, $00, 	$23, $08, $02, $F7, 	$15, $85, $1D, $8A
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $0F, $02, $01
	smpsVcRateScale     $00, $02, $01, $02
	smpsVcAttackRate    $1F, $1F, $12, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $00, $00, $09
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $00, $00, $02
	smpsVcReleaseRate   $07, $02, $08, $03
	smpsVcTotalLevel    $8A, $1D, $85, $15

;	Voice $20
;	$3E
;	$77, $71, $32, $31, 	$1F, $1F, $1F, $1F, 	$0D, $06, $00, $00
;	$08, $06, $00, $00, 	$15, $0A, $0A, $0A, 	$1B, $8F, $8F, $8F
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $02, $01, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $06, $0D
	smpsVcDecayRate2    $00, $00, $06, $08
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $8F, $8F, $8F, $1B

;	Voice $21
;	$07
;	$34, $74, $32, $71, 	$1F, $1F, $1F, $1F, 	$0A, $0A, $05, $03
;	$00, $00, $00, $00, 	$3F, $3F, $2F, $2F, 	$8A, $8A, $8A, $8A
	smpsVcAlgorithm     $07
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $07, $03
	smpsVcCoarseFreq    $01, $02, $04, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $05, $0A, $0A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $02, $02, $03, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $8A, $8A, $8A, $8A
