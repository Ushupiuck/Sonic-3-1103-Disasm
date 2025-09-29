Sound_C0_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_C0_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_C0_FM5,	$00, $05

; FM5 Data
Sound_C0_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $04, $83
	dc.b	nFs2, $40, nBb2, $16
	smpsStop

Sound_C0_Voices:
;	Voice $00
;	$82
;	$1F, $18, $14, $1F, 	$0D, $1F, $12, $0C, 	$00, $00, $00, $00
;	$02, $02, $02, $02, 	$2F, $2F, $FF, $3F, 	$22, $16, $11, $82
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $02
	smpsVcDetune        $01, $01, $01, $01
	smpsVcCoarseFreq    $0F, $04, $08, $0F
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0C, $12, $1F, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $03, $0F, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $02, $11, $16, $22

