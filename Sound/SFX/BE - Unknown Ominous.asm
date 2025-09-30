Sound_BE_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_BE_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_BE_FM5,	$F3, $05

; FM5 Data
Sound_BE_FM5:
	smpsSetvoice        $00
	dc.b	nBb2, $7E
	smpsStop

Sound_BE_Voices:
;	Voice $00
;	$35
;	$06, $02, $03, $05, 	$0A, $06, $0A, $D9, 	$0C, $07, $03, $0A
;	$08, $0A, $10, $09, 	$62, $07, $1F, $1F, 	$2E, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $05, $03, $02, $06
	smpsVcRateScale     $03, $00, $00, $00
	smpsVcAttackRate    $19, $0A, $06, $0A
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $03, $07, $0C
	smpsVcDecayRate2    $09, $10, $0A, $08
	smpsVcDecayLevel    $01, $01, $00, $06
	smpsVcReleaseRate   $0F, $0F, $07, $02
	smpsVcTotalLevel    $00, $00, $00, $2E

