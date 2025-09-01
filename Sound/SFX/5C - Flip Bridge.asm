Sound_5C_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_50_5C_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_5C_FM5,	$EE, $00

; FM5 Data
Sound_5C_FM5:
	smpsSetvoice        $00
	dc.b	nB2, $06, nEb3
	smpsStop
