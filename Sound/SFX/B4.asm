Sound_B4_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_B4_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_B4_PSG3,	$02, $00

; PSG3 Data
Sound_B4_PSG3:
	smpsPSGvoice        sTone_0D
	smpsPSGform         $E7
	smpsModSet          $01, $01, $03, $05
	dc.b	nA2, $26
	smpsStop

; Song seems to not use any FM voices
Sound_B4_Voices:
