Sound_D9_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_D9_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG2, Sound_D9_PSG2,	$00, $00

; PSG2 Data
Sound_D9_PSG2:
	smpsPSGvoice        sTone_03

Sound_D9_Loop00:
	dc.b	nD5, $04, nE5, nFs5
	smpsPSGAlterVol     $01
	smpsAlterPitch      $FF
	smpsLoop            $00, $05, Sound_D9_Loop00

Sound_D9_Loop01:
	dc.b	nD5, $04, nE5, nFs5
	smpsPSGAlterVol     $01
	smpsAlterPitch      $01
	smpsLoop            $00, $07, Sound_D9_Loop01
	smpsStop

; Song seems to not use any FM voices
Sound_D9_Voices:
