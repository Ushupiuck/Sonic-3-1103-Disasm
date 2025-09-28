; ---------------------------------------------------------------------------
; Object 7C - flash effect when you collect the giant ring
; Leftover from Sonic 1 (Yes, it has survived THIS long)
; ---------------------------------------------------------------------------
; RingFlash:
		moveq	#0,d0
		move.b	Obj_Routine(a0),d0
		move.w	RingFlash_Index(pc,d0),d1
		jmp	RingFlash_Index(pc,d1)
;-------------------------------------------------------------------------------
RingFlash_Index:
		dc.w	Flash_Main-RingFlash_Index
		dc.w	Flash_ChkDel-RingFlash_Index
		dc.w	Flash_Delete-RingFlash_Index
;-------------------------------------------------------------------------------

Flash_Main:	; Routine 0
		addq.b	#2,Obj_Routine(a0)
		move.l	#Big_Ring_Flash_Mappings,Obj_Map(a0)
		move.w	#$2462,Obj_Art_VRAM(a0)
		ori.b	#4,Obj_Flags(a0)
		move.w	#0,Obj_Priority(a0)
		move.b	#$20,Obj_Width(a0)
		move.b	#$FF,Obj_Map_Id(a0)

Flash_ChkDel:	; Routine 2
		bsr.s	Flash_Collect
;		for reference sake, the code below is essentially
;		out_of_range.w	DeleteObject
		move.w	Obj_X(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_Left).w,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		bra.w	DisplaySprite

;-------------------------------------------------------------------------------

Flash_Collect:
		subq.b	#1,Obj_Ani_Time(a0)
		bpl.s	locret_10DC4
		move.b	#1,Obj_Ani_Time(a0)
		addq.b	#1,Obj_Map_Id(a0)
		cmpi.b	#8,Obj_Map_Id(a0)	; has animation finished?
		bcc.s	Flash_End		; if yes, branch
		cmpi.b	#3,Obj_Map_Id(a0)	; is 3rd frame displayed?
		bne.s	locret_10DC4		; if not, branch
		move.l	Obj_Control_Var_10(a0),a1	; get parent object address
		move.b	#6,Obj_Routine(a1)		; delete parent object
		move.b	#$1C,(Obj_Player_One+Obj_Ani_Number).w	; make Player invisible
		move.b	#1,(Special_Stage_Entry_Flag).w		; stop Player getting bonuses
		lea	(Obj_Player_One).w,a1
		bclr	#1,Obj_Player_Status(a1)	; remove invincibility
		bclr	#0,Obj_Player_Status(a1)	; remove shield

locret_10DC4:
		rts
;-------------------------------------------------------------------------------

Flash_End:
		addq.b	#2,Obj_Routine(a0)
		move.l	#0,(Obj_Player_One).w	; remove Player object
		addq.l	#4,sp
		rts
; End of function Flash_Collect

;-------------------------------------------------------------------------------

Flash_Delete:	; Routine 4
		bra.w	DeleteObject
