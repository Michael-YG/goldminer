	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0	sdk_version 13, 0
	.globl	_sha256_transform               ; -- Begin function sha256_transform
	.p2align	2
_sha256_transform:                      ; @sha256_transform
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #352
	.cfi_def_cfa_offset 352
	stp	x26, x25, [sp, #272]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #288]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #304]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #320]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #336]            ; 16-byte Folded Spill
	add	x29, sp, #336
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	mov	x8, #0
Lloh0:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x9, [x9]
	stur	x9, [x29, #-72]
	ldp	w9, w10, [x1]
	stp	w9, w10, [sp, #8]
	ldur	q1, [x1, #8]
	ldur	q0, [x1, #24]
	stp	q1, q0, [sp, #16]
	add	x10, sp, #8
	add	x10, x10, #36
	ldp	x11, x12, [x1, #40]
	stp	x11, x12, [sp, #48]
	ldp	w11, w12, [x1, #56]
	stp	w11, w12, [sp, #64]
LBB0_1:                                 ; =>This Inner Loop Header: Depth=1
	add	x11, x10, x8
	ldr	w12, [x11, #20]
	ror	w13, w12, #17
	eor	w13, w13, w12, ror #19
	eor	w12, w13, w12, lsr #10
	ldr	w13, [x11]
	add	w12, w12, w13
	add	w9, w12, w9
	ldur	w12, [x11, #-32]
	ror	w13, w12, #7
	eor	w13, w13, w12, ror #18
	eor	w13, w13, w12, lsr #3
	add	w9, w9, w13
	str	w9, [x11, #28]
	add	x8, x8, #4
	mov	x9, x12
	cmp	x8, #192
	b.ne	LBB0_1
; %bb.2:
	mov	x12, #0
	ldp	w8, w9, [x0, #80]
	ldp	w10, w11, [x0, #88]
Lloh3:
	adrp	x17, _k@PAGE
Lloh4:
	add	x17, x17, _k@PAGEOFF
	ldp	w14, w13, [x0, #104]
	add	x2, sp, #8
	mov	x20, x8
	mov	x4, x9
	mov	x22, x13
	mov	x23, x14
	ldp	w16, w15, [x0, #96]
	mov	x24, x15
	mov	x21, x16
	mov	x19, x11
	mov	x7, x10
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	mov	x6, x7
	mov	x5, x21
	mov	x3, x24
	mov	x1, x23
	mov	x7, x4
	mov	x4, x20
	ror	w20, w21, #6
	eor	w20, w20, w21, ror #11
	eor	w20, w20, w21, ror #25
	and	w21, w24, w21
	bic	w23, w23, w5
	ldr	w24, [x17, x12]
	ldr	w25, [x2, x12]
	add	w20, w20, w21
	add	w20, w20, w22
	add	w20, w20, w23
	add	w20, w20, w24
	ror	w21, w4, #2
	eor	w21, w21, w4, ror #13
	eor	w22, w21, w4, ror #22
	eor	w21, w7, w6
	and	w21, w4, w21
	and	w23, w7, w6
	eor	w23, w21, w23
	add	w20, w20, w25
	add	w21, w20, w19
	add	w19, w22, w23
	add	w20, w19, w20
	add	x12, x12, #4
	mov	x22, x1
	mov	x23, x3
	mov	x24, x5
	mov	x19, x6
	cmp	x12, #256
	b.ne	LBB0_3
; %bb.4:
	add	w8, w20, w8
	add	w9, w4, w9
	stp	w8, w9, [x0, #80]
	add	w8, w7, w10
	add	w9, w6, w11
	stp	w8, w9, [x0, #88]
	add	w8, w21, w16
	add	w9, w5, w15
	stp	w8, w9, [x0, #96]
	add	w8, w3, w14
	add	w9, w1, w13
	stp	w8, w9, [x0, #104]
	ldur	x8, [x29, #-72]
Lloh5:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh6:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh7:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_6
; %bb.5:
	ldp	x29, x30, [sp, #336]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #320]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #304]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #288]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #272]            ; 16-byte Folded Reload
	add	sp, sp, #352
	ret
LBB0_6:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpAdd	Lloh3, Lloh4
	.loh AdrpLdrGotLdr	Lloh5, Lloh6, Lloh7
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4                               ; -- Begin function sha256_init
lCPI1_0:
	.long	1779033703                      ; 0x6a09e667
	.long	3144134277                      ; 0xbb67ae85
	.long	1013904242                      ; 0x3c6ef372
	.long	2773480762                      ; 0xa54ff53a
lCPI1_1:
	.long	1359893119                      ; 0x510e527f
	.long	2600822924                      ; 0x9b05688c
	.long	528734635                       ; 0x1f83d9ab
	.long	1541459225                      ; 0x5be0cd19
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_sha256_init
	.p2align	2
_sha256_init:                           ; @sha256_init
	.cfi_startproc
; %bb.0:
	str	wzr, [x0, #64]
	str	xzr, [x0, #72]
Lloh8:
	adrp	x8, lCPI1_0@PAGE
Lloh9:
	ldr	q0, [x8, lCPI1_0@PAGEOFF]
Lloh10:
	adrp	x8, lCPI1_1@PAGE
Lloh11:
	ldr	q1, [x8, lCPI1_1@PAGEOFF]
	stp	q0, q1, [x0, #80]
	ret
	.loh AdrpLdr	Lloh10, Lloh11
	.loh AdrpAdrp	Lloh8, Lloh10
	.loh AdrpLdr	Lloh8, Lloh9
	.cfi_endproc
                                        ; -- End function
	.globl	_sha256_update                  ; -- Begin function sha256_update
	.p2align	2
_sha256_update:                         ; @sha256_update
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x22, x21, [sp, #16]             ; 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #48]             ; 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	mov	x20, x0
	cbz	x2, LBB2_5
; %bb.1:
	mov	x19, x2
	mov	x21, x1
	mov	x22, #0
	ldr	w8, [x20, #64]
	b	LBB2_3
LBB2_2:                                 ;   in Loop: Header=BB2_3 Depth=1
	add	w22, w22, #1
	cmp	x22, x19
	b.hs	LBB2_5
LBB2_3:                                 ; =>This Inner Loop Header: Depth=1
	ldrb	w9, [x21, x22]
	strb	w9, [x20, w8, uxtw]
	ldr	w8, [x20, #64]
	add	w8, w8, #1
	str	w8, [x20, #64]
	cmp	w8, #64
	b.ne	LBB2_2
; %bb.4:                                ;   in Loop: Header=BB2_3 Depth=1
	mov	x0, x20
	mov	x1, x20
	bl	_sha256_transform
	mov	w8, #0
	ldr	x9, [x20, #72]
	add	x9, x9, #512
	str	x9, [x20, #72]
	str	wzr, [x20, #64]
	b	LBB2_2
LBB2_5:
	ldrb	w8, [x20]
	str	x8, [sp]
Lloh12:
	adrp	x0, l_.str@PAGE
Lloh13:
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	ldp	x29, x30, [sp, #48]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #32]             ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             ; 16-byte Folded Reload
	add	sp, sp, #64
	ret
	.loh AdrpAdd	Lloh12, Lloh13
	.cfi_endproc
                                        ; -- End function
	.globl	_sha256_final                   ; -- Begin function sha256_final
	.p2align	2
_sha256_final:                          ; @sha256_final
	.cfi_startproc
; %bb.0:
	stp	x20, x19, [sp, #-32]!           ; 16-byte Folded Spill
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             ; 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	mov	x19, x1
	mov	x20, x0
	ldr	w8, [x0, #64]
	mov	w9, #128
	strb	w9, [x0, x8]
	add	w9, w8, #1
	cmp	w8, #55
	b.hi	LBB3_3
; %bb.1:
	cmp	w9, #55
	b.hi	LBB3_6
; %bb.2:
	add	x9, x8, x20
	add	x0, x9, #1
	mov	w9, #54
	sub	w8, w9, w8
	add	x1, x8, #1
	bl	_bzero
	b	LBB3_6
LBB3_3:
	cmp	w9, #63
	b.hi	LBB3_5
; %bb.4:
	add	x0, x20, w9, uxtw
	mov	w9, #62
	sub	w8, w9, w8
	add	x1, x8, #1
	bl	_bzero
LBB3_5:
	mov	x0, x20
	mov	x1, x20
	bl	_sha256_transform
	str	xzr, [x20, #48]
	movi.2d	v0, #0000000000000000
	stp	q0, q0, [x20, #16]
	str	q0, [x20]
LBB3_6:
	ldr	w8, [x20, #64]
	lsl	w8, w8, #3
	ldr	x9, [x20, #72]
	add	x8, x9, x8
	str	x8, [x20, #72]
	strb	w8, [x20, #63]
	lsr	x9, x8, #8
	strb	w9, [x20, #62]
	lsr	x9, x8, #16
	strb	w9, [x20, #61]
	lsr	x9, x8, #24
	strb	w9, [x20, #60]
	lsr	x9, x8, #32
	strb	w9, [x20, #59]
	lsr	x9, x8, #40
	strb	w9, [x20, #58]
	lsr	x9, x8, #48
	strb	w9, [x20, #57]
	lsr	x8, x8, #56
	strb	w8, [x20, #56]
	mov	x0, x20
	mov	x1, x20
	bl	_sha256_transform
	ldrb	w8, [x20, #83]
	strb	w8, [x19]
	ldrb	w8, [x20, #87]
	strb	w8, [x19, #4]
	ldrb	w8, [x20, #91]
	strb	w8, [x19, #8]
	ldrb	w8, [x20, #95]
	strb	w8, [x19, #12]
	ldrb	w8, [x20, #99]
	strb	w8, [x19, #16]
	ldrb	w8, [x20, #103]
	strb	w8, [x19, #20]
	ldrb	w8, [x20, #107]
	strb	w8, [x19, #24]
	ldrb	w8, [x20, #111]
	strb	w8, [x19, #28]
	ldrh	w8, [x20, #82]
	strb	w8, [x19, #1]
	ldrh	w8, [x20, #86]
	strb	w8, [x19, #5]
	ldrh	w8, [x20, #90]
	strb	w8, [x19, #9]
	ldrh	w8, [x20, #94]
	strb	w8, [x19, #13]
	ldrh	w8, [x20, #98]
	strb	w8, [x19, #17]
	ldrh	w8, [x20, #102]
	strb	w8, [x19, #21]
	ldrh	w8, [x20, #106]
	strb	w8, [x19, #25]
	ldrh	w8, [x20, #110]
	strb	w8, [x19, #29]
	ldr	w8, [x20, #80]
	lsr	w8, w8, #8
	strb	w8, [x19, #2]
	ldr	w8, [x20, #84]
	lsr	w8, w8, #8
	strb	w8, [x19, #6]
	ldr	w8, [x20, #88]
	lsr	w8, w8, #8
	strb	w8, [x19, #10]
	ldr	w8, [x20, #92]
	lsr	w8, w8, #8
	strb	w8, [x19, #14]
	ldr	w8, [x20, #96]
	lsr	w8, w8, #8
	strb	w8, [x19, #18]
	ldr	w8, [x20, #100]
	lsr	w8, w8, #8
	strb	w8, [x19, #22]
	ldr	w8, [x20, #104]
	lsr	w8, w8, #8
	strb	w8, [x19, #26]
	ldr	w8, [x20, #108]
	lsr	w8, w8, #8
	strb	w8, [x19, #30]
	ldr	w8, [x20, #80]
	strb	w8, [x19, #3]
	ldr	w8, [x20, #84]
	strb	w8, [x19, #7]
	ldr	w8, [x20, #88]
	strb	w8, [x19, #11]
	ldr	w8, [x20, #92]
	strb	w8, [x19, #15]
	ldr	w8, [x20, #96]
	strb	w8, [x19, #19]
	ldr	w8, [x20, #100]
	strb	w8, [x19, #23]
	ldr	w8, [x20, #104]
	strb	w8, [x19, #27]
	ldr	w8, [x20, #108]
	strb	w8, [x19, #31]
	ldp	x29, x30, [sp, #16]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp], #32             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__const
	.p2align	2                               ; @k
_k:
	.long	1116352408                      ; 0x428a2f98
	.long	1899447441                      ; 0x71374491
	.long	3049323471                      ; 0xb5c0fbcf
	.long	3921009573                      ; 0xe9b5dba5
	.long	961987163                       ; 0x3956c25b
	.long	1508970993                      ; 0x59f111f1
	.long	2453635748                      ; 0x923f82a4
	.long	2870763221                      ; 0xab1c5ed5
	.long	3624381080                      ; 0xd807aa98
	.long	310598401                       ; 0x12835b01
	.long	607225278                       ; 0x243185be
	.long	1426881987                      ; 0x550c7dc3
	.long	1925078388                      ; 0x72be5d74
	.long	2162078206                      ; 0x80deb1fe
	.long	2614888103                      ; 0x9bdc06a7
	.long	3248222580                      ; 0xc19bf174
	.long	3835390401                      ; 0xe49b69c1
	.long	4022224774                      ; 0xefbe4786
	.long	264347078                       ; 0xfc19dc6
	.long	604807628                       ; 0x240ca1cc
	.long	770255983                       ; 0x2de92c6f
	.long	1249150122                      ; 0x4a7484aa
	.long	1555081692                      ; 0x5cb0a9dc
	.long	1996064986                      ; 0x76f988da
	.long	2554220882                      ; 0x983e5152
	.long	2821834349                      ; 0xa831c66d
	.long	2952996808                      ; 0xb00327c8
	.long	3210313671                      ; 0xbf597fc7
	.long	3336571891                      ; 0xc6e00bf3
	.long	3584528711                      ; 0xd5a79147
	.long	113926993                       ; 0x6ca6351
	.long	338241895                       ; 0x14292967
	.long	666307205                       ; 0x27b70a85
	.long	773529912                       ; 0x2e1b2138
	.long	1294757372                      ; 0x4d2c6dfc
	.long	1396182291                      ; 0x53380d13
	.long	1695183700                      ; 0x650a7354
	.long	1986661051                      ; 0x766a0abb
	.long	2177026350                      ; 0x81c2c92e
	.long	2456956037                      ; 0x92722c85
	.long	2730485921                      ; 0xa2bfe8a1
	.long	2820302411                      ; 0xa81a664b
	.long	3259730800                      ; 0xc24b8b70
	.long	3345764771                      ; 0xc76c51a3
	.long	3516065817                      ; 0xd192e819
	.long	3600352804                      ; 0xd6990624
	.long	4094571909                      ; 0xf40e3585
	.long	275423344                       ; 0x106aa070
	.long	430227734                       ; 0x19a4c116
	.long	506948616                       ; 0x1e376c08
	.long	659060556                       ; 0x2748774c
	.long	883997877                       ; 0x34b0bcb5
	.long	958139571                       ; 0x391c0cb3
	.long	1322822218                      ; 0x4ed8aa4a
	.long	1537002063                      ; 0x5b9cca4f
	.long	1747873779                      ; 0x682e6ff3
	.long	1955562222                      ; 0x748f82ee
	.long	2024104815                      ; 0x78a5636f
	.long	2227730452                      ; 0x84c87814
	.long	2361852424                      ; 0x8cc70208
	.long	2428436474                      ; 0x90befffa
	.long	2756734187                      ; 0xa4506ceb
	.long	3204031479                      ; 0xbef9a3f7
	.long	3329325298                      ; 0xc67178f2

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"ctx -> data[0] = %x\n"

.subsections_via_symbols
