Sound_D8_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Sound_D8_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_D8_FM5,	$00, $02

; FM5 Data
Sound_D8_FM5:
	smpsSetvoice        $00
	dc.b	nGs5, $15
	smpsStop

Sound_D8_Voices:
;	Voice $00
;	$3E
;	$34, $00, $75, $02, 	$59, $D9, $5F, $9C, 	$0F, $04, $0F, $0A
;	$02, $02, $05, $05, 	$FF, $FF, $FF, $FF, 	$28, $00, $23, $00
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $07, $00, $03
	smpsVcCoarseFreq    $02, $05, $00, $04
	smpsVcRateScale     $02, $01, $03, $01
	smpsVcAttackRate    $1C, $1F, $19, $19
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0F, $04, $0F
	smpsVcDecayRate2    $05, $05, $02, $02
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $23, $00, $28

