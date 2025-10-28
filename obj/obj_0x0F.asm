;===============================================================================
; Objeto 0x0F - Collapsing Platforms
;===============================================================================
; Offset_0x01595E:
Obj_0x0F_Collapsing_Platform:
		move.l	#Offset_0x015B62,(A0)
		ori.b	#4,render_flags(A0)
		move.w	#$200,priority(A0)				; $0008
		cmpi.b	#LBz_Id,(Current_Zone).w			; $06, $FFFFFE10
		bne.s	Offset_0x0159E6
		move.b	subtype(A0),d0					; $002C
		andi.w	#$3F,d0
		add.w	D0,d0
		add.w	D0,d0
		addq.w	#8,d0
		bcc.s	Offset_0x01598C
		move.b	#$FF,d0
Offset_0x01598C:
		move.b	D0,Obj_Control_Var_08(A0)				; $0038
		btst	#6,subtype(A0)					; $002C
		bne.s	Offset_0x0159C4
		move.l	#LBz_Collapsing_Platforms_Mappings,mappings(A0) ; Offset_0x0161E2, $000C
		move.w	#$4001,art_tile(A0)				; $000A
		move.b	#$40,width_pixels(A0)					; $0007
		move.b	#$10,height_pixels(A0)					; $0006
		move.l	#Offset_0x015E26,Obj_Control_Var_00(A0)		; $0030
		move.l	#Offset_0x015E36,Obj_Control_Var_04(A0)		; $0034
		bra.s	Offset_0x0159E6
Offset_0x0159C4:
		move.l	#LBz_Collapsing_Platforms_Mappings_2,mappings(A0) ; Offset_0x0162DE, $000C
		move.w	#$4001,art_tile(A0)				; $000A
		move.b	#$20,width_pixels(A0)					; $0007
		move.b	#$30,height_pixels(A0)					; $0006
		move.l	#Offset_0x015E46,Obj_Control_Var_00(A0)		; $0030
Offset_0x0159E6:
		cmpi.b	#Hz_Id,(Current_Zone).w			; $01, $FFFFFE10
		bne.w	Offset_0x015A80
		move.l	#Hz_Collapsing_Platform_Mappings,mappings(A0) ; Offset_0x016366, $000C
		move.w	#$C001,art_tile(A0)				; $000A
		move.b	subtype(A0),d0					; $002C
		bpl.s	Offset_0x015A18
		move.b	D0,d1
		andi.b	#$F,d1
		move.b	D1,Obj_Control_Var_10(A0)				; $0040
		move.l	#Offset_0x015C44,(A0)
		andi.b	#$70,d0
Offset_0x015A18:
		move.b	D0,d1
		andi.w	#$F,d0
		lsl.w	#4,d0
		addq.w	#8,d0
		move.b	D0,Obj_Control_Var_08(A0)				; $0038
		andi.w	#$F0,d1
		lsr.w	#2,d1
		lea	Offset_0x015A50(pc,d1.w),a1
		move.b	(A1)+,width_pixels(A0)					; $0007
		move.b	(A1)+,height_pixels(A0)					; $0006
		move.b	(A1)+,mapping_frame(A0)					; $0022
		move.b	(A1)+,subtype(A0)				; $002C
		add.w	D1,d1
		lea	Offset_0x015A60(pc,d1.w),a1
		move.l	(A1)+,Obj_Control_Var_00(A0)			; $0030
		move.l	(A1)+,Obj_Control_Var_04(A0)			; $0034
		bra.s	Offset_0x015A80
; ---------------------------------------------------------------------------
Offset_0x015A50:
		dc.b	$40, $10, $00, $80, $50, $10, $03, $80
		dc.b	$40, $10, $06, $00, $50, $20, $09, $80
; ---------------------------------------------------------------------------
Offset_0x015A60:
		dc.l	Offset_0x015E54
		dc.l	Offset_0x015E64
		dc.l	Offset_0x015E74
		dc.l	Offset_0x015E88
		dc.l	Offset_0x015E9C
		dc.l	Offset_0x015E9C
		dc.l	Offset_0x015EAB
		dc.l	Offset_0x015EC3
; ---------------------------------------------------------------------------
Offset_0x015A80:
		cmpi.b	#MGz_Id,(Current_Zone).w			; $02, $FFFFFE10
		bne.s	Offset_0x015B02
		move.l	#MGz_Collapsing_Platform_Mappings,mappings(A0) ; Offset_0x0167B4, $000C
		move.w	#$4001,art_tile(A0)				; $000A
		move.b	subtype(A0),d0					; $002C
		move.b	D0,d1
		andi.w	#$F,d0
		lsl.w	#4,d0
		addq.w	#8,d0
		move.b	D0,Obj_Control_Var_08(A0)				; $0038
		andi.w	#$F0,d1
		lsr.w	#2,d1
		lea	Offset_0x015ADE(pc,d1.w),a1
		move.b	(A1)+,width_pixels(A0)					; $0007
		move.b	(A1)+,height_pixels(A0)					; $0006
		move.b	(A1)+,mapping_frame(A0)					; $0022
		move.b	(A1)+,subtype(A0)				; $002C
		add.w	D1,d1
		lea	Offset_0x015AEA(pc,d1.w),a1
		move.l	(A1)+,Obj_Control_Var_00(A0)			; $0030
		move.l	(A1)+,Obj_Control_Var_04(A0)			; $0034
		cmpi.w	#$10,d1
		bne.s	Offset_0x015B02
		move.l	#Offset_0x015BD4,(A0)
		rts
; ---------------------------------------------------------------------------
Offset_0x015ADE:
		dc.b	$40, $20, $00, $80, $30, $20, $03, $80
		dc.b	$40, $20, $06, $80
; ---------------------------------------------------------------------------
Offset_0x015AEA:
		dc.l	Offset_0x015EDB
		dc.l	Offset_0x015EFB
		dc.l	Offset_0x015F1B
		dc.l	Offset_0x015F33
		dc.l	Offset_0x015EDB
		dc.l	Offset_0x015EFB
; ---------------------------------------------------------------------------
Offset_0x015B02:
		cmpi.b	#Iz_Id,(Current_Zone).w			; $05, $FFFFFE10
		bne.s	Offset_0x015B62
		move.b	subtype(A0),d0					; $002C
		bpl.s	Offset_0x015B24
		move.b	D0,d1
		andi.b	#$F,d1
		move.b	D1,Obj_Control_Var_10(A0)				; $0040
		move.l	#Offset_0x015C44,(A0)
		andi.b	#$70,d0
Offset_0x015B24:
		move.b	D0,d1
		andi.w	#$F,d0
		lsl.w	#4,d0
		addq.w	#8,d0
		move.b	D0,Obj_Control_Var_08(A0)				; $0038
		move.l	#Iz_Collapsing_Platform_Mappings,mappings(A0) ; Offset_0x016D00, $000C
		move.w	#$4001,art_tile(A0)				; $000A
		move.b	#$50,width_pixels(A0)					; $0007
		move.b	#$38,height_pixels(A0)					; $0006
		move.l	#Offset_0x015F4B,Obj_Control_Var_00(A0)			; $0030
		move.l	#Offset_0x015F77,Obj_Control_Var_04(A0)			; $0034
		move.b	#3,mapping_frame(A0)					; $0022
Offset_0x015B62:
		tst.b	Obj_Control_Var_0A(A0)				; $003A
		beq.s	Offset_0x015BAC
		tst.b	Obj_Control_Var_08(A0)				; $0038
		bne.s	Offset_0x015BA8
		move.l	Obj_Control_Var_00(A0),a4				; $0030
		tst.b	subtype(A0)					; $002C
		bpl.s	Offset_0x015BA4
		move.b	status(A0),d0
		andi.b	#$18,d0
		beq.s	Offset_0x015BA4
		move.w	(Obj_Player_One+x_pos).w,d1		; $FFFFB010
		andi.b	#8,d0
		bne.s	Offset_0x015B90
		move.w	(Obj_Player_Two+x_pos).w,d1		; $FFFFB05A
Offset_0x015B90:
		cmp.w	x_pos(A0),d1					; $0010
		bcc.s	Offset_0x015BA4
		move.l	Obj_Control_Var_04(A0),a4				; $0034
		bchg	#0,status(A0)
		addq.b	#1,mapping_frame(A0)					; $0022
Offset_0x015BA4:
		bra.w	Offset_0x015D5E
Offset_0x015BA8:
		subq.b	#1,Obj_Control_Var_08(A0)			; $0038
Offset_0x015BAC:
		move.b	status(A0),d0
		andi.b	#$18,d0
		beq.s	Offset_0x015BBC
		move.b	#1,Obj_Control_Var_0A(A0)			; $003A
Offset_0x015BBC:
		moveq	#0,d1
		move.b	width_pixels(A0),d1				; $0007
		move.w	#$10,d3
		move.w	x_pos(A0),d4					; $0010
		jsr	(Platform_Object).l
		bra.w	MarkObjGone
; ---------------------------------------------------------------------------
Offset_0x015BD4:
		tst.b	Obj_Control_Var_0A(A0)				; $003A
		beq.s	Offset_0x015C1E
		tst.b	Obj_Control_Var_08(A0)				; $0038
		bne.s	Offset_0x015C1A
		move.l	Obj_Control_Var_00(A0),a4				; $0030
		tst.b	subtype(A0)					; $002C
		bpl.s	Offset_0x015C16
		move.b	status(A0),d0
		andi.b	#$18,d0
		beq.s	Offset_0x015C16
		move.w	(Obj_Player_One+x_pos).w,d1		; $FFFFB010
		andi.b	#8,d0
		bne.s	Offset_0x015C02
		move.w	(Obj_Player_Two+x_pos).w,d1		; $FFFFB05A
Offset_0x015C02:
		cmp.w	x_pos(A0),d1					; $0010
		bcc.s	Offset_0x015C16
		move.l	Obj_Control_Var_04(A0),a4				; $0034
		bchg	#0,status(A0)
		addq.b	#1,mapping_frame(A0)					; $0022
Offset_0x015C16:
		bra.w	Offset_0x015D5E
Offset_0x015C1A:
		subq.b	#1,Obj_Control_Var_08(A0)			; $0038
Offset_0x015C1E:
		move.b	status(A0),d0
		andi.b	#$18,d0
		beq.s	Offset_0x015C40
		move.b	(Obj_Player_One+Obj_Player_Hit_Flag).w,d1	; $FFFFB037
		andi.b	#8,d0
		bne.s	Offset_0x015C36
		move.b	(Obj_Player_Two+Obj_Player_Hit_Flag).w,d1	; $FFFFB081
Offset_0x015C36:
		tst.b	D1
		bpl.s	Offset_0x015C40
		move.b	#1,Obj_Control_Var_0A(A0)			; $003A
Offset_0x015C40:
		bra.w	Offset_0x015BBC
; ---------------------------------------------------------------------------
Offset_0x015C44:
		tst.b	Obj_Control_Var_0A(A0)				; $003A
		beq.s	Offset_0x015C8E
		tst.b	Obj_Control_Var_08(A0)				; $0038
		bne.s	Offset_0x015C8A
		move.l	Obj_Control_Var_00(A0),a4				; $0030
		tst.b	subtype(A0)					; $002C
		bpl.s	Offset_0x015C86
		move.b	status(A0),d0
		andi.b	#$18,d0
		beq.s	Offset_0x015C86
		move.w	(Obj_Player_One+x_pos).w,d1		; $FFFFB010
		andi.b	#8,d0
		bne.s	Offset_0x015C72
		move.w	(Obj_Player_Two+x_pos).w,d1		; $FFFFB05A
Offset_0x015C72:
		cmp.w	x_pos(A0),d1					; $0010
		bcc.s	Offset_0x015C86
		move.l	Obj_Control_Var_04(A0),a4				; $0034
		bchg	#0,status(A0)
		addq.b	#1,mapping_frame(A0)					; $0022
Offset_0x015C86:
		bra.w	Offset_0x015D5E
Offset_0x015C8A:
		subq.b	#1,Obj_Control_Var_08(A0)			; $0038
Offset_0x015C8E:
		move.b	Obj_Control_Var_10(A0),d0				; $0040
		andi.w	#$F,d0
		lea	(Level_Trigger_Array).w,a3			; $FFFFF7E0
		lea	(A3,d0.w),a3
		tst.b	(A3)
		beq.s	Offset_0x015CAC
		move.b	#1,Obj_Control_Var_0A(A0)			; $003A
		clr.w	respawn_addr(A0)					; $0048
Offset_0x015CAC:
		bra.w	Offset_0x015BBC
; ---------------------------------------------------------------------------
Offset_0x015CB0:
		tst.b	Obj_Control_Var_08(A0)				; $0038
		beq.w	Offset_0x015CC8
		tst.b	Obj_Control_Var_0A(A0)				; $003A
		bne.s	Offset_0x015CE0
		subq.b	#1,Obj_Control_Var_08(A0)			; $0038
		jmp	(DisplaySprite).l
Offset_0x015CC8:
		jsr	(ObjectFall).l
		tst.b	render_flags(A0)
		bpl.s	Offset_0x015CDA
		jmp	(DisplaySprite).l
Offset_0x015CDA:
		jmp	(DeleteObject).l
Offset_0x015CE0:
		subq.b	#1,Obj_Control_Var_08(A0)			; $0038
		move.b	Obj_Control_Var_08(A0),d3				; $0038
		movea.l	Obj_Control_Var_00(A0),a2				; $0030
		moveq	#0,d1
		move.b	width_pixels(A0),d1				; $0007
		lea	(Obj_Player_One).w,a1				; $FFFFB000
		moveq	#p1_standing_bit,d6
		bsr.s	Offset_0x015D06
		lea	(Obj_Player_Two).w,a1				; $FFFFB04A
		moveq	#p2_standing_bit,d6
		bsr.s	Offset_0x015D06
		bra.w	MarkObjGone
Offset_0x015D06:
		btst	D6,status(A0)
		beq.s	Offset_0x015D5C
		move.w	D1,d2
		add.w	D2,d2
		btst	#1,status(A1)
		bne.s	Offset_0x015D40
		move.w	x_pos(A1),d0					; $0010
		sub.w	x_pos(A0),d0					; $0010
		add.w	D1,d0
		bmi.s	Offset_0x015D40
		cmp.w	D2,d0
		bcc.s	Offset_0x015D40
		btst	#0,status(A0)
		beq.s	Offset_0x015D34
		neg.w	D0
		add.w	D2,d0
Offset_0x015D34:
		lsr.w	#4,d0
		move.b	(A2),d2
		sub.b	(A2,d0.w),d2
		cmp.b	D2,d3
		bhi.s	Offset_0x015D5C
Offset_0x015D40:
		bclr	D6,status(A0)
		bclr	#3,status(A1)
		bclr	#5,status(A1)
		bset	#1,status(A1)
		move.b	#1,prev_anim(A1)				; $0021
Offset_0x015D5C:
		rts
; ---------------------------------------------------------------------------
Offset_0x015D5E:
		move.l	#Offset_0x015CB0,(A0)
		addq.b	#1,mapping_frame(A0)					; $0022
		bra.s	Offset_0x015D78