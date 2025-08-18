Sound_36_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Sound_36_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cPSG2, Sound_36_PSG2,	$00, $00
	smpsHeaderSFXChannel cPSG3, Sound_36_PSG3,	$00, $00

; PSG2 Data
Sound_36_PSG2:
	smpsPSGvoice        sTone_0D
	dc.b	nBb3, $01, nRst, nBb3, nRst, $03

Sound_36_Loop00:
	dc.b	nBb3, $01, nRst, $01
	smpsLoop            $00, $0B, Sound_36_Loop00
	smpsStop

; PSG3 Data
Sound_36_PSG3:
	smpsPSGvoice        sTone_0D
	dc.b	nRst, $01, nAb3, nRst, nAb3, nRst, $03

Sound_36_Loop01:
	dc.b	nAb3, $01, nRst, $01
	smpsLoop            $00, $0B, Sound_36_Loop01
	smpsStop

; Song seems to not use any FM voices
Sound_36_Voices:
