Sound_C8_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_C8_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_C8_FM5,	$0B, $08

; FM5 Data
Sound_C8_FM5:
	smpsSetvoice        $00
	dc.b	nB4, $17, nRst, nB4, nRst, nB4, nRst, nCb6, $20, nRst
	smpsStop

Sound_C8_Voices:
;	Voice $00
;	$3C
;	$30, $70, $16, $20, 	$17, $19, $14, $14, 	$14, $02, $02, $02
;	$1F, $1F, $1F, $1F, 	$1C, $16, $1A, $17, 	$44, $80, $50, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $02, $01, $07, $03
	smpsVcCoarseFreq    $00, $06, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $14, $19, $17
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $02, $02, $14
	smpsVcDecayRate2    $1F, $1F, $1F, $1F
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $17, $1A, $16, $1C
	smpsVcTotalLevel    $00, $50, $00, $44

