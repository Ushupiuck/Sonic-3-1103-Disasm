;===============================================================================
; Objeto 0x4B - Anel gigante usado no Sonic 1 para acesso ao Special Stage
; ->>>	não usado (Left over)
;===============================================================================
; Offset_0x010C60:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	Offset_0x010C6E(pc,d0),d1
		jmp	Offset_0x010C6E(pc,d1)
;-------------------------------------------------------------------------------
Offset_0x010C6E:
		dc.w	Offset_0x010C76-Offset_0x010C6E
		dc.w	Offset_0x010CC0-Offset_0x010C6E
		dc.w	Offset_0x010CDE-Offset_0x010C6E
		dc.w	Offset_0x010D22-Offset_0x010C6E
;-------------------------------------------------------------------------------
Offset_0x010C76:
		move.l	#Big_Ring_Mappings,Obj_Map(a0)
		move.w	#$2400,Obj_Art_VRAM(a0)
		ori.b	#4,Obj_Flags(a0)
		move.b	#$40,Obj_Width(a0)
		tst.b	Obj_Flags(a0)
		bpl.s	Offset_0x010CC0
		cmpi.b	#6,(SS_Completed_Flag).w
		beq.w	Offset_0x010D22
		cmpi.w	#50,(Ring_count).w
		bcc.s	Offset_0x010CAA
		rts
Offset_0x010CAA:
		addq.b	#2,Obj_Routine(a0)
		move.w	#$100,Obj_Priority(a0)
		move.b	#$52,Obj_Col_Flags(a0)
		move.w	#$C40,(S1_Load_Big_Ring_Art_Flag).w
;-------------------------------------------------------------------------------
Offset_0x010CC0:
		move.b	(Object_Frame_Buffer).w,Obj_Map_Id(a0)
		move.w	Obj_X(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_Left).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite
;-------------------------------------------------------------------------------
Offset_0x010CDE:
		subq.b	#2,Obj_Routine(a0)
		move.b	#0,Obj_Col_Flags(a0)
		bsr.w	AllocateObject
		bne.w	Offset_0x010D16
		move.l	#Obj_S1_0x7C_Big_Ring_Flash,(a1)
		move.w	Obj_X(a0),Obj_X(a1)
		move.w	Obj_Y(a0),Obj_Y(a1)
		move.l	a0,Obj_Control_Var_10(a1)
		move.w	(Obj_Player_One+Obj_X).w,d0
		cmp.w	Obj_X(a0),d0
		bcs.s	Offset_0x010D16
		bset	#0,Obj_Flags(a1)
Offset_0x010D16:
		move.w	#sfx_BigRingUnk,d0
		jsr	(PlaySound).l
		bra.s	Offset_0x010CC0
Offset_0x010D22:
		bra.w	DeleteObject
;===============================================================================
; Objeto 0x4B - Anel gigante usado no Sonic 1 para acesso ao Special Stage
; <<<-	não usado (Left over)
;===============================================================================