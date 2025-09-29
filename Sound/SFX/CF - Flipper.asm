Sound_CF_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_CF_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound_CF_FM5,	$0D, $0A
	smpsHeaderSFXChannel cFM6, Sound_CF_FM6,	$0D, $09

; FM6 Data
Sound_CF_FM6:
	smpsJump            Sound_CF_Jump00

; FM5 Data
Sound_CF_FM5:
	smpsDetune          $01

Sound_CF_Jump00:
	smpsSetvoice        $00
	dc.b	nF1, $03, nCs2, $1A
	smpsStop

Sound_CF_Voices:
;	Voice $00
;	$3D
;	$12, $77, $13, $30, 	$5F, $5F, $5F, $5F, 	$0D, $0A, $0A, $0A
;	$0D, $0D, $0D, $0D, 	$4F, $0F, $0F, $0F, 	$10, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $01, $07, $01
	smpsVcCoarseFreq    $00, $03, $07, $02
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0A, $0D
	smpsVcDecayRate2    $0D, $0D, $0D, $0D
	smpsVcDecayLevel    $00, $00, $00, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $00, $00, $10

