s3p21_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     s3p21_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $15

	smpsHeaderDAC       s3p21_DAC
	smpsHeaderFM        s3p21_FM1,	$0C, $12
	smpsHeaderFM        s3p21_FM2,	$18, $17
	smpsHeaderFM        s3p21_FM3,	$0C, $12
	smpsHeaderFM        s3p21_FM4,	$00, $14
	smpsHeaderFM        s3p21_FM5,	$00, $14
	smpsHeaderPSG       s3p21_PSG1,	$00, $06, $00, sTone_0C
	smpsHeaderPSG       s3p21_PSG2,	$00, $06, $00, sTone_0C
	smpsHeaderPSG       s3p21_PSG3,	$00, $02, $00, sTone_0C

; Unreachable
	smpsStop
	smpsStop

; DAC Data
s3p21_DAC:
	dc.b	nRst, $32, nRst, $4D, nRst, $32, nRst, $4D, nRst, $46, dKickS3, $18
	dc.b	dKickS3, dSnareS3, $06, dSnareS3, $0C, dSnareS3, $06, dSnareS3, $18, dKickS3, $04, dKickS3
	dc.b	$02, dKickS3, $06, dKickS3, $0C, dKickS3, $18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3
	dc.b	dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3
	dc.b	dSnareS3, $24, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3
	dc.b	$06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06
	dc.b	dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3, $02, dKickS3, $06, dKickS3, $0C, dKickS3
	dc.b	$18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3
	dc.b	$0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $24, dKickS3, $0C, dKickS3, $24
	dc.b	dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3
	dc.b	dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3
	dc.b	$02, dKickS3, $06, dKickS3, $0C, dKickS3, $18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3
	dc.b	dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3
	dc.b	dSnareS3, $24, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3
	dc.b	$06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06
	dc.b	dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3, $02, dKickS3, $06, dKickS3, $0C, dKickS3
	dc.b	$18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3
	dc.b	$0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $24, dKickS3, $0C, dKickS3, $24
	dc.b	dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3
	dc.b	dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3
	dc.b	$02, dKickS3, $06, dKickS3, $0C, dKickS3, $18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3
	dc.b	dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3
	dc.b	dSnareS3, $24, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3
	dc.b	$06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06
	dc.b	dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3, $02, dKickS3, $06, dKickS3, $0C, dKickS3
	dc.b	$18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3
	dc.b	$0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $24, dKickS3, $0C, dKickS3, $24
	dc.b	dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3
	dc.b	dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3
	dc.b	$02, dKickS3, $06, dKickS3, $0C, dKickS3, $18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3
	dc.b	dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3
	dc.b	dSnareS3, $24, dKickS3, $0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3
	dc.b	$06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dFloorTomS3, dLowTomS3, dMidTomS3, $0C, dSnareS3, $06
	dc.b	dSnareS3, dSnareS3, $18, dKickS3, $04, dKickS3, $02, dKickS3, $06, dKickS3, $0C, dKickS3
	dc.b	$18, dSnareS3, $06, dSnareS3, dSnareS3, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dKickS3
	dc.b	$0C, dKickS3, $24, dSnareS3, $06, dSnareS3, dSnareS3, $24, dKickS3, $0C, dKickS3, $24
	dc.b	dSnareS3, $06, dSnareS3, dSnareS3, $18, dKickS3, $06, dKickS3, dSnareS3, dFloorTomS3, dFloorTomS3, dFloorTomS3
	dc.b	dFloorTomS3, dLowTomS3, dMidTomS3, $0C
	smpsJump            s3p21_DAC

; Unreachable
	smpsStop

; FM3 Data
s3p21_FM3:
	smpsSetvoice        $15
	smpsDetune          $04
	smpsModSet          $0F, $01, $FD, $07
	smpsPan             panLeft, $00
	smpsJump            s3p21_Jump02

; FM1 Data
s3p21_FM1:
	smpsSetvoice        $15
	smpsDetune          $FC
	smpsModSet          $0F, $01, $00, $07
	smpsPan             panCenter, $00

s3p21_Jump02:
	dc.b	nG1, $04, nRst, $08, nG1, $06, nRst, nG1, $24, nG2, nG1, $1C
	dc.b	nRst, $08, nG1, $0E, nRst, $0A, nC2, $18, nB1, $0A, nRst, $02
	dc.b	nG1, $04, nRst, $08, nG1, $06, nRst, nG1, $24, nG2, nG1, $1C
	dc.b	nRst, $08, nG1, $0A, nRst, $0E, nG1, $0A, nRst, $1A, nC2, $06
	dc.b	nRst, nC2, $52, nRst, $02, nC3, $22, nRst, $02, nC2, $1E, nRst
	dc.b	$06, nC2, $14, nRst, $04, nBb1, $08, nRst, $04, nBb1, $52, nRst
	dc.b	$02, nBb2, $24, nBb1, nBb2, $16, nRst, $02, nA1, $06, nRst, nA1
	dc.b	$48, nG2, $06, nAb2, $04, nRst, $02, nA2, $22, nRst, $02, nA1
	dc.b	$24, nA2, $18, nAb1, $08, nRst, $04, nAb1, $52, nRst, $02, nAb2
	dc.b	$24, nAb1, nAb2, $16, nRst, $02, nC2, $08, nRst, $04, nC2, $52
	dc.b	nRst, $02, nC3, $24, nC2, nC3, $18, nBb1, $06, nRst, nBb1, $42
	dc.b	nRst, $06, nG2, nA2, nBb2, $22, nRst, $02, nA2, $24, nF2, $16
	dc.b	nRst, $02, nA1, $06, nRst, nA1, $48, nG2, $06, nAb2, $04, nRst
	dc.b	$02, nA2, $22, nRst, $02, nA1, $24, nA2, $18, nAb1, $06, nRst
	dc.b	nAb1, $4E, nRst, $06, nBb1, nRst, nBb1, $4E, nRst, $06, nG1, $48
	dc.b	nG2, $06, nRst, nG2, $46, nRst, $02, nG1, $18, nG2, $0C, nAb1
	dc.b	$46, nRst, $02, nAb2, $08, nRst, $04, nAb2, $46, nRst, $02, nAb1
	dc.b	$0C, nAb2, nAb1, $0A, nRst, $02, nG1, $68, nRst, $04, nG2, $18
	dc.b	nG1, $24, nG2, $18, nAb1, $3C, nAb2, $22, nRst, $02, nBb1, $3C
	dc.b	nBb2, $24, nC2, $5A, nRst, $06, nC3, $24, nC2, nC3, $18, nBb1
	dc.b	$06, nRst, nBb1, $42, nRst, $06, nG2, nA2, nBb2, $22, nRst, $02
	dc.b	nA2, $24, nF2, $16, nRst, $02, nA1, $06, nRst, nA1, $48, nG2
	dc.b	$06, nAb2, $04, nRst, $02, nA2, $22, nRst, $02, nA1, $24, nA2
	dc.b	$18, nAb1, $06, nRst, nAb1, $4E, nRst, $06, nBb1, nRst, nBb1, $4E
	dc.b	nRst, $06
	smpsJump            s3p21_Jump02

; Unreachable
	smpsStop

; FM2 Data
s3p21_FM2:
	smpsFMAlterVol      $08
	smpsSetvoice        $08
	smpsJump            s3p21_Jump01

s3p21_Jump04:
	dc.b	nG4, $06, nF4, $04, nRst, $02, nB3, $06, nC4, $04, nRst, $02
	dc.b	nG4, $06, nF4, nB3, $04, nRst, $02, nC4, $06, nG4, nF4, $04
	dc.b	nRst, $02, nB3, $06, nC4, $04, nRst, $02, nG4, $06, nF4, nB3
	dc.b	$04, nRst, $02, nC4, $06, nG4, nF4, $04, nRst, $02, nB3, $06
	dc.b	nC4, $04, nRst, $02, nG4, $06, nF4, nB3, $04, nRst, $02, nC4
	dc.b	$06, nG4, nF4, $04, nRst, $02, nB3, $06, nC4, $04, nRst, $02
	dc.b	nG4, $06, nF4, nB3, $04, nRst, $02, nC4, $06, nG4, nF4, $04
	dc.b	nRst, $02, nB3, $06, nC4, $04, nRst, $02, nG4, $06, nF4, nB3
	dc.b	$04, nRst, $02, nC4, $06, nG4, nF4, $04, nRst, $02, nB3, $06
	dc.b	nC4, $04, nRst, $02, nG4, $06, nF4, nB3, $04, nRst, $02, nC4
	dc.b	$06, nG4, nF4, $04, nRst, $02, nB3, $06, nC4, $04, nRst, $02
	dc.b	nG4, $06, nF4, nB3, $02, nRst, $16, nB3, $02, nRst, $22, nC5
	dc.b	$06, nC4, $04, nRst, $02, nC5, $06, nC4, nC5, nC4, nC5, nC4
	dc.b	nC6, $04, nRst, $02, nC4, $04, nRst, $02, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4
	dc.b	nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04
	dc.b	nRst, $02, nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4
	dc.b	$04, nRst, $02, nC5, $06, nC4, nC5, nC4, nC5, nC4, nC6, $04
	dc.b	nRst, $02, nC4, $04, nRst, $02, nC6, $04, nRst, $02, nC4, $06
	dc.b	nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, $04, nRst
	dc.b	$02, nC5, $06, nC4, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $04, nRst, $02, nC6, $04, nRst, $02, nC4, $06, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC5, $04, nRst, $02
	dc.b	nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02, nC4, $06
	dc.b	nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, $04, nRst, $02, nC5
	dc.b	$06, nC4, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02, nC4, $04
	dc.b	nRst, $02, nC6, $04, nRst, $02, nC4, $06, nC5, $04, nRst, $02
	dc.b	nC4, $06, nC5, nC4, nC5, nC4, nC5, $04, nRst, $02, nC4, $06
	dc.b	nC5, nC4, nC5, nC4, nC6, $04, nRst, $02, nC4, $06, nC6, nC4
	dc.b	nC5, nC4, nC5, nC4, nC5, nC4, $04, nRst, $02, nC5, $06, nC4
	dc.b	nC5, nC4, nC5, nC4, nC6, $04, nRst, $02, nC4, $04, nRst, $02
	dc.b	nC6, $04, nRst, $02, nC4, $06, nC5, $04, nRst, $02, nC4, $06
	dc.b	nC5, nC4, nC5, nC4, nC5, $04, nRst, $02, nC4, $06, nC5, nC4
	dc.b	nC5, nC4, nC6, $04, nRst, $02, nC4, $06, nC6, nC4, nC5, nC4
	dc.b	nC5, nC4, nC5, nC4, $04, nRst, $02, nC5, $06, nC4, nC5, nC4
	dc.b	nC5, nC4, nC6, $04, nRst, $02, nC4, $04, nRst, $02, nC6, $04
	dc.b	nRst, $02, nC4, $06, nC5, $04, nRst, $02, nC4, $06, nC5, nC4
	dc.b	nC5, nC4, nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4
	dc.b	nC6, $04, nRst, $02, nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4
	dc.b	nC5, nC4, $04, nRst, $02, nC5, $06, nC4, nC5, nC4, nC5, nC4
	dc.b	nC6, $04, nRst, $02, nC4, $04, nRst, $02, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4
	dc.b	nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04
	dc.b	nRst, $02, nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4
	dc.b	$04, nRst, $02, nC5, $06, nC4, nC5, nC4, nC5, nC4, nC6, $04
	dc.b	nRst, $02, nC4, $04, nRst, $02, nC6, $04, nRst, $02, nC4, $06
	dc.b	nC5, $04, nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nG5, nG4, nG5, $04
	dc.b	nRst, $02, nG4, $06, nG5, nG4, nG5, nG4, nG6, $04, nRst, $02
	dc.b	nG4, $06, nG6, nG4, nG5, nG4, nG5, nG4, nG5, nG4, nG5, $04
	dc.b	nRst, $02, nG4, $06, nG5, nG4, nG5, nG4, nG6, $04, nRst, $02
	dc.b	nG4, $06, nG6, nG4, nG5, nG4, nG5, nG4, nAb5, nAb4, nAb5, $04
	dc.b	nRst, $02, nAb4, $06, nAb5, nAb4, nAb5, nAb4, nAb6, $04, nRst, $02
	dc.b	nAb4, $06, nAb6, nAb4, nAb5, nAb4, nAb5, nAb4, nAb5, nAb4, nAb5, $04
	dc.b	nRst, $02, nAb4, $06, nAb5, nAb4, nAb5, nAb4, nAb6, $04, nRst, $02
	dc.b	nAb4, $06, nAb6, nAb4, nAb5, nAb4, nAb5, nAb4, nG5, nG4, nG5, $04
	dc.b	nRst, $02, nG4, $06, nG5, nG4, nG5, nG4, nG6, $04, nRst, $02
	dc.b	nG4, $06, nG6, nG4, nG5, nG4, nG5, nG4, nG5, nG4, nG5, $04
	dc.b	nRst, $02, nG4, $06, nG5, nG4, nG5, nG4, nG6, $04, nRst, $02
	dc.b	nG4, $06, nG6, nG4, nG5, nG4, nG5, nG4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4, nC5, nC4, nC5, $04
	dc.b	nRst, $02, nC4, $06, nC5, nC4, nC5, nC4, nC6, $04, nRst, $02
	dc.b	nC4, $06, nC6, nC4, nC5, nC4, nC5, nC4
	smpsJump            s3p21_Jump04

; Unreachable
	smpsStop

; PSG1 Data
s3p21_PSG1:
	smpsPSGvoice        sTone_02
	smpsDetune          $00
	dc.b	nRst, $01
	smpsJump            s3p21_Jump04

; PSG2 Data
s3p21_PSG2:
	smpsPSGvoice        sTone_02
	smpsDetune          $FF
	smpsJump            s3p21_Jump04

s3p21_Jump01:
	dc.b	nF4, $12, nE4, nC4, $0C, nC5, $12, nB4, $10, nRst, $02, nG4
	dc.b	$0C, nF4, $12, nE4, nC4, $0C, nC5, $12, nB4, $10, nRst, $02
	dc.b	nG4, $0C, nF4, $12, nE4, nC4, $0C, nC5, $12, nB4, $10, nRst
	dc.b	$02, nG4, $0C, nF4, $12, nE4, nC4, $0A, nRst, $0E, nC4, $0A
	dc.b	nRst, $1A, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst
	dc.b	$02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2
	dc.b	$04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2
	dc.b	$06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst
	dc.b	$02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst
	dc.b	$02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst
	dc.b	$02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2
	dc.b	$04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2
	dc.b	$06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst
	dc.b	$02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst
	dc.b	$02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst
	dc.b	$02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2
	dc.b	$04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2
	dc.b	$06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst
	dc.b	$02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst
	dc.b	$02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst
	dc.b	$02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2
	dc.b	$04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2
	dc.b	$06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst
	dc.b	$02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst
	dc.b	$02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst
	dc.b	$02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2, $04, nRst
	dc.b	$02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2, $06, nF2
	dc.b	$04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2, $06, nD2
	dc.b	$04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst, $02, nC2
	dc.b	$06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst, $02, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04, nRst, $02
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst, $04, nC2
	dc.b	$06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2, $04, nRst
	dc.b	$02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2, $04, nRst
	dc.b	$02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2, nC2, $04
	dc.b	nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, nRst
	dc.b	$04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst, $02, nE2
	dc.b	$04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2, $06, nE2
	dc.b	$04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2, $06, nE2
	dc.b	nC2, $04, nRst, $02, nC2, $04, nRst, $02, nC2, $04, nRst, $02
	dc.b	nC2, nRst, $04, nC2, $06, nD2, $04, nRst, $02, nC2, $04, nRst
	dc.b	$02, nE2, $04, nRst, $02, nC2, $06, nF2, $04, nRst, $02, nC2
	dc.b	$06, nE2, $04, nRst, $02, nC2, $06, nD2, $04, nRst, $02, nC2
	dc.b	$06, nE2, nC2, $04, nRst, $02
	smpsJump            s3p21_Jump01

; Unreachable
	dc.b	nRst, $7F, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, $08
	smpsStop

; FM4 Data
s3p21_FM4:
	smpsSetvoice        $0A
	smpsDetune          $04
	smpsModSet          $19, $01, $F9, $06
	smpsPan             panLeft, $00

s3p21_Jump00:
	dc.b	nC4, $12, nB3, nG3, $0C, nG4, $12, nF4, nE4, $0C, nC4, $10
	dc.b	nRst, $02, nB3, $12, nG3, $0C, nG4, $12, nF4, nE4, $0C, nC4
	dc.b	$10, nRst, $02, nB3, $12, nG3, $0C, nG4, $12, nF4, nE4, $0C
	dc.b	nC4, $12, nB3, $10, nRst, $02, nG3, $0E, nRst, $0A, nG3, $0E
	dc.b	nRst, $16, nC5, $54, nC4, $06, nE4, nF4, $22, nRst, $02, nE4
	dc.b	$18, nC4, $12, nRst, $06, nC4, $08, nRst, $04, nC5, $48, nRst
	dc.b	$0C, nC4, $06, nE4, nF4, $24, nE4, $16, nRst, $02, nC4, $1C
	dc.b	nRst, $20, nA3, $0E, nRst, $16, nC4, $0C, nRst, $18, nF3, $0C
	dc.b	nRst, $18, nA3, $1C, nRst, $08, nA3, $12, nRst, $2A, nAb3, $0C
	dc.b	nC4, nBb3, nAb3, nEb4, $18, nC4, $0C, nD4, nEb4, $16, nRst, $02
	dc.b	nD4, $0C, nC4, $18, nC5, $50, nRst, $04, nC4, $06, nE4, nF4
	dc.b	$22, nRst, $02, nE4, $14, nRst, $04, nC4, $14, nRst, $04, nC4
	dc.b	nRst, $02, nC4, $04, nRst, $02, nC5, $4E, nRst, $06, nC4, nE4
	dc.b	nF4, $24, nE4, $16, nRst, $02, nC4, $14, nRst, $04, nC4, $0E
	dc.b	nRst, $16, nA3, $0C, nRst, $18, nC4, $08, nRst, $1C, nF3, $08
	dc.b	nRst, $1C, nA3, $20, nRst, $04, nA3, $12, nRst, $2A, nAb3, $0C
	dc.b	nC4, nBb3, $0A, nRst, $02, nAb3, $0C, nEb4, $18, nD4, $0C, nC4
	dc.b	nF4, $18, nEb4, $0A, nRst, $02, nF4, $12, nRst, $06, nG4, $24
	dc.b	nEb5, $22, nRst, $02, nD5, $24, nG4, $54, nAb4, $24, nEb5, $22
	dc.b	nRst, $02, nC5, $24, nF5, nEb5, $18, nD5, $14, nRst, $04, nAb4
	dc.b	$24, nEb5, $1C, nRst, $08, nD5, $22, nRst, $02, nG4, $54, nAb4
	dc.b	$24, nC5, nEb5, $16, nRst, $02, nG5, $18, nF5, $0C, nEb5, $18
	dc.b	nF5, $1E, nRst, $06, nC5, $4E, nRst, $06, nC4, nE4, $04, nRst
	dc.b	$02, nF4, $24, nE4, $16, nRst, $02, nC4, $12, nRst, $06, nC4
	dc.b	$02, nRst, $04, nC4, $02, nRst, $04, nC5, $48, nRst, $0C, nC5
	dc.b	$04, nRst, $02, nE5, $04, nRst, $02, nF5, $1E, nRst, $06, nE5
	dc.b	$16, nRst, $02, nC5, $10, nRst, $08, nC5, $0A, nRst, $02, nG5
	dc.b	$0C, nC5, $10, nRst, $20, nC5, $08, nRst, $04, nG5, $0C, nC5
	dc.b	$08, nRst, $10, nC5, $0C, nRst, nC5, $08, nRst, $04, nG5, $0C
	dc.b	nC5, nRst, nC5, $06, nRst, nBb5, $24, nAb5, $22, nRst, $02, nG5
	dc.b	$20, nRst, $04, nF5, $24, nEb5, $12, nRst, $06, nF5, $08, nRst
	dc.b	$04, nG5, $0C
	smpsJump            s3p21_Jump00

; Unreachable
	dc.b	nRst, $7F, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst, nRst
	dc.b	nRst, nRst, nRst, nRst, nRst, $27
	smpsStop

; FM5 Data
s3p21_FM5:
	dc.b	nRst, $03
	smpsFMAlterVol      $04
	smpsSetvoice        $0A
	smpsDetune          $FC
	smpsModSet          $19, $01, $07, $06
	smpsPan             panRight, $00
	smpsJump            s3p21_Jump00
	
; Unreachable
	smpsStop

; PSG3 Data
s3p21_PSG3:
	smpsPSGform         $E7

s3p21_Jump03:
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $06
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $06
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $0C
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $06
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $06
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $0C
	smpsJump            s3p21_Jump03

; Unreachable
	smpsStop

s3p21_Voices:
	include	"..\unibank.asm"