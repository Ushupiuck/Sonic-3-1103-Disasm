Sound_61_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_61_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_61_PSG3,	$1D, $00

; PSG3 Data
Sound_61_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        sTone_0F
	dc.b	nB3, $02, nRst, $03, nD4, $04
	smpsPSGAlterVol     $02
	dc.b	nD3, $04
	smpsStop

; Song seems to not use any FM voices
Sound_61_Voices:
