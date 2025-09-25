Sound_87_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_87_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_87_FM5,	$07, $04

; FM5 Data
Sound_87_FM5:
	smpsSetvoice        $00
	dc.b	nEb3, $07
	smpsLoop            $00, $04, Sound_87_FM5
	dc.b	nB2, $12
	smpsStop

Sound_87_Voices:
;	Voice $00
;	$F3
;	$10, $70, $3C, $3A, 	$1F, $1F, $1F, $1F, 	$17, $1F, $1F, $17
;	$00, $00, $00, $00, 	$FF, $08, $0F, $FF, 	$33, $1B, $33, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $1E
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $01
	smpsVcCoarseFreq    $0A, $0C, $00, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $17, $1F, $1F, $17
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $00, $00, $0F
	smpsVcReleaseRate   $0F, $0F, $08, $0F
	smpsVcTotalLevel    $00, $33, $1B, $33

