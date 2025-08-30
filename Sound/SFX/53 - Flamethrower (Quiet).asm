Sound_53_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_53_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_53_PSG3,	$00, $00

; PSG3 Data
Sound_53_PSG3:
	smpsPSGform         $E7
	smpsPSGAlterVol     $03
	dc.b	nG3, $10
	smpsStop

; Song seems to not use any FM voices
Sound_53_Voices:
