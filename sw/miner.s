	.arch armv7-a
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"miner.c"
	.section	.rodata
	.align	2
	.type	k, %object
	.size	k, 256
k:
	.word	1116352408
	.word	1899447441
	.word	-1245643825
	.word	-373957723
	.word	961987163
	.word	1508970993
	.word	-1841331548
	.word	-1424204075
	.word	-670586216
	.word	310598401
	.word	607225278
	.word	1426881987
	.word	1925078388
	.word	-2132889090
	.word	-1680079193
	.word	-1046744716
	.word	-459576895
	.word	-272742522
	.word	264347078
	.word	604807628
	.word	770255983
	.word	1249150122
	.word	1555081692
	.word	1996064986
	.word	-1740746414
	.word	-1473132947
	.word	-1341970488
	.word	-1084653625
	.word	-958395405
	.word	-710438585
	.word	113926993
	.word	338241895
	.word	666307205
	.word	773529912
	.word	1294757372
	.word	1396182291
	.word	1695183700
	.word	1986661051
	.word	-2117940946
	.word	-1838011259
	.word	-1564481375
	.word	-1474664885
	.word	-1035236496
	.word	-949202525
	.word	-778901479
	.word	-694614492
	.word	-200395387
	.word	275423344
	.word	430227734
	.word	506948616
	.word	659060556
	.word	883997877
	.word	958139571
	.word	1322822218
	.word	1537002063
	.word	1747873779
	.word	1955562222
	.word	2024104815
	.word	-2067236844
	.word	-1933114872
	.word	-1866530822
	.word	-1538233109
	.word	-1090935817
	.word	-965641998
	.text
	.align	2
	.global	sha256_transform
	.syntax unified
	.thumb
	.thumb_func
	.type	sha256_transform, %function
sha256_transform:
	@ args = 0, pretend = 0, frame = 320
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #320
	add	r7, sp, #0
	adds	r3, r7, #4
	str	r0, [r3]
	mov	r3, r7
	str	r1, [r3]
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #316]
	add	r3, r7, #44
	movs	r2, #0
	str	r2, [r3]
	add	r3, r7, #48
	movs	r2, #0
	str	r2, [r3]
	b	.L2
.L3:
	mov	r2, r7
	add	r3, r7, #48
	ldr	r2, [r2]
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	add	r3, r7, #48
	ldr	r3, [r3]
	adds	r3, r3, #1
	mov	r2, r7
	ldr	r2, [r2]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #8
	orr	r2, r1, r3
	add	r3, r7, #48
	ldr	r3, [r3]
	adds	r3, r3, #2
	mov	r1, r7
	ldr	r1, [r1]
	add	r3, r3, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #16
	orrs	r2, r2, r3
	add	r3, r7, #48
	ldr	r3, [r3]
	adds	r3, r3, #3
	mov	r1, r7
	ldr	r1, [r1]
	add	r3, r3, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsls	r3, r3, #24
	orrs	r3, r3, r2
	mov	r1, r3
	add	r3, r7, #60
	add	r2, r7, #44
	ldr	r2, [r2]
	str	r1, [r3, r2, lsl #2]
	add	r3, r7, #44
	add	r2, r7, #44
	ldr	r2, [r2]
	adds	r2, r2, #1
	str	r2, [r3]
	add	r3, r7, #48
	add	r2, r7, #48
	ldr	r2, [r2]
	adds	r2, r2, #4
	str	r2, [r3]
.L2:
	add	r3, r7, #44
	ldr	r3, [r3]
	cmp	r3, #15
	bls	.L3
	b	.L4
.L5:
	add	r3, r7, #44
	ldr	r3, [r3]
	subs	r2, r3, #2
	add	r3, r7, #60
	ldr	r3, [r3, r2, lsl #2]
	ror	r2, r3, #17
	add	r3, r7, #44
	ldr	r3, [r3]
	subs	r1, r3, #2
	add	r3, r7, #60
	ldr	r3, [r3, r1, lsl #2]
	ror	r3, r3, #19
	eors	r2, r2, r3
	add	r3, r7, #44
	ldr	r3, [r3]
	subs	r1, r3, #2
	add	r3, r7, #60
	ldr	r3, [r3, r1, lsl #2]
	lsrs	r3, r3, #10
	eors	r2, r2, r3
	add	r3, r7, #44
	ldr	r3, [r3]
	subs	r1, r3, #7
	add	r3, r7, #60
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	add	r3, r7, #44
	ldr	r3, [r3]
	sub	r1, r3, #15
	add	r3, r7, #60
	ldr	r3, [r3, r1, lsl #2]
	ror	r1, r3, #7
	add	r3, r7, #44
	ldr	r3, [r3]
	sub	r0, r3, #15
	add	r3, r7, #60
	ldr	r3, [r3, r0, lsl #2]
	ror	r3, r3, #18
	eors	r1, r1, r3
	add	r3, r7, #44
	ldr	r3, [r3]
	sub	r0, r3, #15
	add	r3, r7, #60
	ldr	r3, [r3, r0, lsl #2]
	lsrs	r3, r3, #3
	eors	r3, r3, r1
	add	r2, r2, r3
	add	r3, r7, #44
	ldr	r3, [r3]
	sub	r1, r3, #16
	add	r3, r7, #60
	ldr	r3, [r3, r1, lsl #2]
	adds	r1, r2, r3
	add	r3, r7, #60
	add	r2, r7, #44
	ldr	r2, [r2]
	str	r1, [r3, r2, lsl #2]
	add	r3, r7, #44
	add	r2, r7, #44
	ldr	r2, [r2]
	adds	r2, r2, #1
	str	r2, [r3]
.L4:
	add	r3, r7, #44
	ldr	r3, [r3]
	cmp	r3, #63
	bls	.L5
	add	r3, r7, #12
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #80]
	str	r2, [r3]
	add	r3, r7, #16
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #84]
	str	r2, [r3]
	add	r3, r7, #20
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #88]
	str	r2, [r3]
	add	r3, r7, #24
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #92]
	str	r2, [r3]
	add	r3, r7, #28
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #96]
	str	r2, [r3]
	add	r3, r7, #32
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #100]
	str	r2, [r3]
	add	r3, r7, #36
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #104]
	str	r2, [r3]
	add	r3, r7, #40
	adds	r2, r7, #4
	ldr	r2, [r2]
	ldr	r2, [r2, #108]
	str	r2, [r3]
	add	r3, r7, #44
	movs	r2, #0
	str	r2, [r3]
	b	.L6
.L7:
	add	r3, r7, #28
	ldr	r3, [r3]
	ror	r2, r3, #6
	add	r3, r7, #28
	ldr	r3, [r3]
	ror	r3, r3, #11
	eors	r2, r2, r3
	add	r3, r7, #28
	ldr	r3, [r3]
	ror	r3, r3, #25
	eors	r2, r2, r3
	add	r3, r7, #40
	ldr	r3, [r3]
	add	r2, r2, r3
	add	r1, r7, #28
	add	r3, r7, #32
	ldr	r1, [r1]
	ldr	r3, [r3]
	ands	r1, r1, r3
	add	r3, r7, #28
	ldr	r3, [r3]
	mvns	r0, r3
	add	r3, r7, #36
	ldr	r3, [r3]
	ands	r3, r3, r0
	eors	r3, r3, r1
	add	r2, r2, r3
	movw	r3, #:lower16:k
	movt	r3, #:upper16:k
	add	r1, r7, #44
	ldr	r1, [r1]
	ldr	r3, [r3, r1, lsl #2]
	adds	r1, r2, r3
	add	r3, r7, #60
	add	r2, r7, #44
	ldr	r2, [r2]
	ldr	r2, [r3, r2, lsl #2]
	add	r3, r7, #52
	add	r2, r2, r1
	str	r2, [r3]
	add	r3, r7, #12
	ldr	r3, [r3]
	ror	r2, r3, #2
	add	r3, r7, #12
	ldr	r3, [r3]
	ror	r3, r3, #13
	eors	r2, r2, r3
	add	r3, r7, #12
	ldr	r3, [r3]
	ror	r3, r3, #22
	eor	r1, r2, r3
	add	r2, r7, #12
	add	r3, r7, #16
	ldr	r2, [r2]
	ldr	r3, [r3]
	ands	r2, r2, r3
	add	r0, r7, #12
	add	r3, r7, #20
	ldr	r0, [r0]
	ldr	r3, [r3]
	ands	r3, r3, r0
	eors	r2, r2, r3
	add	r0, r7, #16
	add	r3, r7, #20
	ldr	r0, [r0]
	ldr	r3, [r3]
	ands	r3, r3, r0
	eors	r2, r2, r3
	add	r3, r7, #56
	add	r2, r2, r1
	str	r2, [r3]
	add	r3, r7, #40
	add	r2, r7, #36
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #36
	add	r2, r7, #32
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #32
	add	r2, r7, #28
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #28
	add	r1, r7, #24
	add	r2, r7, #52
	ldr	r1, [r1]
	ldr	r2, [r2]
	add	r2, r2, r1
	str	r2, [r3]
	add	r3, r7, #24
	add	r2, r7, #20
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #20
	add	r2, r7, #16
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #16
	add	r2, r7, #12
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #12
	add	r1, r7, #52
	add	r2, r7, #56
	ldr	r1, [r1]
	ldr	r2, [r2]
	add	r2, r2, r1
	str	r2, [r3]
	add	r3, r7, #44
	add	r2, r7, #44
	ldr	r2, [r2]
	adds	r2, r2, #1
	str	r2, [r3]
.L6:
	add	r3, r7, #44
	ldr	r3, [r3]
	cmp	r3, #63
	bls	.L7
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #80]
	add	r3, r7, #12
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #80]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #84]
	add	r3, r7, #16
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #84]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #88]
	add	r3, r7, #20
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #88]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #92]
	add	r3, r7, #24
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #92]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #96]
	add	r3, r7, #28
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #96]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #100]
	add	r3, r7, #32
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #100]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #104]
	add	r3, r7, #36
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #104]
	adds	r3, r7, #4
	ldr	r3, [r3]
	ldr	r2, [r3, #108]
	add	r3, r7, #40
	ldr	r3, [r3]
	add	r2, r2, r3
	adds	r3, r7, #4
	ldr	r3, [r3]
	str	r2, [r3, #108]
	nop
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #316]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L8
	bl	__stack_chk_fail
.L8:
	add	r7, r7, #320
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	sha256_transform, .-sha256_transform
	.align	2
	.global	sha256_init
	.syntax unified
	.thumb
	.thumb_func
	.type	sha256_init, %function
sha256_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r7}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	movs	r2, #0
	str	r2, [r3, #64]
	ldr	r2, [r7, #4]
	mov	r3, #0
	mov	r4, #0
	strd	r3, [r2, #72]
	ldr	r2, [r7, #4]
	movw	r3, #58983
	movt	r3, 27145
	str	r3, [r2, #80]
	ldr	r2, [r7, #4]
	movw	r3, #44677
	movt	r3, 47975
	str	r3, [r2, #84]
	ldr	r2, [r7, #4]
	movw	r3, #62322
	movt	r3, 15470
	str	r3, [r2, #88]
	ldr	r2, [r7, #4]
	movw	r3, #62778
	movt	r3, 42319
	str	r3, [r2, #92]
	ldr	r2, [r7, #4]
	movw	r3, #21119
	movt	r3, 20750
	str	r3, [r2, #96]
	ldr	r2, [r7, #4]
	movw	r3, #26764
	movt	r3, 39685
	str	r3, [r2, #100]
	ldr	r2, [r7, #4]
	movw	r3, #55723
	movt	r3, 8067
	str	r3, [r2, #104]
	ldr	r2, [r7, #4]
	movw	r3, #52505
	movt	r3, 23520
	str	r3, [r2, #108]
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r4, r7}
	bx	lr
	.size	sha256_init, .-sha256_init
	.comm	sha256_acc_fd0,4,4
	.comm	sha256_acc_fd1,4,4
	.comm	sha256_acc_fd2,4,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Usage: ./miner s(software), h(hardware)\000"
	.align	2
.LC1:
	.ascii	"s\000"
	.align	2
.LC2:
	.ascii	"Software SHA256\000"
	.align	2
.LC3:
	.ascii	"h\000"
	.align	2
.LC4:
	.ascii	"Hardware SHA256\000"
	.align	2
.LC5:
	.ascii	"could not open file %s\012\000"
	.align	2
.LC6:
	.ascii	"read value0: %x\012\000"
	.align	2
.LC7:
	.ascii	"Fisrt round hash finished\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 432
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r7, lr}
	sub	sp, sp, #436
	add	r7, sp, #0
	adds	r3, r7, #4
	str	r0, [r3]
	mov	r3, r7
	str	r1, [r3]
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #428]
	adds	r3, r7, #4
	ldr	r3, [r3]
	cmp	r3, #1
	bgt	.L11
	movw	r0, #:lower16:.LC0
	movt	r0, #:upper16:.LC0
	bl	puts
	movs	r0, #1
	bl	exit
.L11:
	add	r3, r7, #120
	mov	r0, r3
	movs	r3, #64
	mov	r2, r3
	movs	r1, #0
	bl	memset
	add	r3, r7, #184
	movs	r2, #64
	movs	r1, #0
	mov	r0, r3
	bl	memset
	add	r3, r7, #248
	movs	r2, #64
	movs	r1, #0
	mov	r0, r3
	bl	memset
	add	r3, r7, #24
	mov	r0, r3
	movs	r3, #32
	mov	r2, r3
	movs	r1, #0
	bl	memset
	add	r3, r7, #56
	mov	r0, r3
	movs	r3, #32
	mov	r2, r3
	movs	r1, #0
	bl	memset
	add	r3, r7, #88
	mov	r0, r3
	movs	r3, #32
	mov	r2, r3
	movs	r1, #0
	bl	memset
	add	r3, r7, #120
	movs	r2, #220
	str	r2, [r3]
	add	r3, r7, #120
	movs	r2, #0
	str	r2, [r3, #4]
	add	r2, r7, #120
	movw	r3, #46400
	movt	r3, 12857
	str	r3, [r2, #8]
	add	r2, r7, #120
	movw	r3, #45619
	movt	r3, 13113
	str	r3, [r2, #12]
	add	r2, r7, #120
	movw	r3, #12857
	movt	r3, 12467
	str	r3, [r2, #16]
	add	r2, r7, #120
	movw	r3, #45625
	movt	r3, 45877
	str	r3, [r2, #20]
	add	r2, r7, #120
	movw	r3, #14773
	movt	r3, 46514
	str	r3, [r2, #24]
	add	r2, r7, #120
	movw	r3, #46387
	movt	r3, 14768
	str	r3, [r2, #28]
	add	r2, r7, #120
	movw	r3, #12853
	movt	r3, 13109
	str	r3, [r2, #32]
	add	r2, r7, #120
	movw	r3, #46518
	movt	r3, 46384
	str	r3, [r2, #36]
	add	r2, r7, #120
	movw	r3, #13746
	movt	r3, 12467
	str	r3, [r2, #40]
	add	r2, r7, #120
	movw	r3, #14773
	movt	r3, 13746
	str	r3, [r2, #44]
	add	r2, r7, #120
	movw	r3, #46387
	movt	r3, 14768
	str	r3, [r2, #48]
	add	r2, r7, #120
	movw	r3, #45235
	movt	r3, 12857
	str	r3, [r2, #52]
	add	r3, r7, #120
	movs	r2, #0
	str	r2, [r3, #56]
	add	r3, r7, #120
	movw	r2, #447
	str	r2, [r3, #60]
	movs	r3, #32
	movt	r3, 1024
	str	r3, [r7, #184]
	movw	r3, #54468
	movt	r3, 11268
	str	r3, [r7, #188]
	movw	r3, #32029
	movt	r3, 20504
	str	r3, [r7, #192]
	movw	r3, #48163
	movt	r3, 43441
	str	r3, [r7, #196]
	movw	r3, #54911
	movt	r3, 47687
	str	r3, [r7, #200]
	movw	r3, #53796
	movt	r3, 57384
	str	r3, [r7, #204]
	mov	r3, #3072
	movt	r3, 34557
	str	r3, [r7, #208]
	movs	r3, #0
	str	r3, [r7, #212]
	movs	r3, #0
	str	r3, [r7, #216]
	movw	r3, #41789
	movt	r3, 22947
	str	r3, [r7, #220]
	movw	r3, #51097
	movt	r3, 17986
	str	r3, [r7, #224]
	movw	r3, #21668
	movt	r3, 44959
	str	r3, [r7, #228]
	movw	r3, #8191
	movt	r3, 56629
	str	r3, [r7, #232]
	movw	r3, #59048
	movt	r3, 37168
	str	r3, [r7, #236]
	movw	r3, #9489
	movt	r3, 40270
	str	r3, [r7, #240]
	movs	r3, #100
	movt	r3, 12486
	str	r3, [r7, #244]
	movw	r3, #5865
	movt	r3, 34694
	str	r3, [r7, #248]
	movw	r3, #60000
	movt	r3, 1717
	str	r3, [r7, #252]
	movw	r3, #4887
	movt	r3, 52888
	str	r3, [r7, #256]
	movw	r3, #51955
	movt	r3, 14885
	str	r3, [r7, #260]
	mov	r3, #-2147483648
	str	r3, [r7, #264]
	movs	r3, #0
	str	r3, [r7, #268]
	movs	r3, #0
	str	r3, [r7, #272]
	movs	r3, #0
	str	r3, [r7, #276]
	movs	r3, #0
	str	r3, [r7, #280]
	movs	r3, #0
	str	r3, [r7, #284]
	movs	r3, #0
	str	r3, [r7, #288]
	movs	r3, #0
	str	r3, [r7, #292]
	movs	r3, #0
	str	r3, [r7, #296]
	movs	r3, #0
	str	r3, [r7, #300]
	movs	r3, #0
	str	r3, [r7, #304]
	mov	r3, #640
	str	r3, [r7, #308]
	mov	r3, r7
	ldr	r3, [r3]
	adds	r3, r3, #4
	ldr	r3, [r3]
	movw	r1, #:lower16:.LC1
	movt	r1, #:upper16:.LC1
	mov	r0, r3
	bl	strcmp
	mov	r3, r0
	cmp	r3, #0
	bne	.L12
	movw	r0, #:lower16:.LC2
	movt	r0, #:upper16:.LC2
	bl	puts
	add	r3, r7, #312
	mov	r0, r3
	bl	sha256_init
	add	r2, r7, #184
	add	r3, r7, #312
	mov	r1, r2
	mov	r0, r3
	bl	sha256_transform
	add	r2, r7, #248
	add	r3, r7, #312
	mov	r1, r2
	mov	r0, r3
	bl	sha256_transform
	add	r3, r7, #312
	adds	r3, r3, #80
	movs	r1, #3
	mov	r0, r3
	bl	display_hash
	movs	r3, #0
	b	.L13
.L12:
	mov	r3, r7
	ldr	r3, [r3]
	adds	r3, r3, #4
	ldr	r3, [r3]
	movw	r1, #:lower16:.LC3
	movt	r1, #:upper16:.LC3
	mov	r0, r3
	bl	strcmp
	mov	r3, r0
	cmp	r3, #0
	bne	.L14
	movw	r0, #:lower16:.LC4
	movt	r0, #:upper16:.LC4
	bl	puts
	movs	r1, #2
	movw	r0, #:lower16:filename0.5996
	movt	r0, #:upper16:filename0.5996
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	str	r2, [r3]
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	ldr	r3, [r3]
	cmp	r3, #-1
	bne	.L15
	movw	r3, #:lower16:stderr
	movt	r3, #:upper16:stderr
	ldr	r3, [r3]
	movw	r2, #:lower16:filename0.5996
	movt	r2, #:upper16:filename0.5996
	movw	r1, #:lower16:.LC5
	movt	r1, #:upper16:.LC5
	mov	r0, r3
	bl	fprintf
	movs	r0, #1
	bl	exit
.L15:
	movs	r1, #2
	movw	r0, #:lower16:filename1.5997
	movt	r0, #:upper16:filename1.5997
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	str	r2, [r3]
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	ldr	r3, [r3]
	cmp	r3, #-1
	bne	.L16
	movw	r3, #:lower16:stderr
	movt	r3, #:upper16:stderr
	ldr	r3, [r3]
	movw	r2, #:lower16:filename1.5997
	movt	r2, #:upper16:filename1.5997
	movw	r1, #:lower16:.LC5
	movt	r1, #:upper16:.LC5
	mov	r0, r3
	bl	fprintf
	movs	r0, #1
	bl	exit
.L16:
	movs	r1, #2
	movw	r0, #:lower16:filename2.5998
	movt	r0, #:upper16:filename2.5998
	bl	open
	mov	r2, r0
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	str	r2, [r3]
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	ldr	r3, [r3]
	cmp	r3, #-1
	bne	.L17
	movw	r3, #:lower16:stderr
	movt	r3, #:upper16:stderr
	ldr	r3, [r3]
	movw	r2, #:lower16:filename2.5998
	movt	r2, #:upper16:filename2.5998
	movw	r1, #:lower16:.LC5
	movt	r1, #:upper16:.LC5
	mov	r0, r3
	bl	fprintf
	movs	r0, #1
	bl	exit
.L17:
	movs	r0, #0
	bl	reset
	movs	r0, #1
	bl	reset
	movs	r0, #2
	bl	reset
	add	r3, r7, #120
	mov	r0, r3
	bl	write_hash0
	add	r3, r7, #120
	mov	r0, r3
	bl	write_hash1
	add	r3, r7, #120
	mov	r0, r3
	bl	write_hash2
	movs	r0, #0
	bl	start
	movs	r0, #1
	bl	start
	movs	r0, #2
	bl	start
.L20:
	add	r4, r7, #12
	bl	read_control0
	str	r0, [r4]
	add	r4, r7, #16
	bl	read_control1
	str	r0, [r4]
	add	r4, r7, #20
	bl	read_control2
	str	r0, [r4]
	add	r3, r7, #12
	ldr	r1, [r3]
	movw	r0, #:lower16:.LC6
	movt	r0, #:upper16:.LC6
	bl	printf
	add	r3, r7, #12
	ldr	r3, [r3]
	cmp	r3, #286331153
	bne	.L20
	add	r3, r7, #16
	ldr	r3, [r3]
	cmp	r3, #286331153
	bne	.L20
	add	r3, r7, #20
	ldr	r3, [r3]
	cmp	r3, #286331153
	beq	.L23
	b	.L20
.L23:
	nop
	add	r3, r7, #24
	mov	r0, r3
	bl	read_hash0
	add	r3, r7, #56
	mov	r0, r3
	bl	read_hash1
	add	r3, r7, #88
	mov	r0, r3
	bl	read_hash2
	movs	r0, #0
	bl	ack
	movs	r0, #1
	bl	ack
	movs	r0, #2
	bl	ack
	movw	r0, #:lower16:.LC7
	movt	r0, #:upper16:.LC7
	bl	puts
	movs	r0, #0
	bl	reset
	movs	r0, #1
	bl	reset
	movs	r0, #2
	bl	reset
	add	r3, r7, #184
	mov	r0, r3
	bl	write_hash0
	movs	r0, #0
	bl	start
	movs	r0, #0
	bl	ack
	add	r3, r7, #248
	mov	r0, r3
	bl	write_hash0
	movs	r0, #0
	bl	start
	movs	r0, #0
	bl	ack
	add	r3, r7, #24
	mov	r0, r3
	bl	read_hash0
	add	r3, r7, #24
	movs	r1, #0
	mov	r0, r3
	bl	display_hash
.L14:
	movs	r3, #0
.L13:
	mov	r0, r3
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #428]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L21
	bl	__stack_chk_fail
.L21:
	add	r7, r7, #436
	mov	sp, r7
	@ sp needed
	pop	{r4, r7, pc}
	.size	main, .-main
	.section	.rodata
	.align	2
.LC8:
	.ascii	"ioctl(ACC_WRITE_HASH0) failed\000"
	.text
	.align	2
	.global	write_hash0
	.syntax unified
	.thumb
	.thumb_func
	.type	write_hash0, %function
write_hash0:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29441
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L24
	movw	r0, #:lower16:.LC8
	movt	r0, #:upper16:.LC8
	bl	perror
	nop
.L24:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_hash0, .-write_hash0
	.section	.rodata
	.align	2
.LC9:
	.ascii	"ioctl(ACC_WRITE_HASH1) failed\000"
	.text
	.align	2
	.global	write_hash1
	.syntax unified
	.thumb
	.thumb_func
	.type	write_hash1, %function
write_hash1:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29445
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L26
	movw	r0, #:lower16:.LC9
	movt	r0, #:upper16:.LC9
	bl	perror
	nop
.L26:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_hash1, .-write_hash1
	.section	.rodata
	.align	2
.LC10:
	.ascii	"ioctl(ACC_WRITE_HASH2) failed\000"
	.text
	.align	2
	.global	write_hash2
	.syntax unified
	.thumb
	.thumb_func
	.type	write_hash2, %function
write_hash2:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29449
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L28
	movw	r0, #:lower16:.LC10
	movt	r0, #:upper16:.LC10
	bl	perror
	nop
.L28:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_hash2, .-write_hash2
	.section	.rodata
	.align	2
.LC11:
	.ascii	"ioctl(ACC_READ_HASH0) failed\000"
	.text
	.align	2
	.global	read_hash0
	.syntax unified
	.thumb
	.thumb_func
	.type	read_hash0, %function
read_hash0:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29442
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L30
	movw	r0, #:lower16:.LC11
	movt	r0, #:upper16:.LC11
	bl	perror
	nop
.L30:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_hash0, .-read_hash0
	.section	.rodata
	.align	2
.LC12:
	.ascii	"ioctl(ACC_READ_HASH1) failed\000"
	.text
	.align	2
	.global	read_hash1
	.syntax unified
	.thumb
	.thumb_func
	.type	read_hash1, %function
read_hash1:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29446
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L32
	movw	r0, #:lower16:.LC12
	movt	r0, #:upper16:.LC12
	bl	perror
	nop
.L32:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_hash1, .-read_hash1
	.section	.rodata
	.align	2
.LC13:
	.ascii	"ioctl(ACC_READ_HASH2) failed\000"
	.text
	.align	2
	.global	read_hash2
	.syntax unified
	.thumb
	.thumb_func
	.type	read_hash2, %function
read_hash2:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	ldr	r3, [r3]
	ldr	r2, [r7, #4]
	movw	r1, #29450
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L34
	movw	r0, #:lower16:.LC13
	movt	r0, #:upper16:.LC13
	bl	perror
	nop
.L34:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_hash2, .-read_hash2
	.section	.rodata
	.align	2
.LC14:
	.ascii	"ioctl(CONTROL_READ0) failed ;o;\000"
	.text
	.align	2
	.global	read_control0
	.syntax unified
	.thumb
	.thumb_func
	.type	read_control0, %function
read_control0:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	ldr	r3, [r3]
	mov	r2, r7
	movw	r1, #29443
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L37
	movw	r0, #:lower16:.LC14
	movt	r0, #:upper16:.LC14
	bl	perror
	movs	r3, #0
	b	.L39
.L37:
	ldr	r3, [r7]
.L39:
	mov	r0, r3
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L40
	bl	__stack_chk_fail
.L40:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_control0, .-read_control0
	.section	.rodata
	.align	2
.LC15:
	.ascii	"ioctl(CONTROL_READ1) failed ;o;\000"
	.text
	.align	2
	.global	read_control1
	.syntax unified
	.thumb
	.thumb_func
	.type	read_control1, %function
read_control1:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	ldr	r3, [r3]
	mov	r2, r7
	movw	r1, #29447
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L42
	movw	r0, #:lower16:.LC15
	movt	r0, #:upper16:.LC15
	bl	perror
	movs	r3, #0
	b	.L44
.L42:
	ldr	r3, [r7]
.L44:
	mov	r0, r3
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L45
	bl	__stack_chk_fail
.L45:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_control1, .-read_control1
	.section	.rodata
	.align	2
.LC16:
	.ascii	"ioctl(CONTROL_READ2) failed ;o;\000"
	.text
	.align	2
	.global	read_control2
	.syntax unified
	.thumb
	.thumb_func
	.type	read_control2, %function
read_control2:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #4]
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	ldr	r3, [r3]
	mov	r2, r7
	movw	r1, #29451
	movt	r1, 32772
	mov	r0, r3
	bl	ioctl
	mov	r3, r0
	cmp	r3, #0
	beq	.L47
	movw	r0, #:lower16:.LC16
	movt	r0, #:upper16:.LC16
	bl	perror
	movs	r3, #0
	b	.L49
.L47:
	ldr	r3, [r7]
.L49:
	mov	r0, r3
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #4]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L50
	bl	__stack_chk_fail
.L50:
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	read_control2, .-read_control2
	.align	2
	.global	write_control0
	.syntax unified
	.thumb
	.thumb_func
	.type	write_control0, %function
write_control0:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #12]
	ldr	r3, [r7, #4]
	str	r3, [r7, #8]
	movw	r3, #:lower16:sha256_acc_fd0
	movt	r3, #:upper16:sha256_acc_fd0
	ldr	r3, [r3]
	add	r2, r7, #8
	movw	r1, #29444
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	nop
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L52
	bl	__stack_chk_fail
.L52:
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_control0, .-write_control0
	.align	2
	.global	write_control1
	.syntax unified
	.thumb
	.thumb_func
	.type	write_control1, %function
write_control1:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #12]
	ldr	r3, [r7, #4]
	str	r3, [r7, #8]
	movw	r3, #:lower16:sha256_acc_fd1
	movt	r3, #:upper16:sha256_acc_fd1
	ldr	r3, [r3]
	add	r2, r7, #8
	movw	r1, #29448
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	nop
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L54
	bl	__stack_chk_fail
.L54:
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_control1, .-write_control1
	.align	2
	.global	write_control2
	.syntax unified
	.thumb
	.thumb_func
	.type	write_control2, %function
write_control2:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	str	r0, [r7, #4]
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r3, [r3]
	str	r3, [r7, #12]
	ldr	r3, [r7, #4]
	str	r3, [r7, #8]
	movw	r3, #:lower16:sha256_acc_fd2
	movt	r3, #:upper16:sha256_acc_fd2
	ldr	r3, [r3]
	add	r2, r7, #8
	movw	r1, #29452
	movt	r1, 16388
	mov	r0, r3
	bl	ioctl
	nop
	movw	r3, #:lower16:__stack_chk_guard
	movt	r3, #:upper16:__stack_chk_guard
	ldr	r2, [r7, #12]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L56
	bl	__stack_chk_fail
.L56:
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	write_control2, .-write_control2
	.align	2
	.global	reset
	.syntax unified
	.thumb
	.thumb_func
	.type	reset, %function
reset:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bne	.L58
	movs	r0, #255
	movt	r0, 65280
	bl	write_control0
	b	.L61
.L58:
	ldr	r3, [r7, #4]
	cmp	r3, #1
	bne	.L60
	movs	r0, #255
	movt	r0, 65280
	bl	write_control1
	b	.L61
.L60:
	ldr	r3, [r7, #4]
	cmp	r3, #2
	bne	.L61
	movs	r0, #255
	movt	r0, 65280
	bl	write_control2
.L61:
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	reset, .-reset
	.align	2
	.global	ack
	.syntax unified
	.thumb
	.thumb_func
	.type	ack, %function
ack:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bne	.L63
	mov	r0, #252645135
	bl	write_control0
	b	.L66
.L63:
	ldr	r3, [r7, #4]
	cmp	r3, #1
	bne	.L65
	mov	r0, #252645135
	bl	write_control1
	b	.L66
.L65:
	ldr	r3, [r7, #4]
	cmp	r3, #2
	bne	.L66
	mov	r0, #252645135
	bl	write_control2
.L66:
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	ack, .-ack
	.align	2
	.global	start
	.syntax unified
	.thumb
	.thumb_func
	.type	start, %function
start:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bne	.L68
	mov	r0, #-1
	bl	write_control0
	mov	r0, #-1
	bl	write_control0
	b	.L71
.L68:
	ldr	r3, [r7, #4]
	cmp	r3, #1
	bne	.L70
	mov	r0, #-1
	bl	write_control1
	mov	r0, #-1
	bl	write_control1
	b	.L71
.L70:
	ldr	r3, [r7, #4]
	cmp	r3, #2
	bne	.L71
	mov	r0, #-1
	bl	write_control2
	mov	r0, #-1
	bl	write_control2
.L71:
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	start, .-start
	.section	.rodata
	.align	2
.LC17:
	.ascii	"----- OUTPUT OF ACC%d -----\012\000"
	.align	2
.LC18:
	.ascii	"hash_output%d.r0: %x\012\000"
	.align	2
.LC19:
	.ascii	"hash_output%d.r1: %x\012\000"
	.align	2
.LC20:
	.ascii	"hash_output%d.r2: %x\012\000"
	.align	2
.LC21:
	.ascii	"hash_output%d.r3: %x\012\000"
	.align	2
.LC22:
	.ascii	"hash_output%d.r4: %x\012\000"
	.align	2
.LC23:
	.ascii	"hash_output%d.r5: %x\012\000"
	.align	2
.LC24:
	.ascii	"hash_output%d.r6: %x\012\000"
	.align	2
.LC25:
	.ascii	"hash_output%d.r7: %x\012\000"
	.align	2
.LC26:
	.ascii	"----- OUTPUT OF sofware -----\000"
	.align	2
.LC27:
	.ascii	"hash_output.r0: %x\012\000"
	.align	2
.LC28:
	.ascii	"hash_output.r1: %x\012\000"
	.align	2
.LC29:
	.ascii	"hash_output.r2: %x\012\000"
	.align	2
.LC30:
	.ascii	"hash_output.r3: %x\012\000"
	.align	2
.LC31:
	.ascii	"hash_output.r4: %x\012\000"
	.align	2
.LC32:
	.ascii	"hash_output.r5: %x\012\000"
	.align	2
.LC33:
	.ascii	"hash_output.r6: %x\012\000"
	.align	2
.LC34:
	.ascii	"hash_output.r7: %x\012\000"
	.text
	.align	2
	.global	display_hash
	.syntax unified
	.thumb
	.thumb_func
	.type	display_hash, %function
display_hash:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	ldr	r3, [r7]
	cmp	r3, #2
	bgt	.L73
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC17
	movt	r0, #:upper16:.LC17
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC18
	movt	r0, #:upper16:.LC18
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC19
	movt	r0, #:upper16:.LC19
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #8]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC20
	movt	r0, #:upper16:.LC20
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #12]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC21
	movt	r0, #:upper16:.LC21
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #16]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC22
	movt	r0, #:upper16:.LC22
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC23
	movt	r0, #:upper16:.LC23
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC24
	movt	r0, #:upper16:.LC24
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #28]
	mov	r2, r3
	ldr	r1, [r7]
	movw	r0, #:lower16:.LC25
	movt	r0, #:upper16:.LC25
	bl	printf
	b	.L75
.L73:
	ldr	r3, [r7]
	cmp	r3, #3
	bne	.L75
	movw	r0, #:lower16:.LC26
	movt	r0, #:upper16:.LC26
	bl	puts
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #28]
	mov	r1, r3
	movw	r0, #:lower16:.LC27
	movt	r0, #:upper16:.LC27
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #24]
	mov	r1, r3
	movw	r0, #:lower16:.LC28
	movt	r0, #:upper16:.LC28
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #20]
	mov	r1, r3
	movw	r0, #:lower16:.LC29
	movt	r0, #:upper16:.LC29
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #16]
	mov	r1, r3
	movw	r0, #:lower16:.LC30
	movt	r0, #:upper16:.LC30
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #12]
	mov	r1, r3
	movw	r0, #:lower16:.LC31
	movt	r0, #:upper16:.LC31
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #8]
	mov	r1, r3
	movw	r0, #:lower16:.LC32
	movt	r0, #:upper16:.LC32
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3, #4]
	mov	r1, r3
	movw	r0, #:lower16:.LC33
	movt	r0, #:upper16:.LC33
	bl	printf
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	mov	r1, r3
	movw	r0, #:lower16:.LC34
	movt	r0, #:upper16:.LC34
	bl	printf
.L75:
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	display_hash, .-display_hash
	.section	.rodata
	.align	2
	.type	filename0.5996, %object
	.size	filename0.5996, 17
filename0.5996:
	.ascii	"/dev/sha256acc_1\000"
	.align	2
	.type	filename1.5997, %object
	.size	filename1.5997, 17
filename1.5997:
	.ascii	"/dev/sha256acc_2\000"
	.align	2
	.type	filename2.5998, %object
	.size	filename2.5998, 17
filename2.5998:
	.ascii	"/dev/sha256acc_3\000"
	.ident	"GCC: (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",%progbits
