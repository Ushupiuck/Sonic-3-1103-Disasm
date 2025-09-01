Sound_60_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_5F_60_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM3, Sound_60_FM3,	$F0, $0D

; FM3 Data
Sound_60_FM3:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $0F, $00
	dc.b	nEb3, $30, smpsNoAttack
	smpsModOff
	dc.b	nB3, $70
	smpsStop