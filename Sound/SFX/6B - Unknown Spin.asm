Sound_6B_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_6A_6B_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, Sound_6B_FM5,	$00, $00

; FM3 Data
Sound_6B_FM5:
	smpsSetvoice        $00
	smpsModSet          $01, $01, $0D, $00
	dc.b	nFs4, $0C, smpsNoAttack
	smpsModSet          $00, $01, $00, $00
	dc.b	$4B
	smpsStop