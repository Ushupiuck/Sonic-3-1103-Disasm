Sound_7B_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_7B_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG3, Sound_7B_PSG3,	$00, $00

; PSG3 Data
Sound_7B_PSG3:
	smpsPSGvoice        sTone_0D
	smpsPSGform         $E7
	dc.b	nA5, $03, nRst, $03, nA5, $01, smpsNoAttack

Sound_7B_Loop00:
	dc.b	$01
	smpsPSGAlterVol     $01
	dc.b	smpsNoAttack
	smpsLoop            $00, $15, Sound_7B_Loop00
	smpsStop

; Song seems to not use any FM voices
Sound_7B_Voices:
