; ===========================================================================
; ---------------------------------------------------------------------------
; Object 00 - Rings
;
; This just handles ones spawned in debug mode, the actual rings in levels
; are handled using a separate manager
; ---------------------------------------------------------------------------
; Offset_0x0109A4: Obj_0x00_Rings:
Obj00_Rings:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	Rings_Index(pc,d0.w),d1
		jmp	Rings_Index(pc,d1.w) 
; ===========================================================================
; Offset_0x0109B2:
Rings_Index:	offsetTable
		offsetTableEntry.w Rings_Init
		offsetTableEntry.w Rings_Main
		offsetTableEntry.w Rings_Collect
		offsetTableEntry.w Rings_Display
		offsetTableEntry.w Rings_Delete
; ===========================================================================
; Offset_0x0109BC:
Rings_Init:
		addq.b	#2,Obj_Routine(a0)
		move.l	#Rings_Mappings,Obj_Map(a0)
		move.w	#$A6BC,Obj_Art_VRAM(a0)
		move.b	#4,Obj_Flags(a0)
		move.w	#$100,Obj_Priority(a0)
		move.b	#$47,Obj_Col_Flags(a0)
		move.b	#8,Obj_Width(a0)
		tst.w	(Two_Player_Flag).w
		beq.s	Rings_Main
		move.w	#$63D2,Obj_Art_VRAM(a0)
; Offset_0x0109F2:
Rings_Main:
		move.b	(Object_Frame_Buffer).w,Obj_Map_Id(a0)
		bra.w	MarkObjGone_5
; ===========================================================================
; Offset_0x0109FC:
Rings_Collect:
		addq.b	#2,Obj_Routine(a0)
		move.b	#0,Obj_Col_Flags(a0)
		move.w	#$80,Obj_Priority(a0)
		bsr.s	Add_Rings_Check_Ring_Status
; Offset_0x010A0E:
Rings_Display:
		lea	(Rings_Animate_Data).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================
; Offset_0x010A1C:
Rings_Delete:
		bra.w	DeleteObject