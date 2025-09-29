Sound_9D_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_9D_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cPSG2, Sound_9D_PSG2,	$E1, $05
	smpsHeaderSFXChannel cPSG3, Sound_9D_PSG3,	$E1, $05

; PSG2 Data
Sound_9D_PSG2:
	smpsModSet          $0F, $01, $FF, $17
	smpsPSGvoice        $00
	dc.b	nA7, $20
	smpsStop

; PSG3 Data
Sound_9D_PSG3:
	smpsPSGform         $E7
	smpsModSet          $0F, $01, $FF, $47
	smpsPSGvoice        $00
	dc.b	nA7, $20
	smpsStop

; Song seems to not use any FM voices
Sound_9D_Voices:
