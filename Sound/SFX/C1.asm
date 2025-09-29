Sound_C1_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_C1_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_C1_FM5,	$FB, $02

; FM5 Data
Sound_C1_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $85, $32
	dc.b	nBb2, $10

Sound_C1_Loop00:
	smpsAlterVol        $0F
	dc.b	nBb2, $0D, nRst, $02
	smpsLoop            $00, $04, Sound_C1_Loop00
	smpsStop

Sound_C1_Voices:
;	Voice $00
;	$83
;	$13, $10, $1F, $1D, 	$11, $1C, $0C, $14, 	$00, $10, $00, $00
;	$02, $02, $02, $02, 	$2F, $2F, $FF, $3F, 	$03, $0D, $64, $87
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $02
	smpsVcDetune        $01, $01, $01, $01
	smpsVcCoarseFreq    $0D, $0F, $00, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $0C, $1C, $11
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $10, $00
	smpsVcDecayRate2    $02, $02, $02, $02
	smpsVcDecayLevel    $03, $0F, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $07, $64, $0D, $03

