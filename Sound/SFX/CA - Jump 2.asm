Sound_CA_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_CA_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG1, Sound_CA_PSG1,	$00, $00

; PSG1 Data
Sound_CA_PSG1:
	smpsPSGvoice        sTone_0D
	dc.b	nF2, $05
	smpsModSet          $02, $01, $F8, $65
	dc.b	nBb2, $15
	smpsStop

; Song seems to not use any FM voices
Sound_CA_Voices:
