Sound_96_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_96_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_96_PSG3,	$1E, $00

; PSG3 Data
Sound_96_PSG3:
	smpsPSGform         $E7
	smpsPSGvoice        sTone_09
	smpsModSet          $02, $01, $09, $06
	dc.b	nA2, $05, nRst, $01
	smpsPSGAlterVol     $03
	smpsPSGAlterVol     $10
	dc.b	nRst, $01
	smpsStop

; Song seems to not use any FM voices
Sound_96_Voices:
