; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; simplifying macros and functions

; makes a VDP address difference
vdpCommDelta function addr,((addr&$3FFF)<<16)|((addr&$C000)>>14)

; makes a VDP command
vdpComm function addr,type,rwd,(((type&rwd)&3)<<30)|((addr&$3FFF)<<16)|(((type&rwd)&$FC)<<2)|((addr&$C000)>>14)

; values for the type argument
VRAM = %100001
CRAM = %101011
VSRAM = %100101

; values for the rwd argument
READ = %001100
WRITE = %000111
DMA = %100111

; tells the VDP to copy a region of 68k memory to VRAM or CRAM or VSRAM
dma68kToVDP macro source,dest,length,type
	lea	(VDP_control_port).l,a5
	move.l	#(($9400|((((length)>>1)&$FF00)>>8))<<16)|($9300|(((length)>>1)&$FF)),(a5)
	move.l	#(($9600|((((source)>>1)&$FF00)>>8))<<16)|($9500|(((source)>>1)&$FF)),(a5)
	move.w	#$9700|(((((source)>>1)&$FF0000)>>16)&$7F),(a5)
	move.w	#((vdpComm(dest,type,DMA)>>16)&$FFFF),(a5)
	move.w	#(vdpComm(dest,type,DMA)&$FFFF),(DMA_data_thunk).w
	move.w	(DMA_data_thunk).w,(a5)
    endm

; tells the VDP to fill a region of VRAM with a certain byte
dmaFillVRAM macro byte,addr,length
	lea	(VDP_control_port).l,a5
	move.w	#$8F01,(a5) ; VRAM pointer increment: $0001
	move.l	#(($9400|((((length)-1)&$FF00)>>8))<<16)|($9300|(((length)-1)&$FF)),(a5) ; DMA length ...
	move.w	#$9780,(a5) ; VRAM fill
	move.l	#vdpComm(addr,VRAM,DMA),(a5) ; Start at ...
	move.w	#(byte)|((byte)<<8),(VDP_data_port).l ; Fill with byte
.loop:	move.w	(a5),d1
	btst	#1,d1
	bne.s	.loop ; busy loop until the VDP is finished filling...
	move.w	#$8F02,(a5) ; VRAM pointer increment: $0002
    endm

; tells the Z80 to stop, and waits for it to finish stopping (acquire bus)
stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l	; stop the Z80
.loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	.loop				; loop until it says it has stopped
    endm

; tells the Z80 to start again
startZ80 macro
	move.w	#0,(Z80_Bus_Request).l    ; start the Z80
    endm

; function to make a little-endian 16-bit pointer for the Z80 sound driver
z80_ptr function x,(x)<<8&$FF00|(x)>>8&$7F|$80

; macro to declare a little-endian 16-bit pointer for the Z80 sound driver
rom_ptr_z80 macro addr
	dc.w	z80_ptr(addr)
    endm

tiles_to_bytes function addr,((addr&$7FF)<<5)

; macro formatting text for the game's menus
menutxt	macro	text
	dc.b	strlen(text)-1
	dc.b	text
	endm

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at x bytes per iteration
bytesToXcnt function n,x,n/x-1

; fills a region of 68k RAM with 0
clearRAM macro startaddr,endaddr
    if startaddr>endaddr
		fatal "Starting address of clearRAM \{startaddr} is after ending address \{endaddr}."
    elseif startaddr=endaddr
		warning "clearRAM is clearing zero bytes. Turning this into a nop instead."
	exitm
    endif
	if ((startaddr)&$8000)=0
		lea	(startaddr).l,a1		; if start address is greater than $FFFF8000
	else
		lea	(startaddr).w,a1		; if start address is less than $FFFF8000
	endif
		moveq	#0,d0
	if (startaddr&1)
		move.b	d0,(a1)+			; clear the first byte if start address is odd
	endif
		move.w	#bytesToLcnt((endaddr-startaddr)-(startaddr&1)),d1

	.loop:
		move.l	d0,(a1)+
		dbf	d1,.loop
	if (((endaddr-startaddr)-((startaddr)&1))&2)
		move.w	d0,(a1)+			; if amount to clear is not divisible by longword, clear the last whole word
	endif
	if (((endaddr-startaddr)-((startaddr)&1))&1)
		move.b	d0,(a1)+			; if amount to clear is not divisible by word, clear the last byte
	endif
    	endm

; macros to create an entry for object data
objdata macro pri,width,height,frame,collision,vram,mappings
	if "mappings"<>""
		dc.l	mappings
	endif
	if "vram"<>""
		dc.w	vram
	endif
		dc.w	pri
		dc.b	width, height, frame, collision
		endm

objdatasimple macro pri,width,height,vram
	dc.w	vram, pri
	dc.b	width, height
	endm

; Function to turn a sample rate into a djnz loop counter
pcmLoopCounterBase function sampleRate,baseCycles, 1+(Z80_Clock/(sampleRate)-(baseCycles)+(13/2))/13
pcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,68) ; 68 is the number of cycles zPlaySEGAPCM takes to deliver one sample.
dpcmLoopCounter function sampleRate, pcmLoopCounterBase(sampleRate,303/2) ; 303 is the number of cycles zPlayDigitalAudio takes to deliver two samples.

little_endian function x,(x)<<8&$FF00|(x)>>8&$FF

; Function to make a little endian (z80) pointer
k68z80Pointer function addr,little_endian((addr#$8000)+$8000)

startBank macro {INTLABEL}
	align	$8000
__LABEL__ label *
soundBankStart := __LABEL__
soundBankName := "__LABEL__"
    endm

DebugSoundbanks := 0

finishBank macro
	if * > soundBankStart + $8000
		fatal "soundBank \{soundBankName} must fit in $8000 bytes but was $\{*-soundBankStart}. Try moving something to the other bank."
	elseif (DebugSoundbanks<>0)&&(MOMPASS=1)
		message "soundBank \{soundBankName} has $\{$8000+soundBankStart-*} bytes free at end."
	endif
    endm