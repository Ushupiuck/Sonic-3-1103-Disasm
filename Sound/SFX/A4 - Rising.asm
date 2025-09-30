Sound_A4_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_A4_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_A4_FM5,	$F3, $07

; FM5 Data
Sound_A4_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $03, $CA
	dc.b	nCs3, $61
	smpsModSet          $01, $01, $DF, $05
	dc.b	smpsNoAttack, $16
	smpsStop

Sound_A4_Voices:
;	Voice $00
;	$35
;	$06, $07, $03, $05, 	$11, $07, $0B, $EE, 	$0C, $15, $03, $06
;	$0C, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$2E, $8D, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $05, $03, $07, $06
	smpsVcRateScale     $03, $00, $00, $00
	smpsVcAttackRate    $2E, $0B, $07, $11
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $03, $15, $0C
	smpsVcDecayRate2    $00, $00, $00, $0C
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $0D, $2E

