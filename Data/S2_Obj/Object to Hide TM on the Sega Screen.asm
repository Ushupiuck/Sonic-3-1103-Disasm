; ===========================================================================
; ---------------------------------------------------------------------------
; Object - Object to hide the TM on the Sega screen on Japanese consoles
; (TM symbol means nothing in Japan, and Sonic wasn't registered yet)
; ---------------------------------------------------------------------------
; Offset_0x0346BC: Obj_S2_0xB1_Sonic_Sega_Logo:
Obj_SegaTM:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	Offset_0x0346CA(pc,d0.w),d1
		jmp	Offset_0x0346CA(pc,d1.w)
; ---------------------------------------------------------------------------
Offset_0x0346CA:
		dc.w	Offset_0x0346CE-Offset_0x0346CA
		dc.w	Offset_0x0346F2-Offset_0x0346CA
; ---------------------------------------------------------------------------
Offset_0x0346CE:
		lea	S2_Obj_0xB1_Setup_Data(pc),a1
		jsr	(SetupObjectAttributes).l
		move.b	#0,Obj_Flags(a0)
		move.b	#4,Obj_Map_Id(a0)
		move.w	#$174,Obj_X(a0)
		move.w	#$D8,Obj_Y(a0)
		rts
; ---------------------------------------------------------------------------
Offset_0x0346F2:
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Offset_0x0346F8: ; Usado pelo objeto 0xB0
		lea	(Horizontal_Scroll_Buffer+$138).w,a1
		move.w	#$22,d6
Offset_0x034700:
		subi.w	#$20,(a1)
		addq.w	#8,a1
		dbf	d6,Offset_0x034700
		rts
; ---------------------------------------------------------------------------
Offset_0x03470C: ; Usado pelo objeto 0xB0
		lea	(Horizontal_Scroll_Buffer+$13C).w,a1
		move.w	#$22,d6
Offset_0x034714:
		addi.w	#$20,(a1)
		addq.w	#8,a1
		dbf	d6,Offset_0x034714
		rts
; ---------------------------------------------------------------------------
Offset_0x034720: ; Usado pelo objeto 0xB0
		subq.b	#1,Obj_Control_Var_00(a0)
		bne.s	Offset_0x034766
		moveq	#0,d0
		move.b	Obj_Control_Var_01(a0),d0
		addq.b	#1,d0
		cmp.b	1(a1),d0
		bcs.s	Offset_0x03473A
		tst.b	3(a1)
		bne.s	Offset_0x03476A
Offset_0x03473A:
		move.b	d0,Obj_Control_Var_01(a0)
		move.b	(a1),Obj_Control_Var_00(a0)
		lea	6(a1),a2
		moveq	#0,d1
		move.b	2(a1),d1
		move.w	d1,d2
		tst.w	d0
		beq.s	Offset_0x03475C
Offset_0x034752:
		subq.b	#1,d0
		beq.s	Offset_0x03475A
		add.w	d2,d1
		bra.s	Offset_0x034752
Offset_0x03475A:
		adda.w	d1,a2
Offset_0x03475C:
		move.w	4(a1),a3
Offset_0x034760:
		move.w	(a2)+,(a3)+
		subq.w	#2,d2
		bne.s	Offset_0x034760
Offset_0x034766:
		moveq	#0,d0
		rts
Offset_0x03476A:
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------
Offset_0x03476E:
		dc.b	$04, $07, $10, $FF
		dc.w	Palette_Buffer+$0010
		dc.w	$0E60, $0E60, $0E60, $0E60, $0E60, $0E60, $0E60, $0EEE
		dc.w	$0E62, $0EEE, $0EEE, $0EEE, $0EEE, $0EEE, $0EEE, $0EEE
		dc.w	$0E84, $0E62, $0E60, $0E60, $0E60, $0E60, $0E60, $0EEE
		dc.w	$0EA6, $0E84, $0E62, $0E60, $0E60, $0E60, $0E60, $0EEE
		dc.w	$0EC8, $0EA6, $0E84, $0E62, $0E60, $0E60, $0E60, $0EEE
		dc.w	$0EEC, $0EC8, $0EA6, $0E84, $0E62, $0E60, $0E60, $0EEE
		dc.w	$0EEE, $0EEC, $0EC8, $0EA6, $0E84, $0E62, $0E60, $0EEE
; ---------------------------------------------------------------------------
Offset_0x0347E4:
		dc.b	$04, $07, $10, $FF
		dc.w	Palette_Buffer
		dc.w	$0EEE, $0E60, $0E60, $0E60, $0E60, $0E60, $0E60, $0E60
		dc.w	$0EEE, $0E62, $0E60, $0E60, $0E60, $0E60, $0E60, $0E60
		dc.w	$0EEE, $0E84, $0E62, $0E60, $0E60, $0E60, $0E60, $0E60
		dc.w	$0EEE, $0EA6, $0E84, $0E62, $0E60, $0E60, $0E60, $0E60
		dc.w	$0EEE, $0EC8, $0EA6, $0E84, $0E62, $0E60, $0E60, $0E60
		dc.w	$0EEE, $0EEC, $0EC8, $0EA6, $0E84, $0E62, $0E60, $0E60
		dc.w	$0EEE, $0EEE, $0EEC, $0EC8, $0EA6, $0E84, $0E62, $0E60
; ---------------------------------------------------------------------------
S2_Obj_0xB0_Setup_Data:
		dc.l	Sonic_Sega_Logo_Mappings
		dc.w	$C088
		dc.b	$00, $80, $10, $00
; ---------------------------------------------------------------------------
S2_Obj_0xB1_Setup_Data:
		dc.l	Sonic_Sega_Logo_Mappings
		dc.w	$0003
		dc.b	$01, $00, $08, $00
; ---------------------------------------------------------------------------
Sonic_SEGA_Logo_Animate_Data:
		dc.w	Offset_0x034870-Sonic_SEGA_Logo_Animate_Data
Offset_0x034870:
		dc.b	$00, $00, $01, $02, $03, $FF
; ---------------------------------------------------------------------------
Sonic_Sega_Logo_Mappings:
		dc.w	Offset_0x034880-Sonic_Sega_Logo_Mappings
		dc.w	Offset_0x0348A6-Sonic_Sega_Logo_Mappings
		dc.w	Offset_0x0348CC-Sonic_Sega_Logo_Mappings
		dc.w	Offset_0x0348F2-Sonic_Sega_Logo_Mappings
		dc.w	Offset_0x034918-Sonic_Sega_Logo_Mappings
Offset_0x034880:
		dc.w	$0006
		dc.w	$D80F, $0000, $FFF0
		dc.w	$D807, $0010, $0010
		dc.w	$F80F, $0018, $FFE0
		dc.w	$180F, $0028, $FFE0
		dc.w	$F80F, $0038, $0000
		dc.w	$180F, $0048, $0000
Offset_0x0348A6:
		dc.w	$0006
		dc.w	$D80F, $0058, $FFF0
		dc.w	$D807, $0068, $0010
		dc.w	$F80F, $0070, $FFE0
		dc.w	$180F, $0080, $FFE0
		dc.w	$F80F, $0090, $0000
		dc.w	$180F, $00A0, $0000
Offset_0x0348CC:
		dc.w	$0006
		dc.w	$D80F, $00B0, $FFF0
		dc.w	$D807, $00C0, $0010
		dc.w	$F80F, $00C8, $FFE0
		dc.w	$180F, $00D8, $FFE0
		dc.w	$F80F, $00E8, $0000
		dc.w	$180F, $00F8, $0000
Offset_0x0348F2:
		dc.w	$0006
		dc.w	$D80F, $0108, $FFF0
		dc.w	$D807, $0118, $0010
		dc.w	$F80F, $0120, $FFE0
		dc.w	$180F, $0130, $FFE0
		dc.w	$F80F, $0140, $0000
		dc.w	$180F, $0150, $0000
Offset_0x034918:
		dc.w	$0002
		dc.w	$FC00, $0000, $FFF8
		dc.w	$FC00, $0000, $0000