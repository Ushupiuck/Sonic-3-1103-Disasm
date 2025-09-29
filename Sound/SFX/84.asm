Sound_84_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Sound_84_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_84_FM5,	$02, $07

; FM5 Data
Sound_84_FM5:
	smpsSetvoice        $00
	dc.b	nF0, $04, $03, $03, nC0, $1B
	smpsLoop            $00, $04, Sound_84_FM5
	smpsStop

Sound_84_Voices:
;	Voice $00
;	$10
;	$06, $03, $03, $06, 	$14, $16, $14, $18, 	$15, $19, $0C, $11
;	$1E, $0F, $0E, $10, 	$13, $0D, $0E, $9C, 	$00, $10, $0A, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $06, $03, $03, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $18, $14, $16, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $11, $0C, $19, $15
	smpsVcDecayRate2    $10, $0E, $0F, $1E
	smpsVcDecayLevel    $09, $00, $00, $01
	smpsVcReleaseRate   $0C, $0E, $0D, $03
	smpsVcTotalLevel    $80, $0A, $10, $00

