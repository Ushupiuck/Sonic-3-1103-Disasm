Sound_CC_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_CC_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_CC_FM5,	$00, $00

; FM5 Data
Sound_CC_FM5:
	smpsSetvoice        $00
	smpsModSet          $00, $01, $20, $F6
	dc.b	nG5, $20
	smpsModOff
	smpsSetvoice        $01
	dc.b	nG6, $25, smpsNoAttack

Sound_CC_Jump00:
	dc.b	$03, smpsNoAttack
	smpsJump            Sound_CC_Jump00

; Unreachable
	smpsStop

Sound_CC_Voices:
;	Voice $00
;	$34
;	$00, $0C, $03, $09, 	$9F, $8F, $8C, $D5, 	$04, $02, $00, $00
;	$00, $04, $0A, $08, 	$BF, $BF, $BF, $BF, 	$00, $80, $1C, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $09, $03, $0C, $00
	smpsVcRateScale     $03, $02, $02, $02
	smpsVcAttackRate    $15, $0C, $0F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $02, $04
	smpsVcDecayRate2    $08, $0A, $04, $00
	smpsVcDecayLevel    $0A, $0A, $0A, $0A
	smpsVcReleaseRate   $1F, $1F, $1F, $1F
	smpsVcTotalLevel    $00, $1C, $00, $00

;	Voice $01
;	$34
;	$00, $0C, $03, $09, 	$9F, $9F, $9F, $DF, 	$00, $00, $00, $00
;	$00, $00, $0A, $08, 	$BF, $BF, $BF, $BF, 	$00, $96, $1C, $89
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $09, $03, $0C, $00
	smpsVcRateScale     $03, $02, $02, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $08, $0A, $00, $00
	smpsVcDecayLevel    $0A, $0A, $0A, $0A
	smpsVcReleaseRate   $1F, $1F, $1F, $1F
	smpsVcTotalLevel    $89, $1C, $96, $00