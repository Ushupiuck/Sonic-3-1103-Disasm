.int:		dc.w .baseMonitor-.int
		dc.w .staticMonitor-.int
		dc.w .sonicMonitor-.int
		dc.w .eggmanMonitor-.int
		dc.w .ringMonitor-.int
		dc.w .speedMonitor-.int
		dc.w .fireMonitor-.int
		dc.w .thundMonitor-.int
		dc.w .bubbleMonitor-.int
		dc.w .invincMonitor-.int
		dc.w .superMonitor-.int
		dc.w .brokenMonitor-.int
; Offset_0x0134BA:
.baseMonitor:	dc.w	1
		dc.w	$F00F, $0000, -$10

; Offset_0x0134C2:
.staticMonitor:	dc.w	2
		dc.w	$F305, $0018, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x0134D0:
.sonicMonitor:
		dc.w	2
		dc.w	$F305, $0310, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x0134DE:
.eggmanMonitor:	dc.w	2
		dc.w	$F305, $001C, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x0134EC:
.ringMonitor:	dc.w	2
		dc.w	$F305, $2020, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x0134FA:
.speedMonitor:	dc.w	2
		dc.w	$F305, $0024, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x013508:
.fireMonitor:	dc.w	2
		dc.w	$F305, $0030, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x013516:
.thundMonitor:	dc.w	2
		dc.w	$F305, $002C, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x013524:
.bubbleMonitor:	dc.w	2
		dc.w	$F305, $0034, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x013532:
.invincMonitor:	dc.w	2
		dc.w	$F305, $0028, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x013540:
.superMonitor:	dc.w	2
		dc.w	$F305, $0038, -8
		dc.w	$F00F, $0000, -$10

; Offset_0x01354E:
.brokenMonitor:	dc.w	1
		dc.w	$FF0D, $0010, -$10