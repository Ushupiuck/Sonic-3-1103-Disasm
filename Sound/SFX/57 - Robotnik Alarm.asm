Sound_57_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_57_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_57_FM5,	$02, $17

; FM5 Data
Sound_57_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $FF, $4B
	dc.b	nA0, $29

Sound_57_Loop00:
	smpsAlterVol        $FE
	dc.b	smpsNoAttack, nA0, $20
	smpsLoop            $00, $07, Sound_57_Loop00
	smpsStop

Sound_57_Voices:
;	Voice $00
;	$02
;	$26, $0A, $02, $18, 	$0F, $0F, $0F, $0D, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$21, $16, $10, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $01, $00, $00, $02
	smpsVcCoarseFreq    $08, $02, $0A, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $0D, $0F, $0F, $0F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $10, $16, $21

