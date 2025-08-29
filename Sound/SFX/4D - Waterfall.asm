Sound_4D_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_4D_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_4D_PSG3,	$00, $00

; PSG3 Data
Sound_4D_PSG3:
	smpsPSGform         $E7
	dc.b	nA6, $05

Sound_4D_Jump01:
	dc.b	nB6, $10, smpsNoAttack
	smpsJump            Sound_4D_Jump01

; Unreachable
	smpsStop

; Song seems to not use any FM voices
Sound_4D_Voices: