Sound_A1_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_A1_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG2, Sound_A1_PSG2,	$FB, $02

; PSG2 Data
Sound_A1_PSG2:
	dc.b	nD4, $05
	smpsStop

; Song seems to not use any FM voices
Sound_A1_Voices:
