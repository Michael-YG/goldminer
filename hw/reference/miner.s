	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 0
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4                               ; -- Begin function main
lCPI0_0:
	.long	220                             ; 0xdc
	.long	0                               ; 0x0
	.long	842642752                       ; 0x3239b540
	.long	859419187                       ; 0x3339b233
lCPI0_1:
	.long	817050169                       ; 0x30b33239
	.long	3006640697                      ; 0xb335b239
	.long	3048356277                      ; 0xb5b239b5
	.long	967882035                       ; 0x39b0b533
lCPI0_2:
	.long	859124277                       ; 0x33353235
	.long	3039868342                      ; 0xb530b5b6
	.long	817051058                       ; 0x30b335b2
	.long	900872629                       ; 0x35b239b5
lCPI0_3:
	.long	967882035                       ; 0x39b0b533
	.long	842641587                       ; 0x3239b0b3
	.long	0                               ; 0x0
	.long	447                             ; 0x1bf
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #240
	.cfi_def_cfa_offset 240
	stp	x20, x19, [sp, #208]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #224]            ; 16-byte Folded Spill
	add	x29, sp, #224
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
Lloh3:
	adrp	x8, lCPI0_0@PAGE
Lloh4:
	ldr	q0, [x8, lCPI0_0@PAGEOFF]
Lloh5:
	adrp	x8, lCPI0_1@PAGE
Lloh6:
	ldr	q1, [x8, lCPI0_1@PAGEOFF]
	stp	q0, q1, [sp, #16]
Lloh7:
	adrp	x8, lCPI0_2@PAGE
Lloh8:
	ldr	q0, [x8, lCPI0_2@PAGEOFF]
Lloh9:
	adrp	x8, lCPI0_3@PAGE
Lloh10:
	ldr	q1, [x8, lCPI0_3@PAGEOFF]
	stp	q0, q1, [sp, #48]
	mov	w20, #34464
	movk	w20, #1, lsl #16
	bl	_clock
	mov	x19, x0
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	add	x0, sp, #88
	bl	_sha256_init
	add	x0, sp, #88
	add	x1, sp, #16
	bl	_sha256_transform
	add	x0, sp, #88
	add	x1, sp, #16
	bl	_sha256_transform
	subs	w20, w20, #1
	b.ne	LBB0_1
; %bb.2:
	bl	_clock
	sub	x8, x0, x19
	ucvtf	d0, x8
	mov	x8, #145685290680320
	movk	x8, #16686, lsl #48
	fmov	d1, x8
	fdiv	d0, d0, d1
	str	d0, [sp]
Lloh11:
	adrp	x0, l_.str@PAGE
Lloh12:
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	ldur	x8, [x29, #-24]
Lloh13:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh14:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh15:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_4
; %bb.3:
	mov	w0, #0
	ldp	x29, x30, [sp, #224]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #208]            ; 16-byte Folded Reload
	add	sp, sp, #240
	ret
LBB0_4:
	bl	___stack_chk_fail
	.loh AdrpLdr	Lloh9, Lloh10
	.loh AdrpAdrp	Lloh7, Lloh9
	.loh AdrpLdr	Lloh7, Lloh8
	.loh AdrpAdrp	Lloh5, Lloh7
	.loh AdrpLdr	Lloh5, Lloh6
	.loh AdrpAdrp	Lloh3, Lloh5
	.loh AdrpLdr	Lloh3, Lloh4
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpLdrGotLdr	Lloh13, Lloh14, Lloh15
	.loh AdrpAdd	Lloh11, Lloh12
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Elapsed time: %.5f seconds\n"

.subsections_via_symbols
