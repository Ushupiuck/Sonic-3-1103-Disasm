; ===========================================================================
; ---------------------------------------------------------------------------
; Object - Sonic on the Sega Screen, updated to the Sonic 3 format
; ---------------------------------------------------------------------------
; Offset_0x034488: Obj_S2_0xB0_Sonic_Sega_Logo:
Obj_SegaSonic:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	SegaSonic_Index(pc,d0.w),d1
		jmp	SegaSonic_Index(pc,d1.w)
; ===========================================================================
; Offset_0x034496:
SegaSonic_Index:
		dc.w SegaSonic_Init-SegaSonic_Index
		dc.w SegaSonic_RunLeft-SegaSonic_Index
		dc.w SegaSonic_MidWipe-SegaSonic_Index
		dc.w SegaSonic_RunRight-SegaSonic_Index
		dc.w SegaSonic_EndWipe-SegaSonic_Index
		dc.w SegaSonic_End-SegaSonic_Index
; ===========================================================================
; Offset_0x0344A2:
SegaSonic_Init:
		lea	S2_Obj_0xB0_Setup_Data(pc),a1
		jsr	(SetupObjectAttributes).l
		move.b	#0,Obj_Flags(a0)
		move.w  #$1E8,Obj_X(a0)
		move.w  #$F0,Obj_Y(a0)
		move.w  #$B,Obj_Timer(a0)
		move.w  #2,(VBlank_Subroutine).w
		bset	#0,Obj_Flags(a0)
		bset	#0,Obj_Status(a0)

		; Initialize streak horizontal offsets for Sonic going left.
		; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
		lea	(Horizontal_Scroll_Buffer+$138).w,a1
		lea	Offset_0x034A08(pc),a2
		moveq	#0,d0
		moveq	#35-1,d6			; number of streaks - 1

Offset_0x0344E2:
		move.b	(a2)+,d0
		add.w	d0,(a1)
		addq.w	#2*2*2,a1			; advance to next streak 2 pixels down
		dbf	d6,Offset_0x0344E2
		lea	SegaSonic_Frames(pc),a1
		lea	(Art_Sonic).l,a3
		lea	(M68K_RAM_Start).l,a5
		moveq	#4-1,d5				; there are 4 mapping frames to loop over

; this copies the tiles that we want to scale up from ROM to RAM
; Offset_0x0344FE:
CopySpriteTilesToRAMForSegaScreen:
		move.l	(a1)+,a2
		move.w	(a2)+,d6			; get the number of pieces in this mapping frame
		subq.w	#1,d6
; Offset_0x034504:
CopySpritePiecesForSegaScreen:
		move.w	(a2)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		lsl.w	#5,d0
		lea	(a3,d0.w),a4			; source ROM address of tiles to copy
		andi.w	#$F000,d1
		rol.w	#4,d1
		addq.w	#1,d1
		lsl.w	#3,d1
		subq.w	#1,d1
; Offset_0x03451E:
CopyAllPixelsToTempBuffer:
		move.l	(a4)+,(a5)+
		dbf	d1,CopyAllPixelsToTempBuffer		; copy all of the pixels in this piece into the temp buffer
		dbf	d6,CopySpritePiecesForSegaScreen	; loop per piece in the frame
		dbf	d5,CopySpriteTilesToRAMForSegaScreen	; loop per mapping frame

; ScaleUpSpriteTiles:
		move.w	d7,-(sp)
		moveq	#0,d0
		moveq	#0,d1
		lea	SegaScreenScaledSpriteDataStart(pc),a6
		moveq	#4*2-1,d7			; there are 4 sprite mapping frames with 2 pieces each

Offset_0x034538:
		move.l	(a6)+,a1			; source in RAM of tile graphics to enlarge
		move.l	(a6)+,a2			; destination in RAM for enlarged graphics
		move.b	(a6)+,d0			; width of the sprite piece to enlarge (minus 1)
		move.b	(a6)+,d1			; height of the sprite piece to enlarge (minus 1)
		bsr.w	Sub_Sega_Intro
		dbf	d7,Offset_0x034538		; loop over each piece
		move.w	(a7)+,d7
		rts
; ===========================================================================
; Offset_0x03454C:
SegaSonic_Frames:
		dc.l	Offset_0x101994
		dc.l	Offset_0x10199A
		dc.l	Offset_0x1019A0
		dc.l	Offset_0x1019A6
; Offset_0x03455C:
SegaScreenScaledSpriteDataStart:
		dc.l	$FFFF0000, $FFFF0B00
		dc.b	$02, $01
		dc.l	$FFFF00C0, $FFFF0E00
		dc.b	$03, $03
		dc.l	$FFFF02C0, $FFFF1600
		dc.b	$02, $01
		dc.l	$FFFF0380, $FFFF1900
		dc.b	$03, $03
		dc.l	$FFFF0580, $FFFF2100
		dc.b	$02, $01
		dc.l	$FFFF0640, $FFFF2400
		dc.b	$03, $03
		dc.l	$FFFF0840, $FFFF2C00
		dc.b	$02, $01
		dc.l	$FFFF0900, $FFFF2F00
		dc.b	$03, $03
; ===========================================================================
; Offset_0x0345AC:
SegaSonic_RunLeft:
		subi.w	#$20,Obj_X(a0)
		subq.w	#1,Obj_Timer(a0)
		bmi.s	Offset_0x0345CE
		bsr.w	Offset_0x0346F8
		lea	(Sonic_SEGA_Logo_Animate_Data).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l

Offset_0x0345CE:
		addq.b	#2,Obj_Routine(a0)
		move.w	#$C,Obj_Timer(a0)
		move.b	#1,Obj_Control_Var_00(a0)
		move.b	#-1,Obj_Control_Var_01(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
; Offset_0x0345EA:
SegaSonic_MidWipe:
		tst.w	Obj_Timer(a0)
		beq.s	Offset_0x0345F8
		subq.w	#1,Obj_Timer(a0)
		bsr.w	Offset_0x0346F8

Offset_0x0345F8:
		lea	Offset_0x03476E(pc),a1
		bsr.w	Offset_0x034720
		bne.s	Offset_0x034604
		rts
; ---------------------------------------------------------------------------

Offset_0x034604:
		addq.b	#2,Obj_Routine(a0)
		bchg	#0,Obj_Flags(a0)
		move.w	#$B,Obj_Timer(a0)
		move.w	#4,(VBlank_Subroutine).w
		subi.w	#$28,Obj_X(a0)
		bchg	#0,Obj_Flags(a0)
		bchg	#0,Obj_Status(a0)

		; The loop counter here is erroniously set to $400 instead of ($400/4)-1; this didn't cause issues
		; in Sonic 2, but in Sonic 3, it causes the entire color RAM to be cleared.
		clearRAM	Horizontal_Scroll_Buffer,Palette_Underwater_Target+4

		lea	(Horizontal_Scroll_Buffer+$13C).w,a1
		lea	Offset_0x034A08(pc),a2
		moveq	#0,d0
		moveq	#35-1,d6			; number of streaks - 1

Offset_0x034648:
		move.b	(a2)+,d0
		sub.w	d0,(a1)
		addq.w	#2*2*2,a1			; advance to the next streak 2 pixels down
		dbf	d6,Offset_0x034648
; Offset_0x034652:
Null_Sub_3:
		rts
; ===========================================================================
; Offset_0x034654:
SegaSonic_RunRight:
		subq.w	#1,Obj_Timer(a0)
		bmi.s	Offset_0x034676
		addi.w	#$20,Obj_X(a0)
		bsr.w	Offset_0x03470C
		lea	(Sonic_SEGA_Logo_Animate_Data).l,a1
		jsr	(AnimateSprite).l
		jmp	(DisplaySprite).l

Offset_0x034676:
		addq.b	#2,Obj_Routine(a0)
		move.w	#$C,Obj_Timer(a0)
		move.b	#1,Obj_Control_Var_00(a0)
		move.b	#-1,Obj_Control_Var_01(a0)
		rts
; ===========================================================================
; Offset_0x03468E:
SegaSonic_EndWipe:
		tst.w	Obj_Timer(a0)
		beq.s	Offset_0x03469C
		subq.w	#1,Obj_Timer(a0)
		bsr.w	Offset_0x03470C

Offset_0x03469C:
		lea	Offset_0x0347E4(pc),a1
		bsr.w	Offset_0x034720
		bne.s	SegaSonic_PlayChant
		rts
; ---------------------------------------------------------------------------
; Offset_0x0346A8:
SegaSonic_PlayChant:
		addq.b	#2,Obj_Routine(a0)
		st	(PalCycle_Done_Flag).w
		move.b	#cmd_S2SEGA,d0
		jsr	(PlaySound).l
; Offset_0x0346BA:
SegaSonic_End:
		rts