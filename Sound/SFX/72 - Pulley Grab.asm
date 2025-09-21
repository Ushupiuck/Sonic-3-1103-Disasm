Sound_73_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_73_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_73_PSG3,	$00, $00

; PSG3 Data
Sound_73_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nEb5, $04, nCs6, $04

Sound_73_Loop00:
	dc.b	nEb5, $01
	smpsPSGAlterVol     $01
	smpsLoop            $00, $06, Sound_73_Loop00
	smpsStop

; Song seems to not use any FM voices
Sound_73_Voices:
