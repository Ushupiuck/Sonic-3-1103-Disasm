;z80_ptr	macro addr
;	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
;	endm

psgdelta:	equ $12
; ---------------------------------------------------------------------------------------------
; Standard Octave Pitch Equates
smpsPitch10lo		EQU	$88
smpsPitch09lo		EQU	$94
smpsPitch08lo		EQU	$A0
smpsPitch07lo		EQU	$AC
smpsPitch06lo		EQU	$B8
smpsPitch05lo		EQU	$C4
smpsPitch04lo		EQU	$D0
smpsPitch03lo		EQU	$DC
smpsPitch02lo		EQU	$E8
smpsPitch01lo		EQU	$F4
smpsPitch00		EQU	$00
smpsPitch01hi		EQU	$0C
smpsPitch02hi		EQU	$18
smpsPitch03hi		EQU	$24
smpsPitch04hi		EQU	$30
smpsPitch05hi		EQU	$3C
smpsPitch06hi		EQU	$48
smpsPitch07hi		EQU	$54
smpsPitch08hi		EQU	$60
smpsPitch09hi		EQU	$6C
smpsPitch10hi		EQU	$78

; ---------------------------------------------------------------------------------------------
; Note Equates
nRst			EQU	$80
nC0			EQU	$81
nCs0			EQU	$82
nD0			EQU	$83
nEb0			EQU	$84
nE0			EQU	$85
nF0			EQU	$86
nFs0			EQU	$87
nG0			EQU	$88
nAb0			EQU	$89
nA0			EQU	$8A
nBb0			EQU	$8B
nB0			EQU	$8C
nC1			EQU	$8D
nCs1			EQU	$8E
nD1			EQU	$8F
nEb1			EQU	$90
nE1			EQU	$91
nF1			EQU	$92
nFs1			EQU	$93
nG1			EQU	$94
nAb1			EQU	$95
nA1			EQU	$96
nBb1			EQU	$97
nB1			EQU	$98
nC2			EQU	$99
nCs2			EQU	$9A
nD2			EQU	$9B
nEb2			EQU	$9C
nE2			EQU	$9D
nF2			EQU	$9E
nFs2			EQU	$9F
nG2			EQU	$A0
nAb2			EQU	$A1
nA2			EQU	$A2
nBb2			EQU	$A3
nB2			EQU	$A4
nC3			EQU	$A5
nCs3			EQU	$A6
nD3			EQU	$A7
nEb3			EQU	$A8
nE3			EQU	$A9
nF3			EQU	$AA
nFs3			EQU	$AB
nG3			EQU	$AC
nAb3			EQU	$AD
nA3			EQU	$AE
nBb3			EQU	$AF
nB3			EQU	$B0
nC4			EQU	$B1
nCs4			EQU	$B2
nD4			EQU	$B3
nEb4			EQU	$B4
nE4			EQU	$B5
nF4			EQU	$B6
nFs4			EQU	$B7
nG4			EQU	$B8
nAb4			EQU	$B9
nA4			EQU	$BA
nBb4			EQU	$BB
nB4			EQU	$BC
nC5			EQU	$BD
nCs5			EQU	$BE
nD5			EQU	$BF
nEb5			EQU	$C0
nE5			EQU	$C1
nF5			EQU	$C2
nFs5			EQU	$C3
nG5			EQU	$C4
nAb5			EQU	$C5
nA5			EQU	$C6
nBb5			EQU	$C7
nB5			EQU	$C8
nC6			EQU	$C9
nCs6			EQU	$CA
nD6			EQU	$CB
nEb6			EQU	$CC
nE6			EQU	$CD
nF6			EQU	$CE
nFs6			EQU	$CF
nG6			EQU	$D0
nAb6			EQU	$D1
nA6			EQU	$D2
nBb6			EQU	$D3
nB6			EQU	$D4
nC7			EQU	$D5
nCs7			EQU	$D6
nD7			EQU	$D7
nEb7			EQU	$D8
nE7			EQU	$D9
nF7			EQU	$DA
nFs7			EQU	$DB
nG7			EQU	$DC
nAb7			EQU	$DD
nA7			EQU	$DE
nBb7			EQU	$DF

nMaxPSG:	equ nBb6-psgdelta
nMaxPSG1:	equ nBb6
nMaxPSG2:	equ nB6
; ---------------------------------------------------------------------------------------------
; PSG volume envelope equates
sTone_01		EQU	$01
sTone_02		EQU	$02
sTone_03		EQU	$03
sTone_04		EQU	$04
sTone_05		EQU	$05
sTone_06		EQU	$06
sTone_07		EQU	$07
sTone_08		EQU	$08
sTone_09		EQU	$09
sTone_0A		EQU	$0A
sTone_0B		EQU	$0B
sTone_0C		EQU	$0C
sTone_0D		EQU	$0D
sTone_0E		EQU	$0E
sTone_0F		EQU	$0F
sTone_10		EQU	$10
sTone_11		EQU	$11
sTone_12		EQU	$12
sTone_13		EQU	$13
sTone_14		EQU	$14
sTone_15		EQU	$15
sTone_16		EQU	$16
sTone_17		EQU	$17
sTone_18		EQU	$18
sTone_19		EQU	$19
sTone_1A		EQU	$1A
sTone_1B		EQU	$1B
sTone_1C		EQU	$1C
sTone_1D		EQU	$1D
sTone_1E		EQU	$1E
sTone_1F		EQU	$1F
sTone_20		EQU	$20
sTone_21		EQU	$21
sTone_22		EQU	$22
sTone_23		EQU	$23
sTone_24		EQU	$24
; ---------------------------------------------------------------------------------------------
; DAC Equates
dSnareS3		EQU	$81
dHighTom		EQU	$82
dMidTomS3		EQU	$83
dLowTomS3		EQU	$84
dFloorTomS3		EQU	$85
dKickS3			EQU	$86
dMuffledSnare		EQU	$87
dCrashCymbal		EQU	$88
dRideCymbal		EQU	$89
dLowMetalHit		EQU	$8A
dMetalHit		EQU	$8B
dHighMetalHit		EQU	$8C
dHigherMetalHit		EQU	$8D
dMidMetalHit		EQU	$8E
dClapS3			EQU	$8F
dElectricHighTom	EQU	$90
dTightSnare		EQU	$91
dMidpitchSnare		EQU	$92
dLooseSnare		EQU	$93
dLooserSnare		EQU	$94
dHiTimpaniS3		EQU	$95
dLowTimpaniS3		EQU	$96
dMidTimpaniS3		EQU	$97

; ---------------------------------------------------------------------------------------------
; Header Macros
; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderStartSong macro ver
SourceDriver = ver
songStart = *
	endm

smpsHeaderVoice macro addr
	;z80_ptr	ptr
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	endm

; Header macros for music (not for SFX)
; Header - Set up Channel Usage
smpsHeaderChan macro fm,psg
	dc.b	fm,psg
	endm

; Header - Set up Tempo
smpsHeaderTempo macro div,mod
	dc.b	div
	dc.b	mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro addr
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	dc.w	0
	endm

; Header - Set up FM Channel
smpsHeaderFM macro addr,pitch,vol
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	dc.b	pitch,vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro addr,pitch,vol,mod,voice
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	dc.b	pitch
	dc.b	vol,mod,voice
	endm
; ---------------------------------------------------------------------------------------------
; Co-ord Flag Macros and Equates
; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
panNone = $00
panRight = $40
panLeft = $80
panCentre = $C0
panCenter = $C0 ; silly Americans :U
	dc.b $E0,direction+amsfms
	endm

; E1xx - Set channel frequency displacement to xx
smpsAlterNote macro val
	dc.b	$E1,val
	endm

smpsDetune macro val
	dc.b	$E1,val
	endm

; Return (used after smpsCall)
smpsReturn macro val
	dc.b	$F9
	endm

; Fade in previous song (ie. 1-Up)
smpsFade macro val
	dc.b	$E2
	if ("val"<>"")
		dc.b	val
	else
		dc.b	$FF
	endif
	endm

; E6xx - Alter Volume by xx
smpsAlterVol macro val
	dc.b	$E6,val
	endm

; E7 - Prevent attack of next note
smpsNoAttack	EQU $E7

; Add xx to channel pitch
smpsAlterPitch macro val
	dc.b	$FB,val
	endm

; Add xx to channel pitch
smpsChangeTransposition macro val
	dc.b	$FB,val
	endm

; Set music tempo modifier to xx
smpsSetTempoMod macro mod
	dc.b	$FF,$00
	dc.b	mod
	endm

; Set music tempo divider to xx
smpsSetTempoDiv macro val
	dc.b	$FF,$04,val
	endm

; ECxx - Set Volume to xx
smpsSetVol macro val
	dc.b	$E4,val
	endm

; Works on all drivers
smpsPSGAlterVol macro vol
	dc.b	$EC,vol
	endm

; EFxx[yy] - Set Voice of FM channel to xx; xx < 0 means yy present
smpsSetvoice macro voice,songID
	dc.b	$EF,voice|$80,songID+$81
	endm

smpsSetvoice2 macro voice,songID
	dc.b	$EF,voice
	endm

; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	dc.b	wait,speed,change,step
	endm

; Turn on Modulation
smpsModOn macro
	dc.b	$F4,$80
	endm

; F2 - End of channel
smpsStop macro
	dc.b	$F2
	endm

; F3xx - PSG waveform to xx
smpsPSGform macro form
	dc.b	$F3,form
	endm

; Turn off Modulation
smpsModOff macro
	dc.b	$FA
	endm

; F5xx - PSG voice to xx
smpsPSGvoice macro voice
	dc.b	$F5,voice
	endm

; F6xxxx - Jump to xxxx
smpsJump macro addr
	dc.b	$F6
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,addr
	dc.b	$F7
	dc.b	index,loops
	dc.w	((((addr&$FFFF)|$8000)>>8)|(((addr&$FFFF)|$8000)<<8))&$FFFF
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	z80_ptr	loc
	endm
; ---------------------------------------------------------------------------------------------
; Alter Volume
smpsFMAlterVol macro val1
	dc.b	$E6,val1
	endm

smpsFMAlterVol2 macro val1,val2
	dc.b	$E5,val1,val2
	endm


; ---------------------------------------------------------------------------------------------
; Macros for FM instruments
; Voices - Feedback
smpsVcFeedback macro val
vcFeedback = val
	endm

; Voices - Algorithm
smpsVcAlgorithm macro val
vcAlgorithm = val
	endm

smpsVcUnusedBits macro val
vcUnusedBits = val
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
vcDT1 = op1
vcDT2 = op2
vcDT3 = op3
vcDT4 = op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
vcCF1 = op1
vcCF2 = op2
vcCF3 = op3
vcCF4 = op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
vcRS1 = op1
vcRS2 = op2
vcRS3 = op3
vcRS4 = op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
vcAR1 = op1
vcAR2 = op2
vcAR3 = op3
vcAR4 = op4
	endm

; Voices - Amplitude Modulation
smpsVcAmpMod macro op1,op2,op3,op4
vcAM1 = op1
vcAM2 = op2
vcAM3 = op3
vcAM4 = op4
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
vcD1R1 = op1
vcD1R2 = op2
vcD1R3 = op3
vcD1R4 = op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
vcD2R1 = op1
vcD2R2 = op2
vcD2R3 = op3
vcD2R4 = op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
vcDL1 = op1
vcDL2 = op2
vcDL3 = op3
vcDL4 = op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
vcRR1 = op1
vcRR2 = op2
vcRR3 = op3
vcRR4 = op4
	endm

; Voices - Total Level
smpsVcTotalLevel macro op1,op2,op3,op4
vcTL1 = op1
vcTL2 = op2
vcTL3 = op3
vcTL4 = op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
;   0     1     2     3     4     5     6     7
;%1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
vcTLMask4 = ((vcAlgorithm=7)<<7)
vcTLMask3 = ((vcAlgorithm>=4)<<7)
vcTLMask2 = ((vcAlgorithm>=5)<<7)
vcTLMask1 = $80
	dc.b	(vcDT4<<4)+vcCF4 ,(vcDT3<<4)+vcCF3 ,(vcDT2<<4)+vcCF2 ,(vcDT1<<4)+vcCF1
	dc.b	(vcRS4<<6)+vcAR4 ,(vcRS3<<6)+vcAR3 ,(vcRS2<<6)+vcAR2 ,(vcRS1<<6)+vcAR1
	dc.b	(vcAM4<<5)+vcD1R4,(vcAM3<<5)+vcD1R3,(vcAM2<<5)+vcD1R2,(vcAM1<<5)+vcD1R1
	dc.b	vcD2R4           ,vcD2R3           ,vcD2R2           ,vcD2R1
	dc.b	(vcDL4<<4)+vcRR4 ,(vcDL3<<4)+vcRR3 ,(vcDL2<<4)+vcRR2 ,(vcDL1<<4)+vcRR1
	dc.b	vcTL4|vcTLMask4  ,vcTL3|vcTLMask3  ,vcTL2|vcTLMask2  ,vcTL1|vcTLMask1
	endm