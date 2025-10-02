s3p41_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     s3p41_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $25

	smpsHeaderDAC       s3p41_DAC
	smpsHeaderFM        s3p41_FM1,	$0C, $12
	smpsHeaderFM        s3p41_FM2,	$0C, $12
	smpsHeaderFM        s3p41_FM3,	$0C, $12
	smpsHeaderFM        s3p41_FM4,	$0C, $12
	smpsHeaderFM        s3p41_FM5,	$0C, $22
	smpsHeaderPSG       s3p41_PSG1,	$00, $06, $00, sTone_0C
	smpsHeaderPSG       s3p41_PSG2,	$00, $06, $00, sTone_0C
	smpsHeaderPSG       s3p41_PSG3,	$05, $05, $00, sTone_0C

; PSG3 Data
s3p41_PSG3:
	smpsStop
	
; Unreachable
	smpsStop

; DAC Data
s3p41_DAC:
	dc.b	dSnareS3, $05, nRst, $01, dKickS3, $05, nRst, $01, dKickS3, $05, nRst, $01
	dc.b	dSnareS3, $05, nRst, $01, dKickS3, $05, nRst, $01, dKickS3, $05, nRst, $01
	dc.b	dSnareS3, $05, nRst, $01, dKickS3, $05, nRst, $01, dSnareS3, $05, nRst, $01
	dc.b	dKickS3, $05, nRst, $01, dKickS3, $05, nRst, $01, dSnareS3, $05, nRst, $01
	dc.b	dKickS3, $05, nRst, $01, dKickS3, $05, nRst, $01, dSnareS3, $05, nRst, $01
	dc.b	dKickS3, nRst, dKickS3, dKickS3, nRst, dKickS3, dHighTom, $05, nRst, $01, dMidTomS3, $05
	dc.b	nRst, $01, dLowTomS3, $05, nRst, $01, dHighTom, $05, nRst, $01, dMidTomS3, $05
	dc.b	nRst, $01, dLowTomS3, $05, nRst, $01, dHighTom, $05, nRst, $01, dMidTomS3, $05
	dc.b	nRst, $01, dLowTomS3, $05, nRst, $01, dSnareS3, $05
	smpsStop

; Unreachable
	dc.b	nRst, $01, nRst, $7F, nRst, nRst, $37

; FM1 Data
s3p41_FM1:
	smpsSetvoice        $15
	dc.b	nG0, $05, nRst, $01, nG1, $05, nRst, $01, nG0, $05, nRst, $01
	dc.b	nD1, $05, nRst, $07, nG1, $05, nRst, $01, nG0, $05, nRst, $07
	dc.b	nA0, $05, nRst, $01, nA1, $05, nRst, $01, nA0, $05, nRst, $01
	dc.b	nE1, $05, nRst, $07, nA1, $05, nRst, $01, nA0, $05, nRst, $07
	dc.b	nD1, $05, nRst, $01, nD2, $05, nRst, $01, nD1, $05, nRst, $01
	dc.b	nE1, $05, nRst, $01, nE2, $05, nRst, $01, nE1, $05, nRst, $01
	dc.b	nG1, $05, nRst, $01, nG2, $05, nRst, $01, nG1, $05, nRst, $01
	dc.b	nA1, $5F, nRst, $01, nRst, $7F, nRst, nRst, $24
	smpsStop

; FM2 Data
s3p41_FM2:
	smpsSetvoice        $06
	dc.b	nD3, $06, nD3, $06, nD3, $06, nD3, $07, nRst, $05, nD3, $07
	dc.b	nRst, $05, nE3, $05, nRst, $07, nE3, $05, nRst, $07, nE3, $07
	dc.b	nRst, $05, nE3, $11, nRst, $01, nG3, $05, nRst, $0D, nA3, $05
	dc.b	nRst, $0D, nC4, $11, nRst, $01, nD4, $5F, nRst, $01, nRst, $7F
	dc.b	nRst, nRst, $05
	smpsStop

; FM3 Data
s3p41_FM3:
	smpsSetvoice        $06
	dc.b	nC3, $06, nC3, nC3, nB2, $06, nRst, $06, nB2, $06, nRst, $06
	dc.b	nD3, $06, nRst, $06, nD3, $06, nRst, $06, nCs3, $06, nRst, $06
	dc.b	nCs3, $11, nRst, $01, nE3, $05, nRst, $0D, nFs3, $05, nRst, $0D
	dc.b	nA3, $11, nRst, $01, nB3, $5F, nRst, $01, nRst, $7F, nRst, nRst
	dc.b	$05
	smpsStop

; FM4 Data
s3p41_FM4:
	smpsSetvoice        $06
	dc.b	nG2, $06, nG2, nG2, nG2, $06, nRst, $06, nG2, $06, nRst, $06
	dc.b	nA2, $06, nRst, $06, nA2, $03, nRst, $09, nA2, $05, nRst, $07
	dc.b	nA2, $11, nRst, $01, nC3, $05, nRst, $0D, nD3, $05, nRst, $0D
	dc.b	nF3, $11, nRst, $01, nG3, $5F, nRst, $01, nRst, $7F, nRst, nRst
	dc.b	$05
	smpsStop

; FM5 Data
s3p41_FM5:
	smpsSetvoice        $02
	dc.b	nRst, $7F, nRst, $71, nRst, $01, nRst, $5F
	smpsStop

; PSG1 Data
s3p41_PSG1:
	smpsDetune          $01
	smpsPSGvoice        sTone_03
	if ~~FixMusicAndSFXDataBugs
	; Bug: This tries to set an FM voice, but we are on PSG.
	smpsSetvoice        $06
	endif
	dc.b	nD3, $06, nD3, nD3, nD3, $05, nRst, $07, nD3, $05, nRst, $07
	dc.b	nE3, $03, nRst, $09, nE3, $03, nRst, $09, nE3, $05, nRst, $07
	dc.b	nE3, $11, nRst, $01, nG3, $05, nRst, $0D, nA3, $05, nRst, $0D
	dc.b	nC4, $11, nRst, $01, nD4, $5F, nRst, $01, nRst, $7F, nRst, nRst
	dc.b	$05
	smpsStop

; PSG2 Data
s3p41_PSG2:
	smpsDetune          $FF
	smpsPSGvoice        sTone_03
	if ~~FixMusicAndSFXDataBugs
	; Bug: This tries to set an FM voice, but we are on PSG.
	smpsSetvoice        $06
	endif
	dc.b	nD3, $06, nD3, nD3, nD3, $05, nRst, $07, nD3, $05, nRst, $07
	dc.b	nE3, $03, nRst, $09, nE3, $03, nRst, $09, nE3, $05, nRst, $07
	dc.b	nE3, $11, nRst, $01, nG3, $05, nRst, $0D, nA3, $05, nRst, $0D
	dc.b	nC4, $11, nRst, $01, nD4, $5F, nRst, $01, nRst, $7F, nRst, nRst
	dc.b	$05
	smpsStop

s3p41_Voices:
	include	"..\old unibank.asm"