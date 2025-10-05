; ===========================================================================
; ---------------------------------------------------------------------------
; Object - Special Stage Results (leftover from Sonic 2)
; ---------------------------------------------------------------------------
; Offset_0x024BCA: Obj_S2_0x6F_Special_Stage_Results:
S2Obj6F_SSResults:
		rts			; this object has been dummied out
		moveq	#0,d0
		moveq	#0,d6
		move.b	Obj_Routine(a0),d0
		move.w	Offset_0x024BDC(pc,d0.w),d1
		jmp	Offset_0x024BDC(pc,d1.w)
; ---------------------------------------------------------------------------
Offset_0x024BDC:
		dc.w	Offset_0x024C12-Offset_0x024BDC
		dc.w	Offset_0x024C52-Offset_0x024BDC
		dc.w	Offset_0x024C86-Offset_0x024BDC
		dc.w	Offset_0x024CC4-Offset_0x024BDC
		dc.w	Offset_0x024CC2-Offset_0x024BDC
		dc.w	Offset_0x024CC0-Offset_0x024BDC
		dc.w	Offset_0x024CBE-Offset_0x024BDC
		dc.w	Offset_0x024CBC-Offset_0x024BDC
		dc.w	Offset_0x024CBA-Offset_0x024BDC
		dc.w	Offset_0x024CB8-Offset_0x024BDC
		dc.w	Offset_0x024D56-Offset_0x024BDC
		dc.w	Offset_0x024CFE-Offset_0x024BDC
		dc.w	Offset_0x024CE0-Offset_0x024BDC
		dc.w	Offset_0x024D5A-Offset_0x024BDC
		dc.w	Offset_0x024D64-Offset_0x024BDC
		dc.w	Offset_0x024D74-Offset_0x024BDC
		dc.w	Offset_0x024D64-Offset_0x024BDC
		dc.w	Offset_0x024E12-Offset_0x024BDC
		dc.w	Offset_0x024D64-Offset_0x024BDC
		dc.w	Offset_0x024D64-Offset_0x024BDC
		dc.w	Offset_0x024E1E-Offset_0x024BDC
		dc.w	Offset_0x024E8C-Offset_0x024BDC
		dc.w	Offset_0x024D64-Offset_0x024BDC
		dc.w	Offset_0x024E12-Offset_0x024BDC
		dc.w	Offset_0x024EA2-Offset_0x024BDC
		dc.w	Offset_0x024F04-Offset_0x024BDC
		dc.w	Offset_0x024F28-Offset_0x024BDC
; ---------------------------------------------------------------------------
Offset_0x024C12:
		tst.l	(PLC_Data_Buffer).w
		beq.s	Offset_0x024C1A
		rts
Offset_0x024C1A:
		move.l	a0,a1
		lea	Special_Stage_Screen_Pos(pc),a2
		moveq	#$C,d1
; ---------------------------------------------------------------------------
Offset_0x024C22:
		move.l	(a0),(a1)
		move.w	(a2),Obj_X(a1)
		move.w	(a2)+,Obj_Control_Var_02(a1)
		move.w	(a2)+,Obj_Control_Var_00(a1)
		move.w	(a2)+,Obj_Y(a1)
		move.b	(a2)+,Obj_Routine(a1)
		move.b	(a2)+,Obj_Map_Id(a1)
		move.l	#Special_Stage_Results_Mappings,Obj_Map(a1)
		move.b	#$78,Obj_Width(a1)
		lea	Obj_Size(a1),a1
		dbf	d1,Offset_0x024C22
Offset_0x024C52:
		tst.b	(SS_Completed_Flag).w
		beq.s	Offset_0x024C5E
		move.b	#4,Obj_Map_Id(a0)
Offset_0x024C5E:
		cmpi.b	#7,(Emeralds_Count).w
		bne.s	Offset_0x024C6C
		move.b	#$19,Obj_Map_Id(a0)
Offset_0x024C6C:
		move.w	Obj_Control_Var_00(a0),d0
		cmp.w	Obj_X(a0),d0
		bne.s	Offset_0x024C82
		move.b	#$1C,Obj_Routine(a0)
		move.w	#$B4,Obj_Ani_Time(a0)
Offset_0x024C82:
		bra.w	S2Obj6F_SSResults
; ---------------------------------------------------------------------------
Offset_0x024C86:
		cmpi.b	#7,(Emeralds_Count).w
		bne.s	Offset_0x024C92
		moveq	#$16,d0
		bra.s	Offset_0x024C9C
Offset_0x024C92:
		tst.b	(SS_Completed_Flag).w
		beq.w	Offset_0x024BC4
		moveq	#1,d0
Offset_0x024C9C:
		cmpi.w	#2,(Player_Selected_Flag).w
		bne.s	Offset_0x024CB0
		addq.w	#1,d0
		btst	#7,(Hardware_Id).w
		beq.s	Offset_0x024CB0
		addq.w	#1,d0
Offset_0x024CB0:
		move.b	d0,Obj_Map_Id(a0)
		bra.w	S2Obj6F_SSResults
; ---------------------------------------------------------------------------
Offset_0x024CB8:
		addq.w	#1,d6
Offset_0x024CBA:
		addq.w	#1,d6
Offset_0x024CBC:
		addq.w	#1,d6
Offset_0x024CBE:
		addq.w	#1,d6
Offset_0x024CC0:
		addq.w	#1,d6
Offset_0x024CC2:
		addq.w	#1,d6

Offset_0x024CC4:
		lea	(Emerald_Collected_Flag_List).w,a1
		tst.b	(a1,d6.w)
		beq.w	Offset_0x024BC4
		btst	#0,(Vint_runcount+3).w
		beq.s	Offset_0x024CDE
		jsr	(DisplaySprite).l

Offset_0x024CDE:
		rts
; ---------------------------------------------------------------------------
Offset_0x024CE0:
		tst.w	(Player_Selected_Flag).w
		bne.w	Offset_0x024BC4
		beq.w	Offset_0x024BC4
		moveq	#$E,d0
		btst	#7,(Hardware_Id).w
		beq.s	Offset_0x024CF8
		addq.w	#1,d0
Offset_0x024CF8:
		lea	(Level_Results_Ring_Bonus).w,a1
		bra.s	Offset_0x024D4C
; ---------------------------------------------------------------------------
Offset_0x024CFE:
		bne.s	Offset_0x024D24
		move.w	#5000,(Level_Results_Time_Bonus).w
		move.b	#$2A,Obj_Routine(a0)
		move.w	#$120,Obj_Y(a0)
		st	(HUD_Results_Refresh_Flag).w
		move.w	#S2_Panel_Spinning_Sfx,d0
		jsr	(PlaySound).l
		bra.w	Offset_0x024E8C
Offset_0x024D24:
		move.w	(Player_Selected_Flag).w,d0
		beq.s	Offset_0x024D46
		move.w	#$120,Obj_Y(a0)
		subq.w	#1,d0
		beq.s	Offset_0x024D46
		moveq	#$E,d0
		btst	#7,(Hardware_Id).w
		beq.s	Offset_0x024D40
		addq.w	#1,d0
Offset_0x024D40:
		lea	(Level_Results_Ring_Bonus).w,a1
		bra.s	Offset_0x024D4C
Offset_0x024D46:
		moveq	#$D,d0
		lea	(Level_Results_Time_Bonus).w,a1
Offset_0x024D4C:
		tst.w	(a1)
		bne.s	Offset_0x024D52
		addq.w	#5,d0
Offset_0x024D52:
		move.b	d0,Obj_Map_Id(a0)
; ---------------------------------------------------------------------------
Offset_0x024D56:
		bra.w	S2Obj6F_SSResults
; ---------------------------------------------------------------------------
Offset_0x024D5A:
		tst.b	(SS_Completed_Flag).w
		beq.w	Offset_0x024BC4
		bra.s	Offset_0x024D56
; ---------------------------------------------------------------------------
Offset_0x024D64:
		subq.w	#1,Obj_Ani_Time(a0)
		bne.s	Offset_0x024D6E
		addq.b	#2,Obj_Routine(a0)
Offset_0x024D6E:
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Offset_0x024D74:
		jsr	(DisplaySprite).l
		move.b	#1,(HUD_Results_Refresh_Flag).w
		moveq	#0,d0
		tst.w	(Level_Results_Time_Bonus).w
		beq.s	Offset_0x024D90
		addi.w	#10,d0
		subq.w	#1,(Level_Results_Time_Bonus).w
Offset_0x024D90:
		tst.w	(Level_Results_Ring_Bonus).w
		beq.s	Offset_0x024D9E
		addi.w	#10,d0
		subq.w	#1,(Level_Results_Ring_Bonus).w
Offset_0x024D9E:
		tst.w	(Level_Results_Total_Bonus).w
		beq.s	Offset_0x024DAE
		addi.w	#10,d0
		subi.w	#10,(Level_Results_Total_Bonus).w
Offset_0x024DAE:
		tst.w	d0
		bne.s	Offset_0x024DF8
		move.w	#S2_Cha_Ching_Sfx,d0
		jsr	(PlaySound).l
		addq.b	#2,Obj_Routine(a0)
		move.w	#$78,Obj_Ani_Time(a0)
		tst.w	(Perfect_Bonus_Rings_Flag).w
		bne.s	Offset_0x024DEA
		cmpi.w	#2,(Player_Selected_Flag).w
		beq.s	return_24DF6
		tst.b	(SS_Completed_Flag).w
		beq.s	return_24DF6
		cmpi.b	#7,(Emeralds_Count).w
		bne.s	return_24DF6
		move.b	#$30,Obj_Routine(a0)
		rts
Offset_0x024DEA:
		move.b	#$24,Obj_Routine(a0)
		move.w	#$5A,Obj_Ani_Time(a0)

return_24DF6:
		rts
; ---------------------------------------------------------------------------
Offset_0x024DF8:
		jsr	(Add_Points_P1).l
		move.b	(Vint_runcount+3).w,d0
		andi.b	#3,d0
		bne.s	return_24DF6
		move.w	#S2_Add_Points_Blip_Sfx,d0
		jmp	(PlaySound).l
; ---------------------------------------------------------------------------
Offset_0x024E12:
		move.w	#1,(Restart_Level_Flag).w
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Offset_0x024E1E:
		jsr	(DisplaySprite).l
		move.b	#1,(HUD_Results_Refresh_Flag).w
		moveq	#0,d0
		tst.w	(Level_Results_Time_Bonus).w
		beq.s	Offset_0x024E3C
		addi.w	#$14,d0
		subi.w	#$14,(Level_Results_Time_Bonus).w
Offset_0x024E3C:
		tst.w	d0
		beq.s	Offset_0x024E5A
		jsr	(Add_Points_P1).l
		move.b	(Vint_runcount+3).w,d0
		andi.b	#3,d0
		bne.s	return_24E8A
		move.w	#S2_Add_Points_Blip_Sfx,d0
		jmp	(PlaySound).l
Offset_0x024E5A:
		move.w	#S2_Cha_Ching_Sfx,d0
		jsr	(PlaySound).l
		addq.b	#4,Obj_Routine(a0)
		move.w	#$78,Obj_Ani_Time(a0)
		cmpi.w	#2,(Player_Selected_Flag).w
		beq.s	return_24E8A
		tst.b	(SS_Completed_Flag).w
		beq.s	return_24E8A
		cmpi.b	#7,(Emeralds_Count).w
		bne.s	return_24E8A
		move.b	#$30,Obj_Routine(a0)

return_24E8A:
		rts
; ---------------------------------------------------------------------------
Offset_0x024E8C:
		moveq	#$11,d0
		btst	#3,(Vint_runcount+3).w
		beq.s	Offset_0x024E98
		moveq	#$15,d0
Offset_0x024E98:
		move.b	d0,Obj_Map_Id(a0)
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Offset_0x024EA2:
		move.b	#$32,Obj_Size+Obj_Routine(a0)
		move.w	Obj_X(a0),d0
		cmp.w	Obj_Control_Var_02(a0),d0
		bne.s	Offset_0x024F04
		move.b	#$14,Obj_Size+Obj_Routine(a0)
		subq.w	#8,Obj_Size+Obj_Y(a0)
		move.b	#$1A,Obj_Size+Obj_Map_Id(a0)
		move.b	#$34,Obj_Routine(a0)
		subq.w	#8,Obj_Y(a0)
		move.b	#$1B,Obj_Map_Id(a0)
		move.l	(a0),(a1)		; used to be "id(a0),id(a1)" in Sonic 2
		clr.w	Obj_X(a1)
		move.w	#$120,Obj_Control_Var_00(a1)
		move.w	#$B4,Obj_Y(a1)
		move.b	#$14,Obj_Routine(a1)
		move.b	#$1C,Obj_Map_Id(a1)
		move.l	#Special_Stage_Results_Mappings,Obj_Map(a1)
		move.b	#$78,Obj_Width(a1)
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
Offset_0x024F04:
		moveq	#$20,d0
		move.w	Obj_X(a0),d1
		cmp.w	Obj_Control_Var_02(a0),d1
		beq.s	Offset_0x024F20
		bhi.s	Offset_0x024F14
		neg.w	d0
Offset_0x024F14:
		sub.w	d0,Obj_X(a0)
		cmpi.w	#$200,Obj_X(a0)
		bhi.s	return_24F26
Offset_0x024F20:
		jmp	(DisplaySprite).l

return_24F26:
		rts
; ---------------------------------------------------------------------------
Offset_0x024F28:
		move.w	Obj_X(a0),d0
		cmp.w	Obj_Control_Var_00(a0),d0
		bne.w	S2Obj6F_SSResults
		move.w	#$B4,Obj_Ani_Time(a0)
		move.b	#$20,Obj_Routine(a0)
		jmp	(DisplaySprite).l