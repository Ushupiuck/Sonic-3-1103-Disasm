; Constants
Compiler_Place_Holder = 0
Check_Interrupt       = $20800C
Size_of_Snd_driver_guess		= $1852

; ---------------------------------------------------------------------------
; Game Constants
; ---------------------------------------------------------------------------
; These are usually hardcoded, such as zone IDs or the selected character,
; so switching them around is considerably more difficult

; GAME MODE
gm_SEGALogo            = 0
gm_TitleScreen         = 4
gm_DemoMode            = 8
gm_PlayMode            = $C
gm_S2_SpecialStage     = $10
gm_Continue            = $14
gm_S2_Versus_Mode_Menu = $1C
gm_S2_Options_Menu     = $24
gm_Level_Select_Menu   = $28
gm_S3_Special_Stage    = $2C
gm_SK_Special_Stage    = $30

; PLAYER MODE
Sonic_And_Miles       = 0
Sonic_Alone           = 1
Miles_Alone           = 2
Knuckles_Alone        = 3

; CONTROLLER BUTTONS
Btn_Up                = 0
Btn_Down              = 1
Btn_Left              = 2
Btn_Right             = 3
Btn_B                 = 4
Btn_C                 = 5
Btn_A                 = 6
Btn_Start             = 7

; PATTERN LOAD CUES
id_PLC__First		= 0
id_PLC_Main1		= (PLCptr_Main1-ArtLoadCues)/2+id_PLC__First
id_PLC_Main2		= (PLCptr_Main2-ArtLoadCues)/2+id_PLC__First
id_PLC_Main3		= (PLCptr_Main3-ArtLoadCues)/2+id_PLC__First
id_PLC_GameOver		= (PLCptr_GameOver-ArtLoadCues)/2+id_PLC__First

; ---------------------------------------------------------------------------
; Sprite Status Table
; ---------------------------------------------------------------------------
Obj_Pointer           = $00     ; Longword      ; 00          ; 00..03
Obj_Flags             = $04     ; Byte          ; 01          ; 04
Obj_Routine           = $05     ; Byte          ; 24          ; 05
Obj_Height            = $06     ; Byte
Obj_Width             = $07     ; Byte          ; 19          ; 07
Obj_Priority          = $08     ; Word          ; 18          ; 08..09
Obj_Art_VRAM          = $0A     ; Word          ; 02..03      ; 0A..0B
Obj_Map               = $0C     ; Longword      ; 04..07      ; 0C..0F
Obj_X                 = $10     ; Word          ; 08..09      ; 10..11
Obj_Sub_X             = $12     ; Word          ; 0A..0B      ; 12..13  ; Fixed position
Obj_Y                 = $14     ; Word          ; 0C..0D      ; 14..15
Obj_Sub_Y             = $16     ; Word          ; 0E..0F      ; 16..17
Obj_Speed_X           = $18     ; Longword      ; 10..13      ; 18..1B
Obj_Speed_Y           = $1A     ; complemento do $18 as vezes referenciado em word ; 12..13 ; 1A..1B
Obj_Inertia           = $1C     ; Word          ; 14..15      ; 1C..1D
Obj_Height_2          = $1E     ; Byte          ; 16          ; 1E
Obj_Width_2           = $1F     ; Byte          ; 17          ; 1F
Obj_Ani_Number        = $20     ; Byte          ; 1C          ; 20
Obj_Ani_Flag          = $21     ; Byte          ; 1D          ; 21
Obj_Map_Id            = $22     ; Byte          ; 1A          ; 22
Obj_Ani_Frame         = $23     ; Byte          ; 1B          ; 23
Obj_Ani_Time          = $24     ; Byte          ; 1E..1F      ; 24..25
Obj_Ani_Time_2        = $25     ; Byte          ; 1F          ; 25   ; Usado por alguns objetos do Sonic 1
Obj_Angle             = $26     ; Byte          ; $26         ; $26
Obj_Flip_Angle        = $27     ; Byte          ; $27         ; $27
Obj_Col_Flags         = $28     ; Byte          ; 20          ; 28   ; Collision Flags
Obj_Col_Prop          = $29     ; Byte          ; 21          ; 29 
Obj_Status            = $2A     ; Byte          ; 22          ; 2A
Obj_Status_2          = $2B     ; Byte
Obj_Subtype           = $2C     ; Byte          ; 28          ; 2C
Obj_Flags_2           = $2D     ; Byte          ; 29          ; 2D
Obj_Timer             = $2E     ; Word          ; 2A..2B      ; 2E..2F
Obj_Timer_2           = $2F 
Obj_Child_Data        = $30  
Obj_Child             = $34 
Obj_Destr_Flag        = $3D     ; Byte          ; 39          ; 3D
Obj_Parent_Ref        = $3E     ; Word          ; 3E..3F      ; 3E..3F     
Obj_Height_3          = $44 
Obj_Width_3           = $45 
Obj_Child_Ref         = $46
Obj_Respaw_Ref        = $48     ; Word          ; None        ; 48..49

Obj_Size              = $4A

; Variaveis locais de objectos
Obj_Control_Var_00      = $30
Obj_Control_Var_01      = $31
Obj_Control_Var_02      = $32
Obj_Control_Var_03      = $33
Obj_Control_Var_04      = $34 
Obj_Control_Var_05      = $35
Obj_Control_Var_06      = $36
Obj_Control_Var_07      = $37
Obj_Control_Var_08      = $38
Obj_Control_Var_09      = $39
Obj_Control_Var_0A      = $3A
Obj_Control_Var_0B      = $3B
Obj_Control_Var_0C      = $3C
Obj_Control_Var_0D      = $3D
Obj_Control_Var_0E      = $3E
Obj_Control_Var_0F      = $3F
Obj_Player_One_Or_Two   = $3F
Obj_Control_Var_10      = $40
Obj_Control_Var_11      = $41
Obj_Control_Var_12      = $42
Obj_Control_Var_13      = $43  
Obj_Player_One_Or_Two_2 = $43
Obj_Control_Var_14      = $44  
Obj_Control_Var_16      = $46  

; Variaveis usadas pelos jogadores
Obj_Player_Flip_Flag  = $2D     ; Byte          ; 29          ; 2D
Obj_Player_Control    = $2E     ; Byte          ; 2A          ; 2E 
Obj_Player_Status     = $2F     ; Byte          ; 2B          ; 2F
Obj_P_Flips_Remaining = $30     ; Byte          ; 2C          ; 30   
Obj_Player_Flip_Speed = $31     ; Byte          ; 2D          ; 31
Obj_P_Horiz_Ctrl_Lock = $32     ; Word          ; 2E..2F      ; 32..33  
Obj_P_Invunerblt_Time = $34     ; Word / Byte   ; 30..31      ; 34
Obj_P_Invcbility_Time = $35     ; Word / Byte   ; 32..33      ; 35
Obj_P_Spd_Shoes_Time  = $36     ; Word / Byte   ; 34..35      ; 36
Obj_Player_Hit_Flag   = $37     ; Byte                        ; 37
Obj_Player_Selected   = $38     ; Byte                        ; 38  0 Sonic 1 Miles 2 Knuckles
Obj_Look_Up_Down_Time = $39     ; Byte                        ; 39 
Obj_Player_Next_Tilt  = $3A     ; Byte          ; 36          ; 3A
Obj_Player_Tilt       = $3B     ; Byte          ; 37          ; 3B
Obj_Player_St_Convex  = $3C     ; Byte          ; 38          ; 3C
Obj_Player_Spdsh_Flag = $3D     ; Byte          ; 39          ; 3D
Obj_Player_Spdsh_Cnt  = $3E     ; Byte          ; 3A          ; 3E
Obj_Player_Jump       = $40     ; Byte          ; 3C          ; 40   
Obj_Player_Angle_Flag = $41
Obj_Player_Last       = $42     ; Byte / Word   ; 3D          ; 42..43
Obj_Player_Top_Solid  = $46     ; Byte          ; 3E          ; 46
Obj_Player_LRB_Solid  = $47     ; Byte          ; 3F          ; 47 ; Left / Right / Bottom

; Variables used by bosses
Obj_LeftLock		= $1C
Obj_BossMusic		= $26
Obj_Boss_Hit		= $29
Obj_BossMusicTimer	= $2E

; Status dos jogadores. Também usado pelos escudos para proteção
Classic_Type       = 0
Invincibility_Type = 1
Speed_Type         = 2
Projectile_Type    = 3 
Fire_Type          = 4 
Lightning_Type     = 5 
Water_Type         = 6

Acceleration = 2
Deceleration = 4

Max_Dynamic_Objects   = ((Obj_Dynamic_RAM_End-Obj_Dynamic_RAM)/Obj_Size)-1
                          
; Fases 
S2_EHz_Id             = $00
S2_EHz_Act_1          = $0000
S2_EHz_Act_2          = $0001
S2_Mz_Act_3           = $0500
S2_WFz                = $0600
S2_HTz_Act_2          = $0701
S2_OOz_Act_2          = $0A01
S2_MCz_Id             = $0B
S2_MCz_Act_2          = $0B01
S2_CNz_Id             = $0C
S2_CNz_Act_1          = $0C00
S2_CNz_Act_2          = $0C01
S2_CPz_Act_1          = $0D00
S2_CPz_Act_2          = $0D01
S2_DEz                = $0E00  
S2_ARz_Act_1          = $0F00
S2_ARz_Act_2          = $0F01
S2_SCz                = $1000

Aiz_Id                = $00
AIz_Act_1             = $0000   
AIz_Act_2             = $0001
Hz_Id                 = $01
Hz_Act_1              = $0100
Hz_Act_2              = $0101
MGz_Id                = $02
MGz_Act_1             = $0200
MGz_Act_2             = $0201
CNz_Id                = $03
CNz_Act_1             = $0300
CNz_Act_2             = $0301
FBz_Act_1             = $0400
FBz_Act_2             = $0401 
Iz_Id                 = $05
Iz_Act_1              = $0500
Iz_Act_2              = $0501
LBz_Id                = $06
LBz_Act_1             = $0600
LBz_Act_2             = $0601
LRz_Id                = $09
LRz_Act_1             = $0900
DDz_Id                = $0C
DDz_Act_1             = $0C00
ALz_Id                = $0E
Alz_Act_1             = $0E00  
BPz_Id                = $0F
BPz_Act_1             = $0F00
DPz_Act_1             = $1000
CGz_Act_1             = $1100
EMz_Id                = $12
EMz_Act_1             = $1200
GM_BS_Id              = $13
GM_BS_Act_1           = $1300
GS_BS_Act_1           = $1400
SM_BS_Act_1           = $1500

; ---------------------------------------------------------------------------
; Sound commands list.

	phase $E0
cmd__First =			*		; ID of the first sound command
cmd_FadeOut			ds.b 1		; $E0 - fade out music
cmd_Stop			ds.b 1		; $E1 - stop music and sound effects
cmd_MutePSG			ds.b 1		; $E2 - mute all PSG channels
cmd_StopSFX			ds.b 1		; $E3 - stop all sound effects
cmd__End =			*		; next ID after last sound command

cmd_S2SlowDown =		$FC	; $FC - slow down music ID in Sonic 2
cmd_S2SEGA =			$FA		; $FA - SEGA sound ID in Sonic 2
cmd_StopSEGA =			$FE		; $FE - Stop SEGA sound
cmd_SEGA =			$FF		; $FF - Play SEGA sound
	dephase
; ---------------------------------------------------------------------------
; Music ID's list. These do not affect the sound driver, be careful.

	phase $01
mus__First =			*		; ID of the first music
mus_AIZ1			ds.b 1		; $01
mus_AIZ2			ds.b 1		; $02
mus_HCZ1			ds.b 1		; $03
mus_HCZ2			ds.b 1		; $04
mus_MGZ1			ds.b 1		; $05
mus_MGZ2			ds.b 1		; $06
mus_CNZ1			ds.b 1		; $07
mus_CNZ2			ds.b 1		; $08
mus_FBZ1			ds.b 1		; $09
mus_FBZ2			ds.b 1		; $0A
mus_ICZ1			ds.b 1		; $0B
mus_ICZ2			ds.b 1		; $0C
mus_LBZ1			ds.b 1		; $0D
mus_LBZ2			ds.b 1		; $0E
mus_MVZ1			ds.b 1		; $0F
mus_MVZ2			ds.b 1		; $10
mus_SOZ1			ds.b 1		; $11
mus_SOZ2			ds.b 1		; $12
mus_LRZ1			ds.b 1		; $13
mus_LRZ2			ds.b 1		; $14
mus_SSZ				ds.b 1		; $15
mus_DEZ1			ds.b 1		; $16
mus_DEZ2			ds.b 1		; $17
mus_Miniboss		ds.b 1		; $18
mus_EndBoss			ds.b 1		; $19
mus_DDZ				ds.b 1		; $1A
mus_Pachinko		ds.b 1		; $1B
mus_SpecialStage	ds.b 1		; $1C
mus_Slots			ds.b 1		; $1D
mus_Gumball			ds.b 1		; $1E
mus_Knuckles		ds.b 1		; $1F
mus_ALZ				ds.b 1		; $20
mus_BPZ				ds.b 1		; $21
mus_DPZ				ds.b 1		; $22
mus_CGZ				ds.b 1		; $23
mus_EMZ				ds.b 1		; $24
mus_TitleScreen		ds.b 1		; $25
mus_Credits			ds.b 1		; $26
mus_GameOver		ds.b 1		; $27
mus_Continue		ds.b 1		; $28
mus_GotThroughAct	ds.b 1		; $29
mus_ExtraLife		ds.b 1		; $2A
mus_Emerald			ds.b 1		; $2B
mus_Invincibility	ds.b 1		; $2C
mus_CompetitionMenu		ds.b 1		; $2D
mus_Unused			ds.b 1		; $2E
mus_DataSelect		ds.b 1		; $2F
mus_FinalBoss		ds.b 1		; $30
mus_Drowning		ds.b 1		; $31
mus__End =			*		; next ID after last music
	dephase

mus_SuperSonicUnk =	$0A
mus_S2ExtraLife =	$98
mus_S2Drowning =	$9F

; ---------------------------------------------------------------------------
; Sound effect ID's list. These do not affect the sound driver, be careful.

	phase $32
sfx__First =			*		; ID of the first sound effect
sfx_RingRight			ds.b 1		; $32
sfx_RingLeft			ds.b 1		; $33
sfx_RingLoss			ds.b 1		; $34
sfx_Death			ds.b 1		; $35
sfx_Skid			ds.b 1		; $36
sfx_SpikeHit			ds.b 1		; $37
sfx_Bubble			ds.b 1		; $38
sfx_Splash			ds.b 1		; $39
sfx_Shield			ds.b 1		; $3A
sfx_Drown			ds.b 1		; $3B
sfx_Roll			ds.b 1		; $3C
sfx_Break			ds.b 1		; $3D
sfx_FireShield			ds.b 1		; $3E
sfx_BubbleShield		ds.b 1		; $3F
sfx_UnknownShield		ds.b 1		; $40
sfx_LightningShield		ds.b 1		; $41
sfx_InstaAttack			ds.b 1		; $42
sfx_FireAttack			ds.b 1		; $43
sfx_BubbleAttack		ds.b 1		; $44
sfx_ElectricAttack		ds.b 1		; $45
sfx_Whistle			ds.b 1		; $46
sfx_SandwallRise		ds.b 1		; $47
sfx_Flying			ds.b 1		; $48
sfx_FlyTired			ds.b 1		; $49
sfx_Blast			ds.b 1		; $4A
sfx_Thump			ds.b 1		; $4B
sfx_Grab			ds.b 1		; $4C
sfx_Waterfall		ds.b 1		; $4D
sfx_SlideSkidLoud		ds.b 1		; $4E
sfx_WaterfallSplash		ds.b 1		; $4F
sfx_GlideLand			ds.b 1		; $50
sfx_Projectile			ds.b 1		; $51
sfx_MissileExplode		ds.b 1		; $52
sfx_FlamethrowerQuiet		ds.b 1		; $53
sfx_LargeShip		ds.b 1		; $54
sfx_BossActivate		ds.b 1		; $55
sfx_MissileThrow		ds.b 1		; $56
		ds.b 1		; $57
sfx_SpikeMove		ds.b 1		; $58
sfx_Charging		ds.b 1		; $59
sfx_BossLaser		ds.b 1		; $5A
sfx_BlockConveyor		ds.b 1		; $5B
sfx_FlipBridge		ds.b 1		; $5C
sfx_Geyser		ds.b 1		; $5D
sfx_BossRotate		ds.b 1		; $5E
sfx_FanBig		ds.b 1		; $5F
sfx_FanSmall		ds.b 1		; $60
sfx_FanLatch		ds.b 1		; $61
sfx_Collapse		ds.b 1		; $62
sfx_UnknownCharge		ds.b 1		; $63
sfx_Switch		ds.b 1		; $64
sfx_FlamethrowerLoud		ds.b 1		; $65
sfx_MechaSpark		ds.b 1		; $66
		ds.b 1		; $67
sfx_FloorThump		ds.b 1		; $68
sfx_Laser		ds.b 1		; $69
sfx_BossPanic		ds.b 1		; $6A
sfx_UnknownSpin		ds.b 1		; $6B
sfx_Crash		ds.b 1		; $6C
sfx_BossZoom		ds.b 1		; $6D
sfx_BossHitFloor		ds.b 1		; $6E
sfx_BossHitFloor2		ds.b 1		; $6F
sfx_Jump		ds.b 1		; $70
sfx_Starpost	ds.b 1		; $71
sfx_PulleyGrab	ds.b 1		; $72
sfx_Death2		ds.b 1		; $73
sfx_Skid2		ds.b 1		; $74
sfx_LevelProjectile	ds.b 1		; $75
sfx_SpikeHit2	ds.b 1		; $76
sfx_PushBlock	ds.b 1		; $77
sfx_Goal		ds.b 1		; $78
sfx_ActionBlock	ds.b 1		; $79
sfx_Splash2		ds.b 1		; $7A
sfx_UnknownShift	ds.b 1		; $7B
sfx_BossHit		ds.b 1		; $7C
sfx_Bubble2		ds.b 1		; $7D
sfx_LavaBall	ds.b 1		; $7E
sfx_Shield2		ds.b 1		; $7F
sfx_Hoverpad	ds.b 1		; $80
sfx_Transporter	ds.b 1		; $81
sfx_TunnelBooster	ds.b 1		; $82
sfx_BalloonPlatform	ds.b 1		; $83
	ds.b 1		; $84
sfx_TrapDoor	ds.b 1		; $85
sfx_Balloon		ds.b 1		; $86
sfx_CannonTurn	ds.b 1		; $87
sfx_GravityMachine	ds.b 1		; $88
sfx_Lightning	ds.b 1		; $89
sfx_BossMagma	ds.b 1		; $8A
sfx_SmallBumpers	ds.b 1		; $8B
sfx_ChainTension	ds.b 1		; $8C
sfx_UnknownPump		ds.b 1		; $8D
sfx_SlideSkidQuiet	ds.b 1		; $8E
sfx_GroundSlide		ds.b 1		; $8F
sfx_SpikeBalls	ds.b 1		; $90
sfx_FrostPuff	ds.b 1		; $91
sfx_IceSpikes	ds.b 1		; $92
sfx_LightTunnel	ds.b 1		; $93
sfx_Rumble	ds.b 1		; $94
sfx_TubeLauncher	ds.b 1		; $95
	ds.b 1		; $96
sfx_BridgeCollapse	ds.b 1		; $97
sfx_BigRumble	ds.b 1		; $98
sfx_UnknownPowerUp	ds.b 1		; $99
sfx_UnknownPowerDown	ds.b 1		; $9A
sfx_Alarm	ds.b 1		; $9B
sfx_DeathEggRiseLoud	ds.b 1		; $9C
sfx_WindQuiet	ds.b 1		; $9D
sfx_WindLoud	ds.b 1		; $9E
sfx_MushroomBounce	ds.b 1		; $9F
sfx_PulleyMove	ds.b 1		; $A0
sfx_WeatherMachine	ds.b 1		; $A1
sfx_Bouncy	ds.b 1		; $A2
sfx_ChopTree	ds.b 1		; $A3
sfx_Rising	ds.b 1		; $A4
sfx_ChopStuck	ds.b 1		; $A5
sfx_UnknownFlutter	ds.b 1		; $A6
sfx_UnknownRevving	ds.b 1		; $A7
sfx_DoorOpen	ds.b 1		; $A8
sfx_DoorMove	ds.b 1		; $A9
sfx_DoorClose	ds.b 1		; $AA
sfx_GhostAppear	ds.b 1		; $AB
sfx_BossRecovery	ds.b 1		; $AC
sfx_ChainTick	ds.b 1		; $AD
sfx_GumballTab	ds.b 1		; $AE
sfx_BossHand	ds.b 1		; $AF
sfx_MechaLand	ds.b 1		; $B0
sfx_EnemyBreath	ds.b 1		; $B1
sfx_DeathEggRiseQuiet	ds.b 1		; $B2
sfx_BossProjectile	ds.b 1		; $B3
	ds.b 1		; $B4
sfx_LavaFall	ds.b 1		; $B5
sfx_SpringLatch	ds.b 1		; $B6
sfx_ThumpBoss	ds.b 1		; $B7
sfx_SuperEmerald	ds.b 1		; $B8
sfx_Targeting	ds.b 1		; $B9
sfx_Clank	ds.b 1		; $BA
sfx_SuperTransform	ds.b 1		; $BB
sfx_UnknownZap	ds.b 1		; $BC
sfx_MissileShoot	ds.b 1		; $BD
sfx_UnknownOminous	ds.b 1		; $BE
sfx_ConveyorPlatform	ds.b 1		; $BF
sfx_UnknownSaw	ds.b 1		; $C0
	ds.b 1		; $C1
sfx_GravityLift	ds.b 1		; $C2
sfx_MechaTransform	ds.b 1		; $C3
sfx_UnknownRise	ds.b 1		; $C4
sfx_MagneticSpike	ds.b 1		; $C5
sfx_LeafBlower	ds.b 1		; $C6
sfx_LaunchGrab	ds.b 1		; $C7
sfx_LaunchReady	ds.b 1		; $C8
sfx_EnergyZap	ds.b 1		; $C9
sfx_Jump2		ds.b 1		; $CA
sfx_Bumper		ds.b 1		; $CB
sfx_Spindash	ds.b 1		; $CC
sfx_Continue	ds.b 1		; $CD
sfx_Starpost2	ds.b 1		; $CE
sfx_Flipper		ds.b 1		; $CF
sfx_EnterSS		ds.b 1		; $D0
sfx_Register	ds.b 1		; $D1
sfx_Spring		ds.b 1		; $D2
sfx_Error		ds.b 1		; $D3
sfx_BigRing		ds.b 1		; $D4
sfx_BossHit2	ds.b 1		; $D5
sfx_Diamonds	ds.b 1		; $D6
sfx_Dash	ds.b 1		; $D7
sfx_SlotMachine	ds.b 1		; $D8
sfx_Signpost	ds.b 1		; $D9
sfx__End =			*		; next ID after the last sound effect

	dephase
	!org 0				; make sure we reset the ROM position to 0

sfx_BigRingUnk = $32
sfx_S2Smash =	$B9
sfx_S2LargeBumper = $D9
sfx_S2Error	=	$ED

; Músicas 
Angel_Island_1_Snd       = mus_AIZ1
Angel_Island_2_Snd       = mus_AIZ2
Hydrocity_1_Snd          = $0003
Hydrocity_2_Snd          = $0004
Marble_Garden_1_Snd      = $0005
Marble_Garden_2_Snd      = $0006
Carnival_Night_1_Snd     = $0007
Carnival_Night_2_Snd     = $0008
Flying_Battery_1_Snd     = $0009
Flying_Battery_2_Snd     = $000A
Icecap_1_Snd             = $000B
Icecap_2_Snd             = $000C
Launch_Base_1_Snd        = $000D
Launch_Base_2_Snd        = $000E
Mushroom_Valley_1_Snd    = $000F
Mushroom_Valley_2_Snd    = $0010
Sandopolis_1_Snd         = $0011
Sandopolis_2_Snd         = $0012
Lava_Reef_1_Snd          = $0013
Lava_Reef_2_Snd          = $0014
Sky_Sanctuary_Snd        = $0015
Death_Egg_1_Snd          = $0016
Death_Egg_2_Snd          = $0017
Mini_Boss_Snd            = $0018
Boss_Snd                 = $0019
The_Doomsday_Snd         = $001A
Special_Stage_Snd        = $001C
BS_Slot_Machine_Snd      = $001D
BS_Gumball_Machine_Snd   = $001E
Knuckles_Theme_Snd       = $001F
Azure_Lake_Snd           = $0020
Balloon_Park_Snd         = $0021
Desert_Palace_Snd        = $0022
Chrome_Gadget_Snd        = $0023
Endless_Mine_Snd         = $0024
Title_Screen_Snd         = $0025
Game_Over_Time_Over_Snd  = $0027 
Continue_Snd             = $0028
Extra_Life_Snd           = $002A
Got_Emerald_Snd          = $002B
Invincibility_Snd        = mus_Invincibility
Panic_Snd                = mus_Drowning

Super_Sonic_Snd          = $000A 


; Efeitos especiais
Ring_Sfx                 = $0032
Ring_Left_Speaker_Sfx    = $0033
Ring_Lost_Sfx            = $0034
Hurt_Sfx                 = $0035
Skidding_Sfx             = $0036 ; Stopping_Sfx
Collect_Oxygen_Sfx       = $0038 
Water_Splash_Sfx         = $0039
Drowning_Sfx             = $003B
Rolling_Sfx              = $003C ; Spin_Sfx     
Object_Hit_Sfx           = $003D
Got_Fire_Shield_Sfx      = $003E  
Got_Water_Shield_Sfx     = $003F
Got_Lightning_Shield_Sfx = $0041
Fire_Shield_Sfx          = $0043
Hyper_Form_Change_Sfx    = $0046
Grab_Sfx                 = $004A
Waterfall_Splash_Sfx     = $004F
Projectile_Sfx           = $0051
Missile_Explosion_Sfx    = $0052
Flame_Sfx                = $0053
Flying_Battery_Move_Sfx  = $0054
Missile_Throw_Sfx        = $0056 
Robotnik_Buzzer_Sfx      = $0057
Spike_Move_Sfx           = $0058
Draw_Bridge_Move_Sfx     = $005C
Geyser_Sfx               = $005D
Fan_Big_Sfx              = $005E 
Sfx_61                   = $0061
Smash_Sfx                = $0062 
Switch_Blip_Sfx          = $0064
Floor_Thump_Sfx          = $0068
Crash_Sfx                = $006C
Jump_Sfx                 = $0070
Level_Projectile_Sfx     = $0075
Underwater_Sfx           = $0079
Boss_Hit_Sfx             = $007C
Hoverpad_Sfx             = -$80   ; $0080
Transporter_Sfx          = -$7F   ; $0081
Tunnel_Booster_Sfx       = -$7E   ; $0082
Rising_Platform_Sfx      = -$7D   ; $0083
Wave_Hover_Sfx           = -$7C   ; $0084
Trapdoor_Sfx             = -$7B   ; $0085
Balloon_Pop_Sfx          = -$7A   ; $0086 
Cannon_Turn_Sfx          = -$79   ; $0087
Small_Bumper_Sfx         = -$75   ; $008B
Frost_Puff_Sfx           = -$6F   ; $0091
Ice_Spike_Sfx            = -$6E   ; $0092
Tube_Launcher_Sfx        = -$6B   ; $0095
Bridge_Collapse_Sfx      = -$69   ; $0097  
Buzzer_Sfx               = -$65   ; $009B
Door_Close_Sfx           = -$56   ; $00AA
Slide_Thunk_Sfx          = -$50   ; $00B0
Super_Form_Change_Sfx    = -$45   ; $00BB  
Energy_Zap_Sfx           = -$37   ; $00C9
Check_Point_Sfx          = -$32   ; $00CE 
Special_Stage_Entry_Sfx  = -$30   ; $00D0 
Spring_Sfx               = -$2E   ; $00D2
Error_Sfx                = $00D3       

S2_Enter_Big_Ring_Sfx    = $32
S2_Extra_Life_Snd        = $98
S2_Panic_Snd             = $9F 
S2_Smash_Sfx             = $B9 
S2_Cha_Ching_Sfx         = $C5 
S2_Spring_Sfx            = $CC
S2_Add_Points_Blip_Sfx   = $CD
S2_Panel_Spinning_Sfx    = $CF 
S2_Baaaang_Bumper_Sfx    = $D9


; Comandos
Volume_Down              = signextendB(cmd_FadeOut)
Stop_Sound               = signextendB(cmd_Stop)
PSG_Mute                 = signextendB(cmd_MutePSG)
Stop_SFx                 = signextendB(cmd_StopSFX)
Music_Normal_Speed       = $FC

; Z80  
Z80_RAM_Start                  = $A00000 

; I/O

IO_Hardware_Version            = $A10001 
IO_Joypad_Port_0               = $A10003
IO_Port_0_Control              = $A10008
IO_Port_1_Control              = $A1000A
IO_Expansion_Control           = $A1000C

Z80_Bus_Request                = $A11100 
Z80_Reset                      = $A11200 

; VDP

VDP_Data_Port                  = $C00000
VDP_Control_Port               = $C00004

; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; RAM
M68K_Dev_RAM_Start	= ramaddr($FFFE0000)

	phase ramaddr($FFFF0000)

M68K_RAM_Start:		ds.b	$8000

Sprite_Table_Buffer_2	= M68K_RAM_Start+$7880
Sprite_Table_Buffer_P2	= M68K_RAM_Start+$7B00
Sprite_Table_Buffer_P2_2	= M68K_RAM_Start+$7D80

Level_Layout_Buffer:	ds.b	$1000
Level_Layout_Buffer_End

Fg_Mem_Start_Address	= Level_Layout_Buffer
Fg_Mem_Index_Address	= Level_Layout_Buffer+8

Blocks_Mem_Address:		ds.b	8*$300		; $1800 bytes ($300 block limit)

Horizontal_Scroll_Table:	ds.b	$200	; $200 bytes
NemesisDec_Data_Buffer:		ds.b	$200	; $200 bytes
Sprite_Table_Input:		ds.b	$400		; $400 bytes
Sprite_Table_Input_End

Obj_Memory_Address:
Obj_Player_One:			ds.b	Obj_Size
Obj_Player_Two:			ds.b	Obj_Size
Obj_02_Mem_Address:		ds.b	Obj_Size
Obj_Dynamic_RAM:		ds.b	Obj_Size
Obj_04_Mem_Address:		ds.b	Obj_Size
Obj_05_Mem_Address:		ds.b	Obj_Size
		ds.b	Obj_Size
		ds.b	Obj_Size
Obj_08_Mem_Address:		ds.b	Obj_Size
	rept $54
		ds.b	Obj_Size
	endm
Obj_Dynamic_RAM_End
		ds.b	Obj_Size
Obj_Fixed_RAM:
Obj_P1_Underwater_Control:		ds.b	Obj_Size
Obj_P2_Underwater_Control:		ds.b	Obj_Size
Obj_Super_Sonic_Stars_RAM:		ds.b	Obj_Size
Obj_Miles_Tails_RAM:		ds.b	Obj_Size
Obj_P1_Dust_Water_Splash:		ds.b	Obj_Size
Obj_P2_Dust_Water_Splash:		ds.b	Obj_Size
Obj_P1_Shield:		ds.b	Obj_Size
Obj_P2_Shield:		ds.b	Obj_Size
Obj_P1_Invincibility:		ds.b	Obj_Size
	rept 3
		ds.b	Obj_Size
	endm
Obj_P2_Invincibility:		ds.b	Obj_Size
		ds.b	Obj_Size
		ds.b	Obj_Size
Obj_Fixed_RAM_End
		ds.b	$5E
Conveyor_Belt_Data_Array:		ds.b	$20
Obj_Memory_Address_End

Kosinski_Decomp_Buffer:		ds.b	$1000
Horizontal_Scroll_Buffer:		ds.b	$380
Horizontal_Scroll_Buffer_End
Horizontal_Scroll_Buffer_End_Padded = Horizontal_Scroll_Buffer_End+$80

Collision_Response_List:		ds.b	$80

Status_Table_Data:		ds.b	$100
Position_Table_Data:		ds.b	$100
Position_Table_Data_P2:		ds.b	$100

DMA_Buffer_List:		ds.w	7*$12	; stores 18 ($12) VDP commands to issue the next time ProcessDMAQueue is called
		ds.w	7*$12
DMA_Buffer_List_End:	ds.l	1	; stores the address of the next open slot for a queued VDP command
		ds.l	1

Ring_Status_Table:		ds.b	$400

Palette_Buffer:		ds.b	$80
Palette_Row_0_Offset	= Palette_Buffer
Palette_Row_1_Offset	= Palette_Buffer+$20
Palette_Row_2_Offset	= Palette_Buffer+$40
Palette_Row_3_Offset	= Palette_Buffer+$60

Palette_Data_Target:		ds.b	$80
Palette_Row_1_Data_Target	= Palette_Data_Target+$20
Palette_Row_2_Data_Target	= Palette_Data_Target+$40
Palette_Row_3_Data_Target	= Palette_Data_Target+$60                            

Camera_RAM:
Horizontal_Scrolling:		ds.w	1
Vertical_Scrolling:		ds.w	1
Horizontal_Scrolling_P2:		ds.w	1
Vertical_Scrolling_P2:		ds.w	1
Tmp_EE08:		ds.w	1
Sonic_Scroll_Lock_Flag:		ds.b	1
Miles_Scroll_Lock_Flag:		ds.b	1
Level_Limits_Min_X:		ds.w	1
Level_Limits_Max_X:		ds.w	1
Level_Limits_Min_Y:		ds.w	1
Level_Limits_Max_Y:		ds.w	1
Sonic_Level_Limits_Min_X:		ds.w	1
Sonic_Level_Limits_Max_X:		ds.w	1
Sonic_Level_Limits_Min_Y:		ds.w	1
Sonic_Level_Limits_Max_Y:		ds.w	1
Miles_Level_Limits_Min_X:		ds.w	1
Miles_Level_Limits_Max_X:		ds.w	1
Miles_Level_Limits_Min_Y:		ds.w	1
Miles_Level_Limits_Max_Y:		ds.w	1
Camera_X_Scroll_Delay:		ds.w	1
Position_Table_Index:		ds.w	1
Camera_X_Scroll_Delay_2P:		ds.w	1
Position_Table_Index_2P:		ds.w	1
Distance_From_Top:		ds.w	1
Distance_From_Top_P2:		ds.w	1
Rasters_Flag:		ds.w	1
Level_Limits_Y_Changing:		ds.b	1
Dynamic_Resize_Routine:		ds.b	1
		ds.b	5
Fast_Vertical_Scroll_Flag:		ds.b	1
Vertical_Scroll_Value_P2_2:		ds.l	1
Camera_X_Difference:		ds.w	1
Camera_Y_Difference:		ds.w	1
		ds.w	1
Ring_Start_Offset_Ptr:		ds.l	1
Ring_End_Offset_Ptr:		ds.l	1
Ring_Offset_Ptr:		ds.l	1
Object_Respaw_Next:		ds.w	1
Object_Respaw_Previous:		ds.w	1
Apparent_ZoneAndAct:		; 2 bytes; unlike Current_ZoneAndAct, this is only used during level transitions where the player enters Act 2 but is still stated to be in Act 1 until a later point
Apparent_Zone:		ds.b	1
Apparent_Act:		ds.b	1
Palette_Fade_Timer:		ds.w	1
		ds.b	8
Camera_X_P2:		ds.l	1
Camera_Y_P2:		ds.l	1
Screen_Pos_Buffer_X_P2:		ds.l	1
Screen_Pos_Buffer_Y_P2:		ds.l	1
Screen_Pos_Buffer_X_P2_2:		ds.l	1
Screen_Pos_Buffer_Y_P2_2:		ds.l	1
Camera_X:		ds.l	1
Camera_Y:		ds.l	1
Screen_Pos_Buffer_X:		ds.l	1
Screen_Pos_Buffer_Y:		ds.l	1
Screen_Pos_Rounded_X:		ds.w	1
Screen_Pos_Rounded_Y:		ds.w	1
Screen_Pos_Buffer_X_2:		ds.w	1
AIz_Wavy_Flame_Counter:		ds.w	1
Screen_Pos_Buffer_Y_2:		ds.l	1
Screen_Pos_Rounded_X_2:		ds.w	1
Screen_Pos_Rounded_Y_2:		ds.w	1
AIz_Flying_Battery_X:		ds.l	1
AIz_Flying_Battery_Y:		ds.l	1
		ds.w	1
AIz_Flying_Battery_Rounded_Y:		ds.w	1
Plane_Double_Update_Flag:		ds.w	1
Special_Vint_Routine:		ds.w	1
Screen_Wrap_X:		ds.w	1
Screen_Wrap_Y:		ds.w	1
Level_Layout_Wrap_Y:		ds.w	1
Level_Layout_Wrap_Row:		ds.w	1
VRAM_Add:		ds.w	1
Level_Repeat_Routine:		ds.w	1
Level_Events_Buffer_0:		ds.w	1
Level_Events_Buffer_1:		ds.w	1
Level_Events_Buffer_0_P2:		ds.w	1
Level_Events_Buffer_1_P2:		ds.w	1
Level_Repeat_Offset:		ds.l	1
Level_Events_Routine:		ds.w	1
Level_Events_Routine_2:		ds.w	1
Foreground_Events_Y_Counter:		ds.w	1
Level_Events_Buffer_5:		ds.w	1
Draw_Delayed_Position:		ds.w	1
Draw_Delayed_Position_Rowcount:		ds.w	1
Earthquake_Flag:		ds.w	1
Earthquake_Offset:		ds.w	1
Earthquake_Last_Offset:		ds.w	1
Background_Events:		ds.b	$18
Vertical_Scroll_Buffer:		ds.b	$50
Sprite_Mask_Flag:		ds.w	1
Use_Normal_Sprite_Table:		ds.w	1
Normal_Sprite_Table_Flag:		ds.w	1
Level_Result_BCD_Total_Bonus:		ds.b	$40
Ring_Consumption_Table:		ds.b	$80

Palette_Underwater_Target:		ds.b	$80

Palette_Underwater_Buffer:		ds.b	$80
Palette_UW_Row_0_Offset	= Palette_Underwater_Buffer
Palette_UW_Row_1_Offset	= Palette_Underwater_Buffer+$20
Palette_UW_Row_2_Offset	= Palette_Underwater_Buffer+$40
Palette_UW_Row_3_Offset	= Palette_Underwater_Buffer+$60

Plane_Buffer:		ds.b	$500
Game_Mode:		ds.b	1
		ds.b	1
Control_Ports_Logical_Data:		ds.w	1
Control_Ports_Buffer_Data:		ds.w	1
		ds.w	1
HBlank_Ptr:		ds.b	6
VDP_Register_1_Command:		ds.w	1
		ds.l	1
Demo_Timer:		ds.w	1
Vertical_Scroll_Value:		ds.w	1
Vertical_Scroll_Value_2:		ds.w	1
Vertical_Scroll_Value_3:		ds.w	1
		ds.w	1
Vertical_Scroll_Value_P2:		ds.w	1
Vertical_Scroll_Value_P2_3:		ds.w	1
S2_Teleport_Timer:		ds.b	1
S2_Teleport_Flag:		ds.b	1
Horizontal_Int_Count_Cmd:		ds.b	1
Scanline_Counter:		ds.b	1
Palette_Fade_Info:		ds.b	1
Palette_Fade_Count:		ds.b	1

MiscLevelVariables:

VBlank_0_Run_Count:		ds.w	1
VBlank_Index:		ds.w	1
Sprites_Drawn:		ds.w	1
Palette_Underwater_Ptr:		ds.l	1
Palette_Cycle_Count_0:		ds.w	1
Palette_Cycle_Count_1:		ds.w	1
Random_Seed:		ds.l	1
Pause_Status:		ds.w	1
		ds.l	1
DMA_Trigger:		ds.l	1
Horizontal_Interrupt_Flag:		ds.w	1
Water_Level_Move:		ds.w	1
Current_Water_Level:		ds.w	1
Target_Water_Level:		ds.w	1
Water_Level_Change_Speed:		ds.b	1
Water_Entered_Counter:		ds.b	1
Underwater_Flag:		ds.b	1
H_Int_Update_Flag:		ds.b	1
Palette_Cycle_Counters:		ds.b	$C
Super_Sonic_Palette_Frame:		ds.w	1
Super_Sonic_Palette_Timer:		ds.b	1
Super_Sonic_Palette_Status:		ds.b	1
PalCycle_Done_Flag:		ds.w	1
VBlank_Subroutine:		ds.b	1
		ds.b	1
Background_Collision_Flag:		ds.l	1
Level_Boundaries_Flag:		ds.w	1
Control_Ports_Logical_Data_2:		ds.w	1
		ds.l	1
Super_Sonic_Frame_Count:		ds.b	1
		ds.b	$F
MiscLevelVariables_End

PLC_Data_Buffer:		ds.b	6*16
PLC_Data_Buffer_Only_End
Nemesis_Decomp_Destination	= PLC_Data_Buffer+4
Nemesis_Decomp_Vars:		ds.l	1
Nemesis_Repeat_Count:		ds.l	1
Nemesis_Palette_Index:		ds.l	1
Nemesis_Previous_Row:		ds.l	1
Nemesis_Data_Word:		ds.l	1
Nemesis_Shift_Value:		ds.l	1
PLC_Data_Count:		ds.w	1
Nemesis_Frame_Pattern_Left:		ds.w	1
		ds.l	1
PLC_Data_Buffer_End

Misc_Variables:

Miles_Control_Vars:		ds.w	1
Miles_CPU_Ctrl_Auto_Timer:		ds.w	1
Miles_CPU_Respawn_Timer:		ds.w	1
		ds.w	1
Miles_CPU_Routine:		ds.w	1
Miles_CPU_Respawn_X:		ds.w	1
Miles_CPU_Respawn_Y:		ds.w	1
		ds.b	1
Miles_CPU_Jumping:		ds.b	1
Ring_Pos_Routine:		ds.b	1
Title_Card_Flag:		ds.b	1
		ds.b	8
CNz_Triangle_Pos_Routine:		ds.b	1
CNz_Triangle_Pos_Flag:		ds.b	1
CNz_Triangle_Pos_Start:		ds.l	1
CNz_Triangle_Pos_End
		ds.l	1
CNz_Triangle_Pos_Start_2P:		ds.l	1
CNz_Triangle_Pos_End_2P
		ds.b	6
Palette_Cycle_Flag:		ds.w	1
Water_Level_Flag:		ds.w	1
Demo_Button_Index_2P:		ds.w	1
Demo_Button_Press_Counter_2P:		ds.w	1
		ds.b	8
Carrying_Sonic_Data:		ds.w	1
Art_Scaling_Data_Buffer:		ds.l	1
Art_Scaling_Index_0:		ds.w	1
Art_Scaling_Index_1:		ds.w	1
Art_Scaling_Index_2:		ds.w	1
Art_Scaling_Result_0:		ds.l	1
Art_Scaling_Result_1:		ds.l	1
Art_Scaling_Result_2:		ds.l	1
		ds.b	6
Art_Scaling_Address:		ds.l	1
Sonic_Max_Speed:		ds.w	1
Sonic_Acceleration:		ds.w	1
Sonic_Deceleration:		ds.w	1
Sonic_Previous_Frame:		ds.w	1
Primary_Angle:		ds.w	1
Secondary_Angle:		ds.w	1
Object_Pos_Routine:		ds.w	1
Camera_X_Current:		ds.w	1
Object_Pos_Next:		ds.l	1
Object_Pos_Previous:		ds.l	1
		ds.b	$14
Camera_X_Current_P2:		ds.l	1
Demo_Button_Index:		ds.w	1
Demo_Button_Press_Counter:		ds.w	1
Demo_Pal_FadeOut_Counter:		ds.w	1
Current_Collision_Ptr:		ds.l	1
		ds.b	$10
Boss_Flag:		ds.b	1
		ds.b	7
Sonic_LBz_Cylinder_Angle:		ds.b	1
Miles_LBz_Cylinder_Angle:		ds.b	1
Primary_Collision_Ptr:		ds.l	1
Secondary_Collision_Ptr:		ds.l	1
		ds.w	1
S1_Load_Big_Ring_Art_Flag:		ds.w	1
		ds.b	7
Wind_Tunnels_Flag:		ds.b	1
Sonic_Wind_Flag:		ds.b	1
Miles_Wind_Flag:		ds.b	1
		ds.w	1
Control_Locked_Flag_P1:		ds.b	1
Special_Stage_Entry_Flag:		ds.b	1
		ds.b	1
Control_Locked_Flag_P2:		ds.b	1
Enemy_Hit_Chain_Count:		ds.w	1
Level_Results_Time_Bonus:		ds.w	1
Level_Results_Ring_Bonus:		ds.w	1
HUD_Results_Refresh_Flag:		ds.w	1
		ds.w	1
Camera_X_Left:		ds.w	1
Camera_X_Left_P2:		ds.w	1
Miles_Previous_Frame:		ds.b	1
Miles_Tails_Previous_Frame:		ds.b	1
; Refresh_Level_Layout	= M68K_RAM_Start+$F7E0
Level_Trigger_Array:		ds.b	$10
Animate_Counters:		ds.b	$10

Misc_Variables_End

Sprite_Table_Buffer:		ds.b	$280
Sprite_Table_Buffer_End
Boss_Data_Buffer:		ds.b	$12
;Tmp_FA81	= M68K_RAM_Start+$FA81
;Tmp_FA82	= M68K_RAM_Start+$FA82
;Tmp_FA83	= M68K_RAM_Start+$FA83
;Tmp_FA8A	= M68K_RAM_Start+$FA8A
;Tmp_FA8B	= M68K_RAM_Start+$FA8B
Target_Camera_Max_X:		ds.w	1
Target_Camera_Min_X:		ds.w	1
Target_Camera_Min_Y:		ds.w	1
Target_Camera_Max_Y:		ds.w	1
Slotted_Objects_Bits:		ds.b	8
Boss_Attack_Started:		ds.b	1
Boss_Defeated_Flag:		ds.b	1
Obj_Knuckles_Mem_Address:		ds.w	1
Obj_End_Panel_Mem_Address:		ds.w	1
Player_Control_Lock_Flag:		ds.b	1
Knuckles_Control_Lock_Flag:		ds.b	1
End_Level_Flag:		ds.b	1
		ds.b	$2F
Palette_Rotation_Custom:		ds.l	1
Palette_Rotation_Data:		ds.w	9
		ds.b	$10
Object_Respawn_Table:		ds.b	$200
Object_Respawn_Table_End

S2_Palette_Buffer	= M68K_RAM_Start+$FB00
S2_Palette_Row_0_Offset	= S2_Palette_Buffer
S2_Palette_Row_1_Offset	= S2_Palette_Buffer+$20
		ds.b	$100
System_Stack:

; RAM from now will not be cleared after a soft reset.
CrossResetRAM:
		ds.w	1
Restart_Level_Flag:		ds.w	1
Level_inactive_flag:	= Restart_Level_Flag
Level_Frame_Count:		ds.l	1
Level_frame_counter:	= Level_Frame_Count
Debug_object:	= Level_Frame_Count+2
Debug_Mode_Flag_Index:		ds.w	1
Debug_placement_mode:	= Debug_Mode_Flag_Index
Debug_Accel_Timer:		ds.b	1					; time it takes to reach max speed
Debug_Speed:			ds.b	1					; current speed of the camera

Vint_runcount:			ds.l	1					; 4 bytes

Current_ZoneAndAct:		ds.w	1					; 2 bytes; not to be confused with Apparent_ZoneAndAct, this holds the real zone the player is in
Current_Zone:			= *-2
Current_Act:			= *-1
Life_count:			ds.b	1					; current lives; not the lives displayed on the screen
				ds.b	3					; unused
Current_SpecialStage:		ds.w	1					; 2 bytes, although only the first is used
Continue_count:			ds.b	1					; current continues
Super_Sonic_flag:		ds.b	1					; whether or not Sonic is in his Super transformation
Time_Over_flag:			ds.b	1					; determines if the player got a Game or Time over
Extra_life_flags:		ds.b	1					; flag for giving the player a 1UP at 100 or 200 rings

; If set, the respective HUD element will be updated.
Update_HUD_lives:		ds.b	1
Update_HUD_rings:		ds.b	1
Update_HUD_timer:		ds.b	1
Update_HUD_score:		ds.b	1

Ring_count:			ds.w	1					; 2 bytes
Timer:				ds.l	1					; 4 bytes
Timer_minute:		=	*-3
Timer_second:		=	*-2
Timer_frame:		=	*-1

Score_Count_Address:		ds.l	1
		ds.b	6
Saved_Level_Flag:		ds.b	1
Saved_Last_Start_Post_Hit:		ds.b	1
Saved_Obj_X_P1:		ds.w	1
Saved_Obj_Y_P1:		ds.w	1
Saved_Ring_Count_Address:		ds.w	1
Saved_Time:		ds.l	1
Saved_Obj_Art_VRAM_P1:		ds.w	1
Saved_Top_Solid_P1:		ds.w	1
Saved_Camera_X:		ds.w	1
Saved_Camera_Y:		ds.w	1
		ds.b	$C
Saved_Current_Water_Level:		ds.w	1
		ds.b	1
Saved_Underwater_Flag:		ds.b	1
Saved_Ring_Status_Flag:		ds.b	1
Saved_Ring_Status_Flag_P2:		ds.b	1
Saved_Sonic_Level_Limits_Max_Y:		ds.w	1
Saved_Dynamic_Resize_Routine:		ds.b	1
		ds.b	1
Dropdash_flag:		ds.w	1	; checks if Sonic is currently 'dropdashing'
		ds.w	1
Oscillate_Data_Buffer:		ds.w	1
Oscillating_variables:
		ds.b	$42
Object_Frame_Timer:		ds.b	1
Object_Frame_Buffer:		ds.b	1
		ds.w	1
Object_Frame_Anim_Counter:		ds.b	1
Object_Frame_Anim_Frame:		ds.b	1
Object_Frame_Anim_Accum:		ds.w	1
Object_Frame_Angle:		ds.w	1
		ds.l	1
Oscillating_variables_End

LRz_Rocks_Routine:		ds.b	1
		ds.b	1
LRz_Rocks_Pos_Next:		ds.l	1
LRz_Rocks_Pos_Previous:		ds.l	1
		ds.b	6
Miles_Max_Speed:		ds.w	1
Miles_Acceleration:		ds.w	1
Miles_Deceleration:		ds.w	1
Life_Count_P2:		ds.b	1
Ring_Status_Flag_P2:		ds.b	1	; Extra life with 100 and 200 rings and continue
HUD_Life_Refresh_Flag_P2:		ds.b 1
HUD_Rings_Refresh_Flag_P2:		ds.b	1
HUD_Timer_Refresh_Flag_P2:		ds.b	1
HUD_Score_Refresh_Flag_P2:		ds.b	1
Time_Over_Flag_P2:		ds.b	1
		ds.b	3
Ring_Count_Address_P2:		ds.w	1
Time_Count_Address_P2:		ds.b	1
Timer_Minute_Count_Address_P2:		ds.b	1
		ds.w	1
Score_Count_Address_P2:		ds.l	1
		ds.b	6
Saved_Level_Flag_P2:		ds.b	1
Saved_Last_Start_Post_Hit_P2:		ds.b	1
Saved_Obj_X_P2:		ds.w	1
Saved_Obj_Y_P2:		ds.w	1
Saved_Ring_Count_Address_P2:		ds.w	1
Saved_Time_Count_Address_P2:		ds.l	1
Saved_Obj_Art_VRAM_P2:		ds.w	1
Saved_Top_Solid_P2:		ds.w	1
Total_Ring_Count_Address:		ds.w	1
Total_Ring_Count_Address_P2:		ds.w	1
Monitors_Broken:		ds.w	1
Monitors_Broken_P2:		ds.w	1
Loser_Timer_Left:		ds.w	1
Competition_Laps_To_Win:		ds.w	1
Competition_Lap_Count_P1:		ds.b	1
Competition_Lap_Count_P2:		ds.b	1
		ds.l	1
Results_Screen_2P:		ds.w	1
Remainning_Rings_Count:		ds.w	1
Perfect_Bonus_Rings_Flag:		ds.w	1
Player_Selected_Flag:		ds.w	1
Player_Select_Flag:		ds.w	1
Two_Player_Items_Mode:		ds.w	1

Kos_decomp_queue_count:		ds.w	1
Kos_decomp_stored_registers:	ds.w	20
Kos_decomp_stored_SR:		ds.w	1
Kos_decomp_bookmark:		ds.l	1
Kos_description_field:		ds.w	1

Kos_decomp_queue:		ds.l	2*4
Kos_decomp_queue_End:		=	*

Kos_decomp_destination:		=	*-28
Kos_modules_left:		ds.b	1
		ds.b	1	; unused
Kos_last_module_size:		ds.w	1

Kos_module_queue:		ds.w	3*4
Kos_module_queue_End:		=	*

Kos_module_destination:		=	*-20

Tmp_FF7C:		ds.w	1
Tmp_FF7E:		ds.w	1
Level_Select_Hold_Timer:		ds.w	1
Level_Select_Menu_Cursor:		ds.w	1
Sound_Test_Sound:		ds.w	1
Title_Screen_Menu_Cursor:		ds.w	1
Level_Id_2P:		ds.w	1
Act_Id_2P:	= Level_Id_2P+1
Two_Player_Flag_2:		ds.w	1
Options_Menu_Cursor:		ds.w	1
Level_Results_Total_Bonus:		ds.w	1
Level_Music_Buffer:		ds.w	1
		ds.b	6
Game_Over_2P_Flag:		ds.w	1
		ds.b	$16
SS_Completed_Flag:		ds.b	1
Emeralds_Count:		ds.b	1
Emerald_Collected_Flag_List:		ds.b	7
		ds.b	3
Title_Screen_Animate_Buffer:		ds.b	1
Title_Screen_Animate_Delay:		ds.b	1
Title_Screen_Animate_Frame:		ds.b	1
		ds.b	1
Next_Extra_Life_Score:		ds.l	1
Next_Extra_Life_Score_P2:		ds.l	1
End_Level_Art_Load_Flag:		ds.w	1
Debug_Player_Obj_Map:		ds.l	1
Debug_Player_Obj_Art_VRAM:		ds.w	1
Level_Select_Flag:		ds.b	1
Slow_Motion_Flag:		ds.b	1
Debug_Mode_Flag:		ds.w	1
Secret_Code_Input_Entries:		ds.w	1
Secret_Code_Input_Entries_2:		ds.w	1
Two_Player_Flag:		ds.w	1
Menu_Player_One_Cursor:		ds.b	1
Menu_Player_Two_Cursor:		ds.b	1
CNz_Triangle_Angle_Buffer:		ds.b	1
		ds.b	7
SoundQueue STRUCT DOTS
	Music0:	ds.b	1
	SFX0:	ds.b	1
	SFX1:	ds.b	1
	SFX2:	ds.b	1 ; This one is never used, since nothing ever gets written to it.
	Music1:	ds.b	1
SoundQueue ENDSTRUCT

Sound_Queue:		SoundQueue
		ds.b	7
Auto_Control_Player_Flag:		ds.w	1
Demo_Sequence_Idx:		ds.w	1
End_Demo_Sequence_Idx:		ds.w	1
Vertical_Frequency:		ds.w	1
Hardware_Id:		ds.w	1
Debug_Mode_Active:		ds.w	1
Init_Flag:		ds.l	1
CrossResetRAM_End
		dephase						; restore options
		!org 0

; CRAM
Color_RAM_Address	= $C0000000

; Variaveis para os menus exceto seleção de fases que é comprimido
__	=  $00
_0	=  $10
_1	=  $11
_2	=  $12  
_st	=  $1A  ; estrela no sound test
_A	=  $1E
_B	=  $1F 
_C	=  $20
_D	=  $21
_E	=  $22
_F	=  $23
_G	=  $24
_H	=  $25 
_I	=  $26
_J	=  $27
_K	=  $28
_L	=  $29
_M	=  $2A 
_N	=  $2B 
_O	=  $2C
_P	=  $2D
_Q	=  $2E
_R	=  $2F
_S	=  $30
_T	=  $31
_U	=  $32
_V	=  $33
_W	=  $34
_X	=  $35
_Y	=  $36
_Z	=  $37  