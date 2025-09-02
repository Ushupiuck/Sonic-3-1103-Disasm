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
			inform 3,"Starting address of clearRAM $%h is after ending address $%h.",startaddr,endaddr
		elseif startaddr=endaddr
			inform 1,"clearRAM is clearing zero bytes. Turning this into a nop instead."
		mexit
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
objdata macro pri,width,height,frame,collision,VRAM,mapping
  if ("mapping"<>"")
	dc.l	mapping
	dc.w	VRAM, pri
	dc.b	width, height, frame, collision
  elseif ("VRAM"<>"")
	dc.w	VRAM, pri
	dc.b	width, height, frame, collision
  elseif ("collision"<>"")
	dc.w	pri
	dc.b	width, height, frame, collision
  endif
	endm

objdatasimple macro pri,width,height,VRAM
	dc.w	VRAM, pri
	dc.b	width, height
	endm

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