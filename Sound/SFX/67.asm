Sound_67_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_67_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM3, Sound_67_FM3,	$2B, $00

; FM3 Data
Sound_67_FM3:
	smpsSetvoice        $00

Sound_67_Loop00:
	dc.b	nCs1, $02
	smpsAlterVol        $01
	smpsLoop            $00, $08, Sound_67_Loop00
	smpsAlterVol        $E0
	smpsLoop            $00, $05, Sound_67_Loop00
	smpsStop

Sound_67_Voices:
;	Voice $00
;	$35
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$15, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $15

