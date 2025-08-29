Sound_4F_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_4E_4F_8E_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Sound_4F_FM5,	$00, $06
	smpsHeaderSFXChannel cPSG3, Sound_4F_PSG3,	$00, $00

; FM5 Data
Sound_4F_FM5:
	smpsSetvoice        $00
	dc.b	nEb5, $06, smpsNoAttack, nG6, $05

Sound_4F_Loop00:
	dc.b	smpsNoAttack
	smpsFMAlterVol      $02
	dc.b	$05
	smpsLoop            $00, $0A, Sound_4F_Loop00
	smpsStop

; PSG3 Data
Sound_4F_PSG3:
	smpsPSGform         $E7
	dc.b	nBb5, $10

Sound_4F_Loop01:
	dc.b	smpsNoAttack
	smpsPSGAlterVol     $01
	smpsAlterPitch      $FF
	dc.b	$05
	smpsLoop            $00, $0A, Sound_4F_Loop01
	smpsStop