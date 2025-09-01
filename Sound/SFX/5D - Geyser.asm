Sound_5D_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_5D_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_5D_PSG3,	$00, $00

; PSG3 Data
Sound_5D_PSG3:
	smpsPSGform         $E7
	dc.b	nB4, $08

Sound_5D_Loop00:
	dc.b	nAb6
	smpsPSGAlterVol     $01
	smpsLoop            $00, $03, Sound_5D_Loop00
	dc.b	$10, smpsNoAttack
	smpsStop

; Song seems to not use any FM voices
Sound_5D_Voices: