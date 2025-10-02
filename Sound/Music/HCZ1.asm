s3p3_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     s3p3_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $53

	smpsHeaderDAC       s3p3_DAC
	smpsHeaderFM        s3p3_FM1,	$0C, $12
	smpsHeaderFM        s3p3_FM2,	$0C, $12
	smpsHeaderFM        s3p3_FM3,	$0C, $17
	smpsHeaderFM        s3p3_FM4,	$18, $0F
	smpsHeaderFM        s3p3_FM5,	$0C, $17
	smpsHeaderPSG       s3p3_PSG1,	$F4, $05, $00, sTone_0C
	smpsHeaderPSG       s3p3_PSG2,	$E8, $05, $00, sTone_0C
	smpsHeaderPSG       s3p3_PSG3,	$00, $03, $00, sTone_0C

; Unreachable
	smpsStop
	smpsStop

; DAC Data
s3p3_DAC:
	dc.b	dKickS3, $14, dKickS3, $04, dSnareS3, $20, dKickS3, $10, dSnareS3, $14, dKickS3, $18
	dc.b	dKickS3, $04, dSnareS3, $20, dKickS3, $10, dSnareS3, $18, dKickS3, $14, dKickS3, $04
	dc.b	dSnareS3, $20, dKickS3, $10, dSnareS3, $14, dKickS3, $18, dKickS3, $04, dSnareS3, $20
	dc.b	dKickS3, $10, dSnareS3, $18, dKickS3, $14, dKickS3, $04, dSnareS3, $20, dKickS3, $10
	dc.b	dSnareS3, $14, dKickS3, $18, dKickS3, $04, dSnareS3, $20, dKickS3, $10, dSnareS3, $18
	dc.b	dKickS3, $14, dKickS3, $04, dSnareS3, $20, dKickS3, $10, dSnareS3, $14, dKickS3, $18
	dc.b	dKickS3, $04, dSnareS3, $20, dKickS3, $10, dSnareS3, $0C, dSnareS3, dKickS3, $18, dSnareS3
	dc.b	$14, dKickS3, $0C, dKickS3, $04, dKickS3, $0C, dSnareS3, $18, dKickS3, dSnareS3, $14
	dc.b	dSnareS3, $0C, dKickS3, dKickS3, $04, dSnareS3, $18, dKickS3, dSnareS3, $14, dKickS3, $0C
	dc.b	dKickS3, $04, dKickS3, $0C, dSnareS3, $18, dKickS3, dSnareS3, $14, dSnareS3, $10
	smpsPan             panLeft, $00
	dc.b	dHighTom, $04
	smpsPan             panCenter, $00
	dc.b	dMidTomS3
	smpsPan             panRight, $00
	dc.b	dLowTomS3, $0C
	smpsPan             panCenter, $00
	dc.b	dSnareS3, $04, dSnareS3, $08, dSnareS3, $04, dKickS3, $18, dSnareS3, $14, dKickS3, $0C
	dc.b	dKickS3, $04, dKickS3, $0C, dSnareS3, $18, dKickS3, dSnareS3, $14, dSnareS3, $0C, dKickS3
	dc.b	dKickS3, $04, dSnareS3, $18, dKickS3, dSnareS3, $14, dKickS3, $0C, dKickS3, $04, dKickS3
	dc.b	$0C, dSnareS3, $18, dSnareS3, $0C, dSnareS3, dSnareS3, dSnareS3, $08, dSnareS3, $34, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $18, dKickS3
	dc.b	$14, dKickS3, $04, dSnareS3, $08, dKickS3, $18, dKickS3, $10, dSnareS3, $20, dSnareS3
	dc.b	$0C, dSnareS3, dSnareS3, $04, dSnareS3, $0C, dSnareS3, $18, dSnareS3, $0C, dSnareS3
	smpsJump            s3p3_DAC

; Unreachable
	smpsStop

; FM1 Data
s3p3_FM1:
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nRst, $20, nBb3, $02, nRst, nA3, $06, nRst, $02, nG3, nRst, $0E
	dc.b	nEb3, $06, nRst, $02, nC3, nC3, nBb4, $0A, nRst, $02, nEb4, $06
	dc.b	nRst, $02, nC4, nRst, $0E, nBb3, $06, nRst, $02, nA3, nRst, $0A
	dc.b	nG3, $02, nRst, nA3, $06, nRst, $02, nG3, nRst, $0A
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nRst, $10, nBb5, $02, nRst, $06, nD5, $02, nEb5, $0E
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nRst, $20, nFs3, $02, nRst, nF3, $06, nRst, $02, nEb3, nRst, $0E
	dc.b	nC3, $06, nRst, $02, nBb2, nBb2, nEb4, $0A, nRst, $02, nBb3, $06
	dc.b	nRst, $02, nF3, nRst, $0E, nA3, $06, nRst, $02, nG3, nRst, $0A
	dc.b	nF3, $02, nRst, nG3, $06, nRst, $02, nF3, nRst
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nG4, $16, nRst, $02, nF4, $18
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nRst, $20, nBb3, $02, nRst, nA3, $06, nRst, $02, nG3, nRst, $0E
	dc.b	nEb3, $06, nRst, $02, nC3, nC3, nBb4, $0A, nRst, $02, nEb4, $06
	dc.b	nRst, $02, nC4, nRst, $0E, nBb3, $06, nRst, $02, nA3, nRst, $0A
	dc.b	nG3, $02, nRst, nA3, $06, nRst, $02, nG3, nRst, $0A
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nRst, $10, nBb5, $02, nRst, $06, nD5, $02, nEb5, $0E
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nRst, $20, nFs3, $02, nRst, nF3, $06, nRst, $02, nEb3, nRst, $0E
	dc.b	nC3, $06, nRst, $02, nBb2, nBb2, nEb4, $0A, nRst, $02, nBb3, $06
	dc.b	nRst, $02, nF3, nRst, $0E, nA3, $06, nRst, $02, nG3, nRst, $0A
	dc.b	nF3, $02, nRst, nG3, $06, nRst, $02, nF3, nRst
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nG4, $16, nRst, $02, nF4, $18
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nEb4, $0C, nBb2, $08, nC3, $04, nRst, $08, nC3, $04, nFs3, $08
	dc.b	nFs3, $04, nFs4, $18, nEb4, nRst, $0C, nFs3, $06, nRst, $02, nF3
	dc.b	nRst, $0A, nEb3, $02, nRst, nF3, $06, nRst, $02, nEb3, nRst, $1A
	dc.b	nFs5, $08, nFs5, $04, nRst, $0C, nD4, nC3, $08, nD3, $04, nRst
	dc.b	$08, nD3, $04, nAb3, $08, nAb3, $04, nAb4, $18, nF4, nRst, $0C
	dc.b	nAb3, $06, nRst, $02, nG3, nRst, $0A, nF3, $02, nRst, nG3, $06
	dc.b	nRst, $02, nF3, nRst, $1A, nAb5, $08, nCs5, $02, nD5, $0E, nEb4
	dc.b	$0C, nBb2, $08, nC3, $04, nRst, $08, nC3, $04, nFs3, $08, nFs3
	dc.b	$04, nFs4, $18, nEb4, nRst, $0C, nFs3, $06, nRst, $02, nF3, nRst
	dc.b	$0A, nEb3, $02, nRst, nF3, $06, nRst, $02, nEb3, nRst, $1A, nFs5
	dc.b	$08, nFs5, $04, nRst, $0C, nD4, nC3, $08, nD3, $04, nRst, $08
	dc.b	nD3, $04, nAb3, $08, nAb3, $04, nAb4, $18, nF4, nD4, $08, nRst
	dc.b	$04, nD4, $08, nRst, $04, nD4, $08, nRst, $04, nD4, $08, nD4
	dc.b	$04, nRst, $14, nC5, $02, nD5, nG5, $18
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nA4, $02, nBb4, $04, nRst, $02, nBb4, $0C, nA4, $02, nBb4, nRst
	dc.b	$08
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nEb4, $02, nRst, nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10
	dc.b	nEb4, $04, nRst, $08, nD4, $04, nRst, $08, nC4, $16, nRst, $02
	dc.b	nEb4, $06, nRst, nD4, $02, nEb4, $04, nRst, $02, nD4, $10, nRst
	dc.b	$0C, nF4, $08, nF4, $04, nRst, $0C
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nA4, $02, nBb4, $10, nRst, $02, nBb4, nRst, $0A
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nEb4, $02, nRst, nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10
	dc.b	nEb4, $04, nRst, $08, nD4, $04, nRst, $08, nC5, $18, nBb4, nAb4
	dc.b	nG4
	smpsSetvoice        $0A
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nA4, $02, nBb4, $04, nRst, $02, nBb4, $0C, nA4, $02, nBb4, nRst
	dc.b	$08
	smpsSetvoice        $06
	smpsDetune          $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nEb4, $02, nRst, nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10
	dc.b	nEb4, $04, nRst, $08, nD4, $04, nRst, $08, nC4, $16, nRst, $02
	dc.b	nEb4, $06, nRst, nD4, $02, nEb4, $04, nRst, $02, nD4, $10, nRst
	dc.b	$0C, nF4, $08, nF4, $04, nRst, $14, nG4, $02, nRst, nF4, $06
	dc.b	nRst, $02, nEb4, nRst, $0A, nD4, $02, nRst, nEb4, $06, nRst, $02
	dc.b	nC4, nRst, $1A, nEb4, $18, nRst, $08, nG4, $02, nRst, $0A, nG4
	dc.b	$02, nRst, $0A, nG4, $02, nRst, nG4, $0A, nRst, $02, nG4, nRst
	dc.b	$2E
	smpsJump            s3p3_FM1

; Unreachable
	smpsStop

; FM2 Data
s3p3_FM2:
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nEb4, $08, nC4, $04, nRst, $14, nG3, $02, nRst, nF3, $06, nRst
	dc.b	$02, nEb3, nRst, $0E, nC3, $06, nRst, $02, nG2, nG2, nF4, $0A
	dc.b	nRst, $02, nBb3, $06, nRst, $02, nA3, nRst, $0A, nC3, $02, nRst
	dc.b	nG3, $06, nRst, $02, nF3, nRst, $0A, nEb3, $02, nRst, nF3, $06
	dc.b	nRst, $02, nEb3, nRst, $0A
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nF4, $02, nRst, nFs4, $06, nRst, $02, nG4, nRst, nF5, nRst, $06
	dc.b	nBb4, $10
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nEb4, $08, nC4, $04, nRst, $14, nEb3, $02, nRst, nD3, $06, nRst
	dc.b	$02, nC3, nRst, $0E, nA2, $06, nRst, $02, nG2, nG2, nBb3, $0A
	dc.b	nRst, $02, nF3, $06, nRst, $02, nD3, nRst, $0A, nC3, $02, nRst
	dc.b	nF3, $06, nRst, $02, nEb3, nRst, $0A, nD3, $02, nRst, nEb3, $06
	dc.b	nRst, $02, nD3, nRst
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nEb4, $16, nRst, $02, nD4, $18
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nEb4, $08, nC4, $04, nRst, $14, nG3, $02, nRst, nF3, $06, nRst
	dc.b	$02, nEb3, nRst, $0E, nC3, $06, nRst, $02, nG2, nG2, nF4, $0A
	dc.b	nRst, $02, nBb3, $06, nRst, $02, nA3, nRst, $0A, nC3, $02, nRst
	dc.b	nG3, $06, nRst, $02, nF3, nRst, $0A, nEb3, $02, nRst, nF3, $06
	dc.b	nRst, $02, nEb3, nRst, $0A
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nF4, $02, nRst, nFs4, $06, nRst, $02, nG4, nRst, nF5, nRst, $06
	dc.b	nBb4, $10
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nEb4, $08, nC4, $04, nRst, $14, nEb3, $02, nRst, nD3, $06, nRst
	dc.b	$02, nC3, nRst, $0E, nA2, $06, nRst, $02, nG2, nG2, nBb3, $0A
	dc.b	nRst, $02, nF3, $06, nRst, $02, nD3, nRst, $0A, nC3, $02, nRst
	dc.b	nF3, $06, nRst, $02, nEb3, nRst, $0A, nD3, $02, nRst, nEb3, $06
	dc.b	nRst, $02, nD3, nRst
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $F4
	dc.b	nEb4, $16, nRst, $02, nD4, $18
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	smpsAlterPitch      $0C
	dc.b	nC4, $0C, nFs2, $08, nAb2, $04, nRst, $08, nAb2, $04, nEb3, $08
	dc.b	nEb3, $04, nEb4, $18, nC4, nRst, $08, nAb2, $02, nRst, nEb3, $06
	dc.b	nRst, $02, nCs3, nRst, $0A, nC3, $02, nRst, nCs3, $06, nRst, $02
	dc.b	nC3, nRst, $0E, nFs3, $04, nAb3, nC4, nEb5, $08, nEb5, $04, nRst
	dc.b	$0C, nBb3, nAb2, $08, nBb2, $04, nRst, $08, nBb2, $04, nF3, $08
	dc.b	nF3, $04, nF4, $18, nD4, nRst, $08, nBb2, $02, nRst, nF3, $06
	dc.b	nRst, $02, nEb3, nRst, $0A, nD3, $02, nRst, nEb3, $06, nRst, $02
	dc.b	nD3, nRst, $0E, nAb3, $04, nBb3, nD4, nF5, $08, nG4, $02, nAb4
	dc.b	$0E, nC4, $0C, nFs2, $08, nAb2, $04, nRst, $08, nAb2, $04, nEb3
	dc.b	$08, nEb3, $04, nEb4, $18, nC4, nRst, $08, nAb2, $02, nRst, nEb3
	dc.b	$06, nRst, $02, nCs3, nRst, $0A, nC3, $02, nRst, nCs3, $06, nRst
	dc.b	$02, nC3, nRst, $0E, nFs3, $04, nAb3, nC4, nEb5, $08, nEb5, $04
	dc.b	nRst, $0C, nBb3, nAb2, $08, nBb2, $04, nRst, $08, nBb2, $04, nF3
	dc.b	$08, nF3, $04, nF4, $18, nD4, nB3, $08, nRst, $04, nB3, $08
	dc.b	nRst, $04, nB3, $08, nRst, $04, nB3, $08, nB3, $04, nRst, $14
	dc.b	nB4, $02, nCs5, nBb4, nB4, $16
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nG4, $06, nRst, $02, nG4, $0C, nG4, $04, nRst, $08
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nC4, $02, nRst, nBb3, $06, nRst, $02, nAb3, nRst, $0A, nBb3, $10
	dc.b	nG3, $04, nRst, $08, nF3, $04, nRst, $08, nBb3, $16, nRst, $02
	dc.b	nC4, $06, nRst, nC4, nRst, $02, nF3, $10, nC4, $04, nCs4, nD4
	dc.b	nBb3, $08, nBb3, $04, nEb4, $02, nD4, nC4, nBb3, nAb3, nRst
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nG4, $12, nRst, $02, nG4, nRst, $0A
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nC4, $02, nRst, nBb3, $06, nRst, $02, nAb3, nRst, $0A, nBb3, $10
	dc.b	nG3, $04, nRst, $08, nF3, $04, nRst, $08, nG4, $18, nF4, nEb4
	dc.b	nD4
	smpsSetvoice        $0A
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nG4, $06, nRst, $02, nG4, $0C, nG4, $04, nRst, $08
	smpsSetvoice        $06
	smpsDetune          $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nC4, $02, nRst, nBb3, $06, nRst, $02, nAb3, nRst, $0A, nBb3, $10
	dc.b	nG3, $04, nRst, $08, nF3, $04, nRst, $08, nBb3, $16, nRst, $02
	dc.b	nC4, $06, nRst, nC4, nRst, $02, nF3, $10, nC4, $04, nCs4, nD4
	dc.b	nBb3, $08, nBb3, $04, nEb4, $02, nD4, nC4, nBb3, nAb3, nRst, $0A
	dc.b	nEb4, $02, nRst, nD4, $06, nRst, $02, nC4, nRst, $0A, nBb3, $02
	dc.b	nRst, nC4, $06, nRst, $02, nAb3, nRst, $0A, nEb3, $04, nAb3, $08
	dc.b	nEb3, $04, nC4, $18, nRst, $08, nD4, $02, nRst, $0A, nD4, $02
	dc.b	nRst, $0A, nD4, $02, nRst, nD4, $0A, nRst, $02, nD4, nRst, $2E
	smpsJump            s3p3_FM2

; Unreachable
	smpsStop

; FM3 Data
s3p3_FM3:
	smpsPan             panRight, $00

s3p3_Jump01:
	smpsSetvoice        $1C
	smpsDetune          $FF
	smpsModSet          $0A, $01, $04, $06
	dc.b	nC5, $08, nG4, $04, nF4, $02, nEb4, nD4, nC4, nBb3, nA3, nG3
	dc.b	nF3, nRst, $04, nBb3, nA3, $08, nG3, $04, nF3, $02, nFs3, $06
	dc.b	nF3, $04, nEb3, $08, nC3, $04, nBb3, $0C, nBb3, $08, nA3, $10
	dc.b	nG3, $02, nFs3, nF3, nEb3, nD3, nC3, nBb2, nA2, nG2, nRst, $36
	dc.b	nBb3, $08, nB3, $04, nC4, $08, nG3, $04, nF3, $02, nEb3, nD3
	dc.b	nC3, nBb2, nA2, nG2, nF2, nRst, $04, nF3, $02, nFs3, nF3, $08
	dc.b	nEb3, $04, nF3, $08, nEb3, $04, nC3, $08, nBb2, $04, nG3, $0C
	dc.b	nG3, $08, nEb3, $1C, nRst, $48, nC5, $08, nG4, $04, nF4, $02
	dc.b	nEb4, nD4, nC4, nBb3, nA3, nG3, nF3, nRst, $04, nBb3, nA3, $08
	dc.b	nG3, $04, nF3, $02, nFs3, $06, nF3, $04, nEb3, $08, nC3, $04
	dc.b	nBb3, $0C, nBb3, $08, nA3, $10, nG3, $02, nFs3, nF3, nEb3, nD3
	dc.b	nC3, nBb2, nA2, nG2, nRst, $36, nBb3, $08, nB3, $04, nC4, $08
	dc.b	nG3, $04, nF3, $02, nEb3, nD3, nC3, nBb2, nA2, nG2, nF2, nRst
	dc.b	$04, nF3, $02, nFs3, nF3, $08, nEb3, $04, nF3, $08, nEb3, $04
	dc.b	nC3, $08, nBb2, $04, nG3, $0C, nG3, $08, nEb3, $1C, nRst, $54
	smpsSetvoice        $21
	smpsDetune          $01
	smpsModSet          $0A, $01, $06, $06
	dc.b	nCs4, $08, nEb4, $04, nRst, $08, nEb4, $04, nBb4, $08, nBb4, $04
	dc.b	nRst, $30, nF4, $0C, nF4, $08, nFs4, $04, nF4, $0C, nF4, $08
	dc.b	nEb4, $02, nRst, $0A, nAb3, $04, nB3, $02, nC4, $06, nEb4, $04
	dc.b	nFs4, nRst, nFs4, nF4, $02, nEb4, nCs4, nC4, nBb3, nAb3, nFs3, nF3
	dc.b	nRst, $08, nEb4, nF4, $04, nRst, $08, nF4, $04, nC5, $08, nC5
	dc.b	$04, nRst, $30, nG4, $0C, nG4, $08, nAb4, $04, nG4, $0C, nG4
	dc.b	$08, nF4, $04, nRst, $3C, nCs4, $08, nEb4, $04, nRst, $08, nEb4
	dc.b	$04, nBb4, $08, nBb4, $04, nRst, $30, nF4, $0C, nF4, $08, nFs4
	dc.b	$04, nF4, $0C, nF4, $08, nEb4, $02, nRst, $0A, nAb3, $04, nB3
	dc.b	$02, nC4, $06, nEb4, $04, nFs4, nRst, nFs4, nF4, $02, nEb4, nCs4
	dc.b	nC4, nBb3, nAb3, nFs3, nF3, nRst, $08, nEb4, nF4, $04, nRst, $08
	dc.b	nF4, $04, nC5, $08, nC5, $04, nRst, $24, nD4, $04, nF4, nG4
	dc.b	nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04
	dc.b	nAb4, $08, nG4, $04, nRst, $24
	smpsSetvoice        $03
	smpsDetune          $FE
	smpsModSet          $0F, $01, $06, $06
	dc.b	nC4, $08, nD4, $04, nEb4, $24, nD4, $08, nC4, $02, nRst, $0A
	dc.b	nD4, $10, nC4, $04, nRst, $08, nBb3, $04, nRst, $08, nG3, $18
	dc.b	nBb3, $14, nC4, $1C, nRst, $0C, nC4, $08, nD4, $04, nEb4, $24
	dc.b	nD4, $08, nC4, $04, nRst, $08, nD4, $10, nC4, $04, nRst, $08
	dc.b	nBb3, $04, nRst, $08, nD4, $14, nD4, $04, nD4, $18, nEb4, nF4
	dc.b	$0C, nC4, $08, nD4, $04, nEb4, $24, nD4, $08, nC4, $04, nRst
	dc.b	$08, nD4, $10, nC4, $04, nRst, $08, nBb3, $04, nRst, $08, nG3
	dc.b	$18, nBb3, $14, nC4, $1C, nRst, $0C, nC4, $08, nD4, $04, nEb4
	dc.b	$14, nEb4, $04, nRst, $08, nD4, $04, nEb4, $14, nEb4, $04, nF4
	dc.b	$0C, nEb4, $04, nRst, $08, nC4, $04, nEb4, nAb4, nRst, $08, nC5
	dc.b	$04, nRst, $08, nC5, $04, nRst, $08, nC5, $04, nC5, $0C, nB4
	dc.b	$04, nRst, $2C
	smpsJump            s3p3_Jump01

; Unreachable
	smpsStop

; FM4 Data
s3p3_FM4:
	smpsSetvoice        $00
	dc.b	nC1, $12, nRst, $02, nC1, nRst, $0A, nBb0, $02, nRst, nBb0, $08
	dc.b	nRst, $0C, nA0, $02, nRst, nA0, $08, nRst, $04, nBb0, $0A, nRst
	dc.b	$02, nBb0, $06, nRst, $02, nC1, nRst, $0A
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nC2, $02, nRst, $0A
	smpsSetvoice        $00
	dc.b	nC1, $02, nRst, $0A, nBb0, $02, nRst, nBb0, $08, nRst, $0C, nA0
	dc.b	$02, nRst, nA0, $08, nRst, $04, nBb0, $0A, nRst, $02, nBb0, $0A
	dc.b	nRst, $02, nC1, $12, nRst, $02, nC1, nRst, $0A, nBb0, $02, nRst
	dc.b	nBb0, $08, nRst, $0C, nA0, $02, nRst, nA0, $08, nRst, $04, nBb0
	dc.b	$0A, nRst, $02, nBb0, $06, nRst, $02, nC1, nRst, $0A
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nBb1, $02
	smpsSetvoice        $00
	dc.b	nRst, $0A, nC1, $02, nRst, $0A, nBb0, $02, nRst, nBb0, $08, nRst
	dc.b	$0C, nA0, $02, nRst, nA0, $08, nRst, $04, nBb0, $0A, nRst, $02
	dc.b	nBb0, $0A, nRst, $02, nC1, $12, nRst, $02, nC1, nRst, $0A, nBb0
	dc.b	$02, nRst, nBb0, $08, nRst, $0C, nA0, $02, nRst, nA0, $08, nRst
	dc.b	$04, nBb0, $0A, nRst, $02, nBb0, $06, nRst, $02, nC1, nRst, $0A
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nC2, $02, nRst, $0A
	smpsSetvoice        $00
	dc.b	nC1, $02, nRst, $0A, nBb0, $02, nRst, nBb0, $08, nRst, $0C, nA0
	dc.b	$02, nRst, nA0, $08, nRst, $04, nBb0, $0A, nRst, $02, nBb0, $0A
	dc.b	nRst, $02, nC1, $12, nRst, $02, nC1, nRst, $0A, nBb0, $02, nRst
	dc.b	nBb0, $08, nRst, $0C, nA0, $02, nRst, nA0, $08, nRst, $04, nBb0
	dc.b	$0A, nRst, $02, nBb0, $06, nRst, $02, nC1, nRst, $0A
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nBb1, $02
	smpsSetvoice        $00
	dc.b	nRst, $0A, nC1, $02, nRst, $0A, nBb0, $02, nRst, nBb0, $08, nRst
	dc.b	$0C, nA0, $02, nRst, nA0, $08, nRst, $04, nBb0, $0A, nRst, $02
	dc.b	nBb0, $0A, nRst, $02, nAb0, $06, nRst, nFs0, $0A, nRst, $02, nF0
	dc.b	$0A, nRst, $02, nF0, $06, nRst, $02, nFs0, nRst, $0A, nFs0, $02
	dc.b	nRst, nF0, $0A, nRst, $02, nEb0, $0A, nRst, $02, nF0, $0A, nRst
	dc.b	$02, nAb0, $06, nRst, $02
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nAb1, nRst
	smpsSetvoice        $00
	dc.b	nEb1, $0A, nRst, $02, nF1, $0A, nRst, $02, nFs1, $06, nRst, $02
	dc.b	nF1, nRst, $26, nAb0, $0C, nBb0, $06, nRst, nAb0, $0A, nRst, $02
	dc.b	nG0, $0A, nRst, $02, nG0, $06, nRst, $02, nAb0, nRst, $0A, nAb0
	dc.b	$02, nRst, nG0, $0A, nRst, $02, nF0, $0A, nRst, $02, nG0, $0A
	dc.b	nRst, $02, nBb0, $06, nRst, $02
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nBb1, nRst
	smpsSetvoice        $00
	dc.b	nF1, $0A, nRst, $02, nG1, $0A, nRst, $02, nAb1, $06, nRst, $02
	dc.b	nG1, nRst, $1A, nBb0, $02, nRst, $06, nBb0, $0E, nRst, $02, nAb0
	dc.b	$06, nRst, nFs0, $0A, nRst, $02, nF0, $0A, nRst, $02, nF0, $06
	dc.b	nRst, $02, nFs0, nRst, $0A, nFs0, $02, nRst, nF0, $0A, nRst, $02
	dc.b	nEb0, $0A, nRst, $02, nF0, $0A, nRst, $02, nAb0, $06, nRst, $02
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nAb1, nRst
	smpsSetvoice        $00
	dc.b	nEb1, $0A, nRst, $02, nF1, $0A, nRst, $02, nFs1, $06, nRst, $02
	dc.b	nF1, nRst, $26, nAb0, $0C, nBb0, $06, nRst, nAb0, $0A, nRst, $02
	dc.b	nG0, $0A, nRst, $02, nG0, $06, nRst, $02, nAb0, nRst, $0A, nAb0
	dc.b	$02, nRst, nG0, $0A, nRst, $02, nF0, $0A, nRst, $02, nG0, $0A
	dc.b	nRst, $02, nG0, $06, nRst, nG0, nRst, nG0, nRst, nG0, nRst, $02
	dc.b	nG0, nRst, $26, nG0, $04, nRst, nG0
	smpsSetvoice        $14
	smpsDetune          $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nF0, $12, nRst, $02, nF0, nRst, nEb0, $06, nRst, $02, nF0, nRst
	dc.b	$16, nG0, $02, nRst, nG1, $0A, nRst, $02, nG0, $16, nRst, $02
	dc.b	nAb0, $12, nRst, $02, nAb0, nRst, nAb0, $06, nRst, $02, nAb0, nRst
	dc.b	$16, nBb0, $02, nRst, nBb0, $0A, nRst, $02, nBb0, $0A, nRst, $02
	dc.b	nBb0, $04, nRst, nBb0, nF0, $12, nRst, $02, nF0, nRst, nEb0, $06
	dc.b	nRst, $02, nF0, nRst, $16, nG0, $02, nRst, nG1, $0A, nRst, $02
	dc.b	nG0, $16, nRst, $02, nC1, $06, nRst, $02, nC1, $0A, nRst, $02
	dc.b	nC1, nRst, nBb0, $06, nRst, $02, nBb0, $0A, nRst, $02, nBb1, nRst
	dc.b	$0A, nAb0, $02, nRst, nAb0, $06, nRst, nG0, $0C, nG0, $04, nRst
	dc.b	nG0, nF0, $12, nRst, $02, nF0, nRst, nEb0, $06, nRst, $02, nF0
	dc.b	nRst, $16, nG0, $02, nRst, nG1, $0A, nRst, $02, nG0, $16, nRst
	dc.b	$02, nAb0, $12, nRst, $02, nAb0, nRst, nAb0, $06, nRst, $02, nAb0
	dc.b	nRst, $16, nBb0, $02, nRst, nBb0, $0A, nRst, $02, nBb0, $0A, nRst
	dc.b	$02, nBb0, $04, nRst, nBb0, nAb0, $12, nRst, $02, nAb0, nRst, nAb0
	dc.b	$06, nRst, $02, nAb0, nRst, $16, nF0, $02, nRst, nF0, $0A, nRst
	dc.b	$02, nF0, $0A, nRst, $02, nF0, $0A, nRst, nG0, $02, nRst, $0A
	dc.b	nG0, $02, nRst, $0A, nG0, $02, nRst, nG0, $0A, nRst, $02, nG0
	dc.b	nRst, $16
	smpsSetvoice        $00
	dc.b	nF0, $04, nRst, nFs0, $02, nRst, nG0, $06, nRst, $02, nBb0, nRst
	smpsJump            s3p3_FM4

; Unreachable
	smpsStop

; FM5 Data
s3p3_FM5:
	smpsPan             panLeft, $00
	dc.b	nRst, $01

s3p3_Jump00:
	smpsSetvoice        $1C
	smpsDetune          $01
	smpsModSet          $0A, $01, $04, $06
	dc.b	nC5, $08, nG4, $04, nF4, $02, nEb4, nD4, nC4, nBb3, nA3, nG3
	dc.b	nF3, nRst, $04, nBb3, nA3, $08, nG3, $04, nF3, $02, nFs3, $06
	dc.b	nF3, $04, nEb3, $08, nC3, $04, nBb3, $0C, nBb3, $08, nA3, $10
	dc.b	nG3, $02, nFs3, nF3, nEb3, nD3, nC3, nBb2, nA2, nG2, nRst, $36
	dc.b	nBb3, $08, nB3, $04, nC4, $08, nG3, $04, nF3, $02, nEb3, nD3
	dc.b	nC3, nBb2, nA2, nG2, nF2, nRst, $04, nF3, $02, nFs3, nF3, $08
	dc.b	nEb3, $04, nF3, $08, nEb3, $04, nC3, $08, nBb2, $04, nG3, $0C
	dc.b	nG3, $08, nEb3, $1C, nRst, $48, nC5, $08, nG4, $04, nF4, $02
	dc.b	nEb4, nD4, nC4, nBb3, nA3, nG3, nF3, nRst, $04, nBb3, nA3, $08
	dc.b	nG3, $04, nF3, $02, nFs3, $06, nF3, $04, nEb3, $08, nC3, $04
	dc.b	nBb3, $0C, nBb3, $08, nA3, $10, nG3, $02, nFs3, nF3, nEb3, nD3
	dc.b	nC3, nBb2, nA2, nG2, nRst, $36, nBb3, $08, nB3, $04, nC4, $08
	dc.b	nG3, $04, nF3, $02, nEb3, nD3, nC3, nBb2, nA2, nG2, nF2, nRst
	dc.b	$04, nF3, $02, nFs3, nF3, $08, nEb3, $04, nF3, $08, nEb3, $04
	dc.b	nC3, $08, nBb2, $04, nG3, $0C, nG3, $08, nEb3, $1C, nRst, $54
	smpsSetvoice        $21
	smpsDetune          $FF
	smpsModSet          $0A, $01, $06, $06
	dc.b	nCs4, $08, nEb4, $04, nRst, $08, nEb4, $04, nBb4, $08, nBb4, $04
	dc.b	nRst, $30, nF4, $0C, nF4, $08, nFs4, $04, nF4, $0C, nF4, $08
	dc.b	nEb4, $02, nRst, $0A, nAb3, $04, nB3, $02, nC4, $06, nEb4, $04
	dc.b	nFs4, nRst, nFs4, nF4, $02, nEb4, nCs4, nC4, nBb3, nAb3, nFs3, nF3
	dc.b	nRst, $08, nEb4, nF4, $04, nRst, $08, nF4, $04, nC5, $08, nC5
	dc.b	$04, nRst, $30, nG4, $0C, nG4, $08, nAb4, $04, nG4, $0C, nG4
	dc.b	$08, nF4, $04, nRst, $3C, nCs4, $08, nEb4, $04, nRst, $08, nEb4
	dc.b	$04, nBb4, $08, nBb4, $04, nRst, $30, nF4, $0C, nF4, $08, nFs4
	dc.b	$04, nF4, $0C, nF4, $08, nEb4, $02, nRst, $0A, nAb3, $04, nB3
	dc.b	$02, nC4, $06, nEb4, $04, nFs4, nRst, nFs4, nF4, $02, nEb4, nCs4
	dc.b	nC4, nBb3, nAb3, nFs3, nF3, nRst, $08, nEb4, nF4, $04, nRst, $08
	dc.b	nF4, $04, nC5, $08, nC5, $04, nRst, $24, nD4, $04, nF4, nG4
	dc.b	nAb4, $08, nRst, $04, nAb4, $08, nRst, $04, nAb4, $08, nRst, $04
	dc.b	nAb4, $08, nG4, $04, nRst, $24
	smpsSetvoice        $03
	smpsDetune          $02
	smpsModSet          $0F, $01, $06, $06
	dc.b	nC4, $08, nD4, $04, nEb4, $24, nD4, $08, nC4, $02, nRst, $0A
	dc.b	nD4, $10, nC4, $04, nRst, $08, nBb3, $04, nRst, $08, nG3, $18
	dc.b	nBb3, $14, nC4, $1C, nRst, $0C, nC4, $08, nD4, $04, nEb4, $24
	dc.b	nD4, $08, nC4, $04, nRst, $08, nD4, $10, nC4, $04, nRst, $08
	dc.b	nBb3, $04, nRst, $08, nD4, $14, nD4, $04, nD4, $18, nEb4, nF4
	dc.b	$0C, nC4, $08, nD4, $04, nEb4, $24, nD4, $08, nC4, $04, nRst
	dc.b	$08, nD4, $10, nC4, $04, nRst, $08, nBb3, $04, nRst, $08, nG3
	dc.b	$18, nBb3, $14, nC4, $1C, nRst, $0C, nC4, $08, nD4, $04, nEb4
	dc.b	$14, nEb4, $04, nRst, $08, nD4, $04, nEb4, $14, nEb4, $04, nF4
	dc.b	$0C, nEb4, $04, nRst, $08, nC4, $04, nEb4, nAb4, nRst, $08, nC5
	dc.b	$04, nRst, $08, nC5, $04, nRst, $08, nC5, $04, nC5, $0C, nB4
	dc.b	$04, nRst, $2C
	smpsJump            s3p3_Jump00

; Unreachable
	smpsStop

; PSG1 Data
s3p3_PSG1:
	smpsPSGvoice        sTone_0A

s3p3_Jump02:
	dc.b	nC5, $04, nRst, nG4, nRst, $0C, nC4, $04, nRst, $08, nG4, $04
	dc.b	nRst, nC5, nRst, $08, nC5, $04, nG4, nRst, $14, nBb4, $04, nRst
	dc.b	nC5, nRst, $08, nC5, $04, nG4, nRst, $08, nC4, $04, nRst, $08
	dc.b	nG4, $04, nRst, nC5, nRst, $08, nF4, $02, nRst, nFs4, $06, nRst
	dc.b	$02, nG4, nRst, nBb5, nRst, $06, nD5, $02, nEb5, $0E, nC5, $04
	dc.b	nRst, nG4, nRst, $0C, nC4, $04, nRst, $08, nG4, $04, nRst, nC5
	dc.b	nRst, $08, nC5, $04, nG4, nRst, $14, nBb4, $04, nRst, nC5, nRst
	dc.b	$08, nC5, $04, nG4, nRst, $08, nC4, $04, nRst, $08, nG4, $04
	dc.b	nRst, nC5, nFs4, $02, nG4, $14, nRst, $02, nF4, $18, nC5, $04
	dc.b	nRst, nG4, nRst, $0C, nC4, $04, nRst, $08, nG4, $04, nRst, nC5
	dc.b	nRst, $08, nC5, $04, nG4, nRst, $14, nBb4, $04, nRst, nC5, nRst
	dc.b	$08, nC5, $04, nG4, nRst, $08, nC4, $04, nRst, $08, nG4, $04
	dc.b	nRst, nC5, nRst, $08, nF4, $02, nRst, nFs4, $06, nRst, $02, nG4
	dc.b	nRst, nBb5, nRst, $06, nD5, $02, nEb5, $0E, nC5, $04, nRst, nG4
	dc.b	nRst, $0C, nC4, $04, nRst, $08, nG4, $04, nRst, nC5, nRst, $08
	dc.b	nC5, $04, nG4, nRst, $14, nBb4, $04, nRst, nC5, nRst, $08, nC5
	dc.b	$04, nG4, nRst, $08, nC4, $04, nRst, $08, nG4, $04, nRst, nC5
	dc.b	nFs4, $02, nG4, $14, nRst, $02, nF4, $18, nAb3, $02, nRst, $06
	dc.b	nAb3, $02, nRst, nAb4, nRst, $06, nAb3, $02, nRst, nAb3, nRst, $06
	dc.b	nAb3, $02, nRst, nFs4, nRst, $06, nAb3, $02, nRst, $0A, nAb3, $02
	dc.b	nRst, nFs4, nRst, $06, nAb3, $02, nRst, $0A, nAb3, $02, nRst, nFs4
	dc.b	nRst, $06, nAb3, $02, nRst, nAb3, nRst, $06, nAb3, $02, nRst, nAb4
	dc.b	nRst, $0A, nAb3, $02, nRst, $0A, nFs4, $02, nRst, $06, nAb3, $02
	dc.b	nRst, $32, nBb3, $02, nRst, $06, nBb3, $02, nRst, nBb4, nRst, $06
	dc.b	nBb3, $02, nRst, nBb3, nRst, $06, nBb3, $02, nRst, nAb4, nRst, $06
	dc.b	nBb3, $02, nRst, $0A, nBb3, $02, nRst, nAb4, nRst, $06, nBb3, $02
	dc.b	nRst, $0A, nBb3, $02, nRst, nAb4, nRst, $06, nBb3, $02, nRst, nBb3
	dc.b	nRst, $06, nBb3, $02, nRst, nBb4, nRst, $0A, nBb3, $02, nRst, $0A
	dc.b	nAb4, $02, nRst, $06, nBb3, $02, nRst, $0E, nAb3, $02, nRst, nAb3
	dc.b	nRst, nAb3, nRst, nBb3, $08, nAb4, $04, nBb3, $08, nBb4, $04, nAb3
	dc.b	$02, nRst, $06, nAb3, $02, nRst, nAb4, nRst, $06, nAb3, $02, nRst
	dc.b	nAb3, nRst, $06, nAb3, $02, nRst, nFs4, nRst, $06, nAb3, $02, nRst
	dc.b	$0A, nAb3, $02, nRst, nFs4, nRst, $06, nAb3, $02, nRst, $0A, nAb3
	dc.b	$02, nRst, nFs4, nRst, $06, nAb3, $02, nRst, nAb3, nRst, $06, nAb3
	dc.b	$02, nRst, nAb4, nRst, $0A, nAb3, $02, nRst, $0A, nFs4, $02, nRst
	dc.b	$06, nAb3, $02, nRst, $32, nBb3, $02, nRst, $06, nBb3, $02, nRst
	dc.b	nBb4, nRst, $06, nBb3, $02, nRst, nBb3, nRst, $06, nBb3, $02, nRst
	dc.b	nAb4, nRst, $06, nBb3, $02, nRst, $0A, nBb3, $02, nRst, nAb4, nRst
	dc.b	$06, nBb3, $02, nRst, $0A, nBb3, $02, nRst, nAb4, nRst, $06, nBb3
	dc.b	$02, nRst, nD4, nRst, $0A, nD4, $02, nRst, $0A, nD4, $02, nRst
	dc.b	$0A, nD4, $02, nRst, $06, nG4, $02, nRst, $32, nBb4, $02, nRst
	dc.b	$06, nBb4, $02, nRst, $0A, nBb4, $02, nRst, $0A, nEb4, $02, nRst
	dc.b	nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10, nEb4, $04, nRst
	dc.b	$08, nD4, $04, nRst, $08, nC4, $18, nEb4, $14, nD4, $34, nBb4
	dc.b	$02, nRst, $06, nBb4, $02, nRst, $0A, nBb4, $02, nRst, $0A, nEb4
	dc.b	$02, nRst, nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10, nEb4
	dc.b	$04, nRst, $08, nD4, $04, nRst, $08, nC3, $04, nRst, nG3, nC4
	dc.b	nRst, nG4, nBb2, nRst, nF3, nBb3, nRst, nF4, nRst, $08, nEb3, $04
	dc.b	nAb3, nRst, nEb4, nG2, nRst, nD3, nG3, nRst, nD4, nBb4, $02, nRst
	dc.b	$06, nBb4, $02, nRst, $0A, nBb4, $02, nRst, $0A, nEb4, $02, nRst
	dc.b	nD4, $06, nRst, $02, nC4, nRst, $0A, nF4, $10, nEb4, $04, nRst
	dc.b	$08, nD4, $04, nRst, $08, nC4, $18, nEb4, $14, nD4, $34, nRst
	dc.b	$08, nG4, $02, nRst, nF4, $06, nRst, $02, nEb4, nRst, $0A, nD4
	dc.b	$02, nRst, nEb4, $06, nRst, $02, nC4, nRst, $0A, nEb3, $04, nAb3
	dc.b	$08, nEb3, $04, nEb4, $18, nRst, $08, nG4, $02, nRst, $0A, nG4
	dc.b	$02, nRst, $0A, nG4, $02, nRst, nG4, $0A, nRst, $02, nG4, nRst
	dc.b	$2E
	smpsJump            s3p3_Jump02

; Unreachable
	smpsStop

; PSG2 Data
s3p3_PSG2:
	smpsPSGvoice        sTone_0A
	dc.b	nRst, $01
	smpsDetune          $01

s3p3_Jump03:
	smpsJump            s3p3_Jump02

; Unreachable
	smpsJump            s3p3_Jump03
	smpsStop

; PSG3 Data
s3p3_PSG3:
	smpsPSGvoice        sTone_02
	smpsPSGform         $E7

s3p3_Loop00:
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsLoop            $01, $24, s3p3_Loop00

s3p3_Loop01:
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsLoop            $01, $02, s3p3_Loop01
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $34

s3p3_Loop02:
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsLoop            $01, $02, s3p3_Loop02
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $64

s3p3_Loop03:
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsPSGvoice        sTone_08
	dc.b	nMaxPSG1, $08
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG1, $04
	smpsLoop            $01, $0E, s3p3_Loop03
	dc.b	nRst, $60
	smpsJump            s3p3_Loop00

; Unreachable
	smpsStop

s3p3_Voices:
	include	"..\unibank.asm"