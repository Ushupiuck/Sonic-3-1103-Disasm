Sound_93_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_93_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_93_FM5,	$F1, $08

; FM5 Data
Sound_93_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $7C, $95

Sound_93_Loop00:
	dc.b	nB3, $07
	smpsFMAlterVol      $0A
	dc.b	nB3, $07
	smpsFMAlterVol      $F0
	smpsStop

Sound_93_Voices:
;	Voice $00
;	$3B
;	$04, $0D, $19, $02, 	$14, $14, $12, $14, 	$0C, $04, $04, $04
;	$02, $02, $02, $03, 	$DF, $2F, $2F, $2F, 	$22, $24, $27, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $00, $00
	smpsVcCoarseFreq    $02, $09, $0D, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $12, $14, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $04, $04, $0C
	smpsVcDecayRate2    $03, $02, $02, $02
	smpsVcDecayLevel    $02, $02, $02, $0D
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $24, $22

