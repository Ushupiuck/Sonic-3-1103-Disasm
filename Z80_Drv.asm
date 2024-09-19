; ===========================================================================
; Sonic the Hedgehog 3 - November 11, 1993 prototype Z80 sound driver
; Stock Z80 Type 2 DAC driver with many features from Sonic 1/2 missing

; Disassembled using Z80Dasm.exe
; Documented by Alex Field
; Additional help by Naoto and OrionNavettan

; Note that the Z80 syntax used here is slightly non-standard as of result of how AXM68k
; works: * is used to invoke the current program counter rather than $, offset(*) must be
; used to invoke the program counter in macro parameters due to the use of ASM68K's section
; and group functionality, and shadow registers are not indicated  with an apostrophe; e.g.,
; ex af,af' is simply written as ex af,af.

	pushs
	CPU z80
	obj 0
; ---------------------------------------------------------------------------

zTrack_Start:
PlaybackControl:	equ 0
VoiceControl:		equ 1
TempoDivider:		equ 2
DataPointerLow:		equ 3
DataPointerHigh:	equ 4
Transpose:		equ 5
Volume:			equ 6
ModulationCtrl:		equ 7
VoiceIndex:		equ 8
StackPointer:		equ 9
AMSFMSPan:		equ $A
DurationTimeout:	equ $B
SavedDuration:		equ $C
FreqLow:		equ $D
FreqHigh:		equ $E
VoiceSongID:		equ $F
Detune:			equ $10
Unk11h:			equ $11
; $12-$16 are unused!
VolEnv:			equ $17
FMVoLEnv:		equ $18
FMVolEnvMask:		equ $19
SSGEGPointerLow:	equ FMVolEnvMask
PSGNoise:		equ $1A
SSGEGPointerHigh:	equ PSGNoise
FeedbackAlgo:		equ $1B
TLPtrLow:		equ $1C
TLPtrHigh:		equ $1D
NoteFillTimeout:	equ $1E
NoteFillMaster:		equ $1F
ModulationPtrLow:	equ $20
ModulationPtrHigh:	equ $21
ModulationValLow:	equ $22
ModEnvSens:		equ ModulationValLow
ModulationValHigh:	equ $23
ModulationWait:		equ $24
ModulationSpeed:	equ $25
ModEnvIndex:		equ ModulationSpeed
ModulationDelta:	equ $26
ModulationSteps:	equ $27
LoopCounters:		equ $28		; and $29
VoicesLow:		equ $2A
VoicesHigh:		equ $2B
Stack_top:		equ $2C		; and $2D and $2E and $2F
zTrack_End:		equ Stack_top+4

zTrack			equ zTrack_End-zTrack_Start

; ---------------------------------------------------------------------------
z80_stack	=	$2000
z80_stack_end	=	z80_stack-$60
; equates: standard (for Genesis games) addresses in the memory map
zYM2612_A0:		equ $4000
zYM2612_D0:		equ $4001
zYM2612_A1:		equ $4002
zYM2612_D1:		equ $4003
zBankRegister:		equ $6000
zPSG:			equ $7F11
zROMWindow:		equ $8000
; ---------------------------------------------------------------------------
; z80 RAM:
zDataStart:		equ $1C00

		pusho						; save options
		opt	ae+					; enable auto evens

		rsset zDataStart
			rs.b	2	; unused
zPointerTable:		rs.w	1	; the 68000 SoundDriverLoad routine sets this to $1200 in Z80 memory
zSongBank:		rs.b	1	; bits 15 to 22 of M68K bank address
zCurrentTempo:		rs.b	1
zDACIndex:		rs.b	1	; bit 7 = 1 if playing, 0 if not; remaining 7 bits are index into DAC tables (1-based)
zPlaySegaPCMFlag:	rs.b	1
zPalDblUpdCounter:	rs.b	1	; used to update the sound driver twice every five frames; not actually implemented yet

zTempVariablesStart:	rs.b	1
zNextSound:		equ	zTempVariablesStart
			rs.b	3	; unused (first byte not sure?)
zFadeOutTimeout:	rs.b	1
zFadeDelay:		rs.b	1
zFadeDelayTimeout:	rs.b	1
zPauseFlag:		rs.b	1
zHaltFlag:		rs.b	1
zFM3Settings:		rs.b	1	; set twice, never read (is read in Z80 Type 1 for YM timer-related purposes)
zTempoAccumulator:	rs.b	1
			rs.b	1	; unused
unk_1C15:		rs.b	1	; set twice, unused read
zFadeToPrevFlag:	rs.b	1
unk_1C17:		rs.b	1	; set once, never read
zSoundIndex:		rs.b	1	; effectively unused in the final
zUpdatingSFX:		rs.b	1
zSpecFM3FreqsSFX:	rs.b	1
			rs.b	7	; unused
unk_1C22:		rs.b	1
			rs.b	7	; unused
zSpecFM3Freqs:		rs.b	1
			rs.b	7	; unused
zSFXSaveIndex:		rs.b	1
zSongPosition:		rs.b	2
zTrackInitPos:		rs.b	2
zVoiceTblPtr:		rs.b	2
zSFXVoiceTblPtr:	rs.b	2
zSFXTempoDivider:	rs.b	1
			rs.b	4	; unused

zTracksStart:		rs.b	zTrack
zSongFM6_DAC:		equ	zTracksStart
zSongFM1:		rs.b	zTrack
zSongFM2:		rs.b	zTrack
zSongFM3:		rs.b	zTrack
zSongFM4:		rs.b	zTrack
zSongFM5:		rs.b	zTrack
zSongPSG1:		rs.b	zTrack
zSongPSG2:		rs.b	zTrack
zSongPSG3:		rs.b	zTrack
zTracksEnd:		equ	zSongPSG3+zTrack

zTracksSFXStart:	rs.b	zTrack
zSFX_FM3:		equ	zTracksSFXStart
zSFX_FM4:		rs.b	zTrack
zSFX_FM5:		rs.b	zTrack
zSFX_FM6:		rs.b	zTrack
zSFX_PSG1:		rs.b	zTrack
zSFX_PSG2:		rs.b	zTrack
zSFX_PSG3:		rs.b	zTrack
zTracksSFXEnd:		equ	zSFX_PSG3+zTrack


zTempVariablesEnd:	equ	zTracksSFXEnd
		popo						; restore options

bankswitchToMusic macro
	; hardcoded to only accept 4-bit bank values
	ld	(hl),a
	rept 3
		rra
		ld	(hl),a
	endr
	xor	a
	ld	d,1
	ld	(hl),d
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	endm

bankswitchToSFX macro
	ld	hl,zBankRegister
	xor	a
	ld	e,1
	ld	(hl),e
	ld	(hl),a
	ld	(hl),e
	ld	(hl),e
	ld	(hl),e
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Entry Point
; ---------------------------------------------------------------------------

zEntryPoint:
	di					; disable interrupts...
	di					; twice
	im	1				; set interrupt mode 1
	jp	zInitAudioDriver
; ---------------------------------------------------------------------------
	nop

; ===========================================================================
; ---------------------------------------------------------------------------
; Gets the correct pointer to pointer table for the data type in question
; (music, sfx, voices, etc.).
;
; input:  c    ID for data type.
; output: hl   master pointer table for	index
;         af   trashed
;         b    trashed
; ---------------------------------------------------------------------------

zGetPointerTable:
	ld	hl,(zPointerTable)		; read pointer to pointer table (yes, really)
						; really, you should just make this reference z80_SoundDriverPointers directly
	ld	b,0
	add	hl,bc				; add offset into pointer table
	ex	af,af				; backup AF
	ld	a,(hl)				; read low byte of pointer table
	inc	hl
	ld	h,(hl)				; read high byte of pointer table
	ld	l,a				; combine both bytes together to get our address
	ex	af,af				; restore AF
	ret
; ---------------------------------------------------------------------------
	nop
	nop
	nop

; ===========================================================================
; ---------------------------------------------------------------------------
; Reads	an offset into a pointer table and returns dereferenced pointer.
;
; input:  a    index into pointer table
;	  hl   pointer to pointer table
; output: hl   selected	pointer	in pointer table
;         bc   trashed
; ---------------------------------------------------------------------------

zPointerTableOffset:
	ld	c,a				; get index for pointer table
	; then load the pointer in the index
	ld	b,0
	add	hl,bc
	add	hl,bc
	nop
	nop
	nop

; ----------------------------------------------------------------------------
; Dereferences a pointer.
;
; input:  hl	pointer
; output: hl	equal to what that was being pointed to by hl

zReadPointer:
	ld	a,(hl)				; read low byte of pointer table
	inc	hl
	ld	h,(hl)				; read high byte of pointer table
	ld	l,a				; combine both bytes together to get our address
	ret

; ----------------------------------------------------------------------------
; Possible to fit two more rsttargets into here
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop

; ===========================================================================
; ---------------------------------------------------------------------------
; This subroutine is called every V-Int. After it is processed, the z80
; returns to the digital audio loop to continue playing DAC samples.
;
; If the SEGA PCM is being played, it disables interrupts -- this means that
; this procedure will NOT be called while the SEGA PCM is playing.
; ---------------------------------------------------------------------------

zVInt:
	di					; disable interrupts
	push	af
	push	iy
	exx

	call	zDoUpdate
	call	zUpdateEverything

	; DAC bankswitch
	ld	hl,zBankRegister		; get the DAC table
	xor	a
	ld	e,1
	ld	(hl),a
	ld	(hl),e
	ld	(hl),e
	ld	(hl),e
	ld	(hl),e
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	exx
	pop	iy
	pop	af
	ld	b,1
	ret
; ---------------------------------------------------------------------------

zInitAudioDriver:
	ld	sp,z80_stack			; set the stack pointer to 0x2000 (end of z80 RAM)
	ld	c,0

@loop:
	ld	b,0
	djnz	*
	dec	c
	jr	z,@loop

	ld	a,6
	ld	(zSongBank),a			; store the music bank
	xor	a
	ld	(zDACIndex),a			; clear the DAC index
	ld	(zPlaySegaPCMFlag),a		; clear the Sega sound flag
	call	zStopAllSound			; stop all music
	ld	a,5				; set PAL double-update timer to 5
	ld	(zPalDblUpdCounter),a		; (that is, do not double-update for 5 frames)

	; ...second DAC bankswitch?
	ld	hl,zBankRegister
	ld	d,1
	xor	a
	ld	(hl),a
	ld	(hl),d
	ld	(hl),d
	ld	(hl),d
	ld	(hl),d
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	ld	(hl),a
	ei
	jp	zPlayDigitalAudio

; ===========================================================================
; ---------------------------------------------------------------------------
; Writes a reg/data pair to part I or II
;
; input:  a    value for register
;         c    value for data
;         ix   pointer to track RAM
; ---------------------------------------------------------------------------

zWriteFMIorII:
	bit	7,(ix+VoiceControl)		; is this a PSG track?
	ret	nz				; return if yes
	bit	2,(ix+PlaybackControl)		; is SFX overriding this track?
	ret	nz				; return if yes
	add	a,(ix+VoiceControl)		; add the channel bits to the register address
	bit	2,(ix+VoiceControl)		; is this the DAC channel or FM4 or FM5 or FM6?
	jr	nz,zWriteFMII_reduced		; if yes, branch
; End of function zWriteFMIorII

; ---------------------------------------------------------------------------
; Writes a reg/data pair to part I
;
; input:  a    value for register
;         c    value for data
; ---------------------------------------------------------------------------

zWriteFMI:
	ld	(zYM2612_A0),a			; select YM2612 register
	nop
	ld	a,c
	ld	(zYM2612_D0),a			; send data to register
	ret
; End of function zWriteFMI

; ---------------------------------------------------------------------------

zWriteFMII_reduced:
	sub	4				; strip 'bound to Part II regs' bit
	; fall through to next function
; ---------------------------------------------------------------------------
; Writes a reg/data pair to part II
;
; input:  a    value for register
;         c    value for data
; ---------------------------------------------------------------------------

zWriteFMII:
	ld	(zYM2612_A1),a			; select YM2612 register
	nop
	ld	a,c
	ld	(zYM2612_D1),a			; send data to register
	ret
; End of function zWriteFMII


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


zUpdateEverything:
	call	zPauseUnpause
	call	zTempoWait
	call	zDoMusicFadeOut
	call	zCycleSoundQueue
	call	zUpdateSFXTracks

; zUpdateMusicTracks:
	ld	hl,zBankRegister
	ld	a,(zSongBank)			; get bank ID for music
	bankswitchToMusic
	xor	a
	ld	(zUpdatingSFX),a		; update music
	ld	ix,zSongFM6_DAC
	bit	7,(ix+PlaybackControl)		; is this an FM/DAC track?
	call	nz,zUpdateDACTrack		; if yes, branch
	ld	b,(zTracksEnd-zSongFM1)/zTrack	; get number of tracks
	ld	ix,zSongFM1
	jr	zTrackUpdLoop			; play all tracks

zUpdateSFXTracks:
	ld	a,1
	ld	(zUpdatingSFX),a		; update SFX
	bankswitchToSFX
	ld	ix,zTracksSFXStart		; get number of tracks
	ld	b,(zTracksSFXEnd-zTracksSFXStart)/zTrack

zTrackUpdLoop:
	push	bc
	bit	7,(ix+PlaybackControl)		; is a track currently playing?
	call	nz,zUpdateFMorPSGTrack		; if yes, branch
	ld	de,zTrack
	add	ix,de				; otherwise, advance to the next track
	pop	bc
	djnz	zTrackUpdLoop			; loop for all tracks
	ret

zUpdateFMorPSGTrack:
	bit	7,(ix+VoiceControl)		; is this a PSG channel?
	jp	nz,zUpdatePSGTrack		; if yes, branch

	call	zTrackRunTimer			; run note timer
	jr	nz,@noteGoing			; if the note has not expired yet, branch
	call	zGetNextNote			; get note for next FM track
	bit	4,(ix+PlaybackControl)		; is track resting?
	ret	nz				; if yes, return
	call	zPrepareModulation
	call	zUpdateFreq
	call	zDoModulation
	call	zFMSendFreq
	jp	zFMNoteOn
; ---------------------------------------------------------------------------

@noteGoing:
	bit	4,(ix+PlaybackControl)		; is the track resting?
	ret	nz				; if yes, return
	call	zDoFMVolEnv
	ld	a,(ix+NoteFillTimeout)
	or	a				; is timeout either not running or expired?
	jr	z,@keepGoing			; if yes, branch
	dec	(ix+NoteFillTimeout)
	jp	z,zKeyOffIfActive

@keepGoing:
	call	zUpdateFreq
	bit	6,(ix+PlaybackControl)		; is 'sustain frequency' bit set?
	ret	nz				; if yes, return
	call	zDoModulation
; End of function zUpdateFMorPSGTrack

; ===========================================================================
; ---------------------------------------------------------------------------
; Uploads track's frequency to YM2612.
;
; input:   ix    Pointer to track RAM
;          hl    Frequency to upload
;          de    For FM3 in special mode, pointer to extra FM3 frequency data (never correctly set)
; output:  a     Trashed
;          bc    Trashed
;          hl    Trashed
;          de    Increased by 8
; ---------------------------------------------------------------------------

zFMSendFreq:
	bit	2,(ix+PlaybackControl)		; is SFX overriding this track?
	ret	nz				; if yes, return
	bit	0,(ix+PlaybackControl)		; is track in special mode (FM3 only)?
	jp	nz,@specialMode			; if yes, branch

@notFM3:
	ld	a,$A4				; update frequency MSB
	ld	c,h
	call	zWriteFMIorII
	ld	a,$A0				; update frequency LSB
	ld	c,l
	call	zWriteFMIorII
	ret
; ---------------------------------------------------------------------------

@specialMode:
	ld	a,(ix+VoiceControl)
	cp	2				; is this FM3?
	jr	nz,@notFM3			; if not, branch
	call	zGetSpecialFM3DataPointer
	ld	b,zSpecialFreqCommands_End-zSpecialFreqCommands
	ld	hl,zSpecialFreqCommands

@loop:
	push	bc
	ld	a,(hl)
	inc	hl
	push	hl
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ex	de,hl
	ld	l,(ix+FreqLow)
	ld	h,(ix+FreqHigh)
	add	hl,bc
	push	af
	ld	c,h
	call	zWriteFMI
	pop	af
	sub	4
	ld	c,l
	call	zWriteFMI
	pop	hl
	pop	bc
	djnz	@loop
	ret
; End of function zFMSendFreq

; ===========================================================================
; zloc_1A5:
zSpecialFreqCommands:
	db	$AD
	db	$AE
	db	$AC
	db	$A6
zSpecialFreqCommands_End:

; ===========================================================================

zGetSpecialFM3DataPointer:
	ld	de,zSpecFM3Freqs
	ld	a,(zUpdatingSFX)
	or	a				; is this a SFX track?
	ret	z				; if not, return
	ld	de,zSpecFM3FreqsSFX
	ret	p
	ld	de,unk_1C22
	ret
; End of function zGetSpecialFM3DataPointer


zGetNextNote:
    ld     e,(ix+DataPointerLow)      ; 0001B9 DD 5E 03
    ld     d,(ix+DataPointerHigh)      ; 0001BC DD 56 04
    res    1,(ix+PlaybackControl)      ; 0001BF DD CB 00 8E
    res    4,(ix+PlaybackControl)      ; 0001C3 DD CB 00 A6

zGetNextNote_cont:
    ld     a,(de)          ; 0001C7 1A
    inc    de              ; 0001C8 13
    cp     $e0             ; 0001C9 FE E0
	jp	nc,zHandleFMorPSGCoordFlag
    ex     af,af          ; 0001CE 08
	call	zKeyOffIfActive
    ex     af,af          ; 0001D2 08
    bit    3,(ix+PlaybackControl)      ; 0001D3 DD CB 00 5E
	jp	nz,zAltFreqMode
    or     a               ; 0001DA B7
	jp	p,zStoreDuration
    sub    $81             ; 0001DE D6 81
	jp	p,@gotNote
	call	zRestTrack
	jr	zGetNoteDuration

@gotNote:
    add    a,(ix+Transpose)      ; 0001E8 DD 86 05
	ld	hl,zPSGFrequencies
    push   af              ; 0001EE F5
	rst	zPointerTableOffset
    pop    af              ; 0001F0 F1
    bit    7,(ix+VoiceControl)      ; 0001F1 DD CB 01 7E
	jr	nz,zGotNoteFreq
    push   de              ; 0001F7 D5
    ld     d,$08           ; 0001F8 16 08
    ld     e,$0c           ; 0001FA 1E 0C
    ex     af,af          ; 0001FC 08
    xor    a               ; 0001FD AF

@loop:
    ex     af,af          ; 0001FE 08
    sub    e               ; 0001FF 93
	jr	c,@gotDisplacement
    ex     af,af          ; 000202 08
    add    a,d             ; 000203 82
	jr	@loop
    ex     af,af          ; 000206 08

@gotDisplacement:
    add    a,e             ; 000207 83
	ld	hl,zFMFrequencies
	rst	zPointerTableOffset
    ex     af,af          ; 00020C 08
    or     h               ; 00020D B4
    ld     h,a             ; 00020E 67
    pop    de              ; 00020F D1

zGotNoteFreq:
    ld     (ix+FreqLow),l      ; 000210 DD 75 0D
    ld     (ix+FreqHigh),h      ; 000213 DD 74 0E

zGetNoteDuration:
    ld     a,(de)          ; 000216 1A
    or     a               ; 000217 B7
	jp	p,zGotNoteDuration
    ld     a,(ix+SavedDuration)      ; 00021B DD 7E 0C
    ld     (ix+DurationTimeout),a      ; 00021E DD 77 0B
	jr	zFinishTrackUpdate
    ld     a,(de)          ; 000223 1A
    inc    de              ; 000224 13
    ld     (ix+Unk11h),a      ; 000225 DD 77 11
	jr	zGetRawDuration

zAltFreqMode:
    ld     h,a             ; 00022A 67
    ld     a,(de)          ; 00022B 1A
    inc    de              ; 00022C 13
    ld     l,a             ; 00022D 6F
    or     h               ; 00022E B4
	jr	z,@gotZero
    ld     a,(ix+Transpose)      ; 000231 DD 7E 05
    ld     b,$00           ; 000234 06 00
    or     a               ; 000236 B7
	jp	p,@didSignExtend
    dec    b               ; 00023A 05

@didSignExtend:
    ld     c,a             ; 00023B 4F
    add    hl,bc           ; 00023C 09

@gotZero:
    ld     (ix+FreqLow),l      ; 00023D DD 75 0D
    ld     (ix+FreqHigh),h      ; 000240 DD 74 0E
    ld     a,(de)          ; 000243 1A
    inc    de              ; 000244 13
    ld     (ix+Unk11h),a      ; 000245 DD 77 11

zGetRawDuration:
    ld     a,(de)          ; 000248 1A

zGotNoteDuration:
    inc    de              ; 000249 13

zStoreDuration:
	call	zComputeNoteDuration
    ld     (ix+SavedDuration),a      ; 00024D DD 77 0C

zFinishTrackUpdate:
    ld     (ix+DataPointerLow),e      ; 000250 DD 73 03
    ld     (ix+DataPointerHigh),d      ; 000253 DD 72 04
    ld     a,(ix+SavedDuration)      ; 000256 DD 7E 0C
    ld     (ix+DurationTimeout),a      ; 000259 DD 77 0B
    bit    1,(ix+PlaybackControl)      ; 00025C DD CB 00 4E
    ret    nz              ; 000260 C0
    xor    a               ; 000261 AF
    ld     (ix+ModEnvIndex),a      ; 000262 DD 77 25
    ld     (ix+ModEnvSens),a      ; 000265 DD 77 22
    ld     (ix+VolEnv),a      ; 000268 DD 77 17
    ld     a,(ix+NoteFillMaster)      ; 00026B DD 7E 1F
    ld     (ix+NoteFillTimeout),a      ; 00026E DD 77 1E
	ret

zComputeNoteDuration:
    ld     b,(ix+TempoDivider)      ; 000272 DD 46 02
    dec    b               ; 000275 05
    ret    z               ; 000276 C8
    ld     c,a             ; 000277 4F

@loop:
    add    a,c             ; 000278 81
	djnz	@loop
	ret

zTrackRunTimer:
    ld     a,(ix+DurationTimeout)      ; 00027C DD 7E 0B
    dec    a               ; 00027F 3D
    ld     (ix+DurationTimeout),a      ; 000280 DD 77 0B
    ret                    ; 000283 C9

zFMNoteOn:
    ld     a,(ix+FreqLow)      ; 000284 DD 7E 0D
    or     (ix+FreqHigh)        ; 000287 DD B6 0E
    ret    z               ; 00028A C8
    ld     a,(ix+PlaybackControl)      ; 00028B DD 7E 00
    and    $06             ; 00028E E6 06
    ret    nz              ; 000290 C0
    ld     a,(ix+VoiceControl)      ; 000291 DD 7E 01
    or     $f0             ; 000294 F6 F0
    ld     c,a             ; 000296 4F
    ld     a,$28           ; 000297 3E 28
	call	zWriteFMI
	ret

zKeyOffIfActive:
    ld     a,(ix+PlaybackControl)      ; 00029D DD 7E 00
    and    $06             ; 0002A0 E6 06
    ret    nz              ; 0002A2 C0

zKeyOff:
    ld     c,(ix+VoiceControl)      ; 0002A3 DD 4E 01
    bit    7,c             ; 0002A6 CB 79
    ret    nz              ; 0002A8 C0

zKeyOnOff:
    ld     a,$28           ; 0002A9 3E 28
	call	zWriteFMI
	ret

zDoFMVolEnv:
    ld     a,(ix+FMVolEnv)      ; 0002AF DD 7E 18
    or     a               ; 0002B2 B7
    ret    z               ; 0002B3 C8
    ret    m               ; 0002B4 F8
    dec    a               ; 0002B5 3D
    ld     c,$0a           ; 0002B6 0E 0A
	rst	zGetPointerTable
	rst	zPointerTableOffset
	call	zDoVolEnv
    ld     h,(ix+TLPtrHigh)      ; 0002BD DD 66 1D
    ld     l,(ix+TLPtrLow)      ; 0002C0 DD 6E 1C
	ld	de,zFMInstrumentTLTable
	ld	b,zFMInstrumentTLTable_End-zFMInstrumentTLTable
    ld     c,(ix+FMVolEnvMask)      ; 0002C8 DD 4E 19

@loop:
    push   af              ; 0002CB F5
    sra    c               ; 0002CC CB 29
    push   bc              ; 0002CE C5
	jr	nc,@skipReg
    add    a,(hl)          ; 0002D1 86
    and    $7f             ; 0002D2 E6 7F
    ld     c,a             ; 0002D4 4F
    ld     a,(de)          ; 0002D5 1A
	call	zWriteFMIorII

@skipReg:
    pop    bc              ; 0002D9 C1
    inc    de              ; 0002DA 13
    inc    hl              ; 0002DB 23
    pop    af              ; 0002DC F1
	djnz	@loop
	ret

zPrepareModulation:
    bit    7,(ix+ModulationCtrl)      ; 0002E0 DD CB 07 7E
    ret    z               ; 0002E4 C8
    bit    1,(ix+PlaybackControl)      ; 0002E5 DD CB 00 4E
    ret    nz              ; 0002E9 C0
    ld     e,(ix+ModulationPtrLow)      ; 0002EA DD 5E 20
    ld     d,(ix+ModulationPtrHigh)      ; 0002ED DD 56 21
    push   ix              ; 0002F0 DD E5
    pop    hl              ; 0002F2 E1
    ld     b,$00           ; 0002F3 06 00
    ld     c,ModulationWait           ; 0002F5 0E 24
    add    hl,bc           ; 0002F7 09
    ex     de,hl           ; 0002F8 EB
    ldi                    ; 0002F9 ED A0
    ldi                    ; 0002FB ED A0
    ldi                    ; 0002FD ED A0
    ld     a,(hl)          ; 0002FF 7E
    srl    a               ; 000300 CB 3F
    ld     (de),a          ; 000302 12
    xor    a               ; 000303 AF
    ld     (ix+ModulationValLow),a      ; 000304 DD 77 22
    ld     (ix+ModulationValHigh),a      ; 000307 DD 77 23
	ret

zDoModulation:
    ld     a,(ix+ModulationCtrl)      ; 00030B DD 7E 07
    or     a               ; 00030E B7
    ret    z               ; 00030F C8
    cp     $80             ; 000310 FE 80
	jr	nz,zDoModEnvelope
    dec    (ix+ModulationWait)        ; 000314 DD 35 24
    ret    nz              ; 000317 C0
    inc    (ix+ModulationWait)        ; 000318 DD 34 24
    push   hl              ; 00031B E5
    ld     l,(ix+ModulationValLow)      ; 00031C DD 6E 22
    ld     h,(ix+ModulationValHigh)      ; 00031F DD 66 23
    ld     e,(ix+ModulationPtrLow)      ; 000322 DD 5E 20
    ld     d,(ix+ModulationPtrHigh)      ; 000325 DD 56 21
    push   de              ; 000328 D5
    pop    iy              ; 000329 FD E1
    dec    (ix+ModulationSpeed)        ; 00032B DD 35 25
	jr	nz,@modSustain
    ld     a,(iy+VoiceControl)      ; 000330 FD 7E 01
    ld     (ix+ModulationSpeed),a      ; 000333 DD 77 25
    ld     a,(ix+ModulationDelta)      ; 000336 DD 7E 26
    ld     c,a             ; 000339 4F
    and    $80             ; 00033A E6 80
    rlca                   ; 00033C 07
    neg                    ; 00033D ED 44
    ld     b,a             ; 00033F 47
    add    hl,bc           ; 000340 09
    ld     (ix+ModulationValLow),l      ; 000341 DD 75 22
    ld     (ix+ModulationValHigh),h      ; 000344 DD 74 23

@modSustain:
    pop    bc              ; 000347 C1
    add    hl,bc           ; 000348 09
    dec    (ix+ModulationSteps)        ; 000349 DD 35 27
    ret    nz              ; 00034C C0
    ld     a,(iy+DataPointerLow)      ; 00034D FD 7E 03
    ld     (ix+ModulationSteps),a      ; 000350 DD 77 27
    ld     a,(ix+ModulationDelta)      ; 000353 DD 7E 26
    neg                    ; 000356 ED 44
    ld     (ix+ModulationDelta),a      ; 000358 DD 77 26
	ret

zDoModEnvelope:
    dec    a               ; 00035C 3D
    ex     de,hl           ; 00035D EB
    ld     c,$08           ; 00035E 0E 08
	rst	zGetPointerTable
	rst	zPointerTableOffset
	jr	zDoModEnvelope_cont

zModEnvSetIndex:
    ld     (ix+ModEnvIndex),a      ; 000364 DD 77 25

zDoModEnvelope_cont:
    push   hl              ; 000367 E5
    ld     c,(ix+ModEnvIndex)      ; 000368 DD 4E 25
    ld     b,$00           ; 00036B 06 00
    add    hl,bc           ; 00036D 09
    ld     a,(hl)          ; 00036E 7E
    pop    hl              ; 00036F E1
    bit    7,a             ; 000370 CB 7F
	jp	z,zPositiveModEnvMod
    cp     $82             ; 000375 FE 82
	jr	z,zChangeModEnvIndex
    cp     $80             ; 000379 FE 80
	jr	z,zResetModEnvMod
    cp     $84             ; 00037D FE 84
	jr	z,zModEnvIncMultiplier
    ld     h,$ff           ; 000381 26 FF
	jr	nc,zApplyModEnvMod
    set    6,(ix+PlaybackControl)      ; 000385 DD CB 00 F6
    pop    hl              ; 000389 E1
    ret                    ; 00038A C9

zChangeModEnvIndex:
    inc    bc              ; 00038B 03
    ld     a,(bc)          ; 00038C 0A
	jr	zModEnvSetIndex

zResetModEnvMod:
    xor    a               ; 00038F AF
	jr	zModEnvSetIndex

zModEnvIncMultiplier:
    inc    bc              ; 000392 03
    ld     a,(bc)          ; 000393 0A
    add    a,(ix+ModEnvSens)      ; 000394 DD 86 22
    ld     (ix+ModEnvSens),a      ; 000397 DD 77 22
    inc    (ix+ModEnvIndex)        ; 00039A DD 34 25
    inc    (ix+ModEnvIndex)        ; 00039D DD 34 25
	jr	zDoModEnvelope_cont

zPositiveModEnvMod:
    ld     h,$00           ; 0003A2 26 00

zApplyModEnvMod:
    ld     l,a             ; 0003A4 6F
    ld     b,(ix+ModEnvSens)      ; 0003A5 DD 46 22
    inc    b               ; 0003A8 04
    ex     de,hl           ; 0003A9 EB

@loop:
    add    hl,de           ; 0003AA 19
	djnz	@loop
    inc    (ix+ModEnvIndex)        ; 0003AD DD 34 25
    ret                    ; 0003B0 C9

zUpdateFreq:
    ld     h,(ix+FreqHigh)      ; 0003B1 DD 66 0E
    ld     l,(ix+FreqLow)      ; 0003B4 DD 6E 0D
    ld     b,$00           ; 0003B7 06 00
    ld     a,(ix+Detune)      ; 0003B9 DD 7E 10
    or     a               ; 0003BC B7
	jp	p,@didSignExtend
    ld     b,$ff           ; 0003C0 06 FF

@didSignExtend:
    ld     c,a             ; 0003C2 4F
    add    hl,bc           ; 0003C3 09
    ret                    ; 0003C4 C9

zGetFMInstrumentPointer:
    ld     hl,(zVoiceTblPtr)      ; 0003C5 2A 37 1C
    ld     a,(zUpdatingSFX)       ; 0003C8 3A 19 1C
    or     a               ; 0003CB B7
	jr	z,zGetFMInstrumentOffset
    ld     l,(ix+VoicesLow)      ; 0003CE DD 6E 2A
    ld     h,(ix+VoicesHigh)      ; 0003D1 DD 66 2B

zGetFMInstrumentOffset:
    xor    a               ; 0003D4 AF
    or     b               ; 0003D5 B0
    ret    z               ; 0003D6 C8
    ld     de,$0019        ; 0003D7 11 19 00

@loop:
    add    hl,de           ; 0003DA 19
	djnz	@loop
	ret

zFMInstrumentRegTable:
	db	$B0

zFMInstrumentOperatorTable:
	db	$30
	db	$38
	db	$34
	db	$3C

zFMInstrumentRSARTable:
	db	$50
	db	$58
	db	$54
	db	$5C

zFMInstrumentAMD1RTable:
	db	$60
	db	$68
	db	$64
	db	$6C

zFMInstrumentD2RTable:
	db	$70
	db	$78
	db	$74
	db	$7C

zFMInstrumentD1LRRTable:
	db	$80
	db	$88
	db	$84
	db	$8C
zFMInstrumentOperatorTable_End:

zFMInstrumentTLTable:
	db	$40
	db	$48
	db	$44
	db	$4C
zFMInstrumentTLTable_End:

zFMInstrumentSSGEGTable:
	db	$90
	db	$98
	db	$94
	db	$9C
zFMInstrumentSSGEGTable_End:


zSendFMInstrument:
	ld	de,zFMInstrumentRegTable
    ld     c,(ix+AMSFMSPan)      ; 0003FE DD 4E 0A
    ld     a,$b4           ; 000401 3E B4
	call	zWriteFMIorII
	call	zSendFMInstrData
    ld     (ix+FeedbackAlgo),a      ; 000409 DD 77 1B
    ld     b,zFMInstrumentOperatorTable_End-zFMInstrumentOperatorTable           ; 00040C 06 14

@loop:
	call	zSendFMInstrData
	djnz	@loop
    ld     (ix+TLPtrLow),l      ; 000413 DD 75 1C
    ld     (ix+TLPtrHigh),h      ; 000416 DD 74 1D
	jp	zSendTL

zSendFMInstrData:
    ld     a,(de)          ; 00041C 1A
    inc    de              ; 00041D 13
    ld     c,(hl)          ; 00041E 4E
    inc    hl              ; 00041F 23
	call	zWriteFMIorII
    ret                    ; 000423 C9

zCycleSoundQueue:
    ld     a,(zNextSound)       ; 000424 3A 09 1C

zPlaySoundByIndex:
    cp     $ff             ; 000427 FE FF
	jp	z,zPlaySegaSound
    cp     $32             ; 00042C FE 32
	jp	c,zPlayMusic
    cp     $da             ; 000431 FE DA
	jp	c,zPlaySound
    cp     $e0             ; 000436 FE E0
	jp	c,zStopAllSound
    cp     $f0             ; 00043B FE F0
	jp	nc,zStopAllSound
    sub    $e0             ; 000440 D6 E0
	ld	hl,zFadeEffects
	rst	zPointerTableOffset
    xor    a               ; 000446 AF
    ld     (zSoundIndex),a       ; 000447 32 18 1C
    jp     (hl)            ; 00044A E9
; ---------------------------------------------------------------------------

zFadeEffects:
	dw	zFadeOutMusic
	dw	zStopAllSound
	dw	zPSGSilenceAll
	dw	zStopSFX
; ---------------------------------------------------------------------------

zStopSFX:
    ld     ix,zTracksSFXStart        ; 000453 DD 21 F0 1D
    ld     b,(zTracksSFXEnd-zTracksSFXStart)/zTrack           ; 000457 06 07
    ld     a,$01           ; 000459 3E 01
    ld     (zUpdatingSFX),a       ; 00045B 32 19 1C

@loop:
    push   bc              ; 00045E C5
    bit    7,(ix+PlaybackControl)      ; 00045F DD CB 00 7E
	call	nz,zSilenceStopTrack
    ld     de,zTrack        ; 000466 11 30 00
    add    ix,de           ; 000469 DD 19
    pop    bc              ; 00046B C1
	djnz	@loop
	call	zClearNextSound
	ret

zSilenceStopTrack:
    push   hl              ; 000472 E5
    push   hl              ; 000473 E5
	jp	cfSilenceStopTrack

zPlayMusic:
    sub    $01             ; 000477 D6 01
    ret    m               ; 000479 F8
    push   af              ; 00047A F5
	call	zStopAllSound
    pop    af              ; 00047E F1
    push   af              ; 00047F F5
	ld	hl,z80_MusicBanks
    add    a,l             ; 000483 85
    ld     l,a             ; 000484 6F
    adc    a,h             ; 000485 8C
    sub    l               ; 000486 95
    ld     h,a             ; 000487 67
	ld	(zloc_48B+1),hl

zloc_48B:
	ld	a,(z80_MusicBanks)
    ld     (zSongBank),a       ; 00048E 32 04 1C

	; music bankswitch
    ld     hl,zBankRegister        ; 000491 21 00 60
	bankswitchToMusic
    ld     a,$b6           ; 0004A3 3E B6
    ld     (zYM2612_A1),a       ; 0004A5 32 02 40
    nop                    ; 0004A8 00
    ld     a,$c0           ; 0004A9 3E C0
    ld     (zYM2612_D1),a       ; 0004AB 32 03 40
    pop    af              ; 0004AE F1
    ld     c,$04           ; 0004AF 0E 04
	rst	zGetPointerTable
	rst	zPointerTableOffset
    push   hl              ; 0004B3 E5
    push   hl              ; 0004B4 E5
	rst	zReadPointer
    ld     (zVoiceTblPtr),hl      ; 0004B6 22 37 1C
    pop    hl              ; 0004B9 E1
    pop    iy              ; 0004BA FD E1
    ld     a,(iy+5)      ; 0004BC FD 7E 05
    ld     (zTempoAccumulator),a       ; 0004BF 32 13 1C
    ld     (zCurrentTempo),a       ; 0004C2 32 05 1C
    ld     de,$0006        ; 0004C5 11 06 00
    add    hl,de           ; 0004C8 19
    ld     (zSongPosition),hl      ; 0004C9 22 33 1C
	ld	hl,zFMDACInitBytes
    ld     (zTrackInitPos),hl      ; 0004CF 22 35 1C
    ld     de,zTracksStart        ; 0004D2 11 40 1C
    ld     b,(iy+TempoDivider)      ; 0004D5 FD 46 02
    ld     a,(iy+DataPointerHigh)      ; 0004D8 FD 7E 04

@FMDACLoop:
    push   bc              ; 0004DB C5
    ld     hl,(zTrackInitPos)      ; 0004DC 2A 35 1C
    ldi                    ; 0004DF ED A0
    ldi                    ; 0004E1 ED A0
    ld     (de),a          ; 0004E3 12
    inc    de              ; 0004E4 13
    ld     (zTrackInitPos),hl      ; 0004E5 22 35 1C
    ld     hl,(zSongPosition)      ; 0004E8 2A 33 1C
    ldi                    ; 0004EB ED A0
    ldi                    ; 0004ED ED A0
    ldi                    ; 0004EF ED A0
    ldi                    ; 0004F1 ED A0
    ld     (zSongPosition),hl      ; 0004F3 22 33 1C
	call	zInitFMDACTrack
    pop    bc              ; 0004F9 C1
	djnz	@FMDACLoop
    ld     a,(iy+DataPointerLow)      ; 0004FC FD 7E 03
    or     a               ; 0004FF B7
	jp	z,zClearNextSound
    ld     b,a             ; 000503 47
	ld	hl,zPSGInitBytes
    ld     (zTrackInitPos),hl      ; 000507 22 35 1C
    ld     de,zSongPSG1        ; 00050A 11 60 1D
    ld     a,(iy+DataPointerHigh)      ; 00050D FD 7E 04

@PSGLoop:
    push   bc              ; 000510 C5
    ld     hl,(zTrackInitPos)      ; 000511 2A 35 1C
    ldi                    ; 000514 ED A0
    ldi                    ; 000516 ED A0
    ld     (de),a          ; 000518 12
    inc    de              ; 000519 13
    ld     (zTrackInitPos),hl      ; 00051A 22 35 1C
    ld     hl,(zSongPosition)      ; 00051D 2A 33 1C
    ld     bc,$0006        ; 000520 01 06 00
    ldir                   ; 000523 ED B0
    ld     (zSongPosition),hl      ; 000525 22 33 1C
	call	zZeroFillTrackRAM
    pop    bc              ; 00052B C1
	djnz	@PSGLoop

zClearNextSound:
    xor    a               ; 00052E AF
    ld     (zNextSound),a       ; 00052F 32 09 1C
	ret

zFMDACInitBytes:
	db	$80
	db	$06
	db	$80
	db	$00
	db	$80
	db	$01
	db	$80
	db	$02
	db	$80
	db	$04
	db	$80
	db	$05
	db	$80
	db	$06

zPSGInitBytes:
	db	$80
	db	$80
	db	$80
	db	$A0
	db	$80
	db	$C0

zPlaySound:
    sub    $32             ; 000547 D6 32
    ex     af,af          ; 000549 08

	; sound bankswitch
	bankswitchToSFX

    xor    a               ; 000559 AF
    ld     c,$06           ; 00055A 0E 06
    ld     (zUpdatingSFX),a       ; 00055C 32 19 1C
    ex     af,af          ; 00055F 08
	rst	zGetPointerTable
	rst	zPointerTableOffset
    push   hl              ; 000562 E5
	rst	zReadPointer
    ld     (zSFXVoiceTblPtr),hl      ; 000564 22 39 1C
    xor    a               ; 000567 AF
    ld     (unk_1C15),a       ; 000568 32 15 1C
    pop    hl              ; 00056B E1
    push   hl              ; 00056C E5
    pop    iy              ; 00056D FD E1
    ld     a,(iy+TempoDivider)      ; 00056F FD 7E 02
    ld     (zSFXTempoDivider),a       ; 000572 32 3B 1C
    ld     de,$0004        ; 000575 11 04 00
    add    hl,de           ; 000578 19
    ld     b,(iy+DataPointerLow)      ; 000579 FD 46 03

zSFXTrackInitLoop:
    push   bc              ; 00057C C5
    push   hl              ; 00057D E5
    inc    hl              ; 00057E 23
    ld     c,(hl)          ; 00057F 4E
	call	zGetSFXChannelPointers
    set    2,(hl)          ; 000583 CB D6
    push   ix              ; 000585 DD E5
    ld     a,(zUpdatingSFX)       ; 000587 3A 19 1C
    or     a               ; 00058A B7
	jr	z,@normalSFX1
    pop    hl              ; 00058D E1
    push   iy              ; 00058E FD E5

@normalSFX1:
    pop    de              ; 000590 D1
    pop    hl              ; 000591 E1
    ldi                    ; 000592 ED A0
    ld     a,(de)          ; 000594 1A
    cp     $02             ; 000595 FE 02
	call	z,zFM3NormalMode
    ldi                    ; 00059A ED A0
    ld     a,(zSFXTempoDivider)       ; 00059C 3A 3B 1C
    ld     (de),a          ; 00059F 12
    inc    de              ; 0005A0 13
    ldi                    ; 0005A1 ED A0
    ldi                    ; 0005A3 ED A0
    ldi                    ; 0005A5 ED A0
    ldi                    ; 0005A7 ED A0
	call	zInitFMDACTrack
    bit    7,(ix+PlaybackControl)      ; 0005AC DD CB 00 7E
	jr	z,@dontOverride
    ld     a,(ix+VoiceControl)      ; 0005B2 DD 7E 01
    cp     (iy+VoiceControl)        ; 0005B5 FD BE 01
	jr	nz,@dontOverride
    set    2,(iy+PlaybackControl)      ; 0005BA FD CB 00 D6

@dontOverride:
    push   hl              ; 0005BE E5
    ld     hl,(zSFXVoiceTblPtr)      ; 0005BF 2A 39 1C
    ld     a,(zUpdatingSFX)       ; 0005C2 3A 19 1C
    or     a               ; 0005C5 B7
	jr	z,@normalSFX2
    push   iy              ; 0005C8 FD E5
    pop    ix              ; 0005CA DD E1

@normalSFX2:
    ld     (ix+VoicesLow),l      ; 0005CC DD 75 2A
    ld     (ix+VoicesHigh),h      ; 0005CF DD 74 2B
	call	zKeyOffIfActive
	call	zFMClearSSGEGOps
    pop    hl              ; 0005D8 E1
    pop    bc              ; 0005D9 C1
	djnz	zSFXTrackInitLoop
	jp	zClearNextSound

zGetSFXChannelPointers:
    bit    7,c             ; 0005DF CB 79
	jr	nz,@isPSG
    ld     a,c             ; 0005E3 79
    bit    2,a             ; 0005E4 CB 57
	jr	z,@getPtrs
    dec    a               ; 0005E8 3D
	jr	@getPtrs

@isPSG:
    ld     a,$1f           ; 0005EB 3E 1F
	call	zSilencePSGChannel
    ld     a,$ff           ; 0005F0 3E FF
    ld     (zPSG),a       ; 0005F2 32 11 7F
    ld     a,c             ; 0005F5 79
    srl    a               ; 0005F6 CB 3F
    srl    a               ; 0005F8 CB 3F
    srl    a               ; 0005FA CB 3F
    srl    a               ; 0005FC CB 3F
    srl    a               ; 0005FE CB 3F
    add    a,$02           ; 000600 C6 02

@getPtrs:
    sub    $02             ; 000602 D6 02
    ld     (zSFXSaveIndex),a       ; 000604 32 32 1C
    push   af              ; 000607 F5
	ld	hl,zSFXChannelData
	rst	zPointerTableOffset
    push   hl              ; 00060C E5
    pop    ix              ; 00060D DD E1
    pop    af              ; 00060F F1
	ld	hl,zSFXOverriddenChannel
	rst	zPointerTableOffset
	ret

zInitFMDACTrack:
    ex     af,af          ; 000615 08
    xor    a               ; 000616 AF
    ld     (de),a          ; 000617 12
    inc    de              ; 000618 13
    ld     (de),a          ; 000619 12
    inc    de              ; 00061A 13
    ex     af,af          ; 00061B 08

zZeroFillTrackRAM:
    ex     de,hl           ; 00061C EB
    ld     (hl),zTrack       ; 00061D 36 30
    inc    hl              ; 00061F 23
    ld     (hl),$c0        ; 000620 36 C0
    inc    hl              ; 000622 23
    ld     (hl),$01        ; 000623 36 01
    ld     b,$24           ; 000625 06 24

@loop:
    inc    hl              ; 000627 23
    ld     (hl),$00        ; 000628 36 00
	djnz	@loop
    inc    hl              ; 00062C 23
    ex     de,hl           ; 00062D EB
	ret

zSFXChannelData:
	dw	zSFX_FM3
	dw	zSFX_FM4
	dw	zSFX_FM5
	dw	zSFX_FM6
	dw	zSFX_PSG1
	dw	zSFX_PSG2
	dw	zSFX_PSG3
	dw	zSFX_PSG3

zSFXOverriddenChannel:
	dw	zSongFM3
	dw	zSongFM4
	dw	zSongFM5
	dw	zSongFM6_DAC
	dw	zSongPSG1
	dw	zSongPSG2
	dw	zSongPSG3
	dw	zSongPSG3

zPauseUnpause:
    ld     hl,zPauseFlag        ; 00064F 21 10 1C
    ld     a,(hl)          ; 000652 7E
    or     a               ; 000653 B7
    ret    z               ; 000654 C8
	jp	m,@unpause
    pop    de              ; 000658 D1
    dec    a               ; 000659 3D
    ret    nz              ; 00065A C0
    ld     (hl),$02        ; 00065B 36 02
	jp	zPauseAudio

@unpause:
    xor    a               ; 000660 AF
    ld     (hl),a          ; 000661 77
    ld     a,(zFadeOutTimeout)       ; 000662 3A 0D 1C
    or     a               ; 000665 B7
	jp	nz,zStopAllSound
    ld     ix,zSongFM1        ; 000669 DD 21 70 1C
    ld     b,(zSongPSG2-zSongFM1)/zTrack           ; 00066D 06 06

@FMLoop:
    ld     a,(zHaltFlag)       ; 00066F 3A 11 1C
    or     a               ; 000672 B7
	jr	nz,@setPan
    bit    7,(ix+PlaybackControl)      ; 000675 DD CB 00 7E
	jr	z,@skipFMTrack

@setPan:
    ld     c,(ix+AMSFMSPan)      ; 00067B DD 4E 0A
    ld     a,$b4           ; 00067E 3E B4
	call	zWriteFMIorII

@skipFMTrack:
    ld     de,zTrack        ; 000683 11 30 00
    add    ix,de           ; 000686 DD 19
	djnz	@FMLoop
    ld     ix,zTracksSFXEnd        ; 00068A DD 21 40 1F
    ld     b,$07           ; 00068E 06 07

@PSGLoop:
    bit    7,(ix+PlaybackControl)      ; 000690 DD CB 00 7E
	jr	z,@skipPSG
    bit    7,(ix+VoiceControl)      ; 000696 DD CB 01 7E
	jr	nz,@skipPSG
    ld     c,(ix+AMSFMSPan)      ; 00069C DD 4E 0A
    ld     a,$b4           ; 00069F 3E B4
	call	zWriteFMIorII

@skipPSG:
    ld     de,zTrack        ; 0006A4 11 30 00
    add    ix,de           ; 0006A7 DD 19
	djnz	@PSGLoop
	ret

zFadeOutMusic:
    ld     a,$28           ; 0006AC 3E 28
    ld     (zFadeOutTimeout),a       ; 0006AE 32 0D 1C
    ld     a,$06           ; 0006B1 3E 06
    ld     (zFadeDelayTimeout),a       ; 0006B3 32 0F 1C
    ld     (zFadeDelay),a       ; 0006B6 32 0E 1C

zHaltDACPSG:
    xor    a               ; 0006B9 AF
    ld     (zSongFM6_DAC),a       ; 0006BA 32 40 1C
    ld     (zSongPSG3),a       ; 0006BD 32 C0 1D
    ld     (zSongPSG1),a       ; 0006C0 32 60 1D
    ld     (zSongPSG2),a       ; 0006C3 32 90 1D
	jp	zPSGSilenceAll

zDoMusicFadeOut:
    ld     hl,zFadeOutTimeout        ; 0006C9 21 0D 1C
    ld     a,(hl)          ; 0006CC 7E
    or     a               ; 0006CD B7
    ret    z               ; 0006CE C8
	call	m,zHaltDACPSG
    res    7,(hl)          ; 0006D2 CB BE
    ld     a,(zFadeDelayTimeout)       ; 0006D4 3A 0F 1C
    dec    a               ; 0006D7 3D
	jr	z,@timerExpired
    ld     (zFadeDelayTimeout),a       ; 0006DA 32 0F 1C
	ret

@timerExpired:
    ld     a,(zFadeDelay)       ; 0006DE 3A 0E 1C
    ld     (zFadeDelayTimeout),a       ; 0006E1 32 0F 1C
    ld     a,(zFadeOutTimeout)       ; 0006E4 3A 0D 1C
    dec    a               ; 0006E7 3D
    ld     (zFadeOutTimeout),a       ; 0006E8 32 0D 1C
	jr	z,zStopAllSound
    ld     a,(zSongBank)       ; 0006ED 3A 04 1C

	; music bankswitch
    ld     hl,zBankRegister        ; 0006F0 21 00 60
	bankswitchToMusic
    ld     ix,zTracksStart        ; 000702 DD 21 40 1C
    ld     b,(zSongPSG1-zTracksStart)/zTrack           ; 000706 06 06

@loop:
    inc    (ix+Volume)        ; 000708 DD 34 06
	jp	p,@chkChangeVolume
    dec    (ix+Volume)        ; 00070E DD 35 06
	jr	@nextTrack

@chkChangeVolume:
    bit    7,(ix+PlaybackControl)      ; 000713 DD CB 00 7E
	jr	z,@nextTrack
    bit    2,(ix+PlaybackControl)      ; 000719 DD CB 00 56
	jr	nz,@nextTrack
    push   bc              ; 00071F C5
	call	zSendTL
    pop    bc              ; 000723 C1

@nextTrack:
    ld     de,zTrack        ; 000724 11 30 00
    add    ix,de           ; 000727 DD 19
	djnz	@loop
	ret

zStopAllSound:
	ld	hl,zTempVariablesStart
	ld	de,zTempVariablesStart+1
	ld	bc,zTempVariablesEnd-zTempVariablesStart-1
    ld     (hl),$00        ; 000735 36 00
    ldir                   ; 000737 ED B0
	ld	ix,zFMDACInitBytes
    ld     b,$06           ; 00073D 06 06

@loop:
    push   bc              ; 00073F C5
	call	zFMSilenceChannel
	call	zFMClearSSGEGOps
    inc    ix              ; 000746 DD 23
    inc    ix              ; 000748 DD 23
    pop    bc              ; 00074A C1
	djnz	@loop
    ld     b,$07           ; 00074D 06 07
    xor    a               ; 00074F AF
    ld     (zFadeOutTimeout),a       ; 000750 32 0D 1C
	call	zPSGSilenceAll
    ld     c,$00           ; 000756 0E 00
    ld     a,$2b           ; 000758 3E 2B
	call	zWriteFMI

zFM3NormalMode:
    xor    a               ; 00075D AF
    ld     (zFM3Settings),a       ; 00075E 32 12 1C
    ld     c,a             ; 000761 4F
    ld     a,$27           ; 000762 3E 27
	call	zWriteFMI
	jp	zClearNextSound

zFMClearSSGEGOps:
    ld     a,$90           ; 00076A 3E 90
    ld     c,$00           ; 00076C 0E 00
	jp	zFMOperatorWriteLoop

zPauseAudio:
	call	zPSGSilenceAll
    push   bc              ; 000774 C5
    push   af              ; 000775 F5
    ld     b,(zSongFM4-zSongFM1)/zTrack           ; 000776 06 03
    ld     a,$b4           ; 000778 3E B4
    ld     c,$00           ; 00077A 0E 00

@loop1:
    push   af              ; 00077C F5
	call	zWriteFMI
    pop    af              ; 000780 F1
    inc    a               ; 000781 3C
	djnz	@loop1
    ld     b,(zSongPSG1-zSongFM4)/zTrack          ; 000784 06 02
    ld     a,$b4           ; 000786 3E B4

@loop2:
    push   af              ; 000788 F5
	call	zWriteFMII
    pop    af              ; 00078C F1
    inc    a               ; 00078D 3C
	djnz	@loop2
    ld     c,$00           ; 000790 0E 00
    ld     b,(zSongPSG1-zSongFM1)/zTrack+1           ; 000792 06 06
    ld     a,$28           ; 000794 3E 28

@loop3:
    push   af              ; 000796 F5
	call	zWriteFMI
    inc    c               ; 00079A 0C
    pop    af              ; 00079B F1
	djnz	@loop3
    pop    af              ; 00079E F1
    pop    bc              ; 00079F C1

zPSGSilenceAll:
    push   bc              ; 0007A0 C5
    ld     b,$04           ; 0007A1 06 04
    ld     a,$9f           ; 0007A3 3E 9F

@loop:
    ld     (zPSG),a       ; 0007A5 32 11 7F
    add    a,$20           ; 0007A8 C6 20
	djnz	@loop
    pop    bc              ; 0007AC C1
	jp	zClearNextSound

zTempoWait:
    ld     a,(zCurrentTempo)       ; 0007B0 3A 05 1C
    ld     hl,zTempoAccumulator        ; 0007B3 21 13 1C
    add    a,(hl)          ; 0007B6 86
    ld     (hl),a          ; 0007B7 77
    ret    nc              ; 0007B8 D0
    ld     hl,zTracksStart+DurationTimeout
    ld     de,zTrack        ; 0007BC 11 30 00
    ld     b,(zTracksEnd-zTracksStart)/zTrack           ; 0007BF 06 09

@loop:
    inc    (hl)            ; 0007C1 34
    add    hl,de           ; 0007C2 19
	djnz	@loop
	ret

zDoUpdate:
    ld     a,r             ; 0007C6 ED 5F
    ld     (unk_1C17),a       ; 0007C8 32 17 1C
    ld     de,zTempVariablesStart+1        ; 0007CB 11 0A 1C
	call	zloc_7D4
	call	zloc_7D4

zloc_7D4:
    ld     a,(de)          ; 0007D4 1A
    or     a               ; 0007D5 B7
    ret    z               ; 0007D6 C8
    sub    $01             ; 0007D7 D6 01
    ld     c,$00           ; 0007D9 0E 00
	rst	zGetPointerTable
    ld     c,a             ; 0007DC 4F
    ld     b,$00           ; 0007DD 06 00
    add    hl,bc           ; 0007DF 09
    ld     a,(zSoundIndex)       ; 0007E0 3A 18 1C
    cp     (hl)            ; 0007E3 BE
	jr	z,@skip
	jr	nc,@skip2

@skip:
    ld     a,(de)          ; 0007E8 1A
    ld     (zNextSound),a       ; 0007E9 32 09 1C
    ld     a,(hl)          ; 0007EC 7E
    and    $7f             ; 0007ED E6 7F
    ld     (zSoundIndex),a       ; 0007EF 32 18 1C

@skip2:
    xor    a               ; 0007F2 AF
    ld     (de),a          ; 0007F3 12
    inc    de              ; 0007F4 13
	ret

zFMSilenceChannel:
	call	zSetMaxRelRate
    ld     a,$40           ; 0007F9 3E 40
    ld     c,$7f           ; 0007FB 0E 7F
	call	zFMOperatorWriteLoop
    ld     c,(ix+VoiceControl)      ; 000800 DD 4E 01
	jp	zKeyOnOff

zSetMaxRelRate:
    ld     a,$80           ; 000806 3E 80
    ld     c,$ff           ; 000808 0E FF

zFMOperatorWriteLoop:
    ld     b,$04           ; 00080A 06 04

@loop:
    push   af              ; 00080C F5
	call	zWriteFMIorII
    pop    af              ; 000810 F1
    add    a,$04           ; 000811 C6 04
	djnz	@loop
	ret

zPlaySegaSound:
    ld     a,$01           ; 000816 3E 01
    ld     (zPlaySegaPCMFlag),a       ; 000818 32 07 1C
    pop    hl              ; 00081B E1
	ret

zPSGFrequencies:
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03FF
	dw	$03F7
	dw	$03BE
	dw	$0388
	dw	$0356
	dw	$0326
	dw	$02F9
	dw	$02CE
	dw	$02A5
	dw	$0280
	dw	$025C
	dw	$023A
	dw	$021A
	dw	$01FB
	dw	$01DF
	dw	$01C4
	dw	$01AB
	dw	$0193
	dw	$017D
	dw	$0167
	dw	$0153
	dw	$0140
	dw	$012E
	dw	$011D
	dw	$010D
	dw	$00FE
	dw	$00EF
	dw	$00E2
	dw	$00D6
	dw	$00C9
	dw	$00BE
	dw	$00B4
	dw	$00A9
	dw	$00A0
	dw	$0097
	dw	$008F
	dw	$0087
	dw	$007F
	dw	$0078
	dw	$0071
	dw	$006B
	dw	$0065
	dw	$005F
	dw	$005A
	dw	$0055
	dw	$0050
	dw	$004B
	dw	$0047
	dw	$0043
	dw	$0040
	dw	$003C
	dw	$0039
	dw	$0036
	dw	$0033
	dw	$0030
	dw	$002D
	dw	$002B
	dw	$0028
	dw	$0026
	dw	$0024
	dw	$0022
	dw	$0020
	dw	$001F
	dw	$001D
	dw	$001B
	dw	$001A
	dw	$0018
	dw	$0017
	dw	$0016
	dw	$0015
	dw	$0013
	dw	$0012
	dw	$0011
	dw	$0010
	dw	$0000
	dw	$0000

zFMFrequencies:
	dw	$0284
	dw	$02AB
	dw	$02D3
	dw	$02FE
	dw	$032D
	dw	$035C
	dw	$038F
	dw	$03C5
	dw	$03FF
	dw	$043C
	dw	$047C
	dw	$04C0

z80_MusicBanks:
	db	$06
	db	$06
	db	$06
	db	$06
	db	$06
	db	$06
	db	$07
	db	$07
	db	$07
	db	$07
	db	$07
	db	$07
	db	$07
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$09
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0A
	db	$0B
	db	$0B

zUpdateDACTrack:
	call	zTrackRunTimer
    ret    nz              ; 000911 C0
    ld     e,(ix+DataPointerLow)      ; 000912 DD 5E 03
    ld     d,(ix+DataPointerHigh)      ; 000915 DD 56 04

zUpdateDACTrack_cont:
    ld     a,(de)          ; 000918 1A
    inc    de              ; 000919 13
    cp     $e0             ; 00091A FE E0
	jp	nc,zHandleDACCoordFlag
    or     a               ; 00091F B7
	jp	m,@gotSample
    dec    de              ; 000923 1B
    ld     a,(ix+FreqLow)      ; 000924 DD 7E 0D

@gotSample:
    ld     (ix+FreqLow),a      ; 000927 DD 77 0D
    cp     $80             ; 00092A FE 80
	jp	z,zUpdateDACTrack_GetDuration
    res    7,a             ; 00092F CB BF
    push   de              ; 000931 D5
    ex     af,af          ; 000932 08
	call	zKeyOffIfActive
	call	zFM3NormalMode
    ex     af,af          ; 000939 08
    ld     (zDACIndex),a       ; 00093A 32 06 1C
    pop    de              ; 00093D D1

zUpdateDACTrack_GetDuration:
    ld     a,(de)          ; 00093E 1A
    inc    de              ; 00093F 13
    or     a               ; 000940 B7
	jp	p,zStoreDuration
    dec    de              ; 000944 1B
    ld     a,(ix+SavedDuration)      ; 000945 DD 7E 0C
    ld     (ix+DurationTimeout),a      ; 000948 DD 77 0B
	jp	zFinishTrackUpdate

zHandleDACCoordFlag:
	ld	hl,zloc_954
	jp	zHandleCoordFlag

zloc_954:
    inc    de              ; 000954 13
	jp	zUpdateDACTrack_cont

zHandleFMorPSGCoordFlag:
	ld	hl,zloc_964

zHandleCoordFlag:
    push   hl              ; 00095B E5
    sub    $e0             ; 00095C D6 E0
	ld	hl,zCoordFlagSwitchTable
	rst	zPointerTableOffset
    ld     a,(de)          ; 000962 1A
    jp     (hl)            ; 000963 E9

zloc_964:
    inc    de              ; 000964 13
	jp	zGetNextNote_cont

zCoordFlagSwitchTable:
	dw	cfPanningAMSFMS
	dw	cfDetune
	dw	cfFadeInToPrevious
	dw	cfSilenceStopTrack
	dw	cfSetVolume
	dw	cfChangeVolume2
	dw	cfChangeVolume
	dw	cfPreventAttack
	dw	cfNoteFill
	dw	cfSpindashRev
	dw	cfPlayDACSample
	dw	cfConditionalJump
	dw	cfChangePSGVolume
	dw	cfSetKey
	dw	cfSendFMI
	dw	cfSetVoice
	dw	cfModulation
	dw	cfAlterModulation
	dw	cfStopTrack
	dw	cfSetPSGNoise
	dw	cfSetModulation
	dw	cfSetPSGVolEnv
	dw	cfJumpTo
	dw	cfRepeatAtPos
	dw	cfJumpToGosub
	dw	cfJumpReturn
	dw	cfDisableModulation
	dw	cfChangeTransposition
	dw	cfSpecialSFX
	dw	cfToggleAltFreqMode
	dw	cfFM3SpecialMode
	dw	cfMetaCF

zExtraCoordFlagSwitchTable:
	dw	cfSetTempo
	dw	cfPlaySoundByIndex
	dw	cfHaltSound
	dw	cfCopyData
	dw	cfSetTempoDivider
	dw	cfSetSSGEG
	dw	cfFMVolEnv

cfPlayDACSample:
    ld     (zDACIndex),a       ; 0009B6 32 06 1C
	ret

cfPanningAMSFMS:
    ld     c,$3f           ; 0009BA 0E 3F

zDoChangePan:
    ld     a,(ix+AMSFMSPan)      ; 0009BC DD 7E 0A
    and    c               ; 0009BF A1
    push   de              ; 0009C0 D5
    ex     de,hl           ; 0009C1 EB
    or     (hl)            ; 0009C2 B6
    ld     (ix+AMSFMSPan),a      ; 0009C3 DD 77 0A
    ld     c,a             ; 0009C6 4F
    ld     a,$b4           ; 0009C7 3E B4
	call	zWriteFMIorII
    pop    de              ; 0009CC D1
	ret

cfSpindashRev:
    ld     a,(ix+ModulationCtrl)      ; 0009CE DD 7E 07
    or     a               ; 0009D1 B7
    ret    z               ; 0009D2 C8
    set    7,(ix+ModulationCtrl)      ; 0009D3 DD CB 07 FE
    dec    de              ; 0009D7 1B
	ret

cfDetune:
    ld     (ix+Detune),a      ; 0009D9 DD 77 10
	ret

cfFadeInToPrevious:
    ld     (zFadeToPrevFlag),a       ; 0009DD 32 16 1C
	ret

cfSilenceStopTrack:
	call	zFMSilenceChannel
	jp	cfStopTrack

cfSetVolume:
    bit    7,(ix+VoiceControl)      ; 0009E7 DD CB 01 7E
	jr	z,@notPSG
    srl    a               ; 0009ED CB 3F
    srl    a               ; 0009EF CB 3F
    srl    a               ; 0009F1 CB 3F
    xor    $0f             ; 0009F3 EE 0F
    and    $0f             ; 0009F5 E6 0F
	jp	zStoreTrackVolume

@notPSG:
    xor    $7f             ; 0009FA EE 7F
    and    $7f             ; 0009FC E6 7F
    ld     (ix+Volume),a      ; 0009FE DD 77 06
	jr	zSendTL

cfChangeVolume2:
    inc    de              ; 000A03 13
    ld     a,(de)          ; 000A04 1A

cfChangeVolume:
    bit    7,(ix+VoiceControl)      ; 000A05 DD CB 01 7E
    ret    nz              ; 000A09 C0
    add    a,(ix+Volume)      ; 000A0A DD 86 06
	jp	p,@setVol
	jp	pe,@underflow
    xor    a               ; 000A13 AF
	jp	@setVol

@underflow:
    ld     a,$7f           ; 000A17 3E 7F

@setVol:
    ld     (ix+Volume),a      ; 000A19 DD 77 06

zSendTL:
    push   de              ; 000A1C D5
    ld     de,$03f3        ; 000A1D 11 F3 03
    ld     l,(ix+TLPtrLow)      ; 000A20 DD 6E 1C
    ld     h,(ix+TLPtrHigh)      ; 000A23 DD 66 1D
    ld     b,$04           ; 000A26 06 04

@loop:
    ld     a,(hl)          ; 000A28 7E
    or     a               ; 000A29 B7
	jp	p,@skipTrackVol
    add    a,(ix+Volume)      ; 000A2D DD 86 06

@skipTrackVol:
    and    $7f             ; 000A30 E6 7F
    ld     c,a             ; 000A32 4F
    ld     a,(de)          ; 000A33 1A
	call	zWriteFMIorII
    inc    de              ; 000A37 13
    inc    hl              ; 000A38 23
	djnz	@loop
    pop    de              ; 000A3B D1
    ret                    ; 000A3C C9

cfPreventAttack:
    set    1,(ix+PlaybackControl)      ; 000A3D DD CB 00 CE
    dec    de              ; 000A41 1B
	ret

cfNoteFill:
	call	zComputeNoteDuration
    ld     (ix+NoteFillTimeout),a      ; 000A46 DD 77 1E
    ld     (ix+NoteFillMaster),a      ; 000A49 DD 77 1F
	ret

cfConditionalJump:
    inc    de              ; 000A4D 13
    add    a,LoopCounters           ; 000A4E C6 28
    ld     c,a             ; 000A50 4F
    ld     b,$00           ; 000A51 06 00
    push   ix              ; 000A53 DD E5
    pop    hl              ; 000A55 E1
    add    hl,bc           ; 000A56 09
    ld     a,(hl)          ; 000A57 7E
    dec    a               ; 000A58 3D
	jp	z,@doJump
    inc    de              ; 000A5C 13
	ret

@doJump:
    xor    a               ; 000A5E AF
    ld     (hl),a          ; 000A5F 77
	jp	cfJumpTo

cfChangePSGVolume:
    bit    7,(ix+VoiceControl)      ; 000A63 DD CB 01 7E
    ret    z               ; 000A67 C8
    res    4,(ix+PlaybackControl)      ; 000A68 DD CB 00 A6
    dec    (ix+VolEnv)        ; 000A6C DD 35 17
    add    a,(ix+Volume)      ; 000A6F DD 86 06
    cp     $0f             ; 000A72 FE 0F
	jp	c,zStoreTrackVolume
    ld     a,$0f           ; 000A77 3E 0F

zStoreTrackVolume:
    ld     (ix+Volume),a      ; 000A79 DD 77 06
	ret

cfSetKey:
    sub    $40             ; 000A7D D6 40
    ld     (ix+Transpose),a      ; 000A7F DD 77 05
	ret

cfSendFMI:
	call	zGetFMParams
	call	zWriteFMI
	ret

zGetFMParams:
    ex     de,hl           ; 000A8A EB
    ld     a,(hl)          ; 000A8B 7E
    inc    hl              ; 000A8C 23
    ld     c,(hl)          ; 000A8D 4E
    ex     de,hl           ; 000A8E EB
	ret

cfSetVoice:
    bit    7,(ix+VoiceControl)      ; 000A90 DD CB 01 7E
	jr	nz,zSetVoicePSG
	call	zSetMaxRelRate
    ld     a,(de)          ; 000A99 1A
    ld     (ix+VoiceIndex),a      ; 000A9A DD 77 08
    or     a               ; 000A9D B7
	jp	p,zSetVoiceUpload
    inc    de              ; 000AA1 13
    ld     a,(de)          ; 000AA2 1A
    ld     (ix+VoiceSongID),a      ; 000AA3 DD 77 0F

zSetVoiceUploadAlter:
    push   de              ; 000AA6 D5
    ld     a,(ix+VoiceSongID)      ; 000AA7 DD 7E 0F
    sub    $81             ; 000AAA D6 81
    ld     c,$04           ; 000AAC 0E 04
	rst	zGetPointerTable
	rst	zPointerTableOffset
	rst	zReadPointer
    ld     a,(ix+VoiceIndex)      ; 000AB1 DD 7E 08
    and    $7f             ; 000AB4 E6 7F
    ld     b,a             ; 000AB6 47
	call	zGetFMInstrumentOffset
	jr	zSetVoiceDoUpload

zSetVoiceUpload:
    push   de              ; 000ABC D5
    ld     b,a             ; 000ABD 47
	call	zGetFMInstrumentPointer

zSetVoiceDoUpload:
	call	zSendFMInstrument
    pop    de              ; 000AC4 D1
	ret

zSetVoicePSG:
    or     a               ; 000AC6 B7
	jp	p,cfStoreNewVoice
    inc    de              ; 000ACA 13
	jp	cfStoreNewVoice
	ret

cfModulation:
    ld     (ix+ModulationPtrLow),e      ; 000ACF DD 73 20
    ld     (ix+ModulationPtrHigh),d      ; 000AD2 DD 72 21
    ld     (ix+ModulationCtrl),$80    ; 000AD5 DD 36 07 80
    inc    de              ; 000AD9 13
    inc    de              ; 000ADA 13
    inc    de              ; 000ADB 13
	ret

cfAlterModulation:
    inc    de              ; 000ADD 13
    bit    7,(ix+VoiceControl)      ; 000ADE DD CB 01 7E
	jr	nz,cfSetModulation
    ld     a,(de)          ; 000AE4 1A

cfSetModulation:
    inc    a               ; 000AE5 3C
    ld     (ix+ModulationCtrl),a      ; 000AE6 DD 77 07
	ret

cfStopTrack:
    res    7,(ix+PlaybackControl)      ; 000AEA DD CB 00 BE
    ld     a,$1f           ; 000AEE 3E 1F
    ld     (unk_1C15),a       ; 000AF0 32 15 1C
	call	zKeyOffIfActive
    ld     c,(ix+VoiceControl)      ; 000AF6 DD 4E 01
    push   ix              ; 000AF9 DD E5
	call	zGetSFXChannelPointers
    ld     a,(zUpdatingSFX)       ; 000AFE 3A 19 1C
    or     a               ; 000B01 B7
	jr	z,zStopCleanExit
    xor    a               ; 000B04 AF
    ld     (zSoundIndex),a       ; 000B05 32 18 1C
    push   hl              ; 000B08 E5
    ld     hl,(zVoiceTblPtr)      ; 000B09 2A 37 1C
    pop    ix              ; 000B0C DD E1
    res    2,(ix+PlaybackControl)      ; 000B0E DD CB 00 96
    bit    7,(ix+VoiceControl)      ; 000B12 DD CB 01 7E
	jr	nz,zStopPSGTrack
    bit    7,(ix+PlaybackControl)      ; 000B18 DD CB 00 7E
	jr	z,zStopCleanExit
    ld     a,$02           ; 000B1E 3E 02
    cp     (ix+VoiceControl)        ; 000B20 DD BE 01
	jr	nz,@notFM3
    ld     a,$4f           ; 000B25 3E 4F
    bit    0,(ix+PlaybackControl)      ; 000B27 DD CB 00 46
	jr	nz,@doFM3Settings
    and    $0f             ; 000B2D E6 0F

@doFM3Settings:
	call	zWriteFM3Settings

@notFM3:
    ld     a,(ix+VoiceIndex)      ; 000B32 DD 7E 08
    or     a               ; 000B35 B7
	jp	p,@switchToMusic
	call	zSetVoiceUploadAlter
	jr	@sendSSGEG

@switchToMusic:
    ld     b,a             ; 000B3E 47
    push   hl              ; 000B3F E5

	; music bankswitch
    ld     hl,zBankRegister        ; 000B40 21 00 60
    ld     a,(zSongBank)       ; 000B43 3A 04 1C
	bankswitchToMusic
    pop    hl              ; 000B55 E1
	call	zGetFMInstrumentOffset
	call	zSendFMInstrument
	; there SHOULD be a sound bankswitch here, but it's missing; this is
	; what causes all the sound glitches to happen
	;bankswitchToSFX
    ld     a,(ix+FMVolEnv)      ; 000B5C DD 7E 18
    or     a               ; 000B5F B7
	jp	p,zStopCleanExit
    ld     e,(ix+SSGEGPointerLow)      ; 000B63 DD 5E 19
    ld     d,(ix+SSGEGPointerHigh)      ; 000B66 DD 56 1A

@sendSSGEG:
	call	zSendSSGEGData

zStopCleanExit:
    pop    ix              ; 000B6C DD E1
    pop    hl              ; 000B6E E1
    pop    hl              ; 000B6F E1
	ret

zStopPSGTrack:
    bit    0,(ix+PlaybackControl)      ; 000B71 DD CB 00 46
	jr	z,zStopCleanExit
    ld     a,(ix+PSGNoise)      ; 000B77 DD 7E 1A
    or     a               ; 000B7A B7
	jp	p,@skipCommand
    ld     (zPSG),a       ; 000B7E 32 11 7F

@skipCommand:
	jr	zStopCleanExit

cfSetPSGNoise:
    bit    2,(ix+VoiceControl)      ; 000B83 DD CB 01 56
    ret    nz              ; 000B87 C0
    ld     a,$df           ; 000B88 3E DF
    ld     (zPSG),a       ; 000B8A 32 11 7F
    ld     a,(de)          ; 000B8D 1A
    ld     (ix+PSGNoise),a      ; 000B8E DD 77 1A
    set    0,(ix+PlaybackControl)      ; 000B91 DD CB 00 C6
    or     a               ; 000B95 B7
	jr	nz,@skipNoiseSilence
    res    0,(ix+PlaybackControl)      ; 000B98 DD CB 00 86
    ld     a,$ff           ; 000B9C 3E FF

@skipNoiseSilence:
    ld     (zPSG),a       ; 000B9E 32 11 7F
	ret

cfSetPSGVolEnv:
    bit    7,(ix+VoiceControl)      ; 000BA2 DD CB 01 7E
    ret    z               ; 000BA6 C8

cfStoreNewVoice:
    ld     (ix+VoiceIndex),a      ; 000BA7 DD 77 08
    ret                    ; 000BAA C9

cfJumpTo:
    ex     de,hl           ; 000BAB EB
    ld     e,(hl)          ; 000BAC 5E
    inc    hl              ; 000BAD 23
    ld     d,(hl)          ; 000BAE 56
    dec    de              ; 000BAF 1B
	ret

cfRepeatAtPos:
    inc    de              ; 000BB1 13
    add    a,LoopCounters           ; 000BB2 C6 28
    ld     c,a             ; 000BB4 4F
    ld     b,$00           ; 000BB5 06 00
    push   ix              ; 000BB7 DD E5
    pop    hl              ; 000BB9 E1
    add    hl,bc           ; 000BBA 09
    ld     a,(hl)          ; 000BBB 7E
    or     a               ; 000BBC B7
	jr	nz,@runCounter
    ld     a,(de)          ; 000BBF 1A
    ld     (hl),a          ; 000BC0 77

@runCounter:
    inc    de              ; 000BC1 13
    dec    (hl)            ; 000BC2 35
	jp	nz,cfJumpTo
    inc    de              ; 000BC6 13
	ret

cfJumpToGosub:
    ld     c,a             ; 000BC8 4F
    inc    de              ; 000BC9 13
    ld     a,(de)          ; 000BCA 1A
    ld     b,a             ; 000BCB 47
    push   bc              ; 000BCC C5
    push   ix              ; 000BCD DD E5
    pop    hl              ; 000BCF E1
    dec    (ix+StackPointer)        ; 000BD0 DD 35 09
    ld     c,(ix+StackPointer)      ; 000BD3 DD 4E 09
    dec    (ix+StackPointer)        ; 000BD6 DD 35 09
    ld     b,$00           ; 000BD9 06 00
    add    hl,bc           ; 000BDB 09
    ld     (hl),d          ; 000BDC 72
    dec    hl              ; 000BDD 2B
    ld     (hl),e          ; 000BDE 73
    pop    de              ; 000BDF D1
    dec    de              ; 000BE0 1B
	ret

cfJumpReturn:
    push   ix              ; 000BE2 DD E5
    pop    hl              ; 000BE4 E1
    ld     c,(ix+StackPointer)      ; 000BE5 DD 4E 09
    ld     b,$00           ; 000BE8 06 00
    add    hl,bc           ; 000BEA 09
    ld     e,(hl)          ; 000BEB 5E
    inc    hl              ; 000BEC 23
    ld     d,(hl)          ; 000BED 56
    inc    (ix+StackPointer)        ; 000BEE DD 34 09
    inc    (ix+StackPointer)        ; 000BF1 DD 34 09
	ret

cfDisableModulation:
    res    7,(ix+ModulationCtrl)      ; 000BF5 DD CB 07 BE
    dec    de              ; 000BF9 1B
	ret

cfChangeTransposition:
    add    a,(ix+Transpose)      ; 000BFB DD 86 05
    ld     (ix+Transpose),a      ; 000BFE DD 77 05
	ret

cfSpecialSFX:
	ret

cfToggleAltFreqMode:
    cp     $01             ; 000C03 FE 01
	jr	nz,@stopAltFreqMode
    set    3,(ix+PlaybackControl)      ; 000C07 DD CB 00 DE
	ret

@stopAltFreqMode:
    res    3,(ix+PlaybackControl)      ; 000C0C DD CB 00 9E
	ret

cfFM3SpecialMode:
    ld     a,(ix+VoiceControl)      ; 000C11 DD 7E 01
    cp     $02             ; 000C14 FE 02
	jr	nz,zTrackSkip3bytes
    set    0,(ix+PlaybackControl)      ; 000C18 DD CB 00 C6
    ex     de,hl           ; 000C1C EB
	call	zGetSpecialFM3DataPointer
    ld     b,$04           ; 000C20 06 04

@loop:
    push   bc              ; 000C22 C5
    ld     a,(hl)          ; 000C23 7E
    inc    hl              ; 000C24 23
    push   hl              ; 000C25 E5
	ld	hl,zFM3FreqShiftTable
    add    a,a             ; 000C29 87
    ld     c,a             ; 000C2A 4F
    ld     b,$00           ; 000C2B 06 00
    add    hl,bc           ; 000C2D 09
    ldi                    ; 000C2E ED A0
    ldi                    ; 000C30 ED A0
    pop    hl              ; 000C32 E1
    pop    bc              ; 000C33 C1
	djnz	@loop
    ex     de,hl           ; 000C36 EB
    dec    de              ; 000C37 1B
    ld     a,$4f           ; 000C38 3E 4F

zWriteFM3Settings:
    ld     (zFM3Settings),a       ; 000C3A 32 12 1C
    ld     c,a             ; 000C3D 4F
    ld     a,$27           ; 000C3E 3E 27
	call	zWriteFMI
	ret

zTrackSkip3bytes:
    inc    de              ; 000C44 13
    inc    de              ; 000C45 13
    inc    de              ; 000C46 13
	ret

zFM3FreqShiftTable:
	dw	$0000
	dw	$0132
	dw	$018E
	dw	$01E4
	dw	$0234
	dw	$027E
	dw	$02C2
	dw	$02F0

cfMetaCF:
	ld	hl,zExtraCoordFlagSwitchTable
	rst	zPointerTableOffset
    inc    de              ; 000C5C 13
    ld     a,(de)          ; 000C5D 1A
    jp     (hl)            ; 000C5E E9

cfSetTempo:
    ld     (zCurrentTempo),a       ; 000C5F 32 05 1C
	ret

cfPlaySoundByIndex:
    push   ix              ; 000C63 DD E5
	call	zPlaySoundByIndex
    pop    ix              ; 000C68 DD E1
	ret

cfHaltSound:
    ld     (zHaltFlag),a       ; 000C6B 32 11 1C
    or     a               ; 000C6E B7
	jr	z,@resume
    push   ix              ; 000C71 DD E5
    push   de              ; 000C73 D5
    ld     ix,zTracksStart        ; 000C74 DD 21 40 1C
    ld     b,(zTracksEnd-zTracksStart)/zTrack           ; 000C78 06 09
    ld     de,zTrack        ; 000C7A 11 30 00

@loop:
    res    7,(ix+PlaybackControl)      ; 000C7D DD CB 00 BE
	call	zKeyOff
    add    ix,de           ; 000C84 DD 19
	djnz	@loop
    pop    de              ; 000C88 D1
    pop    ix              ; 000C89 DD E1
	jp	zPSGSilenceAll

@resume:
    push   ix              ; 000C8E DD E5
    push   de              ; 000C90 D5
    ld     ix,zTracksStart        ; 000C91 DD 21 40 1C
    ld     b,(zTracksEnd-zTracksStart)/zTrack           ; 000C95 06 09
    ld     de,zTrack        ; 000C97 11 30 00

@loop2:
    set    7,(ix+PlaybackControl)      ; 000C9A DD CB 00 FE
    add    ix,de           ; 000C9E DD 19
	djnz	@loop2
    pop    de              ; 000CA2 D1
    pop    ix              ; 000CA3 DD E1
	ret

cfCopyData:
    ex     de,hl           ; 000CA6 EB
    ld     e,(hl)          ; 000CA7 5E
    inc    hl              ; 000CA8 23
    ld     d,(hl)          ; 000CA9 56
    inc    hl              ; 000CAA 23
    ld     c,(hl)          ; 000CAB 4E
    ld     b,$00           ; 000CAC 06 00
    inc    hl              ; 000CAE 23
    ex     de,hl           ; 000CAF EB
    ldir                   ; 000CB0 ED B0
    dec    de              ; 000CB2 1B
	ret

cfSetTempoDivider:
    ld     b,(zTracksEnd-zTracksStart)/zTrack           ; 000CB4 06 09
    ld     hl,zTracksStart+TempoDivider        ; 000CB6 21 42 1C

@loop:
    push   bc              ; 000CB9 C5
    ld     bc,zTrack        ; 000CBA 01 30 00
    ld     (hl),a          ; 000CBD 77
    add    hl,bc           ; 000CBE 09
    pop    bc              ; 000CBF C1
	djnz	@loop
	ret

cfSetSSGEG:
    ld     (ix+FMVolEnv),$80    ; 000CC3 DD 36 18 80
    ld     (ix+SSGEGPointerLow),e      ; 000CC7 DD 73 19
    ld     (ix+SSGEGPointerHigh),d      ; 000CCA DD 72 1A

zSendSSGEGData:
	ld	hl,zFMInstrumentSSGEGTable
	ld	b,zFMInstrumentSSGEGTable_End-zFMInstrumentSSGEGTable

@loop:
    ld     a,(de)          ; 000CD2 1A
    inc    de              ; 000CD3 13
    ld     c,a             ; 000CD4 4F
    ld     a,(hl)          ; 000CD5 7E
    inc    hl              ; 000CD6 23
	call	zWriteFMIorII
	djnz	@loop
    dec    de              ; 000CDC 1B
	ret

cfFMVolEnv:
    ld     (ix+FMVolEnv),a      ; 000CDE DD 77 18
    inc    de              ; 000CE1 13
    ld     a,(de)          ; 000CE2 1A
    ld     (ix+FMVolEnvMask),a      ; 000CE3 DD 77 19
    ret                    ; 000CE6 C9

zUpdatePSGTrack:
	call	zTrackRunTimer
	jr	nz,@noteGoing
	call	zGetNextNote
    bit    4,(ix+PlaybackControl)      ; 000CEF DD CB 00 66
    ret    nz              ; 000CF3 C0
	call	zPrepareModulation
	jr	@skipFill

@noteGoing:
    ld     a,(ix+NoteFillTimeout)      ; 000CF9 DD 7E 1E
    or     a               ; 000CFC B7
	jr	z,@skipFill
    dec    (ix+NoteFillTimeout)        ; 000CFF DD 35 1E
	jp	z,zRestTrack

@skipFill:
	call	zUpdateFreq
	call	zDoModulation
    bit    2,(ix+PlaybackControl)      ; 000D0B DD CB 00 56
    ret    nz              ; 000D0F C0
    ld     c,(ix+VoiceControl)      ; 000D10 DD 4E 01
    ld     a,l             ; 000D13 7D
    and    $0f             ; 000D14 E6 0F
    or     c               ; 000D16 B1
    ld     (zPSG),a       ; 000D17 32 11 7F
    ld     a,l             ; 000D1A 7D
    and    $f0             ; 000D1B E6 F0
    or     h               ; 000D1D B4
    rrca                   ; 000D1E 0F
    rrca                   ; 000D1F 0F
    rrca                   ; 000D20 0F
    rrca                   ; 000D21 0F
    ld     (zPSG),a       ; 000D22 32 11 7F
    ld     a,(ix+VoiceIndex)      ; 000D25 DD 7E 08
    or     a               ; 000D28 B7
    ld     c,$00           ; 000D29 0E 00
	jr	z,@noVolEnv
    dec    a               ; 000D2D 3D
    ld     c,$0a           ; 000D2E 0E 0A
	rst	zGetPointerTable
	rst	zPointerTableOffset
	call	zDoVolEnv
    ld     c,a             ; 000D35 4F

@noVolEnv:
    bit    4,(ix+PlaybackControl)      ; 000D36 DD CB 00 66
    ret    nz              ; 000D3A C0
    ld     a,(ix+Volume)      ; 000D3B DD 7E 06
    add    a,c             ; 000D3E 81
    bit    4,a             ; 000D3F CB 67
	jr	z,@noUnderflow
    ld     a,$0f           ; 000D43 3E 0F

@noUnderflow:
    or     (ix+VoiceControl)        ; 000D45 DD B6 01
    add    a,$10           ; 000D48 C6 10
    bit    0,(ix+PlaybackControl)      ; 000D4A DD CB 00 46
	jr	nz,@setNoise
    ld     (zPSG),a       ; 000D50 32 11 7F
	ret

@setNoise:
    add    a,$20           ; 000D54 C6 20
    ld     (zPSG),a       ; 000D56 32 11 7F
	ret

zDoVolEnvSetValue:
    ld     (ix+VolEnv),a      ; 000D5A DD 77 17

zDoVolEnv:
    push   hl              ; 000D5D E5
    ld     c,(ix+VolEnv)      ; 000D5E DD 4E 17
    ld     b,$00           ; 000D61 06 00
    add    hl,bc           ; 000D63 09
    ld     a,(hl)          ; 000D64 7E
    pop    hl              ; 000D65 E1
    bit    7,a             ; 000D66 CB 7F
	jr	z,zDoVolEnvAdvance
    cp     $83             ; 000D6A FE 83
	jr	z,zDoVolEnvFullRest
    cp     $81             ; 000D6E FE 81
	jr	z,zDoVolEnvRest
    cp     $80             ; 000D72 FE 80
	jr	z,zDoVolEnvReset
    inc    bc              ; 000D76 03
    ld     a,(bc)          ; 000D77 0A
	jr	zDoVolEnvSetValue

zDoVolEnvFullRest:
    set    4,(ix+PlaybackControl)      ; 000D7A DD CB 00 E6
    pop    hl              ; 000D7E E1
	jp	zRestTrack

zDoVolEnvReset:
    xor    a               ; 000D82 AF
	jr	zDoVolEnvSetValue

zDoVolEnvRest:
    pop    hl              ; 000D85 E1
    set    4,(ix+PlaybackControl)      ; 000D86 DD CB 00 E6
    ret                    ; 000D8A C9

zDoVolEnvAdvance:
    inc    (ix+VolEnv)        ; 000D8B DD 34 17
    ret                    ; 000D8E C9

zRestTrack:
    set    4,(ix+PlaybackControl)      ; 000D8F DD CB 00 E6
    bit    2,(ix+PlaybackControl)      ; 000D93 DD CB 00 56
    ret    nz              ; 000D97 C0

zSilencePSGChannel:
    ld     a,$1f           ; 000D98 3E 1F
    add    a,(ix+VoiceControl)      ; 000D9A DD 86 01
    or     a               ; 000D9D B7
    ret    p               ; 000D9E F0
    ld     (zPSG),a       ; 000D9F 32 11 7F
    bit    0,(ix+PlaybackControl)      ; 000DA2 DD CB 00 46
    ret    z               ; 000DA6 C8
    ld     a,$ff           ; 000DA7 3E FF
    ld     (zPSG),a       ; 000DA9 32 11 7F
    ret                    ; 000DAC C9

zPlayDigitalAudio:
    di                     ; 000DAD F3
    ld     a,$2b           ; 000DAE 3E 2B
    ld     c,$00           ; 000DB0 0E 00
	call	zWriteFMI

@DACIdleLoop:
    ei                     ; 000DB5 FB
    ld     a,(zPlaySegaPCMFlag)       ; 000DB6 3A 07 1C
    or     a               ; 000DB9 B7
	jp	nz,zPlaySEGAPCM
    ld     a,(zDACIndex)       ; 000DBD 3A 06 1C
    or     a               ; 000DC0 B7
	jr	z,@DACIdleLoop
    ld     a,$2b           ; 000DC3 3E 2B
    ld     c,$80           ; 000DC5 0E 80
    di                     ; 000DC7 F3
	call	zWriteFMI
    ei                     ; 000DCB FB
	ld	iy,DecTable
    ld     hl,zDACIndex        ; 000DD0 21 06 1C
    ld     a,(hl)          ; 000DD3 7E
    dec    a               ; 000DD4 3D
    set    7,(hl)          ; 000DD5 CB FE
    ld     hl,zROMWindow        ; 000DD7 21 00 80
	rst	zPointerTableOffset
    ld     c,$80           ; 000DDB 0E 80
    ld     a,(hl)          ; 000DDD 7E
	ld	(@sample1Rate+1),a
	ld	(@sample2Rate+1),a
    inc    hl              ; 000DE4 23
    ld     e,(hl)          ; 000DE5 5E
    inc    hl              ; 000DE6 23
    ld     d,(hl)          ; 000DE7 56
    inc    hl              ; 000DE8 23
    ld     a,(hl)          ; 000DE9 7E
    inc    hl              ; 000DEA 23
    ld     h,(hl)          ; 000DEB 66
    ld     l,a             ; 000DEC 6F

@DACPlaybackLoop:
@sample1Rate:
    ld     b,$0a           ; 000DED 06 0A
    ei                     ; 000DEF FB
	djnz	*
    di                     ; 000DF2 F3
    ld     a,$2a           ; 000DF3 3E 2A
    ld     (zYM2612_A0),a       ; 000DF5 32 00 40
    ld     a,(hl)          ; 000DF8 7E
    rlca                   ; 000DF9 07
    rlca                   ; 000DFA 07
    rlca                   ; 000DFB 07
    rlca                   ; 000DFC 07
    and    $0f             ; 000DFD E6 0F
	ld	(@sample1Index+2),a
    ld     a,c             ; 000E02 79

@sample1Index:
    add    a,(iy+PlaybackControl)      ; 000E03 FD 86 00
    ld     (zYM2612_D0),a       ; 000E06 32 01 40
    ld     c,a             ; 000E09 4F

@sample2Rate:
    ld     b,$0a           ; 000E0A 06 0A
    ei                     ; 000E0C FB
	djnz	*
    di                     ; 000E0F F3
    ld     a,$2a           ; 000E10 3E 2A
    ld     (zYM2612_A0),a       ; 000E12 32 00 40
    ld     a,(hl)          ; 000E15 7E
    and    $0f             ; 000E16 E6 0F
	ld	(@sample2Index+2),a
    ld     a,c             ; 000E1B 79

@sample2Index:
    add    a,(iy+PlaybackControl)      ; 000E1C FD 86 00
    ld     (zYM2612_D0),a       ; 000E1F 32 01 40
    ei                     ; 000E22 FB
    ld     c,a             ; 000E23 4F
    ld     a,(zDACIndex)       ; 000E24 3A 06 1C
    or     a               ; 000E27 B7
	jp	p,@DACIdleLoop
    inc    hl              ; 000E2B 23
    dec    de              ; 000E2C 1B
    ld     a,d             ; 000E2D 7A
    or     e               ; 000E2E B3
	jp	nz,@DACPlaybackLoop
    xor    a               ; 000E32 AF
    ld     (zDACIndex),a       ; 000E33 32 06 1C
	jp	zPlayDigitalAudio

DecTable:
	db	$00
	db	$01
	db	$02
	db	$04
	db	$08
	db	$10
	db	$20
	db	$40
	db	$80
	db	-$01
	db	-$02
	db	-$04
	db	-$08
	db	-$10
	db	-$20
	db	-$40

zPlaySEGAPCM:
    di                     ; 000E49 F3
    ld     a,$2b           ; 000E4A 3E 2B
    ld     (zYM2612_A0),a       ; 000E4C 32 00 40
    nop                    ; 000E4F 00
    ld     a,$80           ; 000E50 3E 80
    ld     (zYM2612_D0),a       ; 000E52 32 01 40

	; Sega PCM bankswitch
    ld     hl,zBankRegister        ; 000E55 21 00 60
    xor    a               ; 000E58 AF
    ld     e,$01           ; 000E59 1E 01
    ld     (hl),e          ; 000E5B 73
    ld     (hl),e          ; 000E5C 73
    ld     (hl),e          ; 000E5D 73
    ld     (hl),e          ; 000E5E 73
    ld     (hl),e          ; 000E5F 73
    ld     (hl),a          ; 000E60 77
    ld     (hl),a          ; 000E61 77
    ld     (hl),a          ; 000E62 77
    ld     (hl),a          ; 000E63 77
    ld     hl,zROMWindow        ; 000E64 21 00 80
    ld     de,$6caa        ; 000E67 11 AA 6C
    ld     a,$2a           ; 000E6A 3E 2A
    ld     (zYM2612_A0),a       ; 000E6C 32 00 40

@loop:
    ld     a,(hl)          ; 000E6F 7E
    ld     (zYM2612_D0),a       ; 000E70 32 01 40
    ld     b,$0d           ; 000E73 06 0D
	djnz	*
    inc    hl              ; 000E77 23
    dec    de              ; 000E78 1B
    ld     a,d             ; 000E79 7A
    or     e               ; 000E7A B3
	jp	nz,@loop
    xor    a               ; 000E7E AF
    ld     (zPlaySegaPCMFlag),a       ; 000E7F 32 07 1C
	call	zStopAllSound
	jp	zPlayDigitalAudio
EndOf_SoundDriver:

	if *>Size_of_SoundDriver_Guess
		inform 3,"Size_of_SoundDriver_Guess is too small by $%h bytes.",*-Size_of_SoundDriver_Guess
	else
		inform 0,"Z80 sound driver has $%h bytes free at the end.",*>Size_of_SoundDriver_Guess
	endc

; end of code!
    rst    28h             ; 000E88 EF
    inc    d               ; 000E89 14
    adc    a,e             ; 000E8A 8B
    inc    sp              ; 000E8B 33
    jp     nz,$d4d3        ; 000E8C C2 D3 D4
    push   de              ; 000E8F D5
    add    a,h             ; 000E90 84
    sub    $c1             ; 000E91 D6 C1
    add    a,b             ; 000E93 80
    add    a,a             ; 000E94 87
    add    a,b             ; 000E95 80
    adc    a,a             ; 000E96 8F
    add    a,$a0           ; 000E97 C6 A0
    and    e               ; 000E99 A3
    and    l               ; 000E9A A5
    and    a               ; 000E9B A7
    xor    c               ; 000E9C A9
    xor    e               ; 000E9D AB
    xor    l               ; 000E9E AD
    adc    a,c             ; 000E9F 89
    xor    a               ; 000EA0 AF
    pop    bc              ; 000EA1 C1
    out    ($d4),a         ; 000EA2 D3 D4
    add    a,b             ; 000EA4 80
    push   de              ; 000EA5 D5
    add    a,h             ; 000EA6 84
    sub    $c9             ; 000EA7 D6 C9
    add    a,b             ; 000EA9 80
    add    a,a             ; 000EAA 87
    sub    b               ; 000EAB 90
    sbc    a,c             ; 000EAC 99
    adc    a,a             ; 000EAD 8F
    and    h               ; 000EAE A4
    and    (hl)            ; 000EAF A6
    xor    b               ; 000EB0 A8
    xor    d               ; 000EB1 AA
    xor    h               ; 000EB2 AC
    add    a,d             ; 000EB3 82
    xor    (hl)            ; 000EB4 AE
    ret                    ; 000EB5 C9
    or     b               ; 000EB6 B0
    or     c               ; 000EB7 B1
    or     d               ; 000EB8 B2
    or     e               ; 000EB9 B3
    or     l               ; 000EBA B5
    or     a               ; 000EBB B7
    ret    nz              ; 000EBC C0
    call   z,$d4d3         ; 000EBD CC D3 D4
    add    a,b             ; 000EC0 80
    push   de              ; 000EC1 D5
    add    a,h             ; 000EC2 84
    sub    $c4             ; 000EC3 D6 C4
    add    a,b             ; 000EC5 80
    add    a,a             ; 000EC6 87
    sub    c               ; 000EC7 91
    sbc    a,d             ; 000EC8 9A
    and    c               ; 000EC9 A1
    adc    a,d             ; 000ECA 8A
    and    d               ; 000ECB A2
    add    a,$b4           ; 000ECC C6 B4
    or     (hl)            ; 000ECE B6
    cp     b               ; 000ECF B8
    pop    bc              ; 000ED0 C1
    call   $d4d3           ; 000ED1 CD D3 D4
    add    a,b             ; 000ED4 80
    push   de              ; 000ED5 D5
    add    a,h             ; 000ED6 84
    sub    $c3             ; 000ED7 D6 C3
    add    a,b             ; 000ED9 80
    adc    a,b             ; 000EDA 88
    sub    d               ; 000EDB 92
    sbc    a,d             ; 000EDC 9A
    adc    a,l             ; 000EDD 8D
    and    d               ; 000EDE A2
    call   nz,$c2b9        ; 000EDF C4 B9 C2
    adc    a,$d3           ; 000EE2 CE D3
    call   nc,$d580        ; 000EE4 D4 80 D5
    add    a,h             ; 000EE7 84
    sub    $c3             ; 000EE8 D6 C3
    add    a,c             ; 000EEA 81
    adc    a,c             ; 000EEB 89
    sub    e               ; 000EEC 93
    sbc    a,e             ; 000EED 9B
    adc    a,l             ; 000EEE 8D
    and    d               ; 000EEF A2
    ret    nz              ; 000EF0 C0
    cp     d               ; 000EF1 BA
    add    a,b             ; 000EF2 80
    jp     $d3c1           ; 000EF3 C3 C1 D3
    call   nc,$d580        ; 000EF6 D4 80 D5
    add    a,h             ; 000EF9 84
    sub    $c3             ; 000EFA D6 C3
    add    a,c             ; 000EFC 81
    adc    a,c             ; 000EFD 89
    sub    h               ; 000EFE 94
    sbc    a,h             ; 000EFF 9C
    adc    a,(hl)          ; 000F00 8E
    and    d               ; 000F01 A2
    jp     $c4c3           ; 000F02 C3 C3 C4
    out    ($d4),a         ; 000F05 D3 D4
    add    a,b             ; 000F07 80
    push   de              ; 000F08 D5
    add    a,h             ; 000F09 84
    sub    $c3             ; 000F0A D6 C3
    add    a,c             ; 000F0C 81
    adc    a,c             ; 000F0D 89
    sub    l               ; 000F0E 95
    sbc    a,l             ; 000F0F 9D
    adc    a,(hl)          ; 000F10 8E
    and    d               ; 000F11 A2
    add    a,b             ; 000F12 80
    call   nz,$d3c1        ; 000F13 C4 C1 D3
    call   nc,$d580        ; 000F16 D4 80 D5
    add    a,h             ; 000F19 84
    sub    $c3             ; 000F1A D6 C3
    add    a,c             ; 000F1C 81
    adc    a,c             ; 000F1D 89
    sub    (hl)            ; 000F1E 96
    sbc    a,(hl)          ; 000F1F 9E
    adc    a,(hl)          ; 000F20 8E
    and    d               ; 000F21 A2
    add    a,b             ; 000F22 80
    call   nz,$d3c1        ; 000F23 C4 C1 D3
    call   nc,$d580        ; 000F26 D4 80 D5
    add    a,h             ; 000F29 84
    sub    $c3             ; 000F2A D6 C3
    add    a,c             ; 000F2C 81
    adc    a,c             ; 000F2D 89
    sub    a               ; 000F2E 97
    sbc    a,(hl)          ; 000F2F 9E
    adc    a,l             ; 000F30 8D
    and    d               ; 000F31 A2
    call   nz,$c5bb        ; 000F32 C4 BB C5
    call   nz,$d4d3        ; 000F35 C4 D3 D4
    add    a,b             ; 000F38 80
    push   de              ; 000F39 D5
    add    a,h             ; 000F3A 84
    sub    $c3             ; 000F3B D6 C3
    add    a,c             ; 000F3D 81
    adc    a,c             ; 000F3E 89
    sbc    a,b             ; 000F3F 98
    sbc    a,a             ; 000F40 9F
    adc    a,l             ; 000F41 8D
    and    d               ; 000F42 A2
    call   nz,$c6bb        ; 000F43 C4 BB C6
    rst    08h             ; 000F46 CF
    out    ($d4),a         ; 000F47 D3 D4
    add    a,b             ; 000F49 80
    push   de              ; 000F4A D5
    add    a,h             ; 000F4B 84
    sub    $c3             ; 000F4C D6 C3
    add    a,c             ; 000F4E 81
    adc    a,c             ; 000F4F 89
    sbc    a,b             ; 000F50 98
    sbc    a,a             ; 000F51 9F
    adc    a,l             ; 000F52 8D
    and    d               ; 000F53 A2
    call   nz,$c7bb        ; 000F54 C4 BB C7
    ret    nc              ; 000F57 D0
    out    ($d4),a         ; 000F58 D3 D4
    add    a,b             ; 000F5A 80
    push   de              ; 000F5B D5
    add    a,h             ; 000F5C 84
    sub    $c3             ; 000F5D D6 C3
    add    a,d             ; 000F5F 82
    adc    a,c             ; 000F60 89
    sbc    a,b             ; 000F61 98
    sbc    a,a             ; 000F62 9F
    adc    a,l             ; 000F63 8D
    and    d               ; 000F64 A2
    call   nz,$c8bb        ; 000F65 C4 BB C8
    ret    nc              ; 000F68 D0
    out    ($d4),a         ; 000F69 D3 D4
    add    a,b             ; 000F6B 80
    push   de              ; 000F6C D5
    add    a,h             ; 000F6D 84
    sub    $c3             ; 000F6E D6 C3
    add    a,e             ; 000F70 83
    adc    a,d             ; 000F71 8A
    sbc    a,b             ; 000F72 98
    sbc    a,a             ; 000F73 9F
    adc    a,l             ; 000F74 8D
    and    d               ; 000F75 A2
    call   nz,$c9bc        ; 000F76 C4 BC C9
    pop    de              ; 000F79 D1
    out    ($d4),a         ; 000F7A D3 D4
    add    a,b             ; 000F7C 80
    push   de              ; 000F7D D5
    add    a,h             ; 000F7E 84
    sub    $c3             ; 000F7F D6 C3
    add    a,h             ; 000F81 84
    adc    a,e             ; 000F82 8B
    sbc    a,b             ; 000F83 98
    sbc    a,a             ; 000F84 9F
    adc    a,l             ; 000F85 8D
    and    d               ; 000F86 A2
    call   nz,$c7bd        ; 000F87 C4 BD C7
    jp     nc,$d4d3        ; 000F8A D2 D3 D4
    add    a,b             ; 000F8D 80
    push   de              ; 000F8E D5
    add    a,h             ; 000F8F 84
    sub    $c3             ; 000F90 D6 C3
    add    a,l             ; 000F92 85
    adc    a,h             ; 000F93 8C
    sbc    a,b             ; 000F94 98
    sbc    a,a             ; 000F95 9F
    adc    a,l             ; 000F96 8D
    and    d               ; 000F97 A2
    call   nz,$cabe        ; 000F98 C4 BE CA
    jp     nc,$d4d3        ; 000F9B D2 D3 D4
    add    a,b             ; 000F9E 80
    push   de              ; 000F9F D5
    add    a,h             ; 000FA0 84
    sub    $c3             ; 000FA1 D6 C3
    add    a,(hl)          ; 000FA3 86
    adc    a,l             ; 000FA4 8D
    sbc    a,b             ; 000FA5 98
    sbc    a,a             ; 000FA6 9F
    adc    a,l             ; 000FA7 8D
    and    d               ; 000FA8 A2
    call   nz,$cbbe        ; 000FA9 C4 BE CB
    jp     nc,$d4d3        ; 000FAC D2 D3 D4
    add    a,b             ; 000FAF 80
    push   de              ; 000FB0 D5
    add    a,h             ; 000FB1 84
    sub    $c3             ; 000FB2 D6 C3
    add    a,(hl)          ; 000FB4 86
    adc    a,(hl)          ; 000FB5 8E
    sbc    a,b             ; 000FB6 98
    sbc    a,a             ; 000FB7 9F
    adc    a,l             ; 000FB8 8D
    and    d               ; 000FB9 A2
    call   nz,$c7bf        ; 000FBA C4 BF C7
    jp     nc,$d4d3        ; 000FBD D2 D3 D4
    add    a,b             ; 000FC0 80
    push   de              ; 000FC1 D5
    add    a,h             ; 000FC2 84
    sub    $c3             ; 000FC3 D6 C3
    add    a,(hl)          ; 000FC5 86
    adc    a,l             ; 000FC6 8D
    sbc    a,b             ; 000FC7 98
    sbc    a,a             ; 000FC8 9F
    adc    a,l             ; 000FC9 8D
    and    d               ; 000FCA A2
    call   nz,$cbbe        ; 000FCB C4 BE CB
    jp     nc,$d4d3        ; 000FCE D2 D3 D4
    add    a,b             ; 000FD1 80
    push   de              ; 000FD2 D5
    add    a,h             ; 000FD3 84
    sub    $c3             ; 000FD4 D6 C3
    add    a,l             ; 000FD6 85
    adc    a,h             ; 000FD7 8C
    sbc    a,b             ; 000FD8 98
    sbc    a,a             ; 000FD9 9F
    adc    a,l             ; 000FDA 8D
    and    d               ; 000FDB A2
    call   nz,$cabe        ; 000FDC C4 BE CA
    jp     nc,$d4d3        ; 000FDF D2 D3 D4
    add    a,b             ; 000FE2 80
    push   de              ; 000FE3 D5
    add    a,h             ; 000FE4 84
    sub    $c3             ; 000FE5 D6 C3
    add    a,h             ; 000FE7 84
    adc    a,e             ; 000FE8 8B
    sbc    a,b             ; 000FE9 98
    sbc    a,a             ; 000FEA 9F
    adc    a,l             ; 000FEB 8D
    and    d               ; 000FEC A2
    call   nz,$c7bd        ; 000FED C4 BD C7
    jp     nc,$d4d3        ; 000FF0 D2 D3 D4
    add    a,b             ; 000FF3 80
    push   de              ; 000FF4 D5
    add    a,h             ; 000FF5 84
    sub    $c3             ; 000FF6 D6 C3
    add    a,e             ; 000FF8 83
    adc    a,d             ; 000FF9 8A
    sbc    a,b             ; 000FFA 98
    sbc    a,a             ; 000FFB 9F
    adc    a,l             ; 000FFC 8D
    and    d               ; 000FFD A2
    call   nz,$c9bc        ; 000FFE C4 BC C9
    pop    de              ; 001001 D1
    out    ($d4),a         ; 001002 D3 D4
    add    a,b             ; 001004 80
    push   de              ; 001005 D5
    add    a,h             ; 001006 84
    sub    $c3             ; 001007 D6 C3
    add    a,d             ; 001009 82
    adc    a,c             ; 00100A 89
    sbc    a,b             ; 00100B 98
    sbc    a,a             ; 00100C 9F
    adc    a,l             ; 00100D 8D
    and    d               ; 00100E A2
    call   nz,$c8bb        ; 00100F C4 BB C8
    ret    nc              ; 001012 D0
    out    ($d4),a         ; 001013 D3 D4
    add    a,b             ; 001015 80
    push   de              ; 001016 D5
    add    a,h             ; 001017 84
    sub    $c3             ; 001018 D6 C3
    add    a,c             ; 00101A 81
    adc    a,c             ; 00101B 89
    sbc    a,b             ; 00101C 98
    sbc    a,a             ; 00101D 9F
    adc    a,l             ; 00101E 8D
    and    d               ; 00101F A2
    call   nz,$c7bb        ; 001020 C4 BB C7
    ret    nc              ; 001023 D0
    out    ($d4),a         ; 001024 D3 D4
    add    a,b             ; 001026 80
    push   de              ; 001027 D5
    add    a,h             ; 001028 84
    sub    $c3             ; 001029 D6 C3
    add    a,c             ; 00102B 81
    adc    a,c             ; 00102C 89
    sbc    a,b             ; 00102D 98
    sbc    a,a             ; 00102E 9F
    adc    a,l             ; 00102F 8D
    and    d               ; 001030 A2
    call   nz,$c6bb        ; 001031 C4 BB C6
    rst    08h             ; 001034 CF
    out    ($d4),a         ; 001035 D3 D4
    add    a,b             ; 001037 80
    push   de              ; 001038 D5
    add    a,h             ; 001039 84
    sub    $c3             ; 00103A D6 C3
    add    a,c             ; 00103C 81
    adc    a,c             ; 00103D 89
    sub    a               ; 00103E 97
    sbc    a,(hl)          ; 00103F 9E
    adc    a,l             ; 001040 8D
    and    d               ; 001041 A2
    call   nz,$c5bb        ; 001042 C4 BB C5
    call   nz,$d4d3        ; 001045 C4 D3 D4
    add    a,b             ; 001048 80
    push   de              ; 001049 D5
    add    a,h             ; 00104A 84
    sub    $c3             ; 00104B D6 C3
    add    a,c             ; 00104D 81
    adc    a,c             ; 00104E 89
    sub    (hl)            ; 00104F 96
    sbc    a,(hl)          ; 001050 9E
    adc    a,(hl)          ; 001051 8E
    and    d               ; 001052 A2
    add    a,b             ; 001053 80
    call   nz,$d3c1        ; 001054 C4 C1 D3
    call   nc,$d580        ; 001057 D4 80 D5
    add    a,h             ; 00105A 84
    sub    $c3             ; 00105B D6 C3
    add    a,c             ; 00105D 81
    adc    a,c             ; 00105E 89
    sub    l               ; 00105F 95
    sbc    a,l             ; 001060 9D
    adc    a,(hl)          ; 001061 8E
    and    d               ; 001062 A2
    add    a,b             ; 001063 80
    call   nz,$d3c1        ; 001064 C4 C1 D3
    call   nc,$d580        ; 001067 D4 80 D5
    add    a,h             ; 00106A 84
    sub    $c3             ; 00106B D6 C3
    add    a,c             ; 00106D 81
    adc    a,c             ; 00106E 89
    sub    h               ; 00106F 94
    sbc    a,h             ; 001070 9C
    adc    a,(hl)          ; 001071 8E
    and    d               ; 001072 A2
    jp     $c4c3           ; 001073 C3 C3 C4
    out    ($d4),a         ; 001076 D3 D4
    add    a,b             ; 001078 80
    push   de              ; 001079 D5
    add    a,h             ; 00107A 84
    sub    $c3             ; 00107B D6 C3
    add    a,c             ; 00107D 81
    adc    a,c             ; 00107E 89
    sub    e               ; 00107F 93
    sbc    a,e             ; 001080 9B
    adc    a,l             ; 001081 8D
    and    d               ; 001082 A2
    ret    nz              ; 001083 C0
    cp     d               ; 001084 BA
    add    a,b             ; 001085 80
    jp     $d3c1           ; 001086 C3 C1 D3
    call   nc,$d580        ; 001089 D4 80 D5
    add    a,h             ; 00108C 84
    sub    $c3             ; 00108D D6 C3
    add    a,b             ; 00108F 80
    adc    a,b             ; 001090 88
    sub    d               ; 001091 92
    sbc    a,d             ; 001092 9A
    adc    a,l             ; 001093 8D
    and    d               ; 001094 A2
    call   nz,$c2b9        ; 001095 C4 B9 C2
    adc    a,$d3           ; 001098 CE D3
    call   nc,$d580        ; 00109A D4 80 D5
    add    a,h             ; 00109D 84
    sub    $c4             ; 00109E D6 C4
    add    a,b             ; 0010A0 80
    add    a,a             ; 0010A1 87
    sub    c               ; 0010A2 91
    sbc    a,d             ; 0010A3 9A
    and    c               ; 0010A4 A1
    adc    a,d             ; 0010A5 8A
    and    d               ; 0010A6 A2
    add    a,$b4           ; 0010A7 C6 B4
    or     (hl)            ; 0010A9 B6
    cp     b               ; 0010AA B8
    pop    bc              ; 0010AB C1
    call   $d4d3           ; 0010AC CD D3 D4
    add    a,b             ; 0010AF 80
    push   de              ; 0010B0 D5
    add    a,h             ; 0010B1 84
    sub    $c9             ; 0010B2 D6 C9
    add    a,b             ; 0010B4 80
    add    a,a             ; 0010B5 87
    sub    b               ; 0010B6 90
    sbc    a,c             ; 0010B7 99
    adc    a,a             ; 0010B8 8F
    and    h               ; 0010B9 A4
    and    (hl)            ; 0010BA A6
    xor    b               ; 0010BB A8
    xor    d               ; 0010BC AA
    xor    h               ; 0010BD AC
    add    a,d             ; 0010BE 82
    xor    (hl)            ; 0010BF AE
    ret                    ; 0010C0 C9
    or     b               ; 0010C1 B0
    or     c               ; 0010C2 B1
    or     d               ; 0010C3 B2
    or     e               ; 0010C4 B3
    or     l               ; 0010C5 B5
    or     a               ; 0010C6 B7
    ret    nz              ; 0010C7 C0
    call   z,$d4d3         ; 0010C8 CC D3 D4
    add    a,b             ; 0010CB 80
    push   de              ; 0010CC D5
    add    a,h             ; 0010CD 84
    sub    $c1             ; 0010CE D6 C1
    add    a,b             ; 0010D0 80
    add    a,a             ; 0010D1 87
    add    a,b             ; 0010D2 80
    adc    a,a             ; 0010D3 8F
    add    a,$a0           ; 0010D4 C6 A0
    and    e               ; 0010D6 A3
    and    l               ; 0010D7 A5
    and    a               ; 0010D8 A7
    xor    c               ; 0010D9 A9
    xor    e               ; 0010DA AB
    xor    l               ; 0010DB AD
    adc    a,c             ; 0010DC 89
    xor    a               ; 0010DD AF
    pop    bc              ; 0010DE C1
    out    ($d4),a         ; 0010DF D3 D4
    add    a,b             ; 0010E1 80
    push   de              ; 0010E2 D5
    add    a,h             ; 0010E3 84
    sub    $c9             ; 0010E4 D6 C9
    add    a,b             ; 0010E6 80
    add    a,a             ; 0010E7 87
    adc    a,a             ; 0010E8 8F
    ld     l,b             ; 0010E9 68
    add    a,b             ; 0010EA 80
    adc    a,d             ; 0010EB 8A
    sub    a               ; 0010EC 97
    jp     $14ef           ; 0010ED C3 EF 14
    adc    a,e             ; 0010F0 8B
    inc    sp              ; 0010F1 33
    jp     nz,$d4d3        ; 0010F2 C2 D3 D4
    push   de              ; 0010F5 D5
    add    a,h             ; 0010F6 84
    sub    $c9             ; 0010F7 D6 C9
    add    a,b             ; 0010F9 80
    add    a,a             ; 0010FA 87
    adc    a,a             ; 0010FB 8F
    ld     l,b             ; 0010FC 68
    add    a,b             ; 0010FD 80
    adc    a,d             ; 0010FE 8A
    sub    a               ; 0010FF 97
    jp     $14ef           ; 001100 C3 EF 14
    adc    a,e             ; 001103 8B
    inc    sp              ; 001104 33
    jp     nz,$d4d3        ; 001105 C2 D3 D4
    push   de              ; 001108 D5
    add    a,h             ; 001109 84
    sub    $c9             ; 00110A D6 C9
    add    a,b             ; 00110C 80
    add    a,a             ; 00110D 87
    adc    a,a             ; 00110E 8F
    ld     l,b             ; 00110F 68
    add    a,b             ; 001110 80
    adc    a,d             ; 001111 8A
    sub    a               ; 001112 97
    jp     $14ef           ; 001113 C3 EF 14
    adc    a,e             ; 001116 8B
    inc    sp              ; 001117 33
    jp     nz,$d4d3        ; 001118 C2 D3 D4
    push   de              ; 00111B D5
    add    a,h             ; 00111C 84
    sub    $c9             ; 00111D D6 C9
    add    a,b             ; 00111F 80
    add    a,a             ; 001120 87
    adc    a,a             ; 001121 8F
    ld     l,b             ; 001122 68
    add    a,b             ; 001123 80
    adc    a,d             ; 001124 8A
    sub    a               ; 001125 97
    jp     $14ef           ; 001126 C3 EF 14
    adc    a,e             ; 001129 8B
    inc    sp              ; 00112A 33
    jp     nz,$d4d3        ; 00112B C2 D3 D4
    push   de              ; 00112E D5
    add    a,h             ; 00112F 84
    sub    $c1             ; 001130 D6 C1
    add    a,b             ; 001132 80
    add    a,a             ; 001133 87
    add    a,b             ; 001134 80
    adc    a,a             ; 001135 8F
    add    a,$a0           ; 001136 C6 A0
    and    e               ; 001138 A3
    and    l               ; 001139 A5
    and    a               ; 00113A A7
    xor    c               ; 00113B A9
    xor    e               ; 00113C AB
    xor    l               ; 00113D AD
    adc    a,c             ; 00113E 89
    xor    a               ; 00113F AF
    pop    bc              ; 001140 C1
    out    ($d4),a         ; 001141 D3 D4
    add    a,b             ; 001143 80
    push   de              ; 001144 D5
    add    a,h             ; 001145 84
    sub    $c1             ; 001146 D6 C1
    add    a,b             ; 001148 80
    add    a,a             ; 001149 87
    add    a,b             ; 00114A 80
    adc    a,a             ; 00114B 8F
    ret    nz              ; 00114C C0
    ld     a,(hl)          ; 00114D 7E
    add    a,b             ; 00114E 80
    ld     (hl),h          ; 00114F 74
    rst    08h             ; 001150 CF
    cp     a               ; 001151 BF
    halt                   ; 001152 76
    ld     a,b             ; 001153 78
    xor    d               ; 001154 AA
    inc    a               ; 001155 3C
    ld     l,l             ; 001156 6D
    ld     a,(hl)          ; 001157 7E
    sbc    a,d             ; 001158 9A
    ld     (hl),d          ; 001159 72
    and    (hl)            ; 00115A A6
    cp     h               ; 00115B BC
    rst    00h             ; 00115C C7
    ret    nc              ; 00115D D0
    push   de              ; 00115E D5
    out    ($d4),a         ; 00115F D3 D4
    add    a,c             ; 001161 81
    push   de              ; 001162 D5
    add    a,h             ; 001163 84
    sub    $c1             ; 001164 D6 C1
    add    a,b             ; 001166 80
    add    a,a             ; 001167 87
    add    a,b             ; 001168 80
    adc    a,a             ; 001169 8F
    add    a,c             ; 00116A 81
    ld     (hl),h          ; 00116B 74
    jp     nc,$d3c0        ; 00116C D2 C0 D3
    ld     l,d             ; 00116F 6A
    dec    de              ; 001170 1B
    dec    a               ; 001171 3D
    ld     l,(hl)          ; 001172 6E
    ld     a,a             ; 001173 7F
    sbc    a,e             ; 001174 9B
    ld     (hl),e          ; 001175 73
    and    a               ; 001176 A7
    ret    nc              ; 001177 D0
    ret    m               ; 001178 F8
    ld     l,$d5           ; 001179 2E D5
    out    ($d4),a         ; 00117B D3 D4
    push   de              ; 00117D D5
    db     $dd             ; 00117E DD
    ret    po              ; 00117F E0
    add    a,h             ; 001180 84
    sub    $c1             ; 001181 D6 C1
    add    a,b             ; 001183 80
    add    a,a             ; 001184 87
    add    a,b             ; 001185 80
    adc    a,a             ; 001186 8F
    add    a,b             ; 001187 80
    ld     (hl),h          ; 001188 74
    jp     nc,$c175        ; 001189 D2 75 C1
    call   nc,$1cfb        ; 00118C D4 FB 1C
    ld     a,$6f           ; 00118F 3E 6F
    add    a,b             ; 001191 80
    sbc    a,h             ; 001192 9C
    add    a,l             ; 001193 85
    xor    b               ; 001194 A8
    pop    de              ; 001195 D1
    ld     sp,hl           ; 001196 F9
    cpl                    ; 001197 2F
    push   de              ; 001198 D5
    out    ($d4),a         ; 001199 D3 D4
    push   de              ; 00119B D5
    sbc    a,$85           ; 00119C DE 85
    sub    $c1             ; 00119E D6 C1
    add    a,b             ; 0011A0 80
    add    a,a             ; 0011A1 87
    add    a,b             ; 0011A2 80
    adc    a,a             ; 0011A3 8F
    call   nc,$7574        ; 0011A4 D4 74 75
    halt                   ; 0011A7 76
    jp     nz,$11ed        ; 0011A8 C2 ED 11
    dec    hl              ; 0011AB 2B
    ld     c,e             ; 0011AC 4B
    ld     (hl),e          ; 0011AD 73
    adc    a,(hl)          ; 0011AE 8E
    and    e               ; 0011AF A3
    xor    l               ; 0011B0 AD
    or     (hl)            ; 0011B1 B6
    ret    nz              ; 0011B2 C0
    ret    z               ; 0011B3 C8
    jp     nc,$d3d5        ; 0011B4 D2 D5 D3
    call   nc,$dfd5        ; 0011B7 D4 D5 DF
    add    a,l             ; 0011BA 85
    sub    $c1             ; 0011BB D6 C1
    add    a,b             ; 0011BD 80
    add    a,a             ; 0011BE 87
    add    a,b             ; 0011BF 80
    adc    a,a             ; 0011C0 8F
    push   bc              ; 0011C1 C5
    ld     (hl),l          ; 0011C2 75
    halt                   ; 0011C3 76
    ld     (hl),a          ; 0011C4 77
    xor    d               ; 0011C5 AA
    xor    h               ; 0011C6 AC
    ld     (de),a          ; 0011C7 12
    adc    a,c             ; 0011C8 89
    inc    l               ; 0011C9 2C
    jp     nz,$d4d3        ; 0011CA C2 D3 D4
    exx                    ; 0011CD D9
    add    a,(hl)          ; 0011CE 86
    sub    $c1             ; 0011CF D6 C1
    add    a,b             ; 0011D1 80
    add    a,a             ; 0011D2 87
    add    a,b             ; 0011D3 80
    adc    a,a             ; 0011D4 8F
    push   bc              ; 0011D5 C5
    halt                   ; 0011D6 76
    ld     (hl),a          ; 0011D7 77
    ld     a,b             ; 0011D8 78
    xor    d               ; 0011D9 AA
    xor    h               ; 0011DA AC
    push   af              ; 0011DB F5
    adc    a,c             ; 0011DC 89
    xor    h               ; 0011DD AC
    jp     nz,$d4d3        ; 0011DE C2 D3 D4
    jp     c,$d686         ; 0011E1 DA 86 D6
    pop    bc              ; 0011E4 C1
    add    a,b             ; 0011E5 80
    add    a,a             ; 0011E6 87
    add    a,b             ; 0011E7 80
    adc    a,a             ; 0011E8 8F
    push   bc              ; 0011E9 C5
    ld     (hl),a          ; 0011EA 77
    ld     a,b             ; 0011EB 78
    ld     l,d             ; 0011EC 6A
    xor    e               ; 0011ED AB
    xor    h               ; 0011EE AC
    push   af              ; 0011EF F5
    adc    a,c             ; 0011F0 89
    xor    h               ; 0011F1 AC
    jp     nz,$d4d3        ; 0011F2 C2 D3 D4
    in     a,($86)         ; 0011F5 DB 86
    sub    $c1             ; 0011F7 D6 C1
    add    a,b             ; 0011F9 80
    add    a,a             ; 0011FA 87
    add    a,b             ; 0011FB 80
    adc    a,a             ; 0011FC 8F
    push   bc              ; 0011FD C5
    ld     a,b             ; 0011FE 78
    ld     l,d             ; 0011FF 6A

	if *>$1200
		inform 3,"Too much data before Z80 sound driver pointers at $1200 in the memory!",*-$1200
	elseif *<$1200
		align $1200	; align data to ensure it remains functional
	endc

; zloc_1200:
z80_SoundDriverPointers:
	dw	z80_SoundPriority		; in the final, this is a duplicate of z80_MusicPointers
	dw	Offset_0x0E1852			; in the final, this is used by the Universal Voice Bank
	dw	z80_MusicPointers
	dw	z80_SFXPointers
	dw	z80_ModEnvPointers
	dw	z80_VolEnvPointers
	dw	$0032				; song limit, not actually used

z80_ModEnvPointers:
	dw	ModEnv_00
	dw	ModEnv_01
	dw	ModEnv_02
	dw	ModEnv_03
	dw	ModEnv_04
	dw	ModEnv_05
	dw	ModEnv_06
	dw	ModEnv_07
	dw	ModEnv_08
	dw	ModEnv_09

ModEnv_00:	db	$40, $60, $70, $60, $50, $30, $10,-$10,-$30,-$50,-$70, $83
ModEnv_01:	db	$00, $02, $04, $06, $08, $0A, $0C, $0E, $10, $12, $14, $18, $81
ModEnv_02:	db	$00, $00, $01, $03, $01, $00,-$01,-$03,-$01, $00, $82, $02
ModEnv_03:	db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
		db	$00, $00, $00, $00, $00, $00, $00, $00, $02, $04, $06, $08, $0A, $0C, $0A, $08
		db	$06, $04, $02, $00,-$02,-$04,-$06,-$08,-$0A,-$0C,-$0A,-$08,-$06,-$04,-$02, $00
		db	$82, $29

ModEnv_04:
    nop                    ; 001289 00
    nop                    ; 00128A 00
    nop                    ; 00128B 00
    nop                    ; 00128C 00
    nop                    ; 00128D 00
    nop                    ; 00128E 00
    nop                    ; 00128F 00
    nop                    ; 001290 00
    nop                    ; 001291 00
    nop                    ; 001292 00
    nop                    ; 001293 00
    nop                    ; 001294 00
    nop                    ; 001295 00
    nop                    ; 001296 00
    nop                    ; 001297 00
    nop                    ; 001298 00
    nop                    ; 001299 00
    nop                    ; 00129A 00
    nop                    ; 00129B 00
    nop                    ; 00129C 00
    nop                    ; 00129D 00
    nop                    ; 00129E 00
    nop                    ; 00129F 00
    nop                    ; 0012A0 00
    nop                    ; 0012A1 00
    nop                    ; 0012A2 00
    nop                    ; 0012A3 00
    nop                    ; 0012A4 00
    ld     (bc),a          ; 0012A5 02
    inc    b               ; 0012A6 04
    ld     b,$08           ; 0012A7 06 08
    ld     a,(bc)          ; 0012A9 0A
    inc    c               ; 0012AA 0C
    ld     a,(bc)          ; 0012AB 0A
    ex     af,af          ; 0012AC 08
    ld     b,$04           ; 0012AD 06 04
    ld     (bc),a          ; 0012AF 02
    nop                    ; 0012B0 00
    cp     $fc             ; 0012B1 FE FC
    jp     m,$f6f8         ; 0012B3 FA F8 F6
    call   p,$f8f6         ; 0012B6 F4 F6 F8
    jp     m,$fefc         ; 0012B9 FA FC FE
    add    a,d             ; 0012BC 82
    dec    de              ; 0012BD 1B

ModEnv_05:
    nop                    ; 0012BE 00
    nop                    ; 0012BF 00
    nop                    ; 0012C0 00
    nop                    ; 0012C1 00
    nop                    ; 0012C2 00
    nop                    ; 0012C3 00
    nop                    ; 0012C4 00
    nop                    ; 0012C5 00
    nop                    ; 0012C6 00
    nop                    ; 0012C7 00
    nop                    ; 0012C8 00
    nop                    ; 0012C9 00
    nop                    ; 0012CA 00
    nop                    ; 0012CB 00
    nop                    ; 0012CC 00
    nop                    ; 0012CD 00
    nop                    ; 0012CE 00
    nop                    ; 0012CF 00
    nop                    ; 0012D0 00
    nop                    ; 0012D1 00
    nop                    ; 0012D2 00
    nop                    ; 0012D3 00
    nop                    ; 0012D4 00
    nop                    ; 0012D5 00
    nop                    ; 0012D6 00
    nop                    ; 0012D7 00
    nop                    ; 0012D8 00
    nop                    ; 0012D9 00
    nop                    ; 0012DA 00
    nop                    ; 0012DB 00
    nop                    ; 0012DC 00
    nop                    ; 0012DD 00
    nop                    ; 0012DE 00
    nop                    ; 0012DF 00
    nop                    ; 0012E0 00
    nop                    ; 0012E1 00
    nop                    ; 0012E2 00
    nop                    ; 0012E3 00
    nop                    ; 0012E4 00
    nop                    ; 0012E5 00
    nop                    ; 0012E6 00
    nop                    ; 0012E7 00
    nop                    ; 0012E8 00
    nop                    ; 0012E9 00
    nop                    ; 0012EA 00
    nop                    ; 0012EB 00
    nop                    ; 0012EC 00
    nop                    ; 0012ED 00
    nop                    ; 0012EE 00
    nop                    ; 0012EF 00
    inc    bc              ; 0012F0 03
    ld     b,$03           ; 0012F1 06 03
    nop                    ; 0012F3 00
    db     $fd             ; 0012F4 FD
    jp     m,$fdfa         ; 0012F5 FA FA FD
    nop                    ; 0012F8 00
    add    a,d             ; 0012F9 82
    inc    sp              ; 0012FA 33

ModEnv_06:
    nop                    ; 0012FB 00
    nop                    ; 0012FC 00
    nop                    ; 0012FD 00
    nop                    ; 0012FE 00
    nop                    ; 0012FF 00
    nop                    ; 001300 00
    nop                    ; 001301 00
    nop                    ; 001302 00
    nop                    ; 001303 00
    nop                    ; 001304 00
    nop                    ; 001305 00
    nop                    ; 001306 00
    nop                    ; 001307 00
    nop                    ; 001308 00
    nop                    ; 001309 00
    nop                    ; 00130A 00
    ld     (bc),a          ; 00130B 02
    inc    b               ; 00130C 04
    ld     (bc),a          ; 00130D 02
    nop                    ; 00130E 00
    cp     $fc             ; 00130F FE FC
    cp     $00             ; 001311 FE 00
    add    a,d             ; 001313 82
	db	$11

ModEnv_07:
	dw	$FFFE
    nop                    ; 001317 00
    nop                    ; 001318 00
    nop                    ; 001319 00
    nop                    ; 00131A 00
    nop                    ; 00131B 00
    nop                    ; 00131C 00
    nop                    ; 00131D 00
    nop                    ; 00131E 00
    nop                    ; 00131F 00
    nop                    ; 001320 00
    nop                    ; 001321 00
    nop                    ; 001322 00
    nop                    ; 001323 00
    nop                    ; 001324 00
    nop                    ; 001325 00
    nop                    ; 001326 00
    ld     bc,$0001        ; 001327 01 01 00
    nop                    ; 00132A 00
    rst    38h             ; 00132B FF
    rst    38h             ; 00132C FF
    add    a,d             ; 00132D 82
	db	$11

ModEnv_08:
	dw	$0203
    ld     bc,$0000        ; 001331 01 00 00
    nop                    ; 001334 00
	dw	$8101

ModEnv_09:
	db	$00
    nop                    ; 001338 00
    nop                    ; 001339 00
    nop                    ; 00133A 00
    ld     bc,$0101        ; 00133B 01 01 01
    ld     bc,$0202        ; 00133E 01 02 02
    ld     bc,$0101        ; 001341 01 01 01
    nop                    ; 001344 00
    nop                    ; 001345 00
    nop                    ; 001346 00
    add    a,h             ; 001347 84
    ld     bc,$0482        ; 001348 01 82 04

z80_VolEnvPointers:
	dw	VolEnv_00
	dw	VolEnv_01
	dw	VolEnv_02
	dw	VolEnv_03
	dw	VolEnv_04
	dw	VolEnv_05
	dw	VolEnv_06
	dw	VolEnv_07
	dw	VolEnv_08
	dw	VolEnv_09
	dw	VolEnv_0A
	dw	VolEnv_0B
	dw	VolEnv_0C
	dw	VolEnv_0D
	dw	VolEnv_0E
	dw	VolEnv_0F
	dw	VolEnv_10
	dw	VolEnv_11
	dw	VolEnv_12
	dw	VolEnv_13
	dw	VolEnv_14
	dw	VolEnv_15
	dw	VolEnv_16
	dw	VolEnv_17
	dw	VolEnv_18
	dw	VolEnv_19
	dw	VolEnv_1A
	dw	VolEnv_1B
	dw	VolEnv_1C
	dw	VolEnv_1D
	dw	VolEnv_1E
	dw	VolEnv_1F
	dw	VolEnv_20
	dw	VolEnv_21
	dw	VolEnv_22
	dw	VolEnv_23
	dw	VolEnv_24
	dw	$00F5
	dw	$0026

VolEnv_00:	db	$02, $83
VolEnv_01:	db	$00, $02, $04, $06, $08, $10, $83
VolEnv_02:	db	$02, $01, $00, $00, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
		db	$02, $03, $03, $03, $04, $04, $04, $05, $81
VolEnv_03:	db	$00, $00, $02, $03, $04, $04, $05, $05, $05, $06, $06, $81
VolEnv_04:	db	$03, $00, $01, $01, $01, $02, $03, $04, $04, $05, $81
VolEnv_05:	db	$00, $00, $01, $01, $02, $03, $04, $05, $05, $06, $08, $07, $07, $06, $81
VolEnv_06:	db	$01, $0C, $03, $0F, $02, $07, $03, $0F, $80
VolEnv_07:	db	$00, $00, $00, $02, $03, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0E, $0F
		db	$83
VolEnv_08:	db	$03, $02, $01, $01, $00, $00, $01, $02, $03, $04, $81
VolEnv_09:	db	$01, $00, $00, $00, $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $03, $04
		db	$04, $04, $05, $05, $81
VolEnv_0A:	db	$10, $20, $30, $40, $30, $20, $10, $00,-$10, $80
VolEnv_0B:	db	$00, $00, $01, $01, $03, $03, $04, $05, $83
VolEnv_0C:	db	$00, $81
VolEnv_0D:	db	$02, $83
VolEnv_0E:	db	$00, $02, $04, $06, $08, $10, $83
VolEnv_0F:	db	$09, $09, $09, $08, $08, $08, $07, $07, $07, $06, $06, $06, $05, $05, $05, $04
		db	$04, $04, $03, $03, $03, $02, $02, $02, $01, $01, $01, $00, $00, $00, $81
VolEnv_10:	db	$01, $01, $01, $00, $00, $00, $81
VolEnv_11:	db	$03, $00, $01, $01, $01, $02, $03, $04, $04, $05, $81
VolEnv_12:	db	$00, $00, $01, $01, $02, $03, $04, $05, $05, $06, $08, $07, $07, $06, $81
VolEnv_13:	db	$0A, $05, $00, $04, $08, $83
VolEnv_14:	db	$00, $00, $00, $02, $03, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0E, $0F
		db	$83
VolEnv_15:	db	$03, $02, $01, $01, $00, $00, $01, $02, $03, $04, $81
VolEnv_16:	db	$01, $00, $00, $00, $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $03, $04
		db	$04, $04, $05, $05, $81
VolEnv_17:	db	$10, $20, $30, $40, $30, $20, $10, $00, $10, $20, $30, $40, $30, $20, $10, $00
		db	$10, $20, $30, $40, $30, $20, $10, $00, $80
VolEnv_18:	db	$00, $00, $01, $01, $03, $03, $04, $05, $83
VolEnv_19:	db	$00, $02, $04, $06, $08, $16, $83
VolEnv_1A:	db	$00, $00, $01, $01, $03, $03, $04, $05, $83
VolEnv_1B:	db	$04, $04, $04, $04, $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01
		db	$83
VolEnv_1C:	db	$00, $00, $00, $00, $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03
		db	$04, $04, $04, $04, $05, $05, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07
		db	$08, $08, $08, $08, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $81
VolEnv_1D:	db	$00, $0A, $83
VolEnv_1E:	db	$00, $02, $04, $81
VolEnv_1F:	db	$30, $20, $10, $00, $00, $00, $00, $00, $08, $10, $20, $30, $81
VolEnv_20:	db	$00, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $06, $06, $06, $08, $08
		db	$0A, $83
VolEnv_21:	db	$00, $02, $03, $04, $06, $07, $81
VolEnv_22:	db	$02, $01, $00, $00, $00, $02, $04, $07, $81
VolEnv_23:	db	$0F, $01, $05, $83
VolEnv_24:	db	$08, $06, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
		db	$10, $83
VolEnv_25:	db	$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01
		db	$01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03
		db	$03, $03, $03, $03, $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04
		db	$04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $06, $06, $06
		db	$06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
		db	$08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09, $09, $09, $09, $09, $09
		db	$09, $09, $09, $09, $83

z80_SoundPriority:
    add    a,b             ; 0015D1 80
    add    a,b             ; 0015D2 80
    add    a,b             ; 0015D3 80
    add    a,b             ; 0015D4 80
    add    a,b             ; 0015D5 80
    add    a,b             ; 0015D6 80
    add    a,b             ; 0015D7 80
    add    a,b             ; 0015D8 80
    add    a,b             ; 0015D9 80
    add    a,b             ; 0015DA 80
    add    a,b             ; 0015DB 80
    add    a,b             ; 0015DC 80
    add    a,b             ; 0015DD 80
    add    a,b             ; 0015DE 80
    add    a,b             ; 0015DF 80
    ld     a,a             ; 0015E0 7F
    ld     a,a             ; 0015E1 7F
    ld     a,a             ; 0015E2 7F
    ld     a,a             ; 0015E3 7F
    ld     a,a             ; 0015E4 7F
    ld     a,a             ; 0015E5 7F
    ld     a,a             ; 0015E6 7F
    ld     a,a             ; 0015E7 7F
    ld     a,a             ; 0015E8 7F
    ld     a,a             ; 0015E9 7F
    ld     a,a             ; 0015EA 7F
    ld     a,a             ; 0015EB 7F
    ld     a,a             ; 0015EC 7F
    ld     a,a             ; 0015ED 7F
    ld     a,a             ; 0015EE 7F
    ld     a,a             ; 0015EF 7F
    ld     a,a             ; 0015F0 7F
    ld     a,a             ; 0015F1 7F
    ld     a,a             ; 0015F2 7F
    ld     a,a             ; 0015F3 7F
    ld     a,a             ; 0015F4 7F
    ld     a,a             ; 0015F5 7F
    ld     a,a             ; 0015F6 7F
    ld     a,a             ; 0015F7 7F
    ld     a,a             ; 0015F8 7F
    ld     a,a             ; 0015F9 7F
    ld     a,a             ; 0015FA 7F
    ld     a,a             ; 0015FB 7F
    ld     a,a             ; 0015FC 7F
    ld     a,a             ; 0015FD 7F
    ld     a,a             ; 0015FE 7F
    ld     a,a             ; 0015FF 7F
    ld     a,a             ; 001600 7F
    ld     a,a             ; 001601 7F
    ld     a,a             ; 001602 7F
    ld     a,a             ; 001603 7F
    ld     a,a             ; 001604 7F
    ld     a,a             ; 001605 7F
    ld     a,a             ; 001606 7F
    ld     a,a             ; 001607 7F
    ld     a,a             ; 001608 7F
    ld     a,a             ; 001609 7F
    ld     a,a             ; 00160A 7F
    ld     a,a             ; 00160B 7F
    ld     a,a             ; 00160C 7F
    ld     a,a             ; 00160D 7F
    ld     a,a             ; 00160E 7F
    ld     a,a             ; 00160F 7F
    ld     a,a             ; 001610 7F
    ld     a,a             ; 001611 7F
    ld     a,a             ; 001612 7F
    ld     a,a             ; 001613 7F
    ld     a,a             ; 001614 7F
    ld     a,a             ; 001615 7F
    ld     a,a             ; 001616 7F
    ld     a,a             ; 001617 7F
    ld     a,a             ; 001618 7F
    ld     a,a             ; 001619 7F
    ld     a,a             ; 00161A 7F
    ld     a,a             ; 00161B 7F
    ld     a,a             ; 00161C 7F
    ld     a,a             ; 00161D 7F
    ld     a,a             ; 00161E 7F
    ld     a,a             ; 00161F 7F
    ld     a,a             ; 001620 7F
    ld     a,a             ; 001621 7F
    ld     a,a             ; 001622 7F
    ld     a,a             ; 001623 7F
    ld     a,a             ; 001624 7F
    ld     a,a             ; 001625 7F
    ld     a,a             ; 001626 7F
    ld     a,a             ; 001627 7F
    ld     a,a             ; 001628 7F
    ld     a,a             ; 001629 7F
    ld     a,a             ; 00162A 7F
    ld     a,a             ; 00162B 7F
    ld     a,a             ; 00162C 7F
    ld     a,a             ; 00162D 7F
    ld     a,a             ; 00162E 7F
    ld     a,a             ; 00162F 7F
    ld     a,a             ; 001630 7F
    ld     a,a             ; 001631 7F
    ld     a,a             ; 001632 7F
    ld     a,a             ; 001633 7F
    ld     a,a             ; 001634 7F
    ld     a,a             ; 001635 7F
    ld     a,a             ; 001636 7F
    ld     a,a             ; 001637 7F
    ld     a,a             ; 001638 7F
    ld     a,a             ; 001639 7F
    ld     a,a             ; 00163A 7F
    ld     a,a             ; 00163B 7F
    ld     a,a             ; 00163C 7F
    ld     a,a             ; 00163D 7F
    ld     a,a             ; 00163E 7F
    ld     a,a             ; 00163F 7F
    ld     a,a             ; 001640 7F
    ld     a,a             ; 001641 7F
    ld     a,a             ; 001642 7F
    ld     a,a             ; 001643 7F
    ld     a,a             ; 001644 7F
    ld     a,a             ; 001645 7F
    ld     a,a             ; 001646 7F
    ld     a,a             ; 001647 7F
    ld     a,a             ; 001648 7F
    ld     a,a             ; 001649 7F
    ld     a,a             ; 00164A 7F
    ld     a,a             ; 00164B 7F
    ld     a,a             ; 00164C 7F
    ld     a,a             ; 00164D 7F
    ld     a,a             ; 00164E 7F
    ld     a,a             ; 00164F 7F
    ld     a,a             ; 001650 7F
    ld     a,a             ; 001651 7F
    ld     a,a             ; 001652 7F
    ld     a,a             ; 001653 7F
    ld     a,a             ; 001654 7F
    ld     a,a             ; 001655 7F
    ld     a,a             ; 001656 7F
    ld     a,a             ; 001657 7F
    ld     a,a             ; 001658 7F
    ld     a,a             ; 001659 7F
    ld     a,a             ; 00165A 7F
    ld     a,a             ; 00165B 7F
    ld     a,a             ; 00165C 7F
    ld     a,a             ; 00165D 7F
    ld     a,a             ; 00165E 7F
    ld     a,a             ; 00165F 7F
    ld     a,a             ; 001660 7F
    ld     a,a             ; 001661 7F
    ld     a,a             ; 001662 7F
    ld     a,a             ; 001663 7F
    ld     a,a             ; 001664 7F
    ld     a,a             ; 001665 7F
    ld     a,a             ; 001666 7F
    ld     a,a             ; 001667 7F
    ld     a,a             ; 001668 7F
    ld     a,a             ; 001669 7F
    ld     a,a             ; 00166A 7F
    ld     a,a             ; 00166B 7F
    ld     a,a             ; 00166C 7F
    ld     a,a             ; 00166D 7F
    ld     a,a             ; 00166E 7F
    ld     a,a             ; 00166F 7F
    ld     a,a             ; 001670 7F
    ld     a,a             ; 001671 7F
    ld     a,a             ; 001672 7F
    ld     a,a             ; 001673 7F
    ld     a,a             ; 001674 7F
    ld     a,a             ; 001675 7F
    ld     a,a             ; 001676 7F
    ld     a,a             ; 001677 7F
    ld     a,a             ; 001678 7F
    ld     a,a             ; 001679 7F
    ld     a,a             ; 00167A 7F
    ld     a,a             ; 00167B 7F
    ld     a,a             ; 00167C 7F
    ld     a,a             ; 00167D 7F
    ld     a,a             ; 00167E 7F
    ld     a,a             ; 00167F 7F
    ld     a,a             ; 001680 7F
    ld     a,a             ; 001681 7F
    ld     a,a             ; 001682 7F
    ld     a,a             ; 001683 7F
    ld     a,a             ; 001684 7F
    ld     a,a             ; 001685 7F
    ld     a,a             ; 001686 7F
    ld     a,a             ; 001687 7F
    ld     a,a             ; 001688 7F
    ld     a,a             ; 001689 7F
    ld     a,a             ; 00168A 7F
    ld     a,a             ; 00168B 7F
    ld     a,a             ; 00168C 7F
    ld     a,a             ; 00168D 7F
    ld     a,a             ; 00168E 7F
    ld     a,a             ; 00168F 7F
    ld     a,a             ; 001690 7F
    ld     a,a             ; 001691 7F
    ld     a,a             ; 001692 7F
    ld     a,a             ; 001693 7F
    ld     a,a             ; 001694 7F
    ld     a,a             ; 001695 7F
    ld     a,a             ; 001696 7F
    ld     a,a             ; 001697 7F
    ld     a,a             ; 001698 7F
    ld     a,a             ; 001699 7F
    ld     a,a             ; 00169A 7F
    ld     a,a             ; 00169B 7F
    ld     a,a             ; 00169C 7F
    ld     a,a             ; 00169D 7F
    ld     a,a             ; 00169E 7F
    ld     a,a             ; 00169F 7F

	CPU 68000
	pops
	pushs
	objend