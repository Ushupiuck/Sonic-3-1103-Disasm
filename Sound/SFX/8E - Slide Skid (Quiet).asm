Sound_8E_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_8E_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_8E_PSG3,	$00, $03

Sound_8E_PSG3:
	smpsPSGform         $E7
	dc.b	nAs6, $05, $05, $06
	smpsStop

; Song seems to not use any FM voices
Sound_8E_Voices: