Sound_64_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_64_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG2, Sound_64_PSG2,	$00, $00

; PSG2 Data
Sound_64_PSG2:
	dc.b	nA5, $02
	smpsStop

; Song seems to not use any FM voices
Sound_64_Voices:
