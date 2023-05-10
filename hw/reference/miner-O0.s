	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 0
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3                               ; -- Begin function main
lCPI0_0:
	.quad	0x412e848000000000              ; double 1.0E+6
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #288
	.cfi_def_cfa_offset 288
	stp	x28, x27, [sp, #256]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #272]            ; 16-byte Folded Spill
	add	x29, sp, #272
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w27, -24
	.cfi_offset w28, -32
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-24]
	mov	w1, #0
	str	wzr, [sp, #132]
	add	x0, sp, #68
	mov	x2, #64
	bl	_memset
	mov	w8, #220
	str	w8, [sp, #68]
	str	wzr, [sp, #72]
	mov	w8, #46400
	movk	w8, #12857, lsl #16
	str	w8, [sp, #76]
	mov	w8, #45619
	movk	w8, #13113, lsl #16
	str	w8, [sp, #80]
	mov	w8, #12857
	movk	w8, #12467, lsl #16
	str	w8, [sp, #84]
	mov	w8, #45625
	movk	w8, #45877, lsl #16
	str	w8, [sp, #88]
	mov	w8, #14773
	movk	w8, #46514, lsl #16
	str	w8, [sp, #92]
	mov	w8, #46387
	movk	w8, #14768, lsl #16
	str	w8, [sp, #96]
	mov	w9, #12853
	movk	w9, #13109, lsl #16
	str	w9, [sp, #100]
	mov	w9, #46518
	movk	w9, #46384, lsl #16
	str	w9, [sp, #104]
	mov	w9, #13746
	movk	w9, #12467, lsl #16
	str	w9, [sp, #108]
	mov	w9, #14773
	movk	w9, #13746, lsl #16
	str	w9, [sp, #112]
	str	w8, [sp, #116]
	mov	w8, #45235
	movk	w8, #12857, lsl #16
	str	w8, [sp, #120]
	str	wzr, [sp, #124]
	mov	w8, #447
	str	w8, [sp, #128]
	str	wzr, [sp, #64]
	bl	_clock
	str	x0, [sp, #56]
	b	LBB0_1
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #64]
	mov	w9, #34464
	movk	w9, #1, lsl #16
	subs	w8, w8, w9
	cset	w8, ge
	tbnz	w8, #0, LBB0_3
	b	LBB0_2
LBB0_2:                                 ;   in Loop: Header=BB0_1 Depth=1
	add	x0, sp, #136
	str	x0, [sp, #24]                   ; 8-byte Folded Spill
	bl	_sha256_init
	ldr	x0, [sp, #24]                   ; 8-byte Folded Reload
	add	x1, sp, #68
	str	x1, [sp, #32]                   ; 8-byte Folded Spill
	bl	_sha256_transform
	ldr	x0, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x1, [sp, #32]                   ; 8-byte Folded Reload
	bl	_sha256_transform
	ldr	w8, [sp, #64]
	add	w8, w8, #1
	str	w8, [sp, #64]
	b	LBB0_1
LBB0_3:
	bl	_clock
	str	x0, [sp, #48]
	ldr	x8, [sp, #48]
	ldr	x9, [sp, #56]
	subs	x8, x8, x9
	ucvtf	d0, x8
	adrp	x8, lCPI0_0@PAGE
	ldr	d1, [x8, lCPI0_0@PAGEOFF]
	fdiv	d0, d0, d1
	str	d0, [sp, #40]
	ldr	d0, [sp, #40]
	mov	x8, sp
	str	d0, [x8]
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	ldr	w8, [sp, #132]
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-24]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	subs	x8, x8, x9
	cset	w8, eq
	tbnz	w8, #0, LBB0_5
	b	LBB0_4
LBB0_4:
	bl	___stack_chk_fail
LBB0_5:
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	ldp	x29, x30, [sp, #272]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #256]            ; 16-byte Folded Reload
	add	sp, sp, #288
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Elapsed time: %.5f seconds\n"

.subsections_via_symbols
