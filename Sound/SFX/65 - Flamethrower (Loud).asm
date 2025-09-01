Sound_65_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_65_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_65_PSG3,	$00, $00

; PSG3 Data
Sound_65_PSG3:
	smpsPSGform         $E7
	dc.b	nCs4, $03
	smpsStop

; Song seems to not use any FM voices
Sound_65_Voices:
