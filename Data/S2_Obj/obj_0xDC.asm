; ----------------------------------------------------------------------------
; Object DC - Ring prize from Casino Night Zone
; ----------------------------------------------------------------------------
; casino_prize_x_pos =		objoff_30	; X position of the ring with greater precision
; casino_prize_y_pos =		objoff_34	; Y position of the ring with greater precision
; casino_prize_machine_x_pos =	objoff_38	; X position of the slot machine that generated the ring
; casino_prize_machine_y_pos =	objoff_3A	; Y position of the slot machine that generated the ring
; casino_prize_display_delay =	objoff_3C	; number of frames before which the ring is displayed
; ObjDC:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	ObjDC_Index(pc,d0.w),d1
		jmp	ObjDC_Index(pc,d1.w)
; ===========================================================================
ObjDC_Index:
		dc.w	ObjDC_Main-ObjDC_Index
		dc.w	ObjDC_Animate-ObjDC_Index
		dc.w	ObjDC_Delete-ObjDC_Index
; ===========================================================================
ObjDC_Main:
		moveq	#0,d1
		move.w	Obj_Control_Var_0C(a0),d1
		swap	d1
		move.l	Obj_Control_Var_04(a0),d0
		sub.l	d1,d0
		asr.l	#4,d0
		sub.l	d0,Obj_Control_Var_04(a0)
		move.w	Obj_Control_Var_04(a0),Obj_X(a0)
		moveq	#0,d1
		move.w	Obj_Control_Var_0E(a0),d1
		swap	d1
		move.l	Obj_Control_Var_08(a0),d0
		sub.l	d1,d0
		asr.l	#4,d0
		sub.l	d0,Obj_Control_Var_08(a0)
		move.w	Obj_Control_Var_08(a0),Obj_Y(a0)
		lea	Slot_Machine_Rings_Animate_Data(pc),a1
		bsr.w	AnimateSprite
		subq.w	#1,Obj_Control_Var_10(a0)
		bne.w	DisplaySprite
		move.l	Obj_Timer(a0),a1
		subq.w	#1,(a1)
		bsr.w	CollectRing
		addi.b	#2,Obj_Routine(a0)
; ---------------------------------------------------------------------------
ObjDC_Animate:
		lea	Rings_Animate_Data(pc),a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================
ObjDC_Delete:
		bra.w	DeleteObject
; ===========================================================================
Slot_Machine_Rings_Animate_Data:
		dc.w	Offset_0x01103C-Slot_Machine_Rings_Animate_Data
Offset_0x01103C:
		dc.b	$01, $00, $01, $02, $03, $FF