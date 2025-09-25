		dc.b	" the screen.", $0D, $0A, $0D, $0A
		dc.b	"DMAScrollArrows:", $0D, $0A
		dc.b	"                Subq.w  #1,ArrowDelay                           ; Determine if arrow buffers or blanks should", $0D, $0A
		dc.b	"                Bne.s   @NoTogg                                 ;  be DMA'ed this makes the arrows flash.", $0D, $0A, $0D, $0A
		dc.b	"                Move.w  #15,ArrowDelay                          ; Reset delay between flashes.", $0D, $0A
		dc.b	"                Eor.w   #1,ArrowToggle                          ; Toggle between blanks and arrows.", $0D, $0A, $0D, $0A
		dc.b	"@NoTogg:", $0D, $0A
		dc.b	"                Tst.w   ArrowToggle                             ; Branch to relevent bit.", $0D, $0A
		dc.b	"                Beq.s   @ArrowsOff", $0D, $0A, $0D, $0A
		dc.b	"; ====== Arrows on, DMA the buffers. ======", $0D, $0A, $0D, $0A
		dc.b	"                Lea     UpArrowBuffer,A0                        ; Source.", $0D, $0A
		dc.b	"                Lea     ScrollBBase+(27*2)+(21*64),A1           ; Destination.", $0D, $0A
		dc.b	"                Move.w  #1,D0                                   ; Number of words.", $0D, $0A
		dc.b	"                Move.l  #VDP_VRAMWrite,D1                       ; Set to write to VRAM.   ", $0D, $0A
		dc.b	"                Moveq   #2,D2                                   ; Auto increment.        ", $0D, $0A
		dc.b	"                Jsr     PushDMA                                 ; Move characters to VRAM.", $0D, $0A, $0D, $0A
		dc.b	"                Lea     DownArrowBuffer,A0                      ; Source.", $0D, $0A
		dc.b	"                Lea     ScrollBBase+(27*2)+(26*64),A1           ; Destination.", $0D, $0A
		dc.b	"                Move.w  #1,D0                 "