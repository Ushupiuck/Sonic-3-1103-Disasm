.int:		dc.w	.vertShort-.int
		dc.w	.vertMedium-.int
		dc.w	.vertLong-.int
		dc.w	.vertLong-.int
		dc.w	.horizShort-.int
		dc.w	.horizMedium-.int
		dc.w	.horizLong-.int
		dc.w	.horizLong-.int
; Offset_0x012EA8:
.vertShort:	dc.w	4
		dc.w	$E005, $0000, -8
		dc.w	$F005, $0000, -8
		dc.w	$0005, $0000, -8
		dc.w	$1005, $0000, -8

; Offset_0x012EC2:
.vertMedium:	dc.w	4
		dc.w	$C005, $0000, -8
		dc.w	$E005, $0000, -8
		dc.w	$0005, $0000, -8
		dc.w	$3005, $0000, -8

; Offset_0x012EDC:
.vertLong:	dc.w	4
		dc.w	$8005, $0000, -8
		dc.w	$E005, $0000, -8
		dc.w	$0005, $0000, -8
		dc.w	$7005, $0000, -8

; Offset_0x012EF6:
.horizShort:	dc.w	4
		dc.w	$F805, $0000, -$20
		dc.w	$F805, $0000, -$10
		dc.w	$F805, $0000, 0
		dc.w	$F805, $0000, $10

; Offset_0x012F10:
.horizMedium:	dc.w	4
		dc.w	$F805, $0000, -$40
		dc.w	$F805, $0000, -$20
		dc.w	$F805, $0000, 0
		dc.w	$F805, $0000, $30

; Offset_0x012F2A:
.horizLong:	dc.w	4
		dc.w	$F805, $0000, -$80
		dc.w	$F805, $0000, -$20
		dc.w	$F805, $0000, 0
		dc.w	$F805, $0000, $70