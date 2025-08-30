Sound_54_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_54_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM3, Sound_54_FM3,	$00, $00
	smpsHeaderSFXChannel cFM4, Sound_54_FM4,	$02, $00

; FM4 Data
Sound_54_FM4:
	smpsAlterNote       $90

; FM3 Data
Sound_54_FM3:
	smpsSetvoice        $00
	dc.b	nEb1, $7F, smpsNoAttack
	smpsJump            Sound_54_FM3

; Unreachable
	smpsStop

Sound_54_Voices:
;	Voice $00
;	$2F
;	$32, $04, $02, $34, 	$08, $08, $08, $08, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$80, $80, $80, $80
	smpsVcAlgorithm     $07
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $00, $00, $03
	smpsVcCoarseFreq    $04, $02, $04, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $08, $08, $08, $08
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $00

