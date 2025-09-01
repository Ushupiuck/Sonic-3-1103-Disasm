Sound_58_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_58_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_58_PSG3,	$00, $03

; PSG3 Data
Sound_58_PSG3:
	smpsModSet          $01, $01, $F0, $08
	smpsPSGform         $E7
	dc.b	nE5, $07

Sound_58_Loop00:
	dc.b	nG6, $01
	smpsPSGAlterVol     $01
	smpsLoop            $00, $0C, Sound_58_Loop00
	smpsStop

; Song seems to not use any FM voices
Sound_58_Voices:
