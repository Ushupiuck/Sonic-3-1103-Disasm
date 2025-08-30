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

; Set this to 1 to fix some bugs in the driver.
fix_sndbugs	=	0

z80_SoundDriverStart:
; ---------------------------------------------------------------------------

zTrack STRUCT DOTS
PlaybackControl:	ds.b 1
VoiceControl:		ds.b 1
TempoDivider:		ds.b 1
DataPointerLow:		ds.b 1
DataPointerHigh:	ds.b 1
Transpose:		ds.b 1
Volume:			ds.b 1
ModulationCtrl:		ds.b 1
VoiceIndex:		ds.b 1
StackPointer:		ds.b 1
AMSFMSPan:		ds.b 1
DurationTimeout:	ds.b 1
SavedDuration:		ds.b 1
FreqLow:		ds.b 1
FreqHigh:		ds.b 1
VoiceSongID:		ds.b 1
Detune:			ds.b 1
Unk11h:			ds.b 1
		ds.b 5	; $12-$16 are unused!
VolEnv:			ds.b 1
FMVolEnv:		ds.b 1
SSGEGPointerLow:
FMVolEnvMask:		ds.b 1
SSGEGPointerHigh:
PSGNoise:		ds.b 1
FeedbackAlgo:		ds.b 1
TLPtrLow:		ds.b 1
TLPtrHigh:		ds.b 1
NoteFillTimeout:	ds.b 1
NoteFillMaster:		ds.b 1
ModulationPtrLow:	ds.b 1
ModulationPtrHigh:	ds.b 1
ModEnvSens:
ModulationValLow:	ds.b 1
ModulationValHigh:	ds.b 1
ModulationWait:		ds.b 1
ModEnvIndex:
ModulationSpeed:	ds.b 1
ModulationDelta:	ds.b 1
ModulationSteps:	ds.b 1
LoopCounters:		ds.w 1
VoicesLow:		ds.b 1
VoicesHigh:		ds.b 1
Stack_top:		ds.l 1
zTrack ENDSTRUCT

; ---------------------------------------------------------------------------
z80_stack	=	$2000
z80_stack_end	=	z80_stack-$60
; equates: standard (for Genesis games) addresses in the memory map
zYM2612_A0:		= $4000
zYM2612_D0:		= $4001
zYM2612_A1:		= $4002
zYM2612_D1:		= $4003
zBankRegister:		= $6000
zPSG:			= $7F11
zROMWindow:		= $8000
; ---------------------------------------------------------------------------
; z80 RAM:
zDataStart:		= $1C00

		phase zDataStart
			ds.b	2	; unused
zPointerTable:		ds.w	1	; the 68000 SoundDriverLoad routine sets this to 1200h in Z80 memory
zSongBank:		ds.b	1	; bits 15 to 22 of M68K bank address
zCurrentTempo:		ds.b	1
zDACIndex:		ds.b	1	; bit 7 = 1 if playing, 0 if not; remaining 7 bits are index into DAC tables (1-based)
zPlaySegaPCMFlag:	ds.b	1
zPalDblUpdCounter:	ds.b	1	; used to update the sound driver twice every five frames; not actually implemented yet

zTempVariablesStart:	ds.b	1
zNextSound:		=	zTempVariablesStart
; the following three variables are used for 68000 input, although only the first is functional
zMusicNumber:		ds.b	1
zSFXNumber0:		ds.b	1
zSFXNumber1:		ds.b	1

zFadeOutTimeout:	ds.b	1
zFadeDelay:		ds.b	1
zFadeDelayTimeout:	ds.b	1
zPauseFlag:		ds.b	1
zHaltFlag:		ds.b	1
zFM3Settings:		ds.b	1	; set twice, never read (is read in Z80 Type 1 for YM timer-related purposes)
zTempoAccumulator:	ds.b	1
			ds.b	1	; unused
unk_1C15:		ds.b	1	; set twice, unused read
zFadeToPrevFlag:	ds.b	1
unk_1C17:		ds.b	1	; set once, never read
zSoundIndex:		ds.b	1	; effectively unused in the final
zUpdatingSFX:		ds.b	1
zSpecFM3FreqsSFX:	ds.b	8
unk_1C22:		ds.b	8
zSpecFM3Freqs:		ds.b	8
zSFXSaveIndex:		ds.b	1
zSongPosition:		ds.b	2
zTrackInitPos:		ds.b	2
zVoiceTblPtr:		ds.b	2
zSFXVoiceTblPtr:	ds.b	2
zSFXTempoDivider:	ds.b	1
			ds.b	4	; unused

zTracksStart:
zSongFM6_DAC:	zTrack.len
zSongFM1:		zTrack.len
zSongFM2:		zTrack.len
zSongFM3:		zTrack.len
zSongFM4:		zTrack.len
zSongFM5:		zTrack.len
zSongPSG1:		zTrack.len
zSongPSG2:		zTrack.len
zSongPSG3:		zTrack.len
zTracksEnd

zTracksSFXStart:
zSFX_FM3:		zTrack.len
zSFX_FM4:		zTrack.len
zSFX_FM5:		zTrack.len
zSFX_FM6:		zTrack.len
zSFX_PSG1:		zTrack.len
zSFX_PSG2:		zTrack.len
zSFX_PSG3:		zTrack.len
zTracksSFXEnd


zTempVariablesEnd
		dephase
		!org	z80_SoundDriverStart
		
		save
		!org 0	; z80 Align, handled by the build process
		CPU Z80
		listing purecode

; Macro to perform a bank switch... after using this,
; the start of zROMWindow points to the start of the given 68k address,
; rounded down to the nearest $8000 byte boundary
bankswitch macro addr68k
	if fix_sndbugs
	; Because why use a and e when you can use h and l?
	ld	hl,zBankRegister+1	; +1 so that 6000h becomes 6001h, which is still a valid bankswitch port
.cnt	:= 0
	rept 9
		; this is either ld (hl),h or ld (hl),l
		db 74h|(((addr68k)&(1<<(15+.cnt)))<>0)
.cnt		:= .cnt+1
	endm
	else
	ld	hl,zBankRegister
	xor	a	; a = 0
	ld	e,1	; e = 1
.cnt	:= 0
	rept 9
		; this is either ld (hl),a or ld (hl),e
		db 73h|((((addr68k)&(1<<(15+.cnt)))=0)<<2)
.cnt		:= .cnt+1
	endm
	endif
	endm
	
; Macro to perform a bank switch... after using this,
; the start of zROMWindow points to the start of the given 68k address,
; rounded down to the nearest $8000 byte boundary
; This is only ever used once.
bankswitch2 macro addr68k
	ld	hl,zBankRegister
	ld	d,1	; d = 1
	xor	a	; a = 0
.cnt	:= 0
	rept 9
		; this is either ld (hl),a or ld (hl),d
		db 72h|((((addr68k)&(1<<(15+.cnt)))=0)<<2)|(((addr68k)&(1<<(15+.cnt)))=0)
.cnt		:= .cnt+1
	endm
	endm

bankswitchToMusic macro addr68k
	; hardcoded to only accept 4-bit bank values
	ld	(hl),a
	rept 3
		rra
		ld	(hl),a
	endm
	xor	a
	ld	d,1
.cnt	:= 4
	rept 5
		; this is either ld (hl),a or ld (hl),d
		db 72h|((((addr68k)&(1<<(15+.cnt)))=0)<<2)|(((addr68k)&(1<<(15+.cnt)))=0)
.cnt		:= .cnt+1
	endm
	endm

; macro to make a certain error message clearer should you happen to get it...
rsttarget macro {INTLABEL}
	if ($&7)||($>38h)
		fatal "Function __LABEL__ is at 0\{$}h, but must be at a multiple of 8 bytes <= 38h to be used with the rst instruction."
	endif
	if "__LABEL__"<>""
__LABEL__ label $
	endif
	endm

; function to turn a 68k address into a word the Z80 can use to access it
zmake68kPtr function addr,zROMWindow+(addr&7FFFh)

; function to turn a 68k address into a bank byte
zmake68kBank function addr,(((addr&3F8000h)/zROMWindow))

zmakeSongBank function addr,zmake68kBank(addr)&0Fh ; See bankswitchToMusicS3

zID_PriorityList	= 0
zID_UniVoiceBank	= 2
zID_MusicPointers	= 4
zID_SFXPointers		= 6
zID_ModEnvPointers	= 8
zID_VolEnvPointers	= 0Ah
zID_SongLimit		= 0Ch		; Earlier drivers had this; unused

; ===========================================================================
; ---------------------------------------------------------------------------
; Entry Point
; ---------------------------------------------------------------------------

zEntryPoint:
		di					; disable interrupts...
		di					; twice
		im	1				; set interrupt mode 1
		jp	zInitAudioDriver
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
	align 8
zGetPointerTable:	rsttarget
	if fix_sndbugs
		ld	hl,z80_SoundDriverPointers		; read pointer table
	else
		ld	hl,(zPointerTable)		; read pointer to pointer table (yes, really)
	endif
		; really, you should just make this reference z80_SoundDriverPointers directly
		ld	b,0
		add	hl,bc				; add offset into pointer table
		ex	af,af'				; backup AF
		ld	a,(hl)				; read low byte of pointer table
		inc	hl
		ld	h,(hl)				; read high byte of pointer table
		ld	l,a				; combine both bytes together to get our address
		ex	af,af'				; restore AF
		ret
; ===========================================================================
; ---------------------------------------------------------------------------
; Reads	an offset into a pointer table and returns dereferenced pointer.
;
; input:  a    index into pointer table
;	  hl   pointer to pointer table
; output: hl   selected	pointer	in pointer table
;         bc   trashed
; ---------------------------------------------------------------------------
	align 8
zPointerTableOffset:	rsttarget
		ld	c,a				; get index for pointer table
		; then load the pointer in the index
		ld	b,0
		add	hl,bc
		add	hl,bc
	if fix_sndbugs
		jp	zReadPointer	; 10 clock cycles, 3 bytes
	else
		nop			; 12 clock cycles, 3 bytes
		nop
		nop
	endif
; ----------------------------------------------------------------------------
; Dereferences a pointer.
;
; input:  hl	pointer
; output: hl	equal to what that was being pointed to by hl
	align 8
zReadPointer:	rsttarget
		ld	a,(hl)				; read low byte of pointer table
		inc	hl
		ld	h,(hl)				; read high byte of pointer table
		ld	l,a				; combine both bytes together to get our address
		ret
; ----------------------------------------------------------------------------
; Possible to fit two more rsttargets into here
	align 38h
; ===========================================================================
; ---------------------------------------------------------------------------
; This subroutine is called every V-Int. After it is processed, the z80
; returns to the digital audio loop to continue playing DAC samples.
;
; If the SEGA PCM is being played, it disables interrupts -- this means that
; this procedure will NOT be called while the SEGA PCM is playing.
; ---------------------------------------------------------------------------

zVInt:	rsttarget
		di					; disable interrupts
		push	af
		push	iy
		exx

		call	zDoUpdate
		call	zUpdateEverything

		; DAC bankswitch
		bankswitch DACBank
		exx
		pop	iy
		pop	af
		ld	b,1
		ret
; ---------------------------------------------------------------------------

zInitAudioDriver:
		ld	sp,z80_stack			; set the stack pointer to 0x2000 (end of z80 RAM)
		ld	c,0

.loop:
		ld	b,0
		djnz	$
		dec	c
		jr	z,.loop

		ld	a,zmakeSongBank(Snd_Bank1_Start)
		ld	(zSongBank),a			; store the music bank
		xor	a
		ld	(zDACIndex),a			; clear the DAC index
		ld	(zPlaySegaPCMFlag),a		; clear the Sega sound flag
		call	zStopAllSound			; stop all music
		ld	a,5				; set PAL double-update timer to 5
		ld	(zPalDblUpdCounter),a		; (that is, do not double-update for 5 frames)

	if ~~fix_sndbugs
		; duplicate DAC bankswitch
		bankswitch2 DACBank
	endif
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
		bit	7,(ix+zTrack.VoiceControl)		; is this a PSG track?
		ret	nz				; return if yes
		bit	2,(ix+zTrack.PlaybackControl)		; is SFX overriding this track?
		ret	nz				; return if yes
		add	a,(ix+zTrack.VoiceControl)		; add the channel bits to the register address
		bit	2,(ix+zTrack.VoiceControl)		; is this the DAC channel or FM4 or FM5 or FM6?
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
	if ~~fix_sndbugs
		nop
	endif
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
	if ~~fix_sndbugs
		nop
	endif
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
		bankswitchToMusic Snd_Bank1_Start
		xor	a
		ld	(zUpdatingSFX),a		; update music
		ld	ix,zSongFM6_DAC
		bit	7,(ix+zTrack.PlaybackControl)		; is this an FM/DAC track?
		call	nz,zUpdateDACTrack		; if yes, branch
		ld	b,(zTracksEnd-zSongFM1)/zTrack.len	; get number of tracks
		ld	ix,zSongFM1
		jr	zTrackUpdLoop			; play all tracks

zUpdateSFXTracks:
		ld	a,1
		ld	(zUpdatingSFX),a		; update SFX
		bankswitch SndBank
		ld	ix,zTracksSFXStart		; get number of tracks
		ld	b,(zTracksSFXEnd-zTracksSFXStart)/zTrack.len

zTrackUpdLoop:
		push	bc
		bit	7,(ix+zTrack.PlaybackControl)		; is a track currently playing?
		call	nz,zUpdateFMorPSGTrack		; if yes, branch
		ld	de,zTrack.len
		add	ix,de				; otherwise, advance to the next track
		pop	bc
		djnz	zTrackUpdLoop			; loop for all tracks
		ret

zUpdateFMorPSGTrack:
		bit	7,(ix+zTrack.VoiceControl)		; is this a PSG channel?
		jp	nz,zUpdatePSGTrack		; if yes, branch

	if fix_sndbugs
		dec	(ix+zTrack.DurationTimeout)	; Run note timer
	else
		call	zTrackRunTimer			; Run note timer
	endif
		jr	nz,.noteGoing			; if the note has not expired yet, branch
		call	zGetNextNote			; get note for next FM track
		bit	4,(ix+zTrack.PlaybackControl)		; is track resting?
		ret	nz				; if yes, return
		call	zPrepareModulation
		call	zUpdateFreq
		call	zDoModulation
		call	zFMSendFreq
		jp	zFMNoteOn
; ---------------------------------------------------------------------------

.noteGoing:
		bit	4,(ix+zTrack.PlaybackControl)		; is the track resting?
		ret	nz				; if yes, return
		call	zDoFMVolEnv
		ld	a,(ix+zTrack.NoteFillTimeout)
		or	a				; is timeout either not running or expired?
		jr	z,.keepGoing			; if yes, branch
		dec	(ix+zTrack.NoteFillTimeout)
		jp	z,zKeyOffIfActive

.keepGoing:
		call	zUpdateFreq
		bit	6,(ix+zTrack.PlaybackControl)		; is 'sustain frequency' bit set?
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
;          de		increased by 8
; ---------------------------------------------------------------------------

zFMSendFreq:
		bit	2,(ix+zTrack.PlaybackControl)		; is SFX overriding this track?
		ret	nz				; if yes, return
		bit	0,(ix+zTrack.PlaybackControl)		; is track in special mode (FM3 only)?
		jp	nz,.specialMode			; if yes, branch

.notFM3:
		ld	a,0A4h				; update frequency MSB
		ld	c,h
		call	zWriteFMIorII
		ld	a,0A0h				; update frequency LSB
		ld	c,l
	if fix_sndbugs
		jp	zWriteFMIorII			; Send it to YM2612
	else
		call	zWriteFMIorII			; Send it to YM2612
		ret
	endif
; ---------------------------------------------------------------------------

.specialMode:
		ld	a,(ix+zTrack.VoiceControl)
		cp	2				; is this FM3?
		jr	nz,.notFM3			; if not, branch
		call	zGetSpecialFM3DataPointer
		ld	b,zSpecialFreqCommands_End-zSpecialFreqCommands
		ld	hl,zSpecialFreqCommands

.loop:
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
		ld	l,(ix+zTrack.FreqLow)
		ld	h,(ix+zTrack.FreqHigh)
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
		djnz	.loop
		ret
; End of function zFMSendFreq

; ===========================================================================
; zloc_1A5:
zSpecialFreqCommands:
		db	0ADh
		db	0AEh
		db	0ACh
		db	0A6h
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
		ld	e,(ix+zTrack.DataPointerLow)
		ld	d,(ix+zTrack.DataPointerHigh)
		res	1,(ix+zTrack.PlaybackControl)
		res	4,(ix+zTrack.PlaybackControl)

zGetNextNote_cont:
		ld	a,(de)
		inc	de
		cp	0E0h
		jp	nc,zHandleFMorPSGCoordFlag
		ex	af,af'
		call	zKeyOffIfActive
		ex	af,af'
		bit	3,(ix+zTrack.PlaybackControl)
		jp	nz,zAltFreqMode
		or	a
		jp	p,zStoreDuration
		sub	81h
		jp	p,.gotNote
		call	zRestTrack
		jr	zGetNoteDuration

.gotNote:
		add	a,(ix+zTrack.Transpose)
		ld	hl,zPSGFrequencies
		push	af
		rst	zPointerTableOffset
		pop	af
		bit	7,(ix+zTrack.VoiceControl)
		jr	nz,zGotNoteFreq
		push	de
		ld	d,8
		ld	e,12
		ex	af,af'
		xor	a

.loop:
		ex	af,af'
		sub	e
		jr	c,.gotDisplacement
		ex	af,af'
		add	a,d
		jr	.loop
; ---------------------------------------------------------------------------
	if ~~fix_sndbugs
		; unused
		ex	af,af'
	endif

.gotDisplacement:
		add	a,e
		ld	hl,zFMFrequencies
		rst	zPointerTableOffset
		ex	af,af'
		or	h
		ld	h,a
		pop	de

zGotNoteFreq:
		ld	(ix+zTrack.FreqLow),l
		ld	(ix+zTrack.FreqHigh),h

zGetNoteDuration:
		ld	a,(de)
		or	a
		jp	p,zGotNoteDuration
		ld	a,(ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout),a
		jr	zFinishTrackUpdate
		
	if ~~fix_sndbugs
		; unused
		ld	a,(de)
		inc	de
		ld	(ix+zTrack.Unk11h),a
		jr	zGetRawDuration
	endif

zAltFreqMode:
		ld	h,a
		ld	a,(de)
		inc	de
		ld	l,a
		or	h
		jr	z,.gotZero
		ld	a,(ix+zTrack.Transpose)
		ld	b,0
		or	a
		jp	p,.didSignExtend
		dec	b

.didSignExtend:
		ld	c,a
		add	hl,bc

.gotZero:
		ld	(ix+zTrack.FreqLow),l
		ld	(ix+zTrack.FreqHigh),h
		ld	a,(de)
		inc	de
		ld	(ix+zTrack.Unk11h),a

zGetRawDuration:
		ld	a,(de)

zGotNoteDuration:
		inc	de

zStoreDuration:
		call	zComputeNoteDuration
		ld	(ix+zTrack.SavedDuration),a

zFinishTrackUpdate:
		ld	(ix+zTrack.DataPointerLow),e
		ld	(ix+zTrack.DataPointerHigh),d
		ld	a,(ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout),a
		bit	1,(ix+zTrack.PlaybackControl)
		ret	nz
		xor	a
		ld	(ix+zTrack.ModEnvIndex),a
		ld	(ix+zTrack.ModEnvSens),a
		ld	(ix+zTrack.VolEnv),a
		ld	a,(ix+zTrack.NoteFillMaster)
		ld	(ix+zTrack.NoteFillTimeout),a
		ret

zComputeNoteDuration:
		ld	b,(ix+zTrack.TempoDivider)
		dec	b
		ret	z
		ld	c,a

.loop:
		add	a,c
		djnz	.loop
		ret

; =============== S U B	R O U T	I N E =======================================
; Reduces note duration timeout for current track.
;
; Input:   ix   Track data
; Output:  a    New duration
;sub_33A
	if ~~fix_sndbugs
zTrackRunTimer:
		; This is absurdly inefficient, since 'dec' can be ran directly on memory.
		ld	a, (ix+zTrack.DurationTimeout)	; Get track duration timeout
		dec	a				; Decrement it...
		ld	(ix+zTrack.DurationTimeout), a	; ... and save new value
		ret
; End of function zTrackRunTimer
	endif

zFMNoteOn:
		ld	a,(ix+zTrack.FreqLow)
		or	(ix+zTrack.FreqHigh)
		ret	z
		ld	a,(ix+zTrack.PlaybackControl)
	if fix_sndbugs
		and	16h				; Is either bit 4 ("track at rest") or 2 ("SFX overriding this track") or bit 1 ("do not attack next note") set?
	else
		and	6				; Is either bit 1 ("do not attack next note") or 2 ("SFX overriding this track") set?
	endif
		ret	nz
		ld	a,(ix+zTrack.VoiceControl)
		or	0F0h
		ld	c,a
		ld	a,28h
	if fix_sndbugs
		jp	zWriteFMI			; Send command to YM2612
	else
		call	zWriteFMI			; Send command to YM2612
		ret
	endif

zKeyOffIfActive:
		ld	a,(ix+zTrack.PlaybackControl)
		and	6
		ret	nz

zKeyOff:
		ld	c,(ix+zTrack.VoiceControl)
		bit	7,c
		ret	nz

zKeyOnOff:
		ld	a,28h
	if fix_sndbugs
		res	6, (ix+zTrack.PlaybackControl)	; From Dyna Brothers 2, but in a better place; clear flag to sustain frequency
		jp	zWriteFMI			; Send it
	else
		call	zWriteFMI			; Send it
		ret
	endif

zDoFMVolEnv:
		ld	a,(ix+zTrack.FMVolEnv)
		or	a
		ret	z
		ret	m
		dec	a
		ld	c,zID_VolEnvPointers
		rst	zGetPointerTable
		rst	zPointerTableOffset
		call	zDoVolEnv
		ld	h,(ix+zTrack.TLPtrHigh)
		ld	l,(ix+zTrack.TLPtrLow)
		ld	de,zFMInstrumentTLTable
		ld	b,zFMInstrumentTLTable_End-zFMInstrumentTLTable
		ld	c,(ix+zTrack.FMVolEnvMask)

.loop:
		push	af
		sra	c
		push	bc
		jr	nc,.skipReg
		add	a,(hl)
	if fix_sndbugs=0
		; This isn't actually needed
		and	7Fh				; Strip sign bit
	endif
		ld	c,a
		ld	a,(de)
		call	zWriteFMIorII

.skipReg:
		pop	bc
		inc	de
		inc	hl
		pop	af
		djnz	.loop
		ret

zPrepareModulation:
		bit	7,(ix+zTrack.ModulationCtrl)
		ret	z
		bit	1,(ix+zTrack.PlaybackControl)
		ret	nz
		ld	e,(ix+zTrack.ModulationPtrLow)
		ld	d,(ix+zTrack.ModulationPtrHigh)
		push	ix
		pop	hl
		ld	b,0
		ld	c,zTrack.ModulationWait
		add	hl,bc
		ex	de,hl
		ldi
		ldi
		ldi
		ld	a,(hl)
		srl	a
		ld	(de),a
		xor	a
		ld	(ix+zTrack.ModulationValLow),a
		ld	(ix+zTrack.ModulationValHigh),a
		ret

zDoModulation:
		ld	a,(ix+zTrack.ModulationCtrl)
		or	a
		ret	z
		cp	80h
		jr	nz,zDoModEnvelope
		dec	(ix+zTrack.ModulationWait)
		ret	nz
		inc	(ix+zTrack.ModulationWait)
		push	hl
		ld	l,(ix+zTrack.ModulationValLow)
		ld	h,(ix+zTrack.ModulationValHigh)
		ld	e,(ix+zTrack.ModulationPtrLow)
		ld	d,(ix+zTrack.ModulationPtrHigh)
		push	de
		pop	iy
		dec	(ix+zTrack.ModulationSpeed)
		jr	nz,.modSustain
		ld	a,(iy+1)
		ld	(ix+zTrack.ModulationSpeed),a
		ld	a,(ix+zTrack.ModulationDelta)
		ld	c,a
	if fix_sndbugs
		rla						; Carry contains sign of delta
		sbc	a, a					; a = 0 or -1 if carry is 0 or 1
	else
		and	80h					; Get only sign bit
		rlca						; Shift it into bit 0
		neg						; Negate (so it is either 0 or -1)
	endif
		ld	b,a
		add	hl,bc
		ld	(ix+zTrack.ModulationValLow),l
		ld	(ix+zTrack.ModulationValHigh),h

.modSustain:
		pop	bc
		add	hl,bc
		dec	(ix+zTrack.ModulationSteps)
		ret	nz
		ld	a,(iy+3)
		ld	(ix+zTrack.ModulationSteps),a
		ld	a,(ix+zTrack.ModulationDelta)
		neg
		ld	(ix+zTrack.ModulationDelta),a
		ret

zDoModEnvelope:
		dec	a
		ex	de,hl
		ld	c,zID_ModEnvPointers
		rst	zGetPointerTable
		rst	zPointerTableOffset
		jr	zDoModEnvelope_cont

zModEnvSetIndex:
		ld	(ix+zTrack.ModEnvIndex),a

zDoModEnvelope_cont:
		push	hl
		ld	c,(ix+zTrack.ModEnvIndex)
		ld	b,0
		add	hl,bc
	if fix_sndbugs
		ld	c, l
		ld	b, h
		ld	a, (bc)					; a = new modulation envelope value
	else
		ld	a, (hl)					; a = new modulation envelope value
	endif
		pop	hl
		bit	7,a
		jp	z,zPositiveModEnvMod
		cp	82h
		jr	z,zChangeModEnvIndex
		cp	80h
		jr	z,zResetModEnvMod
		cp	84h
		jr	z,zModEnvIncMultiplier
		ld	h,-1
		jr	nc,zApplyModEnvMod
		set	6,(ix+zTrack.PlaybackControl)
		pop	hl
		ret

zChangeModEnvIndex:
		inc	bc
		ld	a,(bc)
		jr	zModEnvSetIndex

zResetModEnvMod:
		xor	a
		jr	zModEnvSetIndex

zModEnvIncMultiplier:
		inc	bc
		ld	a,(bc)
		add	a,(ix+zTrack.ModEnvSens)
		ld	(ix+zTrack.ModEnvSens),a
		inc	(ix+zTrack.ModEnvIndex)
		inc	(ix+zTrack.ModEnvIndex)
		jr	zDoModEnvelope_cont

zPositiveModEnvMod:
		ld	h,0

zApplyModEnvMod:
		ld	l,a
		ld	b,(ix+zTrack.ModEnvSens)
		inc	b
		ex	de,hl

.loop:
		add	hl,de
		djnz	.loop
		inc	(ix+zTrack.ModEnvIndex)
		ret

zUpdateFreq:
		ld	h,(ix+zTrack.FreqHigh)
		ld	l,(ix+zTrack.FreqLow)
	if fix_sndbugs
		ld	a, (ix+zTrack.Detune)			; a = detune
		ld	c, a					; bc = sign extension of frequency displacement
		rla						; Carry contains sign of frequency displacement
		sbc	a, a					; a = 0 or -1 if carry is 0 or 1
		ld	b, a					; bc = sign extension of frequency displacement
	else
		ld	b, 0					; b = 0
		ld	a, (ix+zTrack.Detune)			; a = detune
		or	a					; Is a negative?
		jp	p, .did_sign_extend			; Branch if not
		ld	b, 0FFh					; b = -1

.did_sign_extend:
		ld	c, a					; bc = sign extension of frequency displacement
	endif
		add	hl,bc
		ret

zGetFMInstrumentPointer:
		ld	hl,(zVoiceTblPtr)
		ld	a,(zUpdatingSFX)
		or	a
		jr	z,zGetFMInstrumentOffset
		ld	l,(ix+zTrack.VoicesLow)
		ld	h,(ix+zTrack.VoicesHigh)

zGetFMInstrumentOffset:
		xor	a
		or	b
		ret	z
		ld	de,25

.loop:
		add	hl,de
		djnz	.loop
		ret

zFMInstrumentRegTable:
		db	0B0h
zFMInstrumentOperatorTable:
		db	30h
		db	38h
		db	34h
		db	3Ch
zFMInstrumentRSARTable:
		db	50h
		db	58h
		db	54h
		db	5Ch
zFMInstrumentAMD1RTable:
		db	60h
		db	68h
		db	64h
		db	6Ch
zFMInstrumentD2RTable:
		db	70h
		db	78h
		db	74h
		db	7Ch
zFMInstrumentD1LRRTable:
		db	80h
		db	88h
		db	84h
		db	8Ch
zFMInstrumentOperatorTable_End:

zFMInstrumentTLTable:
		db	40h
		db	48h
		db	44h
		db	4Ch
zFMInstrumentTLTable_End:

zFMInstrumentSSGEGTable:
		db	90h
		db	98h
		db	94h
		db	9Ch
zFMInstrumentSSGEGTable_End:


zSendFMInstrument:
		ld	de,zFMInstrumentRegTable
		ld	c,(ix+zTrack.AMSFMSPan)
		ld	a,0B4h
		call	zWriteFMIorII
		call	zSendFMInstrData
		ld	(ix+zTrack.FeedbackAlgo),a
		ld	b,zFMInstrumentOperatorTable_End-zFMInstrumentOperatorTable

.loop:
		call	zSendFMInstrData
		djnz	.loop
		ld	(ix+zTrack.TLPtrLow),l
		ld	(ix+zTrack.TLPtrHigh),h
		jp	zSendTL

zSendFMInstrData:
		ld	a,(de)
		inc	de
		ld	c,(hl)
		inc	hl
	if fix_sndbugs
		jp	zWriteFMIorII
	else
		call	zWriteFMIorII
		ret
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Play sound depending on the indexed entry
; ---------------------------------------------------------------------------

zCycleSoundQueue:
		ld	a,(zNextSound)			; get the first (and only) item in the queue

zPlaySoundByIndex:
		cp	cmd_SEGA
		jp	z,zPlaySegaSound
		cp	mus__End
		jp	c,zPlayMusic
		cp	sfx__End
		jp	c,zPlaySound
		cp	cmd__First
		jp	c,zStopAllSound
		cp	0F0h
		jp	nc,zStopAllSound
		sub	cmd__First
		ld	hl,zFadeEffects
		rst	zPointerTableOffset
		xor	a
		ld	(zSoundIndex),a			; set current sound index to 0
		jp	(hl)				; handle fade effect
; ---------------------------------------------------------------------------

zFadeEffects:
		dw	zFadeOutMusic
		dw	zStopAllSound
		dw	zPSGSilenceAll
		dw	zStopSFX
; ---------------------------------------------------------------------------

zStopSFX:
		ld	ix,zTracksSFXStart
		ld	b,(zTracksSFXEnd-zTracksSFXStart)/zTrack.len
		ld	a,1
		ld	(zUpdatingSFX),a

.loop:
		push	bc
		bit	7,(ix+zTrack.PlaybackControl)
		call	nz,zSilenceStopTrack
		ld	de,zTrack.len
		add	ix,de
		pop	bc
		djnz	.loop
	if fix_sndbugs
		jp	zClearNextSound
	else
		call	zClearNextSound
		ret
	endif

zSilenceStopTrack:
		push	hl
		push	hl
		jp	cfSilenceStopTrack

zPlayMusic:
		sub	mus__First
		ret	m
		push	af
		call	zStopAllSound
		pop	af
		push	af
		ld	hl,z80_MusicBanks
		add	a,l
		ld	l,a
		adc	a,h
		sub	l
		ld	h,a
		ld	(zloc_48B+1),hl

zloc_48B:
		ld	a,(z80_MusicBanks)
		ld	(zSongBank),a

		; music bankswitch
		ld	hl,zBankRegister
		bankswitchToMusic Snd_Bank1_Start
		ld	a,0B6h
		ld	(zYM2612_A1),a
		nop
		ld	a,0C0h
		ld	(zYM2612_D1),a
		pop	af
		ld	c,zID_MusicPointers
		rst	zGetPointerTable
		rst	zPointerTableOffset
		push	hl
		push	hl
		rst	zReadPointer
		ld	(zVoiceTblPtr),hl
		pop	hl
		pop	iy
		ld	a,(iy+5)
		ld	(zTempoAccumulator),a
		ld	(zCurrentTempo),a
		ld	de,6
		add	hl,de
		ld	(zSongPosition),hl
		ld	hl,zFMDACInitBytes
		ld	(zTrackInitPos),hl
		ld	de,zTracksStart
		ld	b,(iy+zTrack.TempoDivider)
		ld	a,(iy+zTrack.DataPointerHigh)

.FMDACLoop:
		push	bc
		ld	hl,(zTrackInitPos)
		ldi
		ldi
		ld	(de),a
		inc	de
		ld	(zTrackInitPos),hl
		ld	hl,(zSongPosition)
		ldi
		ldi
		ldi
		ldi
		ld	(zSongPosition),hl
		call	zInitFMDACTrack
		pop	bc
		djnz	.FMDACLoop
		ld	a,(iy+zTrack.DataPointerLow)
		or	a
		jp	z,zClearNextSound
		ld	b,a
		ld	hl,zPSGInitBytes
		ld	(zTrackInitPos),hl
		ld	de,zSongPSG1
		ld	a,(iy+zTrack.DataPointerHigh)

.PSGLoop:
		push	bc
		ld	hl,(zTrackInitPos)
		ldi
		ldi
		ld	(de),a
		inc	de
		ld	(zTrackInitPos),hl
		ld	hl,(zSongPosition)
		ld	bc,6
		ldir
		ld	(zSongPosition),hl
		call	zZeroFillTrackRAM
		pop	bc
		djnz	.PSGLoop

zClearNextSound:
		xor	a
		ld	(zNextSound),a
		ret

zFMDACInitBytes:
		db	80h,6
		db	80h,0
		db	80h,1
		db	80h,2
		db	80h,4
		db	80h,5
		db	80h,6

zPSGInitBytes:
		db	80h,80h
		db	80h,0A0h
		db	80h,0C0h

zPlaySound:
		sub	sfx__First
; Ring SFX patch below provided by ValleyBell.
; Originally used zSpecFM3FreqsSFX to make the rings alternate between speakers, a better method would be to use unused RAM as long as it's a byte in size.
;		or	a ; is it equal to sfx__First?
;		jr	nz,.notequ ; if not, branch
;		ld	a,(zRingSpeaker) ; load zRingSpeaker into a
;		xor	1 ; set a to 1
;		ld	(zRingSpeaker),a ; load a back into zRingSpeaker
;.notequ:
		ex	af,af'

		; sound bankswitch
		bankswitch SndBank

		xor	a
		ld	c,zID_SFXPointers
		ld	(zUpdatingSFX),a
		ex	af,af'
		rst	zGetPointerTable
		rst	zPointerTableOffset
		push	hl
		rst	zReadPointer
		ld	(zSFXVoiceTblPtr),hl
	if ~~fix_sndbugs
		xor	a
		ld	(unk_1C15),a
	endif
		pop	hl
		push	hl
		pop	iy
		ld	a,(iy+zTrack.TempoDivider)
		ld	(zSFXTempoDivider),a
		ld	de,4
		add	hl,de
		ld	b,(iy+zTrack.DataPointerLow)

zSFXTrackInitLoop:
		push	bc
		push	hl
		inc	hl
		ld	c,(hl)
		call	zGetSFXChannelPointers
		set	2,(hl)
		push	ix
		ld	a,(zUpdatingSFX)
		or	a
		jr	z,.normalSFX1
		pop	hl
		push	iy

.normalSFX1:
		pop	de
		pop	hl
		ldi
		ld	a,(de)
		cp	2
		call	z,zFM3NormalMode
		ldi
		ld	a,(zSFXTempoDivider)
		ld	(de),a
		inc	de
		ldi
		ldi
		ldi
		ldi
		call	zInitFMDACTrack
		bit	7,(ix+zTrack.PlaybackControl)
		jr	z,.dontOverride
		ld	a,(ix+zTrack.VoiceControl)
		cp	(iy+zTrack.VoiceControl)
		jr	nz,.dontOverride
		set	2,(iy+zTrack.PlaybackControl)

.dontOverride:
		push	hl              ; 0005BE E5
		ld	hl,(zSFXVoiceTblPtr)      ; 0005BF 2A 39 1C
		ld	a,(zUpdatingSFX)       ; 0005C2 3A 19 1C
		or	a               ; 0005C5 B7
		jr	z,.normalSFX2
		push	iy              ; 0005C8 FD E5
		pop	ix              ; 0005CA DD E1

.normalSFX2:
		ld	(ix+zTrack.VoicesLow),l      ; 0005CC DD 75 2A
		ld	(ix+zTrack.VoicesHigh),h      ; 0005CF DD 74 2B
		call	zKeyOffIfActive
		call	zFMClearSSGEGOps
		pop	hl              ; 0005D8 E1
		pop	bc              ; 0005D9 C1
		djnz	zSFXTrackInitLoop
		jp	zClearNextSound

zGetSFXChannelPointers:
		bit	7,c             ; 0005DF CB 79
		jr	nz,.isPSG
		ld	a,c             ; 0005E3 79
		bit	2,a             ; 0005E4 CB 57
		jr	z,.getPtrs
		dec	a               ; 0005E8 3D
		jr	.getPtrs

.isPSG:
		ld	a,1Fh           ; 0005EB 3E 1F
		call	zSilencePSGChannel
		ld	a,0FFh           ; 0005F0 3E FF
		ld	(zPSG),a       ; 0005F2 32 11 7F
		ld	a,c             ; 0005F5 79
		srl	a               ; 0005F6 CB 3F
		srl	a               ; 0005F8 CB 3F
		srl	a               ; 0005FA CB 3F
		srl	a               ; 0005FC CB 3F
		srl	a               ; 0005FE CB 3F
		add	a,2           ; 000600 C6 02

.getPtrs:
		sub	2             ; 000602 D6 02
		ld	(zSFXSaveIndex),a       ; 000604 32 32 1C
		push	af              ; 000607 F5
		ld	hl,zSFXChannelData
		rst	zPointerTableOffset
		push	hl              ; 00060C E5
		pop	ix              ; 00060D DD E1
		pop	af              ; 00060F F1
		ld	hl,zSFXOverriddenChannel
	if fix_sndbugs
		jp	zPointerTableOffset
	else
		rst	zPointerTableOffset
		ret
	endif

zInitFMDACTrack:
		ex	af,af'          ; 000615 08
		xor	a               ; 000616 AF
		ld	(de),a          ; 000617 12
		inc	de              ; 000618 13
		ld	(de),a          ; 000619 12
		inc	de              ; 00061A 13
		ex	af,af'          ; 00061B 08

zZeroFillTrackRAM:
		ex	de,hl           ; 00061C EB
		ld	(hl),zTrack.len       ; 00061D 36 30
		inc	hl              ; 00061F 23
		ld	(hl),0c0h        ; 000620 36 C0
		inc	hl              ; 000622 23
		ld	(hl),1        ; 000623 36 01
		ld	b,24h           ; 000625 06 24

.loop:
		inc	hl              ; 000627 23
		ld	(hl),0        ; 000628 36 00
		djnz	.loop
		inc	hl              ; 00062C 23
		ex	de,hl           ; 00062D EB
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
		ld	hl,zPauseFlag        ; 00064F 21 10 1C
		ld	a,(hl)          ; 000652 7E
		or	a               ; 000653 B7
		ret	z               ; 000654 C8
		jp	m,.unpause
		pop	de              ; 000658 D1
		dec	a               ; 000659 3D
		ret	nz              ; 00065A C0
		ld	(hl),2        ; 00065B 36 02
		jp	zPauseAudio

.unpause:
		xor	a               ; 000660 AF
		ld	(hl),a          ; 000661 77
		ld	a,(zFadeOutTimeout)       ; 000662 3A 0D 1C
		or	a               ; 000665 B7
		jp	nz,zStopAllSound
		ld	ix,zSongFM1        ; 000669 DD 21 70 1C
	if fix_sndbugs
		ld	b, (zSongPSG1-zSongFM1)/zTrack.len	; Number of FM tracks
	else
		; DANGER! This treats a PSG channel as if it were an FM channel. This
		; will break AMS/FMS/pan for FM1.
		ld	b, (zSongPSG2-zSongFM1)/zTrack.len	; Number of FM tracks +1
	endif

.FMLoop:
		ld	a,(zHaltFlag)       ; 00066F 3A 11 1C
		or	a               ; 000672 B7
		jr	nz,.setPan
		bit	7,(ix+zTrack.PlaybackControl)      ; 000675 DD CB 00 7E
		jr	z,.skipFMTrack

.setPan:
		ld	c,(ix+zTrack.AMSFMSPan)      ; 00067B DD 4E 0A
		ld	a,0B4h           ; 00067E 3E B4
		call	zWriteFMIorII

.skipFMTrack:
		ld	de,zTrack.len        ; 000683 11 30 00
		add	ix,de           ; 000686 DD 19
		djnz	.FMLoop

	if fix_sndbugs
		ld	ix, zTracksSFXStart		; Start at the start of SFX track data
		ld	b, (zTracksSFXEnd-zTracksSFXStart)/zTrack.len	; Number of tracks
	else
		; DANGER! This code goes past the end of Z80 RAM and into reserved territory!
		; By luck, it only *reads* from these areas...
		ld	ix, zTracksSFXEnd		; Start at the END of SFX track data (?)
		ld	b, 7				; But loop for 7 tracks (??)
	endif
.PSGLoop:
		bit	7,(ix+zTrack.PlaybackControl)      ; 000690 DD CB 00 7E
		jr	z,.skipPSG
		bit	7,(ix+zTrack.VoiceControl)      ; 000696 DD CB 01 7E
		jr	nz,.skipPSG
		ld	c,(ix+zTrack.AMSFMSPan)      ; 00069C DD 4E 0A
		ld	a,0B4h           ; 00069F 3E B4
		call	zWriteFMIorII

.skipPSG:
		ld	de,zTrack.len        ; 0006A4 11 30 00
		add	ix,de           ; 0006A7 DD 19
		djnz	.PSGLoop
		ret

zFadeOutMusic:
		ld	a,28h           ; 0006AC 3E 28
		ld	(zFadeOutTimeout),a       ; 0006AE 32 0D 1C
		ld	a,6           ; 0006B1 3E 06
		ld	(zFadeDelayTimeout),a       ; 0006B3 32 0F 1C
		ld	(zFadeDelay),a       ; 0006B6 32 0E 1C

zHaltDACPSG:
		xor	a               ; 0006B9 AF
		ld	(zSongFM6_DAC),a       ; 0006BA 32 40 1C
		ld	(zSongPSG3),a       ; 0006BD 32 C0 1D
		ld	(zSongPSG1),a       ; 0006C0 32 60 1D
		ld	(zSongPSG2),a       ; 0006C3 32 90 1D
		jp	zPSGSilenceAll

zDoMusicFadeOut:
		ld	hl,zFadeOutTimeout        ; 0006C9 21 0D 1C
		ld	a,(hl)          ; 0006CC 7E
		or	a               ; 0006CD B7
		ret	z               ; 0006CE C8
		call	m,zHaltDACPSG
		res	7,(hl)          ; 0006D2 CB BE
		ld	a,(zFadeDelayTimeout)       ; 0006D4 3A 0F 1C
		dec	a               ; 0006D7 3D
		jr	z,.timerExpired
		ld	(zFadeDelayTimeout),a       ; 0006DA 32 0F 1C
		ret

.timerExpired:
		ld	a,(zFadeDelay)       ; 0006DE 3A 0E 1C
		ld	(zFadeDelayTimeout),a       ; 0006E1 32 0F 1C
		ld	a,(zFadeOutTimeout)       ; 0006E4 3A 0D 1C
		dec	a               ; 0006E7 3D
		ld	(zFadeOutTimeout),a       ; 0006E8 32 0D 1C
		jr	z,zStopAllSound
		ld	a,(zSongBank)       ; 0006ED 3A 04 1C

		; music bankswitch
		ld	hl,zBankRegister        ; 0006F0 21 00 60
		bankswitchToMusic Snd_Bank1_Start
		ld	ix,zTracksStart        ; 000702 DD 21 40 1C
		ld	b,(zSongPSG1-zTracksStart)/zTrack.len           ; 000706 06 06

.loop:
		inc	(ix+zTrack.Volume)        ; 000708 DD 34 06
		jp	p,.chkChangeVolume
		dec	(ix+zTrack.Volume)        ; 00070E DD 35 06
		jr	.nextTrack

.chkChangeVolume:
		bit	7,(ix+zTrack.PlaybackControl)      ; 000713 DD CB 00 7E
		jr	z,.nextTrack
		bit	2,(ix+zTrack.PlaybackControl)      ; 000719 DD CB 00 56
		jr	nz,.nextTrack
		push	bc              ; 00071F C5
		call	zSendTL
		pop	bc              ; 000723 C1

.nextTrack:
		ld	de,zTrack.len        ; 000724 11 30 00
		add	ix,de           ; 000727 DD 19
		djnz	.loop
		ret

zStopAllSound:
		ld	hl,zTempVariablesStart
		ld	de,zTempVariablesStart+1
		ld	bc,zTempVariablesEnd-zTempVariablesStart-1
		ld	(hl),0        ; 000735 36 00
		ldir                   ; 000737 ED B0
		ld	ix,zFMDACInitBytes
		ld	b,6           ; 00073D 06 06

.loop:
		push	bc              ; 00073F C5
		call	zFMSilenceChannel
		call	zFMClearSSGEGOps
		inc	ix              ; 000746 DD 23
		inc	ix              ; 000748 DD 23
		pop	bc              ; 00074A C1
		djnz	.loop
		ld	b,7           ; 00074D 06 07
		xor	a               ; 00074F AF
		ld	(zFadeOutTimeout),a       ; 000750 32 0D 1C
		call	zPSGSilenceAll
		ld	c,0           ; 000756 0E 00
		ld	a,2Bh           ; 000758 3E 2B
		call	zWriteFMI

zFM3NormalMode:
		xor	a               ; 00075D AF
		ld	(zFM3Settings),a       ; 00075E 32 12 1C
		ld	c,a             ; 000761 4F
		ld	a,27h           ; 000762 3E 27
		call	zWriteFMI
		jp	zClearNextSound

zFMClearSSGEGOps:
		ld	a,90h           ; 00076A 3E 90
		ld	c,0           ; 00076C 0E 00
		jp	zFMOperatorWriteLoop

zPauseAudio:
		call	zPSGSilenceAll
		push	bc              ; 000774 C5
		push	af              ; 000775 F5
		ld	b,(zSongFM4-zSongFM1)/zTrack.len           ; 000776 06 03
		ld	a,0B4h           ; 000778 3E B4
		ld	c,0           ; 00077A 0E 00

.loop1:
		push	af              ; 00077C F5
		call	zWriteFMI
		pop	af              ; 000780 F1
		inc	a               ; 000781 3C
		djnz	.loop1
		ld	b,(zSongPSG1-zSongFM4)/zTrack.len          ; 000784 06 02
		ld	a,0B4h           ; 000786 3E B4

.loop2:
		push	af              ; 000788 F5
		call	zWriteFMII
		pop	af              ; 00078C F1
		inc	a               ; 00078D 3C
		djnz	.loop2
		ld	c,0           ; 000790 0E 00
		ld	b,(zSongPSG1-zSongFM1)/zTrack.len+1           ; 000792 06 06
		ld	a,28h           ; 000794 3E 28

.loop3:
		push	af              ; 000796 F5
		call	zWriteFMI
		inc	c               ; 00079A 0C
		pop	af              ; 00079B F1
		djnz	.loop3
		pop	af              ; 00079E F1
		pop	bc              ; 00079F C1

zPSGSilenceAll:
		push	bc              ; 0007A0 C5
		ld	b,4           ; 0007A1 06 04
		ld	a,9Fh           ; 0007A3 3E 9F

.loop:
		ld	(zPSG),a       ; 0007A5 32 11 7F
		add	a,20h           ; 0007A8 C6 20
		djnz	.loop
		pop	bc              ; 0007AC C1
		jp	zClearNextSound

zTempoWait:
		ld	a,(zCurrentTempo)       ; 0007B0 3A 05 1C
		ld	hl,zTempoAccumulator	   ; 0007B3 21 13 1C
		add	a,(hl)          ; 0007B6 86
		ld	(hl),a          ; 0007B7 77
		ret	nc              ; 0007B8 D0
		ld	hl,zTracksStart+zTrack.DurationTimeout
		ld	de,zTrack.len        ; 0007BC 11 30 00
		ld	b,(zTracksEnd-zTracksStart)/zTrack.len           ; 0007BF 06 09

.loop:
		inc	(hl)            ; 0007C1 34
		add	hl,de           ; 0007C2 19
		djnz	.loop
		ret

zDoUpdate:
	if ~~fix_sndbugs
		ld	a,r             ; 0007C6 ED 5F
		ld	(unk_1C17),a       ; 0007C8 32 17 1C
	endif
		ld	de,zTempVariablesStart+1        ; 0007CB 11 0A 1C
		call	zloc_7D4
		call	zloc_7D4

zloc_7D4:
		ld	a,(de)          ; 0007D4 1A
		or	a               ; 0007D5 B7
		ret	z               ; 0007D6 C8
		sub	mus__First             ; 0007D7 D6 01
		ld	c,zID_PriorityList
		rst	zGetPointerTable
		ld	c,a             ; 0007DC 4F
		ld	b,0           ; 0007DD 06 00
		add	hl,bc           ; 0007DF 09
		ld	a,(zSoundIndex)       ; 0007E0 3A 18 1C
		cp	(hl)            ; 0007E3 BE
		jr	z,.skip
		jr	nc,.skip2

.skip:
		ld	a,(de)          ; 0007E8 1A
		ld	(zNextSound),a       ; 0007E9 32 09 1C
		ld	a,(hl)          ; 0007EC 7E
		and	7Fh             ; 0007ED E6 7F
		ld	(zSoundIndex),a       ; 0007EF 32 18 1C

.skip2:
		xor	a               ; 0007F2 AF
		ld	(de),a          ; 0007F3 12
		inc	de              ; 0007F4 13
		ret

zFMSilenceChannel:
		call	zSetMaxRelRate
		ld	a,40h           ; 0007F9 3E 40
		ld	c,7Fh           ; 0007FB 0E 7F
		call	zFMOperatorWriteLoop
		ld	c,(ix+zTrack.VoiceControl)      ; 000800 DD 4E 01
		jp	zKeyOnOff

zSetMaxRelRate:
		ld	a,80h           ; 000806 3E 80
		ld	c,0FFh           ; 000808 0E FF

zFMOperatorWriteLoop:
		ld	b,4           ; 00080A 06 04

.loop:
		push	af              ; 00080C F5
		call	zWriteFMIorII
		pop	af              ; 000810 F1
		add	a,4           ; 000811 C6 04
		djnz	.loop
		ret

zPlaySegaSound:
		ld	a,1           ; 000816 3E 01
		ld	(zPlaySegaPCMFlag),a       ; 000818 32 07 1C
		pop	hl              ; 00081B E1
		ret

zPSGFrequencies:
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3FFh
		dw	3F7h
		dw	3BEh
		dw	388h
		dw	356h
		dw	326h
		dw	2F9h
		dw	2CEh
		dw	2A5h
		dw	280h
		dw	25Ch
		dw	23Ah
		dw	21Ah
		dw	1FBh
		dw	1DFh
		dw	1C4h
		dw	1ABh
		dw	193h
		dw	17Dh
		dw	167h
		dw	153h
		dw	140h
		dw	12Eh
		dw	11Dh
		dw	10Dh
		dw	0FEh
		dw	0EFh
		dw	0E2h
		dw	0D6h
		dw	0C9h
		dw	0BEh
		dw	0B4h
		dw	0A9h
		dw	0A0h
		dw	97h
		dw	8Fh
		dw	87h
		dw	7Fh
		dw	78h
		dw	71h
		dw	6Bh
		dw	65h
		dw	5Fh
		dw	5Ah
		dw	55h
		dw	50h
		dw	4Bh
		dw	47h
		dw	43h
		dw	40h
		dw	3Ch
		dw	39h
		dw	36h
		dw	33h
		dw	30h
		dw	2Dh
		dw	2Bh
		dw	28h
		dw	26h
		dw	24h
		dw	22h
		dw	20h
		dw	1Fh
		dw	1Dh
		dw	1Bh
		dw	1Ah
		dw	18h
		dw	17h
		dw	16h
		dw	15h
		dw	13h
		dw	12h
		dw	11h
		dw	10h
		dw	0
		dw	0

zFMFrequencies:
		dw	284h
		dw	2ABh
		dw	2D3h
		dw	2FEh
		dw	32Dh
		dw	35Ch
		dw	38Fh
		dw	3C5h
		dw	3FFh
		dw	43Ch
		dw	47Ch
		dw	4C0h

; ---------------------------------------------------------------------------
; ===========================================================================
; MUSIC BANKS
; ===========================================================================

zmakeSongBanks macro
		irp op,ALLARGS
			db zmakeSongBank(op)
		endm
	endm

z80_MusicBanks:
	zmakeSongBanks	Angel_Island_1_Snd_Data
	zmakeSongBanks	Angel_Island_2_Snd_Data
	zmakeSongBanks	Hydrocity_1_Snd_Data
	zmakeSongBanks	Hydrocity_2_Snd_Data
	zmakeSongBanks	Marble_Garden_1_Snd_Data
	zmakeSongBanks	Marble_Garden_2_Snd_Data
	zmakeSongBanks	Carnival_Night_1_Snd_Data
	zmakeSongBanks	Carnival_Night_2_Snd_Data
	zmakeSongBanks	Flying_Battery_1_Snd_Data
	zmakeSongBanks	Flying_Battery_2_Snd_Data
	zmakeSongBanks	Icecap_1_Snd_Data
	zmakeSongBanks	Icecap_2_Snd_Data
	zmakeSongBanks	Launch_Base_1_Snd_Data
	zmakeSongBanks	Launch_Base_2_Snd_Data
	zmakeSongBanks	Mushroom_Valley_1_Snd_Data
	zmakeSongBanks	Mushroom_Valley_2_Snd_Data
	zmakeSongBanks	Sandopolis_1_Snd_Data
	zmakeSongBanks	Sandopolis_2_Snd_Data
	zmakeSongBanks	Lava_Reef_1_Snd_Data
	zmakeSongBanks	Lava_Reef_2_Snd_Data
	zmakeSongBanks	Sky_Sanctuary_Snd_Data
	zmakeSongBanks	Death_Egg_1_Snd_Data
	zmakeSongBanks	Death_Egg_2_Snd_Data
	zmakeSongBanks	Mini_Boss_Snd_Data
	zmakeSongBanks	Boss_Snd_Data
	zmakeSongBanks	The_Doomsday_Snd_Data
	zmakeSongBanks	Glowing_Spheres_Bonus_Stage_Snd_Data
	zmakeSongBanks	Special_Stage_Snd_Data
	zmakeSongBanks	Slot_Machine_Bonus_Stage_Snd_Data
	zmakeSongBanks	Gumball_Machine_Bonus_Stage_Snd_Data
	zmakeSongBanks	Knuckles_Theme_Snd_Data
	zmakeSongBanks	Azure_Lake_Snd_Data
	zmakeSongBanks	Balloon_Park_Snd_Data
	zmakeSongBanks	Desert_Palace_Snd_Data
	zmakeSongBanks	Chrome_Gadget_Snd_Data
	zmakeSongBanks	Endless_Mine_Snd_Data
	zmakeSongBanks	Title_Screen_Snd_Data
	zmakeSongBanks	Credits_Snd_Data
	zmakeSongBanks	Time_Game_Over_Snd_Data
	zmakeSongBanks	Continue_Snd_Data
	zmakeSongBanks	Level_Results_Snd_Data
	zmakeSongBanks	Extra_Life_Snd_Data
	zmakeSongBanks	Got_Emerald_Snd_Data
	zmakeSongBanks	Invincibility_Snd_Data
	zmakeSongBanks	Competition_Menu_Snd_Data
	zmakeSongBanks	Super_Sonic_Theme_Snd_Data
	zmakeSongBanks	Data_Select_Menu_Snd_Data
	zmakeSongBanks	Final_Boss_Snd_Data
	zmakeSongBanks	Panic_Snd_Data

zUpdateDACTrack:
	if fix_sndbugs
		dec	(ix+zTrack.DurationTimeout)	; Run note timer
	else
		call	zTrackRunTimer			; Run note timer
	endif
		ret	nz
		ld	e,(ix+zTrack.DataPointerLow)
		ld	d,(ix+zTrack.DataPointerHigh)

zUpdateDACTrack_cont:
		ld	a,(de)
		inc	de
		cp	0E0h
		jp	nc,zHandleDACCoordFlag
		or	a
		jp	m,.gotSample
		dec	de
		ld	a,(ix+zTrack.FreqLow)

.gotSample:
		ld	(ix+zTrack.FreqLow),a
		cp	80h
		jp	z,zUpdateDACTrack_GetDuration
		res	7,a
		push	de
		ex	af,af'
		call	zKeyOffIfActive
		call	zFM3NormalMode
		ex	af,af'
		ld	(zDACIndex),a
		pop	de

zUpdateDACTrack_GetDuration:
		ld	a,(de)
		inc	de
		or	a
		jp	p,zStoreDuration
		dec	de
		ld	a,(ix+zTrack.SavedDuration)
		ld	(ix+zTrack.DurationTimeout),a
		jp	zFinishTrackUpdate

zHandleDACCoordFlag:
		ld	hl,zloc_954
		jp	zHandleCoordFlag

zloc_954:
		inc	de
		jp	zUpdateDACTrack_cont

zHandleFMorPSGCoordFlag:
		ld	hl,zloc_964

zHandleCoordFlag:
		push	hl
		sub	0E0h
		ld	hl,zCoordFlagSwitchTable
		rst	zPointerTableOffset
		ld	a,(de)
		jp	(hl)

zloc_964:
		inc	de
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
		ld	(zDACIndex),a       ; 0009B6 32 06 1C
		ret

cfPanningAMSFMS:
		ld	c,3Fh           ; 0009BA 0E 3F

zDoChangePan:
		ld	a,(ix+zTrack.AMSFMSPan)      ; 0009BC DD 7E 0A
		and	c               ; 0009BF A1
		push	de              ; 0009C0 D5
		ex	de,hl           ; 0009C1 EB
		or	(hl)            ; 0009C2 B6
		ld	(ix+zTrack.AMSFMSPan),a      ; 0009C3 DD 77 0A
		ld	c,a             ; 0009C6 4F
		ld	a,0B4h           ; 0009C7 3E B4
		call	zWriteFMIorII
		pop	de              ; 0009CC D1
		ret

cfSpindashRev:
		ld	a,(ix+zTrack.ModulationCtrl)
		or	a
		ret	z
		set	7,(ix+zTrack.ModulationCtrl)
		dec	de
		ret

cfDetune:
		ld	(ix+zTrack.Detune),a
		ret

cfFadeInToPrevious:
		ld	(zFadeToPrevFlag),a
		ret

cfSilenceStopTrack:
		call	zFMSilenceChannel
		jp	cfStopTrack

cfSetVolume:
		bit	7,(ix+zTrack.VoiceControl)
		jr	z,.notPSG
		srl	a
		srl	a
		srl	a
		xor	0Fh
		and	0Fh
		jp	zStoreTrackVolume

.notPSG:
		xor	7Fh
		and	7Fh
		ld	(ix+zTrack.Volume),a
		jr	zSendTL

cfChangeVolume2:
		inc	de
		ld	a,(de)

cfChangeVolume:
		bit	7,(ix+zTrack.VoiceControl)
		ret	nz
		add	a,(ix+zTrack.Volume)
		jp	p,.setVol
		jp	pe,.underflow
		xor	a
		jp	.setVol

.underflow:
		ld	a,7Fh

.setVol:
		ld	(ix+zTrack.Volume),a

zSendTL:
		push	de
		ld	de,zFMInstrumentTLTable        ; 000A1D 11 F3 03
		ld	l,(ix+zTrack.TLPtrLow)      ; 000A20 DD 6E 1C
		ld	h,(ix+zTrack.TLPtrHigh)      ; 000A23 DD 66 1D
		ld	b,zFMInstrumentTLTable_End-zFMInstrumentTLTable           ; 000A26 06 04

.loop:
		ld	a,(hl)          ; 000A28 7E
		or	a               ; 000A29 B7
		jp	p,.skipTrackVol
		add	a,(ix+zTrack.Volume)      ; 000A2D DD 86 06

.skipTrackVol:
		and	7Fh             ; 000A30 E6 7F
		ld	c,a             ; 000A32 4F
		ld	a,(de)          ; 000A33 1A
		call	zWriteFMIorII
		inc	de              ; 000A37 13
		inc	hl              ; 000A38 23
		djnz	.loop
		pop	de              ; 000A3B D1
		ret	                ; 000A3C C9

cfPreventAttack:
		set	1,(ix+zTrack.PlaybackControl)      ; 000A3D DD CB 00 CE
		dec	de              ; 000A41 1B
		ret

cfNoteFill:
		call	zComputeNoteDuration
		ld	(ix+zTrack.NoteFillTimeout),a      ; 000A46 DD 77 1E
		ld	(ix+zTrack.NoteFillMaster),a      ; 000A49 DD 77 1F
		ret

cfConditionalJump:
		inc	de              ; 000A4D 13
		add	a,zTrack.LoopCounters           ; 000A4E C6 28
		ld	c,a             ; 000A50 4F
		ld	b,0           ; 000A51 06 00
		push	ix              ; 000A53 DD E5
		pop	hl              ; 000A55 E1
		add	hl,bc           ; 000A56 09
		ld	a,(hl)          ; 000A57 7E
		dec	a               ; 000A58 3D
		jp	z,.doJump
		inc	de              ; 000A5C 13
		ret

.doJump:
		xor	a               ; 000A5E AF
		ld	(hl),a          ; 000A5F 77
		jp	cfJumpTo

cfChangePSGVolume:
		bit	7,(ix+zTrack.VoiceControl)      ; 000A63 DD CB 01 7E
		ret	z               ; 000A67 C8
		res	4,(ix+zTrack.PlaybackControl)      ; 000A68 DD CB 00 A6
		dec	(ix+zTrack.VolEnv)        ; 000A6C DD 35 17
		add	a,(ix+zTrack.Volume)      ; 000A6F DD 86 06
		cp	0Fh             ; 000A72 FE 0F
		jp	c,zStoreTrackVolume
		ld	a,0Fh           ; 000A77 3E 0F

zStoreTrackVolume:
		ld	(ix+zTrack.Volume),a      ; 000A79 DD 77 06
		ret

cfSetKey:
		sub	40h             ; 000A7D D6 40
		ld	(ix+zTrack.Transpose),a      ; 000A7F DD 77 05
		ret

cfSendFMI:
		call	zGetFMParams
	if fix_sndbugs
		jp	zWriteFMI
	else
		call	zWriteFMI
		ret
	endif

zGetFMParams:
		ex	de,hl           ; 000A8A EB
		ld	a,(hl)          ; 000A8B 7E
		inc	hl              ; 000A8C 23
		ld	c,(hl)          ; 000A8D 4E
		ex	de,hl           ; 000A8E EB
		ret

cfSetVoice:
		bit	7,(ix+zTrack.VoiceControl)      ; 000A90 DD CB 01 7E
		jr	nz,zSetVoicePSG
		call	zSetMaxRelRate
		ld	a,(de)          ; 000A99 1A
		ld	(ix+zTrack.VoiceIndex),a      ; 000A9A DD 77 08
		or	a               ; 000A9D B7
		jp	p,zSetVoiceUpload
		inc	de              ; 000AA1 13
		ld	a,(de)          ; 000AA2 1A
		ld	(ix+zTrack.VoiceSongID),a      ; 000AA3 DD 77 0F

zSetVoiceUploadAlter:
		push	de              ; 000AA6 D5
		ld	a,(ix+zTrack.VoiceSongID)      ; 000AA7 DD 7E 0F
		sub	81h             ; 000AAA D6 81
		ld	c,zID_MusicPointers
		rst	zGetPointerTable
		rst	zPointerTableOffset
		rst	zReadPointer
		ld	a,(ix+zTrack.VoiceIndex)      ; 000AB1 DD 7E 08
		and	7Fh             ; 000AB4 E6 7F
		ld	b,a             ; 000AB6 47
		call	zGetFMInstrumentOffset
		jr	zSetVoiceDoUpload

zSetVoiceUpload:
		push	de              ; 000ABC D5
		ld	b,a             ; 000ABD 47
		call	zGetFMInstrumentPointer

zSetVoiceDoUpload:
		call	zSendFMInstrument
		pop	de              ; 000AC4 D1
		ret

zSetVoicePSG:
		or	a               ; 000AC6 B7
		jp	p,cfStoreNewVoice
		inc	de              ; 000ACA 13
		jp	cfStoreNewVoice
	if ~~fix_sndbugs
		; unused
		ret
	endif

cfModulation:
		ld	(ix+zTrack.ModulationPtrLow),e      ; 000ACF DD 73 20
		ld	(ix+zTrack.ModulationPtrHigh),d      ; 000AD2 DD 72 21
		ld	(ix+zTrack.ModulationCtrl),80h    ; 000AD5 DD 36 07 80
		inc	de              ; 000AD9 13
		inc	de              ; 000ADA 13
		inc	de              ; 000ADB 13
		ret

cfAlterModulation:
		inc	de              ; 000ADD 13
		bit	7,(ix+zTrack.VoiceControl)      ; 000ADE DD CB 01 7E
		jr	nz,cfSetModulation
		ld	a,(de)          ; 000AE4 1A

cfSetModulation:
		inc	a               ; 000AE5 3C
		ld	(ix+zTrack.ModulationCtrl),a      ; 000AE6 DD 77 07
		ret

cfStopTrack:
		res	7,(ix+zTrack.PlaybackControl)      ; 000AEA DD CB 00 BE
	if ~~fix_sndbugs
		ld	a,1Fh           ; 000AEE 3E 1F
		ld	(unk_1C15),a       ; 000AF0 32 15 1C
	endif
		call	zKeyOffIfActive
		ld	c,(ix+zTrack.VoiceControl)      ; 000AF6 DD 4E 01
		push	ix              ; 000AF9 DD E5
		call	zGetSFXChannelPointers
		ld	a,(zUpdatingSFX)       ; 000AFE 3A 19 1C
		or	a               ; 000B01 B7
		jr	z,zStopCleanExit
		xor	a               ; 000B04 AF
		ld	(zSoundIndex),a       ; 000B05 32 18 1C
		push	hl              ; 000B08 E5
		ld	hl,(zVoiceTblPtr)      ; 000B09 2A 37 1C
		pop	ix              ; 000B0C DD E1
		res	2,(ix+zTrack.PlaybackControl)      ; 000B0E DD CB 00 96
		bit	7,(ix+zTrack.VoiceControl)      ; 000B12 DD CB 01 7E
		jr	nz,zStopPSGTrack
		bit	7,(ix+zTrack.PlaybackControl)      ; 000B18 DD CB 00 7E
		jr	z,zStopCleanExit
		ld	a,2           ; 000B1E 3E 02
		cp	(ix+zTrack.VoiceControl)        ; 000B20 DD BE 01
		jr	nz,.notFM3
		ld	a,4Fh           ; 000B25 3E 4F
		bit	0,(ix+zTrack.PlaybackControl)      ; 000B27 DD CB 00 46
		jr	nz,.doFM3Settings
		and	0Fh             ; 000B2D E6 0F

.doFM3Settings:
		call	zWriteFM3Settings

.notFM3:
		ld	a,(ix+zTrack.VoiceIndex)      ; 000B32 DD 7E 08
		or	a               ; 000B35 B7
		jp	p,.switchToMusic
		call	zSetVoiceUploadAlter
		jr	.sendSSGEG

.switchToMusic:
		ld	b,a             ; 000B3E 47
		push	hl              ; 000B3F E5

		; music bankswitch
		ld	hl,zBankRegister        ; 000B40 21 00 60
		ld	a,(zSongBank)       ; 000B43 3A 04 1C
		bankswitchToMusic Snd_Bank1_Start
		pop	hl              ; 000B55 E1
		call	zGetFMInstrumentOffset
		call	zSendFMInstrument
	if fix_sndbugs
		bankswitch SndBank
	else
		; there SHOULD be a sound bankswitch here, but it's missing; this is
		; what causes all the sound glitches to happen
	endif
		ld	a,(ix+zTrack.FMVolEnv)      ; 000B5C DD 7E 18
		or	a               ; 000B5F B7
		jp	p,zStopCleanExit
		ld	e,(ix+zTrack.SSGEGPointerLow)      ; 000B63 DD 5E 19
		ld	d,(ix+zTrack.SSGEGPointerHigh)      ; 000B66 DD 56 1A

.sendSSGEG:
		call	zSendSSGEGData

zStopCleanExit:
		pop	ix              ; 000B6C DD E1
		pop	hl              ; 000B6E E1
		pop	hl              ; 000B6F E1
		ret

zStopPSGTrack:
		bit	0,(ix+zTrack.PlaybackControl)      ; 000B71 DD CB 00 46
		jr	z,zStopCleanExit
		ld	a,(ix+zTrack.PSGNoise)      ; 000B77 DD 7E 1A
		or	a               ; 000B7A B7
		jp	p,.skipCommand
		ld	(zPSG),a       ; 000B7E 32 11 7F

.skipCommand:
		jr	zStopCleanExit

cfSetPSGNoise:
	if fix_sndbugs
		bit	7, (ix+zTrack.VoiceControl)	; Is this a PSG track?
		ret	z				; Return if not
		ld	(ix+zTrack.PSGNoise), a		; Store to track RAM
		set	0, (ix+zTrack.PlaybackControl)	; Mark PSG track as being noise
		or	a				; Test noise value
		ld	a, 0DFh				; Command to silence PSG3
		jr	nz, .skip_noise_silence		; If nonzero, branch
		res	0, (ix+zTrack.PlaybackControl)	; Otherwise, mark track as not being a noise channel
		ld	a, 0FFh				; Command to silence the noise channel

.skip_noise_silence:
		bit	2, (ix+zTrack.PlaybackControl)	; Is SFX overriding this track?
		ret	nz				; Return if yes
		ld	(zPSG), a			; Execute it
		ld	a, (de)				; Get PSG noise value
		ld	(zPSG), a			; Send command to PSG
	else
		bit	2, (ix+zTrack.VoiceControl)	; Is this a channel bound for part II (FM4, FM5, FM6/DAC)?
		ret	nz				; Return if yes
		ld	a, 0DFh				; Command to silence PSG3
		ld	(zPSG), a			; Execute it
		ld	a, (de)				; Get PSG noise value
		ld	(ix+zTrack.PSGNoise), a		; Store to track RAM
		set	0, (ix+zTrack.PlaybackControl)	; Mark PSG track as being noise
		or	a				; Test noise value
		jr	nz, .skip_noise_silence		; If nonzero, branch
		res	0, (ix+zTrack.PlaybackControl)	; Otherwise, mark track as not being a noise channel
		ld	a, 0FFh				; Command to silence the noise channel
.skip_noise_silence:
		ld	(zPSG), a			; Send command to PSG
	endif
		ret

cfSetPSGVolEnv:
		bit	7,(ix+zTrack.VoiceControl)      ; 000BA2 DD CB 01 7E
		ret	z               ; 000BA6 C8

cfStoreNewVoice:
		ld	(ix+zTrack.VoiceIndex),a      ; 000BA7 DD 77 08
		ret	                ; 000BAA C9

cfJumpTo:
		ex	de,hl           ; 000BAB EB
		ld	e,(hl)          ; 000BAC 5E
		inc	hl              ; 000BAD 23
		ld	d,(hl)          ; 000BAE 56
		dec	de              ; 000BAF 1B
		ret

cfRepeatAtPos:
		inc	de              ; 000BB1 13
		add	a,zTrack.LoopCounters           ; 000BB2 C6 28
		ld	c,a             ; 000BB4 4F
		ld	b,0           ; 000BB5 06 00
		push	ix              ; 000BB7 DD E5
		pop	hl              ; 000BB9 E1
		add	hl,bc           ; 000BBA 09
		ld	a,(hl)          ; 000BBB 7E
		or	a               ; 000BBC B7
		jr	nz,.runCounter
		ld	a,(de)          ; 000BBF 1A
		ld	(hl),a          ; 000BC0 77

.runCounter:
		inc	de              ; 000BC1 13
		dec	(hl)            ; 000BC2 35
		jp	nz,cfJumpTo
		inc	de              ; 000BC6 13
		ret

cfJumpToGosub:
		ld	c,a             ; 000BC8 4F
		inc	de              ; 000BC9 13
		ld	a,(de)          ; 000BCA 1A
		ld	b,a             ; 000BCB 47
		push	bc              ; 000BCC C5
		push	ix              ; 000BCD DD E5
		pop	hl              ; 000BCF E1
		dec	(ix+zTrack.StackPointer)        ; 000BD0 DD 35 09
		ld	c,(ix+zTrack.StackPointer)      ; 000BD3 DD 4E 09
		dec	(ix+zTrack.StackPointer)        ; 000BD6 DD 35 09
		ld	b,0           ; 000BD9 06 00
		add	hl,bc           ; 000BDB 09
		ld	(hl),d          ; 000BDC 72
		dec	hl              ; 000BDD 2B
		ld	(hl),e          ; 000BDE 73
		pop	de              ; 000BDF D1
		dec	de              ; 000BE0 1B
		ret

cfJumpReturn:
		push	ix              ; 000BE2 DD E5
		pop	hl              ; 000BE4 E1
		ld	c,(ix+zTrack.StackPointer)      ; 000BE5 DD 4E 09
		ld	b,0           ; 000BE8 06 00
		add	hl,bc           ; 000BEA 09
		ld	e,(hl)          ; 000BEB 5E
		inc	hl              ; 000BEC 23
		ld	d,(hl)          ; 000BED 56
		inc	(ix+zTrack.StackPointer)        ; 000BEE DD 34 09
		inc	(ix+zTrack.StackPointer)        ; 000BF1 DD 34 09
		ret

cfDisableModulation:
		res	7,(ix+zTrack.ModulationCtrl)      ; 000BF5 DD CB 07 BE
		dec	de              ; 000BF9 1B
		ret

cfChangeTransposition:
		add	a,(ix+zTrack.Transpose)      ; 000BFB DD 86 05
		ld	(ix+zTrack.Transpose),a      ; 000BFE DD 77 05
		ret

cfSpecialSFX:
		ret

cfToggleAltFreqMode:
	if fix_sndbugs
		or	a				; Is parameter equal to 0?
		jr	z, .stop_altfreq_mode		; Branch if so
	else
		cp	1				; Is parameter equal to 1?
		jr	nz, .stop_altfreq_mode		; Branch if not
	endif
		set	3,(ix+zTrack.PlaybackControl)      ; 000C07 DD CB 00 DE
		ret

.stop_altfreq_mode:
		res	3,(ix+zTrack.PlaybackControl)      ; 000C0C DD CB 00 9E
		ret

cfFM3SpecialMode:
		ld	a,(ix+zTrack.VoiceControl)      ; 000C11 DD 7E 01
		cp	2             ; 000C14 FE 02
		jr	nz,zTrackSkip3bytes
		set	0,(ix+zTrack.PlaybackControl)      ; 000C18 DD CB 00 C6
		ex	de,hl           ; 000C1C EB
		call	zGetSpecialFM3DataPointer
		ld	b,4           ; 000C20 06 04

.loop:
		push	bc              ; 000C22 C5
		ld	a,(hl)          ; 000C23 7E
		inc	hl              ; 000C24 23
		push	hl              ; 000C25 E5
		ld	hl,zFM3FreqShiftTable
		add	a,a             ; 000C29 87
		ld	c,a             ; 000C2A 4F
		ld	b,0           ; 000C2B 06 00
		add	hl,bc           ; 000C2D 09
		ldi                    ; 000C2E ED A0
		ldi                    ; 000C30 ED A0
		pop	hl              ; 000C32 E1
		pop	bc              ; 000C33 C1
		djnz	.loop
		ex	de,hl           ; 000C36 EB
		dec	de              ; 000C37 1B
		ld	a,4Fh           ; 000C38 3E 4F

zWriteFM3Settings:
	if ~~fix_sndbugs
		ld	(zFM3Settings),a       ; 000C3A 32 12 1C
	endif
		ld	c,a             ; 000C3D 4F
		ld	a,27h           ; 000C3E 3E 27
	if fix_sndbugs
		jp	zWriteFMI
	else
		call	zWriteFMI
		ret
	endif

zTrackSkip3bytes:
		inc	de              ; 000C44 13
		inc	de              ; 000C45 13
		inc	de              ; 000C46 13
		ret

zFM3FreqShiftTable:
		dw	0
		dw	132h
		dw	18Eh
		dw	1E4h
		dw	234h
		dw	27Eh
		dw	2C2h
		dw	2F0h

cfMetaCF:
		ld	hl,zExtraCoordFlagSwitchTable
		rst	zPointerTableOffset
		inc	de              ; 000C5C 13
		ld	a,(de)          ; 000C5D 1A
		jp	(hl)            ; 000C5E E9

cfSetTempo:
		ld	(zCurrentTempo),a       ; 000C5F 32 05 1C
		ret

cfPlaySoundByIndex:
		push	ix              ; 000C63 DD E5
		call	zPlaySoundByIndex
		pop	ix              ; 000C68 DD E1
		ret

cfHaltSound:
		ld	(zHaltFlag),a       ; 000C6B 32 11 1C
		or	a               ; 000C6E B7
		jr	z,.resume
		push	ix              ; 000C71 DD E5
		push	de              ; 000C73 D5
		ld	ix,zTracksStart        ; 000C74 DD 21 40 1C
		ld	b,(zTracksEnd-zTracksStart)/zTrack.len           ; 000C78 06 09
		ld	de,zTrack.len        ; 000C7A 11 30 00

.loop:
		res	7,(ix+zTrack.PlaybackControl)      ; 000C7D DD CB 00 BE
		call	zKeyOff
		add	ix,de           ; 000C84 DD 19
		djnz	.loop
		pop	de              ; 000C88 D1
		pop	ix              ; 000C89 DD E1
		jp	zPSGSilenceAll

.resume:
		push	ix              ; 000C8E DD E5
		push	de              ; 000C90 D5
		ld	ix,zTracksStart        ; 000C91 DD 21 40 1C
		ld	b,(zTracksEnd-zTracksStart)/zTrack.len           ; 000C95 06 09
		ld	de,zTrack.len        ; 000C97 11 30 00

.loop2:
		set	7,(ix+zTrack.PlaybackControl)      ; 000C9A DD CB 00 FE
		add	ix,de           ; 000C9E DD 19
		djnz	.loop2
		pop	de              ; 000CA2 D1
		pop	ix              ; 000CA3 DD E1
		ret

cfCopyData:
		ex	de,hl           ; 000CA6 EB
		ld	e,(hl)          ; 000CA7 5E
		inc	hl              ; 000CA8 23
		ld	d,(hl)          ; 000CA9 56
		inc	hl              ; 000CAA 23
		ld	c,(hl)          ; 000CAB 4E
		ld	b,0           ; 000CAC 06 00
		inc	hl              ; 000CAE 23
		ex	de,hl           ; 000CAF EB
		ldir                   ; 000CB0 ED B0
		dec	de              ; 000CB2 1B
		ret

cfSetTempoDivider:
		ld	b,(zTracksEnd-zTracksStart)/zTrack.len           ; 000CB4 06 09
		ld	hl,zTracksStart+zTrack.TempoDivider        ; 000CB6 21 42 1C

.loop:
		push	bc              ; 000CB9 C5
		ld	bc,zTrack.len        ; 000CBA 01 30 00
		ld	(hl),a          ; 000CBD 77
		add	hl,bc           ; 000CBE 09
		pop	bc              ; 000CBF C1
		djnz	.loop
		ret

cfSetSSGEG:
		ld	(ix+zTrack.FMVolEnv),80h    ; 000CC3 DD 36 18 80
		ld	(ix+zTrack.SSGEGPointerLow),e      ; 000CC7 DD 73 19
		ld	(ix+zTrack.SSGEGPointerHigh),d      ; 000CCA DD 72 1A

zSendSSGEGData:
		; DANGER! The following code ignores the fact that SSG-EG mode must be
		; used with maximum (1Fh) attack rate or output is officially undefined.
		; This has the potential effect of weird sound, even in real hardware.
	if fix_sndbugs
		; This fix is even better than what is done in Ristar's sound driver:
		; we preserve rate scaling, whereas that driver sets it to 0.
		ld	l, (ix+zTrack.TLPtrLow)				; l = low byte of pointer to TL data
		ld	h, (ix+zTrack.TLPtrHigh)			; hl = pointer to TL data
		ld	bc, zFMInstrumentRSARTable-zFMInstrumentTLTable	; bc = -10h
		add	hl, bc						; hl = pointer to RS/AR data
		push	hl						; Save hl (**)
	endif
		ld	hl,zFMInstrumentSSGEGTable
		ld	b,zFMInstrumentSSGEGTable_End-zFMInstrumentSSGEGTable

.loop:
		ld	a,(de)          ; 000CD2 1A
		inc	de              ; 000CD3 13
		ld	c,a             ; 000CD4 4F
		ld	a,(hl)          ; 000CD5 7E
	if fix_sndbugs
		call	zWriteFMIorII	; Send data to correct channel
		ex	(sp), hl	; Save hl, hl = pointer to RS/AR data (see line marked (**) above)
		ld	a, (hl)		; a = RS/AR value for operator
		inc	hl		; Advance pointer
		ex	(sp), hl	; Save hl, hl = pointer to registers for SSG-EG data
		or	1Fh		; Set AR to maximum, but keep RS intact
		ld	c, a		; c = RS/AR
		ld	a, (hl)		; a = register to send to
		sub	40h		; Convert into command to set RS/AR
	endif
		inc	hl              ; 000CD6 23
		call	zWriteFMIorII
		djnz	.loop
	if fix_sndbugs
		pop	hl		; Remove from stack (see line marked (**) above)
	endif
		dec	de              ; 000CDC 1B
		ret

cfFMVolEnv:
		ld	(ix+zTrack.FMVolEnv),a      ; 000CDE DD 77 18
		inc	de              ; 000CE1 13
		ld	a,(de)          ; 000CE2 1A
		ld	(ix+zTrack.FMVolEnvMask),a      ; 000CE3 DD 77 19
		ret	                ; 000CE6 C9

zUpdatePSGTrack:
	if fix_sndbugs
		dec	(ix+zTrack.DurationTimeout)	; Run note timer
	else
		call	zTrackRunTimer			; Run note timer
	endif
		jr	nz,.noteGoing
		call	zGetNextNote
		bit	4,(ix+zTrack.PlaybackControl)      ; 000CEF DD CB 00 66
		ret	nz              ; 000CF3 C0
		call	zPrepareModulation
		jr	.skipFill

.noteGoing:
		ld	a,(ix+zTrack.NoteFillTimeout)      ; 000CF9 DD 7E 1E
		or	a               ; 000CFC B7
		jr	z,.skipFill
		dec	(ix+zTrack.NoteFillTimeout)        ; 000CFF DD 35 1E
		jp	z,zRestTrack

.skipFill:
		call	zUpdateFreq
		call	zDoModulation
		bit	2,(ix+zTrack.PlaybackControl)      ; 000D0B DD CB 00 56
		ret	nz              ; 000D0F C0
		ld	c,(ix+zTrack.VoiceControl)      ; 000D10 DD 4E 01
		ld	a,l             ; 000D13 7D
		and	0Fh             ; 000D14 E6 0F
		or	c               ; 000D16 B1
		ld	(zPSG),a       ; 000D17 32 11 7F
		ld	a,l             ; 000D1A 7D
		and	0F0h             ; 000D1B E6 F0
		or	h               ; 000D1D B4
		rrca                   ; 000D1E 0F
		rrca                   ; 000D1F 0F
		rrca                   ; 000D20 0F
		rrca                   ; 000D21 0F
		ld	(zPSG),a       ; 000D22 32 11 7F
		ld	a,(ix+zTrack.VoiceIndex)      ; 000D25 DD 7E 08
		or	a               ; 000D28 B7
		ld	c,0           ; 000D29 0E 00
		jr	z,.noVolEnv
		dec	a               ; 000D2D 3D
		ld	c,zID_VolEnvPointers
		rst	zGetPointerTable
		rst	zPointerTableOffset
		call	zDoVolEnv
		ld	c,a             ; 000D35 4F

.noVolEnv:
		bit	4,(ix+zTrack.PlaybackControl)      ; 000D36 DD CB 00 66
		ret	nz              ; 000D3A C0
		ld	a,(ix+zTrack.Volume)      ; 000D3B DD 7E 06
		add	a,c             ; 000D3E 81
		bit	4,a             ; 000D3F CB 67
		jr	z,.noUnderflow
		ld	a,0Fh           ; 000D43 3E 0F

.noUnderflow:
		or	(ix+zTrack.VoiceControl)        ; 000D45 DD B6 01
		add	a,10h           ; 000D48 C6 10
		bit	0,(ix+zTrack.PlaybackControl)      ; 000D4A DD CB 00 46
	if fix_sndbugs
		jr	z, .not_noise			; Branch if not
		add	a, 20h				; Change to noise channel
.not_noise:
		ld	(zPSG), a			; Set noise channel volume
		ret
	else
		jr	nz, .set_noise			; Branch if yes
		ld	(zPSG), a			; Set PSG volume
		ret
; ---------------------------------------------------------------------------
.set_noise:
		add	a, 20h				; Change to noise channel
		ld	(zPSG), a			; Set noise channel volume
		ret
	endif

zDoVolEnvSetValue:
		ld	(ix+zTrack.VolEnv),a      ; 000D5A DD 77 17

zDoVolEnv:
		push	hl              ; 000D5D E5
		ld	c,(ix+zTrack.VolEnv)      ; 000D5E DD 4E 17
		ld	b,0           ; 000D61 06 00
		add	hl,bc           ; 000D63 09
	if fix_sndbugs
		ld	c, l
		ld	b, h
		ld	a, (bc)				; a = PSG volume envelope
	else
		ld	a, (hl)				; a = PSG flutter value
	endif
		pop	hl              ; 000D65 E1
		bit	7,a             ; 000D66 CB 7F
		jr	z,zDoVolEnvAdvance
		cp	83h             ; 000D6A FE 83
		jr	z,zDoVolEnvFullRest
		cp	81h             ; 000D6E FE 81
		jr	z,zDoVolEnvRest
		cp	80h             ; 000D72 FE 80
		jr	z,zDoVolEnvReset
		inc	bc              ; 000D76 03
		ld	a,(bc)          ; 000D77 0A
		jr	zDoVolEnvSetValue

zDoVolEnvFullRest:
	if ~~fix_sndbugs
		set	4,(ix+zTrack.PlaybackControl)      ; 000D7A DD CB 00 E6
	endif
		pop	hl              ; 000D7E E1
		jp	zRestTrack

zDoVolEnvReset:
		xor	a               ; 000D82 AF
		jr	zDoVolEnvSetValue

zDoVolEnvRest:
		pop	hl              ; 000D85 E1
		set	4,(ix+zTrack.PlaybackControl)      ; 000D86 DD CB 00 E6
		ret	                ; 000D8A C9

zDoVolEnvAdvance:
		inc	(ix+zTrack.VolEnv)        ; 000D8B DD 34 17
		ret	                ; 000D8E C9

zRestTrack:
		set	4,(ix+zTrack.PlaybackControl)      ; 000D8F DD CB 00 E6
		bit	2,(ix+zTrack.PlaybackControl)      ; 000D93 DD CB 00 56
		ret	nz              ; 000D97 C0

zSilencePSGChannel:
		ld	a,1Fh           ; 000D98 3E 1F
		add	a,(ix+zTrack.VoiceControl)      ; 000D9A DD 86 01
		or	a               ; 000D9D B7
		ret	p               ; 000D9E F0
		ld	(zPSG),a       ; 000D9F 32 11 7F
	if fix_sndbugs
		cp	0DFh				; Was this PSG3?
		ret	nz				; Return if not
	else
		; This does not work as intended: since this function is called when
		; a new channel is starting, this bit will almost inevitably be 0
		; and the noise channel will not be silenced.
		bit	0, (ix+zTrack.PlaybackControl)	; Is this a noise channel?
		ret	z				; Return if not
	endif
		ld	a,0FFh           ; 000DA7 3E FF
		ld	(zPSG),a       ; 000DA9 32 11 7F
		ret	                ; 000DAC C9

zPlayDigitalAudio:
		di                     ; 000DAD F3
		ld	a,2Bh           ; 000DAE 3E 2B
		ld	c,0           ; 000DB0 0E 00
		call	zWriteFMI

.DACIdleLoop:
		ei                     ; 000DB5 FB
		ld	a,(zPlaySegaPCMFlag)       ; 000DB6 3A 07 1C
		or	a               ; 000DB9 B7
		jp	nz,zPlaySEGAPCM
		ld	a,(zDACIndex)       ; 000DBD 3A 06 1C
		or	a               ; 000DC0 B7
		jr	z,.DACIdleLoop
		ld	a,2Bh           ; 000DC3 3E 2B
		ld	c,80h           ; 000DC5 0E 80
		di                     ; 000DC7 F3
		call	zWriteFMI
		ei                     ; 000DCB FB
		ld	iy,DecTable
		ld	hl,zDACIndex        ; 000DD0 21 06 1C
		ld	a,(hl)          ; 000DD3 7E
		dec	a               ; 000DD4 3D
		set	7,(hl)          ; 000DD5 CB FE
		ld	hl,zROMWindow        ; 000DD7 21 00 80
		rst	zPointerTableOffset
		ld	c,80h           ; 000DDB 0E 80
		ld	a,(hl)          ; 000DDD 7E
		ld	(.sample1Rate+1),a
		ld	(.sample2Rate+1),a
		inc	hl              ; 000DE4 23
		ld	e,(hl)          ; 000DE5 5E
		inc	hl              ; 000DE6 23
		ld	d,(hl)          ; 000DE7 56
		inc	hl              ; 000DE8 23
		ld	a,(hl)          ; 000DE9 7E
		inc	hl              ; 000DEA 23
		ld	h,(hl)          ; 000DEB 66
		ld	l,a             ; 000DEC 6F

.DACPlaybackLoop:
.sample1Rate:
		ld	b,0Ah           ; 000DED 06 0A
		ei                     ; 000DEF FB
		djnz	$
		di                     ; 000DF2 F3
		ld	a,2Ah           ; 000DF3 3E 2A
		ld	(zYM2612_A0),a       ; 000DF5 32 00 40
		ld	a,(hl)          ; 000DF8 7E
		rlca                   ; 000DF9 07
		rlca                   ; 000DFA 07
		rlca                   ; 000DFB 07
		rlca                   ; 000DFC 07
		and	0Fh             ; 000DFD E6 0F
		ld	(.sample1Index+2),a
		ld	a,c             ; 000E02 79

.sample1Index:
		add	a,(iy+0)      ; 000E03 FD 86 00
		ld	(zYM2612_D0),a       ; 000E06 32 01 40
		ld	c,a             ; 000E09 4F

.sample2Rate:
		ld	b,0Ah           ; 000E0A 06 0A
		ei                     ; 000E0C FB
		djnz	$
		di                     ; 000E0F F3
		ld	a,2Ah           ; 000E10 3E 2A
		ld	(zYM2612_A0),a       ; 000E12 32 00 40
		ld	a,(hl)          ; 000E15 7E
		and	0Fh             ; 000E16 E6 0F
		ld	(.sample2Index+2),a
		ld	a,c             ; 000E1B 79

.sample2Index:
		add	a,(iy+0)      ; 000E1C FD 86 00
		ld	(zYM2612_D0),a       ; 000E1F 32 01 40
		ei                     ; 000E22 FB
		ld	c,a             ; 000E23 4F
		ld	a,(zDACIndex)       ; 000E24 3A 06 1C
		or	a               ; 000E27 B7
		jp	p,.DACIdleLoop
		inc	hl              ; 000E2B 23
		dec	de              ; 000E2C 1B
		ld	a,d             ; 000E2D 7A
		or	e               ; 000E2E B3
		jp	nz,.DACPlaybackLoop
		xor	a               ; 000E32 AF
		ld	(zDACIndex),a       ; 000E33 32 06 1C
		jp	zPlayDigitalAudio

DecTable:
		db	0
		db	1
		db	2
		db	4
		db	8
		db	10h
		db	20h
		db	40h
		db	80h
		db	-1
		db	-2
		db	-4
		db	-8
		db	-10h
		db	-20h
		db	-40h

zPlaySEGAPCM:
		di
		ld	a,2Bh
		ld	(zYM2612_A0),a
	if ~~fix_sndbugs
		nop
	endif
		ld	a,80h
		ld	(zYM2612_D0),a

		; Sega PCM bankswitch
		bankswitch SEGABank
		ld	hl,zmake68kPtr(SEGA_PCM_Data)
		ld	de,SEGA_PCM_Data_End-SEGA_PCM_Data
		ld	a,2Ah
		ld	(zYM2612_A0),a

.loop:
		ld	a,(hl)
		ld	(zYM2612_D0),a
		ld	b,0Dh
		djnz	$
		inc	hl
		dec	de
		ld	a,d
		or	e
		jp	nz,.loop
		xor	a
		ld	(zPlaySegaPCMFlag),a
		call	zStopAllSound
		jp	zPlayDigitalAudio

	if ~~fix_sndbugs
		binclude	"data\z80_unknown.bin"
	endif

	if $ > 1200h
		fatal "Your Z80 code won't fit before its tables. It's \{$-1200h}h bytes past the start of music data \{1200h}h"
	endif

; zloc_1200:
z80_SoundDriverPointers:
		dw	z80_SoundPriority		; in the final, this is a duplicate of z80_MusicPointers
		dw	Z80_Driver_End-Z80_Driver	; in the final, this is used by the Universal Voice Bank
		dw	z80_MusicPointers
		dw	z80_SFXPointers
		dw	z80_ModEnvPointers
		dw	z80_VolEnvPointers
		dw	mus__End				; song limit, not actually used

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

ModEnv_00:	db	40h, 60h, 70h, 60h, 50h, 30h, 10h,-10h,-30h,-50h,-70h, 83h
ModEnv_01:	db	0, 2, 4, 6, 8, 0Ah, 0Ch, 0Eh, 10h, 12h, 14h, 18h, 81h
ModEnv_02:	db	0, 0, 1, 3, 1, 0,-1,-3,-1, 0, 82h, 2
ModEnv_03:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		db	0, 0, 0, 0, 0, 0, 0, 0, 2, 4, 6, 8, 0Ah, 0Ch, 0Ah, 8
		db	6, 4, 2, 0,-2,-4,-6,-8,-0Ah,-0Ch,-0Ah,-8,-6,-4,-2, 0
		db	82h, 29h
ModEnv_04:	db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   2,   4,   6,   8
		db  0Ah, 0Ch, 0Ah,   8,   6,   4,   2,   0,-2,-4,-6,-8,-0Ah,-0Ch,-0Ah,-8
		db -6,-4,-2, 82h, 1Bh
ModEnv_05:	db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    0,   0,   3,   6,   3,   0,-3,-6,-6,-3,   0, 82h, 33h
ModEnv_06:	db    0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    2,   4,   2,   0,-2,-4,-2,   0, 82h, 11h
ModEnv_07:	db -2,-1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
		db    0,   0,   1,   1,   0,   0,-1,-1, 82h, 11h
ModEnv_08:	db    3,   2,   1,   0,   0,   0,   1, 81h
ModEnv_09:	db    0,   0,   0,   0,   1,   1,   1,   1,   2,   2,   1,   1,   1,   0,   0,   0
		db  84h,   1, 82h,   4
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
		dw	0F5h
		dw	26h

VolEnv_00:	db	2, 83h
VolEnv_01:	db	0, 2, 4, 6, 8, 10h, 83h
VolEnv_02:	db	2, 1, 0, 0, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
		db	2, 3, 3, 3, 4, 4, 4, 5, 81h
VolEnv_03:	db	0, 0, 2, 3, 4, 4, 5, 5, 5, 6, 6, 81h
VolEnv_04:	db	3, 0, 1, 1, 1, 2, 3, 4, 4, 5, 81h
VolEnv_05:	db	0, 0, 1, 1, 2, 3, 4, 5, 5, 6, 8, 7, 7, 6, 81h
VolEnv_06:	db	1, 0Ch, 3, 0Fh, 2, 7, 3, 0Fh, 80h
VolEnv_07:	db	0, 0, 0, 2, 3, 3, 4, 5, 6, 7, 8, 9, 0Ah, 0Bh, 0Eh, 0Fh
		db	83h
VolEnv_08:	db	3, 2, 1, 1, 0, 0, 1, 2, 3, 4, 81h
VolEnv_09:	db	1, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4
		db	4, 4, 5, 5, 81h
VolEnv_0A:	db	10h, 20h, 30h, 40h, 30h, 20h, 10h, 0,-10h, 80h
VolEnv_0B:	db	0, 0, 1, 1, 3, 3, 4, 5, 83h
VolEnv_0C:	db	0, 81h
VolEnv_0D:	db	2, 83h
VolEnv_0E:	db	0, 2, 4, 6, 8, 10h, 83h
VolEnv_0F:	db	9, 9, 9, 8, 8, 8, 7, 7, 7, 6, 6, 6, 5, 5, 5, 4
		db	4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1, 0, 0, 0, 81h
VolEnv_10:	db	1, 1, 1, 0, 0, 0, 81h
VolEnv_11:	db	3, 0, 1, 1, 1, 2, 3, 4, 4, 5, 81h
VolEnv_12:	db	0, 0, 1, 1, 2, 3, 4, 5, 5, 6, 8, 7, 7, 6, 81h
VolEnv_13:	db	0Ah, 5, 0, 4, 8, 83h
VolEnv_14:	db	0, 0, 0, 2, 3, 3, 4, 5, 6, 7, 8, 9, 0Ah, 0Bh, 0Eh, 0Fh
		db	83h
VolEnv_15:	db	3, 2, 1, 1, 0, 0, 1, 2, 3, 4, 81h
VolEnv_16:	db	1, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4
		db	4, 4, 5, 5, 81h
VolEnv_17:	db	10h, 20h, 30h, 40h, 30h, 20h, 10h, 0, 10h, 20h, 30h, 40h, 30h, 20h, 10h, 0
		db	10h, 20h, 30h, 40h, 30h, 20h, 10h, 0, 80h
VolEnv_18:	db	0, 0, 1, 1, 3, 3, 4, 5, 83h
VolEnv_19:	db	0, 2, 4, 6, 8, 16h, 83h
VolEnv_1A:	db	0, 0, 1, 1, 3, 3, 4, 5, 83h
VolEnv_1B:	db	4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1
		db	83h
VolEnv_1C:	db	0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3
		db	4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7
		db	8, 8, 8, 8, 9, 9, 9, 9, 0Ah, 0Ah, 0Ah, 0Ah, 81h
VolEnv_1D:	db	0, 0Ah, 83h
VolEnv_1E:	db	0, 2, 4, 81h
VolEnv_1F:	db	30h, 20h, 10h, 0, 0, 0, 0, 0, 8, 10h, 20h, 30h, 81h
VolEnv_20:	db	0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 8, 8
		db	0Ah, 83h
VolEnv_21:	db	0, 2, 3, 4, 6, 7, 81h
VolEnv_22:	db	2, 1, 0, 0, 0, 2, 4, 7, 81h
VolEnv_23:	db	0Fh, 1, 5, 83h
VolEnv_24:	db	8, 6, 2, 3, 4, 5, 6, 7, 8, 9, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh
		db	10h, 83h
VolEnv_25:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1
		db	1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3
		db	3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4
		db	4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6
		db	6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
		db	8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9
		db	9, 9, 9, 9, 83h

z80_SoundPriority:
		db  80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h, 80h	; $01 - $0F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $10 - $1F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $20 - $2F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $30 - $3F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $40 - $4F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $50 - $5F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $60 - $6F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $70 - $7F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $80 - $8F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $90 - $9F
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $A0 - $AF
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $B0 - $BF
		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $C0 - $CF
		; This table is missing entries $D0 to $FF. Uncomment the lines below to fix this.
;		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $D0 - $DF
;		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $E0 - $EF
;		db  7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh	; $F0 - $FF

zmake68kPtrs macro
		irp op,ALLARGS
			dw zmake68kPtr(op)
		endm
	endm

z80_MusicPointers:
		zmake68kPtrs Angel_Island_1_Snd_Data	; $01
		zmake68kPtrs Angel_Island_2_Snd_Data	; $02
		zmake68kPtrs Hydrocity_1_Snd_Data	; $03
		zmake68kPtrs Hydrocity_2_Snd_Data	; $04
		zmake68kPtrs Marble_Garden_1_Snd_Data	; $05
		zmake68kPtrs Marble_Garden_2_Snd_Data	; $06
		zmake68kPtrs Carnival_Night_1_Snd_Data	; $07
		zmake68kPtrs Carnival_Night_2_Snd_Data	; $08
		zmake68kPtrs Flying_Battery_1_Snd_Data	; $09
		zmake68kPtrs Flying_Battery_2_Snd_Data	; $0A
		zmake68kPtrs Icecap_1_Snd_Data	; $0B
		zmake68kPtrs Icecap_2_Snd_Data	; $0C
		zmake68kPtrs Launch_Base_1_Snd_Data	; $0D
		zmake68kPtrs Launch_Base_2_Snd_Data	; $0E
		zmake68kPtrs Mushroom_Valley_1_Snd_Data	; $0F
		zmake68kPtrs Mushroom_Valley_2_Snd_Data	; $10
		zmake68kPtrs Sandopolis_1_Snd_Data	; $11
		zmake68kPtrs Sandopolis_2_Snd_Data	; $12
		zmake68kPtrs Lava_Reef_1_Snd_Data	; $13
		zmake68kPtrs Lava_Reef_2_Snd_Data	; $14
		zmake68kPtrs Sky_Sanctuary_Snd_Data	; $15
		zmake68kPtrs Death_Egg_1_Snd_Data	; $16
		zmake68kPtrs Death_Egg_2_Snd_Data	; $17
		zmake68kPtrs Mini_Boss_Snd_Data	; $18
		zmake68kPtrs Boss_Snd_Data	; $19
		zmake68kPtrs The_Doomsday_Snd_Data	; $1A
		zmake68kPtrs Glowing_Spheres_Bonus_Stage_Snd_Data	; $1B
		zmake68kPtrs Special_Stage_Snd_Data	; $1C
		zmake68kPtrs Slot_Machine_Bonus_Stage_Snd_Data	; $1D
		zmake68kPtrs Gumball_Machine_Bonus_Stage_Snd_Data	; $1E
		zmake68kPtrs Knuckles_Theme_Snd_Data	; $1F
		zmake68kPtrs Azure_Lake_Snd_Data	; $20
		zmake68kPtrs Balloon_Park_Snd_Data	; $21
		zmake68kPtrs Desert_Palace_Snd_Data	; $22
		zmake68kPtrs Chrome_Gadget_Snd_Data	; $23
		zmake68kPtrs Endless_Mine_Snd_Data	; $24
		zmake68kPtrs Title_Screen_Snd_Data	; $25
		zmake68kPtrs Credits_Snd_Data	; $26
		zmake68kPtrs Time_Game_Over_Snd_Data	; $27
		zmake68kPtrs Continue_Snd_Data	; $28
		zmake68kPtrs Level_Results_Snd_Data	; $29
		zmake68kPtrs Extra_Life_Snd_Data	; $2A
		zmake68kPtrs Got_Emerald_Snd_Data	; $2B
		zmake68kPtrs Invincibility_Snd_Data	; $2C
		zmake68kPtrs Competition_Menu_Snd_Data	; $2D
		zmake68kPtrs Super_Sonic_Theme_Snd_Data	; $2E
		zmake68kPtrs Data_Select_Menu_Snd_Data	; $2F
		zmake68kPtrs Final_Boss_Snd_Data	; $30
		zmake68kPtrs Panic_Snd_Data	; $31

z80_SFXPointers:
		zmake68kPtrs Ring_Sfx_Data    ; $32
		zmake68kPtrs Ring_Left_Speaker_Sfx_Data    ; $33
		zmake68kPtrs Ring_Lost_Sfx_Data    ; $34
		zmake68kPtrs Hurt_Sfx_Data    ; $35
		zmake68kPtrs Skidding_Sfx_Data    ; $36
		zmake68kPtrs Spike_Hurt_Sfx_Data    ; $37
		zmake68kPtrs Collect_Oxygen_Sfx_Data    ; $38
		zmake68kPtrs Water_Splash_Sfx_Data    ; $39
		zmake68kPtrs Got_Classic_Shield_Sfx_Data    ; $3A
		zmake68kPtrs Drowning_Sfx_Data    ; $3B
		zmake68kPtrs Rolling_Sfx_Data    ; $3C
		zmake68kPtrs Object_Hit_Sfx_Data    ; $3D
		zmake68kPtrs Got_Fire_Shield_Sfx_Data    ; $3E
		zmake68kPtrs Got_Water_Shield_Sfx_Data    ; $3F
		zmake68kPtrs Offset_0x0EC2D1    ; $40
		zmake68kPtrs Got_Lightning_Shield_Sfx_Data    ; $41
		zmake68kPtrs Offset_0x0EC317    ; $42
		zmake68kPtrs Fire_Shield_Sfx_Data    ; $43
		zmake68kPtrs Offset_0x0EC34A    ; $44
		zmake68kPtrs Offset_0x0EC377    ; $45
		zmake68kPtrs Hyper_Form_Change_Sfx_Data    ; $46
		zmake68kPtrs Offset_0x0EC3CC    ; $47
		zmake68kPtrs Offset_0x0EC3EC    ; $48
		zmake68kPtrs Offset_0x0EC414    ; $49
		zmake68kPtrs Grab_Sfx_Data    ; $4A
		zmake68kPtrs Offset_0x0EC438    ; $4B
		zmake68kPtrs Offset_0x0EC460    ; $4C
		zmake68kPtrs Offset_0x0EC483    ; $4D
		zmake68kPtrs Offset_0x0EC498    ; $4E
		zmake68kPtrs Waterfall_Splash_Sfx_Data    ; $4F
		zmake68kPtrs Offset_0x0EC4F1    ; $50
		zmake68kPtrs Projectile_Sfx_Data    ; $51
		zmake68kPtrs Missile_Explosion_Sfx_Data    ; $52
		zmake68kPtrs Flame_Sfx_Data    ; $53
		zmake68kPtrs Flying_Battery_Move_Sfx_Data    ; $54
		zmake68kPtrs Offset_0x0EC5D1    ; $55
		zmake68kPtrs Missile_Throw_Sfx_Data    ; $56
		zmake68kPtrs Robotnik_Buzzer_Sfx_Data    ; $57
		zmake68kPtrs Spike_Move_Sfx_Data    ; $58
		zmake68kPtrs Offset_0x0EC68E    ; $59
		zmake68kPtrs Offset_0x0EC6CE    ; $5A
		zmake68kPtrs Offset_0x0EC711    ; $5B
		zmake68kPtrs Draw_Bridge_Move_Sfx_Data    ; $5C
		zmake68kPtrs Geyser_Sfx_Data    ; $5D
		zmake68kPtrs Fan_Big_Sfx_Data    ; $5E
		zmake68kPtrs Offset_0x0EC794    ; $5F
		zmake68kPtrs Offset_0x0EC7C5    ; $60
		zmake68kPtrs Offset_0x0EC7DD    ; $61
		zmake68kPtrs Smash_Sfx_Data    ; $62
		zmake68kPtrs Offset_0x0EC852    ; $63
		zmake68kPtrs Switch_Blip_Sfx_Data    ; $64
		zmake68kPtrs Offset_0x0EC88C    ; $65
		zmake68kPtrs Offset_0x0EC89B    ; $66
		zmake68kPtrs Offset_0x0EC8C3    ; $67
		zmake68kPtrs Floor_Thump_Sfx_Data    ; $68
		zmake68kPtrs Offset_0x0EC922    ; $69
		zmake68kPtrs Offset_0x0EC94A    ; $6A
		zmake68kPtrs Offset_0x0EC97C    ; $6B
		zmake68kPtrs Crash_Sfx_Data    ; $6C
		zmake68kPtrs Offset_0x0EC9BF    ; $6D
		zmake68kPtrs Offset_0x0ECA00    ; $6E
		zmake68kPtrs Offset_0x0ECA00    ; $6F
		zmake68kPtrs Jump_Sfx_Data    ; $70
		zmake68kPtrs Offset_0x0ECA47    ; $71
		zmake68kPtrs Offset_0x0ECA71    ; $72
		zmake68kPtrs Offset_0x0ECA90    ; $73
		zmake68kPtrs Offset_0x0ECAC2    ; $74
		zmake68kPtrs Level_Projectile_Sfx_Data    ; $75
		zmake68kPtrs Offset_0x0ECB23    ; $76
		zmake68kPtrs Offset_0x0ECB52    ; $77
		zmake68kPtrs Offset_0x0ECB7F    ; $78
		zmake68kPtrs Underwater_Sfx_Data    ; $79
		zmake68kPtrs Offset_0x0ECBC4    ; $7A
		zmake68kPtrs Offset_0x0ECC05    ; $7B
		zmake68kPtrs Boss_Hit_Sfx_Data    ; $7C
		zmake68kPtrs Offset_0x0ECC58    ; $7D
		zmake68kPtrs Offset_0x0ECC8E    ; $7E
		zmake68kPtrs Offset_0x0ECCD8    ; $7F
		zmake68kPtrs Hoverpad_Sfx_Data    ; $80
		zmake68kPtrs Transporter_Sfx_Data    ; $81
		zmake68kPtrs Tunnel_Booster_Sfx_Data    ; $82
		zmake68kPtrs Rising_Platform_Sfx_Data    ; $83
		zmake68kPtrs Wave_Hover_Sfx_Data    ; $84
		zmake68kPtrs Trapdoor_Sfx_Data    ; $85
		zmake68kPtrs Balloon_Pop_Sfx_Data    ; $86
		zmake68kPtrs Cannon_Turn_Sfx_Data    ; $87
		zmake68kPtrs Offset_0x0ECE99    ; $88
		zmake68kPtrs Offset_0x0ECEC6    ; $89
		zmake68kPtrs Offset_0x0ECF11    ; $8A
		zmake68kPtrs Small_Bumper_Sfx_Data    ; $8B
		zmake68kPtrs Offset_0x0ECF75    ; $8C
		zmake68kPtrs Offset_0x0ECFA6    ; $8D
		zmake68kPtrs Offset_0x0ECFD3    ; $8E
		zmake68kPtrs Offset_0x0ECFE4    ; $8F
		zmake68kPtrs Offset_0x0ECFFC    ; $90
		zmake68kPtrs Frost_Puff_Sfx_Data    ; $91
		zmake68kPtrs Ice_Spike_Sfx_Data    ; $92
		zmake68kPtrs Offset_0x0ED07F    ; $93
		zmake68kPtrs Offset_0x0ED0B2    ; $94
		zmake68kPtrs Tube_Launcher_Sfx_Data    ; $95
		zmake68kPtrs Offset_0x0ED12F    ; $96
		zmake68kPtrs Bridge_Collapse_Sfx_Data    ; $97
		zmake68kPtrs Offset_0x0ED199    ; $98
		zmake68kPtrs Offset_0x0ED1D1    ; $99
		zmake68kPtrs Offset_0x0ED1FE    ; $9A
		zmake68kPtrs Buzzer_Sfx_Data    ; $9B
		zmake68kPtrs Offset_0x0ED258    ; $9C
		zmake68kPtrs Offset_0x0ED288    ; $9D
		zmake68kPtrs Offset_0x0ED2AE    ; $9E
		zmake68kPtrs Offset_0x0ED2D4    ; $9F
		zmake68kPtrs Offset_0x0ED30A    ; $A0
		zmake68kPtrs Offset_0x0ED337    ; $A1
		zmake68kPtrs Offset_0x0ED344    ; $A2
		zmake68kPtrs Offset_0x0ED378    ; $A3
		zmake68kPtrs Offset_0x0ED3AE    ; $A4
		zmake68kPtrs Offset_0x0ED3E2    ; $A5
		zmake68kPtrs Offset_0x0ED413    ; $A6
		zmake68kPtrs Offset_0x0ED42D    ; $A7
		zmake68kPtrs Offset_0x0ED45E    ; $A8
		zmake68kPtrs Offset_0x0ED494    ; $A9
		zmake68kPtrs Door_Close_Sfx_Data    ; $AA
		zmake68kPtrs Offset_0x0ED4FC    ; $AB
		zmake68kPtrs Offset_0x0ED530    ; $AC
		zmake68kPtrs Offset_0x0ED57A    ; $AD
		zmake68kPtrs Offset_0x0ED5A9    ; $AE
		zmake68kPtrs Offset_0x0ED5DC    ; $AF
		zmake68kPtrs Slide_Thunk_Sfx_Data    ; $B0
		zmake68kPtrs Offset_0x0ED63F    ; $B1
		zmake68kPtrs Offset_0x0ED652    ; $B2
		zmake68kPtrs Offset_0x0ED688    ; $B3
		zmake68kPtrs Offset_0x0ED6D4    ; $B4
		zmake68kPtrs Offset_0x0ED6EA    ; $B5
		zmake68kPtrs Offset_0x0ED720    ; $B6
		zmake68kPtrs Offset_0x0ED73F    ; $B7
		zmake68kPtrs Offset_0x0ED7A4    ; $B8
		zmake68kPtrs Offset_0x0ED7DB    ; $B9
		zmake68kPtrs Offset_0x0ED80F    ; $BA
		zmake68kPtrs Super_Form_Change_Sfx_Data    ; $BB
		zmake68kPtrs Offset_0x0ED88C    ; $BC
		zmake68kPtrs Offset_0x0ED8BA    ; $BD
		zmake68kPtrs Offset_0x0ED8D2    ; $BE
		zmake68kPtrs Offset_0x0ED8FA    ; $BF
		zmake68kPtrs Offset_0x0ED927    ; $C0
		zmake68kPtrs Offset_0x0ED956    ; $C1
		zmake68kPtrs Offset_0x0ED98E    ; $C2
		zmake68kPtrs Offset_0x0ED9BB    ; $C3
		zmake68kPtrs Offset_0x0ED9E8    ; $C4
		zmake68kPtrs Offset_0x0EDA15    ; $C5
		zmake68kPtrs Offset_0x0EDA42    ; $C6
		zmake68kPtrs Offset_0x0EDA6F    ; $C7
		zmake68kPtrs Offset_0x0EDA87    ; $C8
		zmake68kPtrs Energy_Zap_Sfx_Data    ; $C9
		zmake68kPtrs Offset_0x0EDAE1    ; $CA
		zmake68kPtrs Offset_0x0EDAF7    ; $CB
		zmake68kPtrs Offset_0x0EDB52    ; $CC
		zmake68kPtrs Offset_0x0EDBA3    ; $CD
		zmake68kPtrs Check_Point_Sfx_Data    ; $CE
		zmake68kPtrs Offset_0x0EDC3F    ; $CF
		zmake68kPtrs Special_Stage_Entry_Sfx_Data    ; $D0
		zmake68kPtrs Offset_0x0EDCA1    ; $D1
		zmake68kPtrs Spring_Sfx_Data    ; $D2
		zmake68kPtrs Error_Sfx_Data    ; $D3
		zmake68kPtrs Offset_0x0EDD9D    ; $D4
		zmake68kPtrs Offset_0x0EDE17    ; $D5
		zmake68kPtrs Offset_0x0EDE4B    ; $D6
		zmake68kPtrs Offset_0x0EDE73    ; $D7
		zmake68kPtrs Offset_0x0EDEB4    ; $D8
		zmake68kPtrs Offset_0x0EDEDC    ; $D9

		restore
		padding off
		!org Z80_Driver+Size_of_Snd_driver_guess	; The assembler still thinks we're in Z80 memory, so use an 'org' to switch back to the cartridge