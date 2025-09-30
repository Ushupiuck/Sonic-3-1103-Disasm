Sound_D3_Header:
	smpsHeaderStartSong 3, 1
	smpsHeaderVoice     Sound_D3_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_D3_FM5,	$F8, $03

; FM5 Data
Sound_D3_FM5:
	smpsSetvoice        $00
	dc.b	nG3, $06, nRst, $06, nG3, $24
	smpsStop

Sound_D3_Voices:
;	Voice $00
;	$41
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$1F, $FF, $1F, $0F, 	$0C, $29, $15, $80
	smpsVcAlgorithm     $09
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $15, $29, $0C

