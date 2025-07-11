.int:		dc.w	.spinFrame1-.int
		dc.w	.spinFrame2-.int
		dc.w	.spinFrame3-.int
		dc.w	.spinFrame4-.int
		dc.w	.sparkleFrame1-.int
		dc.w	.sparkleFrame2-.int
		dc.w	.sparkleFrame3-.int
		dc.w	.sparkleFrame4-.int
		dc.w	.blank-.int
; Offset_0x010DF4:
.spinFrame1:	dc.w	1
		dc.w	$F805, $0000, -8

; Offset_0x010DFC:
.spinFrame2:	dc.w	1
		dc.w	$F805, $0004, -8

; Offset_0x010E04:
.spinFrame3:	dc.w	1
		dc.w	$F801, $0008, -4

; Offset_0x010E0C:
.spinFrame4:	dc.w	1
		dc.w	$F805, $0804, -8

; Offset_0x010E14:
.sparkleFrame1:	dc.w	1
		dc.w	$F805, $000A, -8

; Offset_0x010E1C:
.sparkleFrame2:	dc.w	1
		dc.w	$F805, $180A, -8

; Offset_0x010E24:
.sparkleFrame3:	dc.w	1
		dc.w	$F805, $080A, -8

; Offset_0x010E2C:
.sparkleFrame4:	dc.w	1
		dc.w	$F805, $100A, -8

; Offset_0x010E34:
.blank:		dc.w	0