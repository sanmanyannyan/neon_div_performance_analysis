	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"div.c"
	.text
	.align	2
	.global	compare_dbl
	.syntax unified
	.arm
	.fpu neon
	.type	compare_dbl, %function
compare_dbl:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	vldr.64	d17, [r0]
	vldr.64	d16, [r1]
	vcmpe.f64	d17, d16
	vmrs	APSR_nzcv, FPSCR
	bgt	.L3
	mvnmi	r0, #0
	movpl	r0, #0
	bx	lr
.L3:
	mov	r0, #1
	bx	lr
	.size	compare_dbl, .-compare_dbl
	.align	2
	.global	print_float_bits
	.syntax unified
	.arm
	.fpu neon
	.type	print_float_bits, %function
print_float_bits:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
	vmov	r8, s0	@ int
	ldr	r7, .L19
	ldr	r10, .L19+4
	mov	r4, #31
	mov	fp, #-2147483648
	mov	r6, #48
	mov	r9, #49
	mov	r5, #1
	b	.L10
.L18:
	tst	r2, r10
	bne	.L16
.L9:
	sub	r4, r4, #1
	cmn	r4, #1
	lsr	fp, fp, #1
	beq	.L17
.L10:
	tst	r8, fp
	mov	r0, r6
	movne	r0, r9
	bl	putchar
	lsl	r2, r5, r4
	tst	r2, r7
	beq	.L18
	mov	r0, #39
	sub	r4, r4, #1
	bl	putchar
	cmn	r4, #1
	lsr	fp, fp, #1
	bne	.L10
.L17:
	mov	r0, #10
	pop	{r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
	b	putchar
.L16:
	mov	r0, #32
	bl	putchar
	b	.L9
.L20:
	.align	2
.L19:
	.word	559240
	.word	-2139095040
	.size	print_float_bits, .-print_float_bits
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 800
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	ip, .L79
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	mov	r5, r0
	mov	r4, r1
	ldm	ip, {r0, r1, r2, r3}
	sub	sp, sp, #828
	add	lr, ip, #16
	add	r6, sp, #472
	add	r8, ip, #32
	stm	r6, {r0, r1, r2, r3}
	add	r9, sp, #504
	ldm	lr, {r0, r1, r2, r3}
	add	lr, sp, #488
	add	r7, ip, #48
	add	r6, ip, #64
	stm	lr, {r0, r1, r2, r3}
	add	lr, ip, #80
	ldm	ip, {r0, r1, r2, r3}
	add	fp, ip, #96
	add	r10, ip, #112
	stm	r9, {r0, r1, r2, r3}
	add	r9, ip, #128
	ldm	r8, {r0, r1, r2, r3}
	add	r8, sp, #520
	stm	r8, {r0, r1, r2, r3}
	add	r8, ip, #144
	ldm	r7, {r0, r1, r2, r3}
	add	r7, sp, #536
	stm	r7, {r0, r1, r2, r3}
	add	r7, ip, #160
	ldm	r6, {r0, r1, r2, r3}
	add	r6, sp, #552
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #568
	ldm	lr, {r0, r1, r2, r3}
	add	lr, ip, #192
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #584
	ldm	fp, {r0, r1, r2, r3}
	add	fp, ip, #224
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #600
	ldm	r10, {r0, r1, r2, r3}
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #616
	ldm	r9, {r0, r1, r2, r3}
	add	r9, ip, #256
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #632
	ldm	r8, {r0, r1, r2, r3}
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #648
	ldm	r7, {r0, r1, r2, r3}
	add	r7, ip, #272
	stm	r6, {r0, r1, r2, r3}
	add	r3, r8, #32
	add	r6, sp, #664
	ldm	r3, {r0, r1, r2, r3}
	stm	r6, {r0, r1, r2, r3}
	add	r6, sp, #680
	ldm	lr, {r0, r1, r2, r3}
	add	lr, ip, #288
	stm	r6, {r0, r1, r2, r3}
	add	r3, r8, #64
	add	r6, sp, #696
	ldm	r3, {r0, r1, r2, r3}
	add	r8, sp, #712
	stm	r6, {r0, r1, r2, r3}
	add	r6, ip, #304
	ldm	fp, {r0, r1, r2, r3}
	add	ip, ip, #320
	ldr	fp, .L79+4
	stm	r8, {r0, r1, r2, r3}
	add	r3, r10, #128
	add	r8, sp, #728
	ldm	r3, {r0, r1, r2, r3}
	ldr	r10, .L79+8
	stm	r8, {r0, r1, r2, r3}
	add	r8, sp, #744
	ldm	r9, {r0, r1, r2, r3}
	mov	r9, #0
	stm	r8, {r0, r1, r2, r3}
	mov	r8, #10
	ldm	r7, {r0, r1, r2, r3}
	add	r7, sp, #760
	stm	r7, {r0, r1, r2, r3}
	ldm	lr, {r0, r1, r2, r3}
	add	lr, sp, #776
	ldr	r7, .L79+12
	stm	lr, {r0, r1, r2, r3}
	add	lr, sp, #792
	ldm	r6, {r0, r1, r2, r3}
	ldr	r6, .L79+16
	stm	lr, {r0, r1, r2, r3}
	ldm	ip, {r0, r1, r2, r3}
	add	ip, sp, #808
	stm	ip, {r0, r1, r2, r3}
.L23:
	mov	r2, r7
	mov	r1, r4
	mov	r0, r5
	bl	getopt
	cmn	r0, #1
	beq	.L78
	cmp	r0, #105
	mov	r2, r8
	mov	r1, r9
	beq	.L24
	cmp	r0, #116
	bne	.L23
	ldr	r0, [fp]
	bl	strtol
	mov	r6, r0
	b	.L23
.L24:
	ldr	r0, [fp]
	bl	strtol
	mov	r10, r0
	b	.L23
.L80:
	.align	2
.L79:
	.word	.LANCHOR0
	.word	optarg
	.word	100000
	.word	.LC21
	.word	10000
	.word	1717986919
	.word	.LC22
	.word	.LC23
	.word	.LC24
.L78:
	ldr	r4, .L79+20
	add	r3, r10, #9
	ldr	r1, .L79+24
	smull	r2, r4, r4, r3
	mov	r0, #1
	asr	r3, r3, #31
	rsb	r4, r3, r4, asr #2
	bl	setlocale
	mov	r1, r10
	ldr	r0, .L79+28
	bl	printf
	lsl	fp, r6, #3
	mov	r1, r6
	ldr	r0, .L79+32
	bl	printf
	mov	r0, fp
	bl	malloc
	add	r3, sp, #504
	vld1.32	{d2-d3}, [r3:64]
	add	r3, sp, #584
	vld1.32	{d4-d5}, [r3:64]
	add	r3, sp, #520
	vld1.32	{d6-d7}, [r3:64]
	add	r3, sp, #600
	vld1.32	{d30-d31}, [r3:64]
	add	r3, sp, #536
	vld1.32	{d28-d29}, [r3:64]
	add	r3, sp, #616
	vld1.32	{d26-d27}, [r3:64]
	add	r3, sp, #552
	vld1.32	{d24-d25}, [r3:64]
	add	r3, sp, #632
	vld1.32	{d20-d21}, [r3:64]
	add	r3, sp, #568
	vld1.32	{d18-d19}, [r3:64]
	add	r3, sp, #648
	vld1.32	{d0-d1}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #744
	vstr	d16, [sp, #192]
	vstr	d17, [sp, #200]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #680
	vstr	d16, [sp, #176]
	vstr	d17, [sp, #184]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #760
	vstr	d16, [sp, #160]
	vstr	d17, [sp, #168]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #696
	vstr	d16, [sp, #144]
	vstr	d17, [sp, #152]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #776
	vstr	d16, [sp, #128]
	vstr	d17, [sp, #136]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #712
	vstr	d16, [sp, #112]
	vstr	d17, [sp, #120]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #792
	vstr	d16, [sp, #96]
	vstr	d17, [sp, #104]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #728
	vstr	d16, [sp, #80]
	vstr	d17, [sp, #88]
	vld1.32	{d16-d17}, [r3:64]
	add	r3, sp, #808
	vstr	d16, [sp, #64]
	vstr	d17, [sp, #72]
	vld1.32	{d16-d17}, [r3:64]
	vstr	d16, [sp, #48]
	vstr	d17, [sp, #56]
	vldr.64	d16, .L81
	cmp	r6, #0
	str	r0, [sp, #372]
	vstr.64	d16, [sp, #24]
	ble	.L56
	mov	r8, #0
	mov	r10, r8
	mov	r9, r0
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #472
	vstr	d0, [sp, #208]
	vstr	d1, [sp, #216]
	vld1.32	{d16-d17}, [r3:64]
	vld1.32	{d8-d9}, [r3:64]
	vld1.32	{d10-d11}, [r3:64]
	vld1.32	{d12-d13}, [r3:64]
	vld1.32	{d14-d15}, [r3:64]
	vstr	d18, [sp, #224]
	vstr	d19, [sp, #232]
	vstr	d20, [sp, #240]
	vstr	d21, [sp, #248]
	vstr	d24, [sp, #256]
	vstr	d25, [sp, #264]
	vstr	d26, [sp, #272]
	vstr	d27, [sp, #280]
	vstr	d28, [sp, #288]
	vstr	d29, [sp, #296]
	vstr	d30, [sp, #304]
	vstr	d31, [sp, #312]
	vstr	d6, [sp, #320]
	vstr	d7, [sp, #328]
	vstr	d4, [sp, #336]
	vstr	d5, [sp, #344]
	vstr	d2, [sp, #352]
	vstr	d3, [sp, #360]
	vstr	d16, [sp, #32]
	vstr	d17, [sp, #40]
.L31:
	mov	r1, r10
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 167 "div.c" 1
	# start add
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L29
	mov	r3, #0
	vldr	d0, [sp, #208]
	vldr	d1, [sp, #216]
	vldr	d18, [sp, #224]
	vldr	d19, [sp, #232]
	vldr	d20, [sp, #240]
	vldr	d21, [sp, #248]
	vldr	d24, [sp, #256]
	vldr	d25, [sp, #264]
	vldr	d26, [sp, #272]
	vldr	d27, [sp, #280]
	vldr	d28, [sp, #288]
	vldr	d29, [sp, #296]
	vldr	d30, [sp, #304]
	vldr	d31, [sp, #312]
	vldr	d6, [sp, #320]
	vldr	d7, [sp, #328]
	vldr	d4, [sp, #336]
	vldr	d5, [sp, #344]
	vldr	d2, [sp, #352]
	vldr	d3, [sp, #360]
	vldr	d16, [sp, #32]
	vldr	d17, [sp, #40]
.L30:
	add	r3, r3, #1
	cmp	r4, r3
	vadd.f32	q8, q8, q1
	vadd.f32	q7, q7, q3
	vadd.f32	q6, q6, q14
	vadd.f32	q5, q5, q12
	vadd.f32	q4, q4, q9
	vadd.f32	q8, q8, q2
	vadd.f32	q7, q7, q15
	vadd.f32	q6, q6, q13
	vadd.f32	q5, q5, q10
	vadd.f32	q4, q4, q0
	bne	.L30
	vstr	d16, [sp, #32]
	vstr	d17, [sp, #40]
.L29:
	.syntax divided
@ 180 "div.c" 1
	# end add
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, r10
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d16, .L81+8
	add	r8, r8, #1
	vcvt.f64.s32	d23, s15
	vmov	s15, r3	@ int
	cmp	r6, r8
	vcvt.f64.s32	d22, s15
	vmla.f64	d22, d23, d16
	vldr.64	d16, [sp, #24]
	vadd.f64	d16, d16, d22
	vstmia.64	r9!, {d22}
	vstr.64	d16, [sp, #24]
	bne	.L31
	ldr	r10, [sp, #372]
	vldr	d16, [sp, #32]
	vldr	d17, [sp, #40]
.L28:
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #32
	mov	r0, r10
	vst1.64	{d16-d17}, [r3:64]
	ldr	r3, .L81+16
	bl	qsort
	ldr	r0, .L81+20
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L81+24
	bl	printf
	add	r3, r6, r6, lsr #31
	ldr	r0, .L81+28
	asr	r3, r3, #1
	sub	fp, fp, #8
	add	r3, r10, r3, lsl #3
	str	r3, [sp, #208]
	ldrd	r2, [r3]
	bl	printf
	vmov	s15, r6	@ int
	vldr.64	d18, [sp, #24]
	ldr	r0, .L81+32
	ldr	r8, .L81+36
	vcvt.f64.s32	d16, s15
	vdiv.f64	d17, d18, d16
	vstr.64	d16, [sp, #224]
	vmov	r2, r3, d17
	bl	printf
	add	r3, r10, fp
	str	r3, [sp, #240]
	ldr	r0, .L81+40
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d16-d17}, [r2:64]
	vst1.32	{d16-d17}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d17, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L81+44
	vcvt.f64.f32	d18, s13
	add	ip, sp, #408
	vstr.64	d17, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d14-d15}, [ip:64]
	vmov	r2, r3, d18
	add	ip, sp, #424
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d10-d11}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L81+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L81+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L81+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L81+60
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L81
	cmp	r6, #0
	vstr.64	d16, [sp, #24]
	ble	.L57
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #472
	vld1.32	{d18-d19}, [r3:64]
	vld1.32	{d8-d9}, [r3:64]
	vld1.32	{d10-d11}, [r3:64]
	vld1.32	{d12-d13}, [r3:64]
	vld1.32	{d14-d15}, [r3:64]
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
	b	.L82
.L83:
	.align	3
.L81:
	.word	0
	.word	0
	.word	0
	.word	1093567616
	.word	compare_dbl
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	stderr
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
.L82:
.L35:
	mov	r1, fp
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 208 "div.c" 1
	# start mul
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L33
	mov	r3, #0
	vldr	d0, [sp, #48]
	vldr	d1, [sp, #56]
	vldr	d16, [sp, #64]
	vldr	d17, [sp, #72]
	vldr	d20, [sp, #80]
	vldr	d21, [sp, #88]
	vldr	d22, [sp, #96]
	vldr	d23, [sp, #104]
	vldr	d24, [sp, #112]
	vldr	d25, [sp, #120]
	vldr	d28, [sp, #128]
	vldr	d29, [sp, #136]
	vldr	d30, [sp, #144]
	vldr	d31, [sp, #152]
	vldr	d6, [sp, #160]
	vldr	d7, [sp, #168]
	vldr	d4, [sp, #176]
	vldr	d5, [sp, #184]
	vldr	d2, [sp, #192]
	vldr	d3, [sp, #200]
	vldr	d18, [sp, #32]
	vldr	d19, [sp, #40]
.L34:
	add	r3, r3, #1
	cmp	r4, r3
	vmul.f32	q9, q9, q1
	vmul.f32	q7, q7, q3
	vmul.f32	q6, q6, q14
	vmul.f32	q5, q5, q11
	vmul.f32	q4, q4, q8
	vmul.f32	q9, q9, q2
	vmul.f32	q7, q7, q15
	vmul.f32	q6, q6, q12
	vmul.f32	q5, q5, q10
	vmul.f32	q4, q4, q0
	bne	.L34
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
.L33:
	.syntax divided
@ 221 "div.c" 1
	# end mul
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d16, .L84
	add	r9, r9, #1
	vcvt.f64.s32	d27, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	vcvt.f64.s32	d26, s15
	vmla.f64	d26, d27, d16
	vldr.64	d16, [sp, #24]
	vadd.f64	d16, d16, d26
	vstmia.64	r10!, {d26}
	vstr.64	d16, [sp, #24]
	bne	.L35
	vldr	d18, [sp, #32]
	vldr	d19, [sp, #40]
.L32:
	ldr	r10, [sp, #372]
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #32
	mov	r0, r10
	vst1.64	{d18-d19}, [r3:64]
	ldr	r3, .L84+16
	bl	qsort
	ldr	r0, .L84+20
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L84+24
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L84+28
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L84+32
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	ldr	r0, .L84+40
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d18-d19}, [r2:64]
	vst1.32	{d18-d19}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+44
	vcvt.f64.f32	d17, s13
	add	ip, sp, #408
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d14-d15}, [ip:64]
	vmov	r2, r3, d17
	add	ip, sp, #424
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d10-d11}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L84+60
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L84+8
	cmp	r6, #0
	add	r3, sp, #488
	vld1.32	{d8-d9}, [r3:64]
	vstr.64	d16, [sp, #24]
	ble	.L58
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #728
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d18-d19}, [r3:64]
	add	r3, sp, #664
	vstr	d18, [sp, #48]
	vstr	d19, [sp, #56]
	vld1.32	{d20-d21}, [r3:64]
	vstr	d20, [sp, #32]
	vstr	d21, [sp, #40]
.L39:
	mov	r1, fp
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 250 "div.c" 1
	# start div0
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L37
	mov	r3, #0
	vldr	d20, [sp, #32]
	vldr	d21, [sp, #40]
	vldr	d18, [sp, #48]
	vldr	d19, [sp, #56]
.L38:
	add	r3, r3, #1
	cmp	r4, r3
	vrecpe.f32	q5, q5
	vrecpe.f32	q6, q6
	vrecpe.f32	q7, q7
	vrecpe.f32	q9, q9
	vrecpe.f32	q10, q10
	vmul.f32	q5, q4, q5
	vmul.f32	q6, q4, q6
	vmul.f32	q7, q4, q7
	vmul.f32	q9, q4, q9
	vmul.f32	q10, q4, q10
	vrecpe.f32	q5, q5
	vrecpe.f32	q6, q6
	vrecpe.f32	q7, q7
	vrecpe.f32	q9, q9
	vrecpe.f32	q10, q10
	vmul.f32	q5, q4, q5
	vmul.f32	q6, q4, q6
	vmul.f32	q7, q4, q7
	vmul.f32	q9, q4, q9
	vmul.f32	q10, q4, q10
	bne	.L38
	vstr	d20, [sp, #32]
	vstr	d21, [sp, #40]
	vstr	d18, [sp, #48]
	vstr	d19, [sp, #56]
.L37:
	.syntax divided
@ 263 "div.c" 1
	# end div0
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d18, .L84
	add	r9, r9, #1
	vcvt.f64.s32	d17, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	vcvt.f64.s32	d16, s15
	vmla.f64	d16, d17, d18
	vldr.64	d17, [sp, #24]
	vstmia.64	r10!, {d16}
	vadd.f64	d16, d17, d16
	vstr.64	d16, [sp, #24]
	bne	.L39
	vldr	d20, [sp, #32]
	vldr	d21, [sp, #40]
	vldr	d18, [sp, #48]
	vldr	d19, [sp, #56]
.L36:
	ldr	r10, [sp, #372]
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #48
	mov	r0, r10
	vst1.64	{d18-d19}, [r3:64]
	add	r3, sp, #32
	vst1.64	{d20-d21}, [r3:64]
	ldr	r3, .L84+16
	bl	qsort
	ldr	r0, .L84+36
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L84+24
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L84+28
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L84+32
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	b	.L85
.L86:
	.align	3
.L84:
	.word	0
	.word	1093567616
	.word	0
	.word	0
	.word	compare_dbl
	.word	.LC35
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC36
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
.L85:
	ldr	r0, .L84+40
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d20-d21}, [r2:64]
	vst1.32	{d20-d21}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d22, s13
	vcvt.f64.f32	d20, s12
	vcvt.f64.f32	d7, s14
	vldr.32	s13, [sp, #392]
	add	lr, sp, #48
	ldr	r1, .L84+44
	add	ip, sp, #408
	vcvt.f64.f32	d16, s13
	vstr.64	d22, [sp, #16]
	vstr.64	d20, [sp]
	vstr.64	d7, [sp, #8]
	vld1.64	{d18-d19}, [lr:64]
	vmov	r2, r3, d16
	vst1.32	{d18-d19}, [ip:64]
	add	ip, sp, #424
	vst1.32	{d10-d11}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d14-d15}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d12-d13}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L84+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L84+60
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L87
	cmp	r6, #0
	add	r3, sp, #488
	vld1.32	{d20-d21}, [r3:64]
	vstr.64	d16, [sp, #24]
	ble	.L59
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #728
	vstr	d20, [sp, #48]
	vstr	d21, [sp, #56]
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d18-d19}, [r3:64]
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
.L43:
	mov	r1, fp
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 292 "div.c" 1
	# start div2
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L41
	mov	r3, #0
	vldr	d20, [sp, #48]
	vldr	d21, [sp, #56]
	vldr	d18, [sp, #32]
	vldr	d19, [sp, #40]
.L42:
	add	r3, r3, #1
	cmp	r4, r3
	vrecpe.f32	q8, q4
	vrecpe.f32	q11, q5
	vrecpe.f32	q12, q6
	vrecpe.f32	q13, q7
	vrecpe.f32	q14, q9
	vrecps.f32	q4, q4, q8
	vrecps.f32	q5, q5, q11
	vrecps.f32	q6, q6, q12
	vrecps.f32	q7, q7, q13
	vrecps.f32	q9, q9, q14
	vmul.f32	q4, q4, q8
	vmul.f32	q5, q5, q11
	vmul.f32	q6, q6, q12
	vmul.f32	q7, q7, q13
	vmul.f32	q9, q9, q14
	vmul.f32	q4, q4, q10
	vmul.f32	q5, q5, q10
	vmul.f32	q6, q6, q10
	vmul.f32	q7, q7, q10
	vmul.f32	q9, q9, q10
	vrecpe.f32	q8, q4
	vrecpe.f32	q11, q5
	vrecpe.f32	q12, q6
	vrecpe.f32	q13, q7
	vrecpe.f32	q14, q9
	vrecps.f32	q4, q4, q8
	vrecps.f32	q5, q5, q11
	vrecps.f32	q6, q6, q12
	vrecps.f32	q7, q7, q13
	vrecps.f32	q9, q9, q14
	vmul.f32	q4, q4, q8
	vmul.f32	q5, q5, q11
	vmul.f32	q6, q6, q12
	vmul.f32	q7, q7, q13
	vmul.f32	q9, q9, q14
	vmul.f32	q4, q4, q10
	vmul.f32	q5, q5, q10
	vmul.f32	q6, q6, q10
	vmul.f32	q7, q7, q10
	vmul.f32	q9, q9, q10
	bne	.L42
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
.L41:
	.syntax divided
@ 305 "div.c" 1
	# end div2
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d18, .L87+8
	add	r9, r9, #1
	vcvt.f64.s32	d17, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	vcvt.f64.s32	d16, s15
	vmla.f64	d16, d17, d18
	vldr.64	d17, [sp, #24]
	vstmia.64	r10!, {d16}
	vadd.f64	d16, d17, d16
	vstr.64	d16, [sp, #24]
	bne	.L43
	vldr	d18, [sp, #32]
	vldr	d19, [sp, #40]
.L40:
	ldr	r10, [sp, #372]
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #32
	mov	r0, r10
	vst1.64	{d18-d19}, [r3:64]
	ldr	r3, .L87+16
	bl	qsort
	ldr	r0, .L87+20
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L87+24
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L87+28
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L87+32
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	ldr	r0, .L87+36
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d18-d19}, [r2:64]
	vst1.32	{d18-d19}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L87+40
	vcvt.f64.f32	d17, s13
	add	ip, sp, #408
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d14-d15}, [ip:64]
	vmov	r2, r3, d17
	add	ip, sp, #424
	vst1.32	{d10-d11}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L87+44
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L87+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L87+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L87+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L87
	cmp	r6, #0
	add	r3, sp, #488
	vld1.32	{d26-d27}, [r3:64]
	vstr.64	d16, [sp, #24]
	ble	.L60
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #728
	vmov.f32	q12, #3.0e+0  @ v4sf
	vld1.32	{d8-d9}, [r3:64]
	vstr	d26, [sp, #64]
	vstr	d27, [sp, #72]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	vstr	d22, [sp, #48]
	vstr	d23, [sp, #56]
	b	.L88
.L89:
	.align	3
.L87:
	.word	0
	.word	0
	.word	0
	.word	1093567616
	.word	compare_dbl
	.word	.LC37
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
.L88:
.L47:
	mov	r1, fp
	mov	r0, r7
	add	r3, sp, #32
	vst1.64	{d24-d25}, [r3:64]
	bl	gettimeofday
	.syntax divided
@ 334 "div.c" 1
	# start div3
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	add	r3, sp, #32
	vld1.64	{d24-d25}, [r3:64]
	ble	.L45
	mov	r3, #0
	vldr	d26, [sp, #64]
	vldr	d27, [sp, #72]
	vldr	d22, [sp, #48]
	vldr	d23, [sp, #56]
.L46:
	add	r3, r3, #1
	cmp	r4, r3
	vrecpe.f32	q10, q11
	vrecpe.f32	q8, q5
	vmul.f32	q11, q10, q11
	vmul.f32	q5, q8, q5
	vsub.f32	q14, q11, q12
	vsub.f32	q9, q5, q12
	vmul.f32	q11, q11, q14
	vmul.f32	q5, q5, q9
	vadd.f32	q11, q11, q12
	vadd.f32	q5, q5, q12
	vmul.f32	q10, q11, q10
	vmul.f32	q8, q5, q8
	vmul.f32	q10, q13, q10
	vmul.f32	q8, q13, q8
	vrecpe.f32	q14, q10
	vrecpe.f32	q9, q8
	vmul.f32	q10, q14, q10
	vmul.f32	q8, q9, q8
	vsub.f32	q11, q10, q12
	vsub.f32	q5, q8, q12
	vmul.f32	q11, q10, q11
	vmul.f32	q8, q8, q5
	vrecpe.f32	q10, q7
	vadd.f32	q8, q8, q12
	vmul.f32	q7, q10, q7
	vmul.f32	q9, q8, q9
	vadd.f32	q11, q11, q12
	vrecpe.f32	q8, q6
	vmul.f32	q11, q11, q14
	vmul.f32	q6, q8, q6
	vsub.f32	q14, q7, q12
	vmul.f32	q5, q13, q9
	vmul.f32	q7, q7, q14
	vsub.f32	q9, q6, q12
	vadd.f32	q7, q7, q12
	vmul.f32	q6, q6, q9
	vmul.f32	q10, q7, q10
	vadd.f32	q6, q6, q12
	vmul.f32	q10, q13, q10
	vmul.f32	q8, q6, q8
	vrecpe.f32	q14, q10
	vmul.f32	q8, q13, q8
	vmul.f32	q10, q14, q10
	vrecpe.f32	q9, q8
	vsub.f32	q7, q10, q12
	vmul.f32	q8, q9, q8
	vmul.f32	q10, q10, q7
	vsub.f32	q6, q8, q12
	vadd.f32	q10, q10, q12
	vmul.f32	q8, q8, q6
	vmul.f32	q14, q10, q14
	vadd.f32	q8, q8, q12
	vmul.f32	q11, q13, q11
	vmul.f32	q9, q8, q9
	vmul.f32	q7, q13, q14
	vrecpe.f32	q8, q4
	vmul.f32	q6, q13, q9
	vmul.f32	q4, q8, q4
	vsub.f32	q9, q4, q12
	vmul.f32	q4, q4, q9
	vadd.f32	q4, q4, q12
	vmul.f32	q8, q4, q8
	vmul.f32	q8, q13, q8
	vrecpe.f32	q9, q8
	vmul.f32	q8, q9, q8
	vsub.f32	q4, q8, q12
	vmul.f32	q8, q8, q4
	vadd.f32	q8, q8, q12
	vmul.f32	q9, q8, q9
	vmul.f32	q4, q13, q9
	bne	.L46
	vstr	d22, [sp, #48]
	vstr	d23, [sp, #56]
.L45:
	add	r3, sp, #32
	vst1.64	{d24-d25}, [r3:64]
	.syntax divided
@ 347 "div.c" 1
	# end div3
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d18, .L90
	add	r9, r9, #1
	vcvt.f64.s32	d17, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	add	r3, sp, #32
	vld1.64	{d24-d25}, [r3:64]
	vcvt.f64.s32	d16, s15
	vmla.f64	d16, d17, d18
	vldr.64	d17, [sp, #24]
	vstmia.64	r10!, {d16}
	vadd.f64	d16, d17, d16
	vstr.64	d16, [sp, #24]
	bne	.L47
	vldr	d22, [sp, #48]
	vldr	d23, [sp, #56]
.L44:
	ldr	r10, [sp, #372]
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #32
	mov	r0, r10
	vst1.64	{d22-d23}, [r3:64]
	ldr	r3, .L90+20
	bl	qsort
	ldr	r0, .L90+16
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L90+28
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L90+32
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L90+36
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	ldr	r0, .L90+40
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d22-d23}, [r2:64]
	vst1.32	{d22-d23}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+44
	vcvt.f64.f32	d17, s13
	add	ip, sp, #408
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d10-d11}, [ip:64]
	vmov	r2, r3, d17
	add	ip, sp, #424
	vst1.32	{d14-d15}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L90+60
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L90+8
	cmp	r6, #0
	add	r3, sp, #488
	vld1.32	{d24-d25}, [r3:64]
	vstr.64	d16, [sp, #24]
	ble	.L61
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #728
	vstr	d24, [sp, #48]
	vstr	d25, [sp, #56]
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	vstr	d22, [sp, #32]
	vstr	d23, [sp, #40]
.L51:
	mov	r1, fp
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 376 "div.c" 1
	# start div4
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L49
	mov	r3, #0
	vldr	d24, [sp, #48]
	vldr	d25, [sp, #56]
	vldr	d22, [sp, #32]
	vldr	d23, [sp, #40]
.L50:
	add	r3, r3, #1
	cmp	r4, r3
	vrecpe.f32	q10, q11
	vrecpe.f32	q8, q5
	vrecps.f32	q13, q11, q10
	vrecps.f32	q9, q5, q8
	vmul.f32	q10, q13, q10
	vmul.f32	q8, q9, q8
	vrecps.f32	q11, q11, q10
	vrecps.f32	q5, q5, q8
	vmul.f32	q10, q11, q10
	vmul.f32	q8, q5, q8
	vmul.f32	q10, q12, q10
	vmul.f32	q8, q12, q8
	vrecpe.f32	q11, q10
	vrecpe.f32	q9, q8
	vrecps.f32	q13, q10, q11
	vrecps.f32	q5, q8, q9
	vmul.f32	q11, q13, q11
	vmul.f32	q9, q5, q9
	vrecps.f32	q10, q10, q11
	vrecps.f32	q8, q8, q9
	vmul.f32	q11, q10, q11
	vmul.f32	q9, q8, q9
	vrecpe.f32	q10, q7
	vrecpe.f32	q8, q6
	vrecps.f32	q13, q7, q10
	vmul.f32	q5, q12, q9
	vmul.f32	q10, q13, q10
	vrecps.f32	q9, q6, q8
	vrecps.f32	q7, q7, q10
	vmul.f32	q8, q9, q8
	vmul.f32	q10, q7, q10
	vrecps.f32	q6, q6, q8
	vmul.f32	q10, q12, q10
	vmul.f32	q8, q6, q8
	vrecpe.f32	q13, q10
	vmul.f32	q8, q12, q8
	vrecps.f32	q7, q10, q13
	vrecpe.f32	q9, q8
	vmul.f32	q13, q7, q13
	vrecps.f32	q6, q8, q9
	vrecps.f32	q10, q10, q13
	vmul.f32	q9, q6, q9
	vmul.f32	q13, q10, q13
	vrecps.f32	q8, q8, q9
	vmul.f32	q11, q12, q11
	vmul.f32	q9, q8, q9
	vmul.f32	q7, q12, q13
	vrecpe.f32	q8, q4
	vmul.f32	q6, q12, q9
	vrecps.f32	q9, q4, q8
	vmul.f32	q8, q9, q8
	vrecps.f32	q4, q4, q8
	vmul.f32	q8, q4, q8
	vmul.f32	q8, q12, q8
	vrecpe.f32	q9, q8
	vrecps.f32	q4, q8, q9
	vmul.f32	q9, q4, q9
	vrecps.f32	q8, q8, q9
	vmul.f32	q9, q8, q9
	vmul.f32	q4, q12, q9
	bne	.L50
	vstr	d22, [sp, #32]
	vstr	d23, [sp, #40]
.L49:
	.syntax divided
@ 389 "div.c" 1
	# end div4
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d18, .L90
	add	r9, r9, #1
	vcvt.f64.s32	d17, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	vcvt.f64.s32	d16, s15
	b	.L91
.L92:
	.align	3
.L90:
	.word	0
	.word	1093567616
	.word	0
	.word	0
	.word	.LC38
	.word	compare_dbl
	.word	.LC39
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
.L91:
	vmla.f64	d16, d17, d18
	vldr.64	d17, [sp, #24]
	vstmia.64	r10!, {d16}
	vadd.f64	d16, d17, d16
	vstr.64	d16, [sp, #24]
	bne	.L51
	vldr	d22, [sp, #32]
	vldr	d23, [sp, #40]
.L48:
	ldr	r10, [sp, #372]
	mov	r1, r6
	mov	r2, #8
	add	r3, sp, #32
	mov	r0, r10
	vst1.64	{d22-d23}, [r3:64]
	ldr	r3, .L90+20
	bl	qsort
	ldr	r0, .L90+24
	bl	puts
	ldrd	r2, [r10]
	ldr	r0, .L90+28
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L90+32
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L90+36
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	ldr	r0, .L90+40
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d22-d23}, [r2:64]
	vst1.32	{d22-d23}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+44
	vcvt.f64.f32	d17, s13
	add	ip, sp, #408
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d10-d11}, [ip:64]
	vmov	r2, r3, d17
	add	ip, sp, #424
	vst1.32	{d14-d15}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L90+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s14, [sp, #464]
	vldr.32	s12, [sp, #460]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d16, s12
	vcvt.f64.f32	d7, s14
	ldr	r1, .L90+60
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d16, [sp]
	vstr.64	d7, [sp, #8]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.64	d16, .L93
	cmp	r6, #0
	add	r3, sp, #488
	vld1.32	{d24-d25}, [r3:64]
	vstr.64	d16, [sp, #24]
	ble	.L62
	mov	r9, #0
	mov	fp, r9
	add	r7, sp, #376
	add	r5, sp, #384
	add	r3, sp, #728
	vstr	d24, [sp, #48]
	vstr	d25, [sp, #56]
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	vstr	d22, [sp, #32]
	vstr	d23, [sp, #40]
.L55:
	mov	r1, fp
	mov	r0, r7
	bl	gettimeofday
	.syntax divided
@ 418 "div.c" 1
	# start div8
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r4, #0
	ble	.L53
	mov	r3, #0
	vldr	d24, [sp, #48]
	vldr	d25, [sp, #56]
	vldr	d22, [sp, #32]
	vldr	d23, [sp, #40]
.L54:
	add	r3, r3, #1
	cmp	r4, r3
	vrecpe.f32	q9, q11
	vrecpe.f32	q8, q5
	vrecps.f32	q13, q11, q9
	vrecps.f32	q10, q5, q8
	vmul.f32	q9, q13, q9
	vmul.f32	q8, q10, q8
	vrecps.f32	q13, q11, q9
	vrecps.f32	q10, q5, q8
	vmul.f32	q9, q13, q9
	vmul.f32	q8, q10, q8
	vrecps.f32	q11, q11, q9
	vrecps.f32	q5, q5, q8
	vmul.f32	q9, q11, q9
	vmul.f32	q8, q5, q8
	vmul.f32	q9, q12, q9
	vmul.f32	q8, q12, q8
	vrecpe.f32	q11, q9
	vrecpe.f32	q10, q8
	vrecps.f32	q13, q9, q11
	vrecps.f32	q5, q8, q10
	vmul.f32	q11, q13, q11
	vmul.f32	q10, q5, q10
	vrecps.f32	q13, q9, q11
	vrecps.f32	q5, q8, q10
	vmul.f32	q11, q13, q11
	vmul.f32	q10, q5, q10
	vrecps.f32	q9, q9, q11
	vrecps.f32	q8, q8, q10
	vmul.f32	q11, q9, q11
	vmul.f32	q10, q8, q10
	vrecpe.f32	q9, q7
	vrecpe.f32	q8, q6
	vrecps.f32	q13, q7, q9
	vmul.f32	q5, q12, q10
	vmul.f32	q9, q13, q9
	vrecps.f32	q10, q6, q8
	vrecps.f32	q13, q7, q9
	vmul.f32	q8, q10, q8
	vmul.f32	q9, q13, q9
	vrecps.f32	q10, q6, q8
	vrecps.f32	q7, q7, q9
	vmul.f32	q8, q10, q8
	vmul.f32	q9, q7, q9
	vrecps.f32	q6, q6, q8
	vmul.f32	q9, q12, q9
	vmul.f32	q8, q6, q8
	vrecpe.f32	q13, q9
	vmul.f32	q8, q12, q8
	vrecps.f32	q7, q9, q13
	vrecpe.f32	q10, q8
	vmul.f32	q13, q7, q13
	vrecps.f32	q6, q8, q10
	vrecps.f32	q7, q9, q13
	vmul.f32	q10, q6, q10
	vmul.f32	q13, q7, q13
	vrecps.f32	q6, q8, q10
	vrecps.f32	q9, q9, q13
	vmul.f32	q10, q6, q10
	vmul.f32	q13, q9, q13
	vrecps.f32	q8, q8, q10
	vmul.f32	q11, q12, q11
	vmul.f32	q10, q8, q10
	vmul.f32	q7, q12, q13
	vrecpe.f32	q8, q4
	vmul.f32	q6, q12, q10
	vrecps.f32	q9, q4, q8
	vmul.f32	q8, q9, q8
	vrecps.f32	q9, q4, q8
	vmul.f32	q8, q9, q8
	vrecps.f32	q4, q4, q8
	vmul.f32	q8, q4, q8
	vmul.f32	q8, q12, q8
	vrecpe.f32	q9, q8
	vrecps.f32	q4, q8, q9
	vmul.f32	q9, q4, q9
	vrecps.f32	q4, q8, q9
	vmul.f32	q9, q4, q9
	vrecps.f32	q8, q8, q9
	vmul.f32	q9, q8, q9
	vmul.f32	q4, q12, q9
	bne	.L54
	vstr	d22, [sp, #32]
	vstr	d23, [sp, #40]
.L53:
	.syntax divided
@ 431 "div.c" 1
	# end div8
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, fp
	mov	r0, r5
	bl	gettimeofday
	ldr	r1, [sp, #376]
	ldr	r2, [sp, #384]
	ldr	r3, [sp, #388]
	sub	r2, r2, r1
	ldr	r1, [sp, #380]
	vmov	s15, r2	@ int
	sub	r3, r3, r1
	vldr.64	d18, .L93+8
	add	r9, r9, #1
	vcvt.f64.s32	d17, s15
	vmov	s15, r3	@ int
	cmp	r6, r9
	vcvt.f64.s32	d16, s15
	vmla.f64	d16, d17, d18
	vldr.64	d17, [sp, #24]
	vstmia.64	r10!, {d16}
	vadd.f64	d16, d17, d16
	vstr.64	d16, [sp, #24]
	bne	.L55
	vldr	d22, [sp, #32]
	vldr	d23, [sp, #40]
.L52:
	ldr	r4, [sp, #372]
	mov	r1, r6
	add	r3, sp, #32
	mov	r2, #8
	vst1.64	{d22-d23}, [r3:64]
	mov	r0, r4
	ldr	r3, .L93+16
	bl	qsort
	ldr	r0, .L93+20
	bl	puts
	ldrd	r2, [r4]
	ldr	r0, .L93+24
	bl	printf
	ldr	r3, [sp, #208]
	ldr	r0, .L93+28
	ldrd	r2, [r3]
	bl	printf
	vldr.64	d17, [sp, #24]
	vldr.64	d18, [sp, #224]
	ldr	r0, .L93+32
	vdiv.f64	d16, d17, d18
	vmov	r2, r3, d16
	bl	printf
	ldr	r3, [sp, #240]
	ldr	r0, .L93+36
	ldrd	r2, [r3]
	bl	printf
	add	r3, sp, #392
	add	r2, sp, #32
	vld1.64	{d22-d23}, [r2:64]
	vst1.32	{d22-d23}, [r3:64]
	vldr.32	s13, [sp, #404]
	vldr.32	s12, [sp, #396]
	vldr.32	s14, [sp, #400]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #392]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	add	ip, sp, #408
	vcvt.f64.f32	d17, s13
	ldr	r1, .L93+40
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vst1.32	{d10-d11}, [ip:64]
	vmov	r2, r3, d17
	add	ip, sp, #424
	vst1.32	{d14-d15}, [ip:64]
	add	ip, sp, #440
	vst1.32	{d12-d13}, [ip:64]
	add	ip, sp, #456
	vst1.32	{d8-d9}, [ip:64]
	bl	fprintf
	vldr.32	s13, [sp, #420]
	vldr.32	s12, [sp, #412]
	vldr.32	s14, [sp, #416]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #408]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L93+44
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #436]
	vldr.32	s12, [sp, #428]
	vldr.32	s14, [sp, #432]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #424]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L93+48
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #452]
	vldr.32	s12, [sp, #444]
	vldr.32	s14, [sp, #448]
	ldr	r0, [r8]
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #440]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L93+52
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	vldr.32	s13, [sp, #468]
	vldr.32	s12, [sp, #460]
	vldr.32	s14, [sp, #464]
	ldr	r0, [r8]
	b	.L94
.L95:
	.align	3
.L93:
	.word	0
	.word	0
	.word	0
	.word	1093567616
	.word	compare_dbl
	.word	.LC40
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC29
	.word	.LC30
	.word	.LC31
	.word	.LC32
	.word	.LC33
	.word	.LC34
.L94:
	vcvt.f64.f32	d18, s13
	vldr.32	s13, [sp, #456]
	vcvt.f64.f32	d7, s14
	vcvt.f64.f32	d16, s12
	ldr	r1, .L93+56
	vcvt.f64.f32	d17, s13
	vstr.64	d18, [sp, #16]
	vstr.64	d7, [sp, #8]
	vstr.64	d16, [sp]
	vmov	r2, r3, d17
	bl	fprintf
	mov	r0, r4
	bl	free
	mov	r0, #0
	add	sp, sp, #828
	@ sp needed
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L56:
	add	r3, sp, #472
	mov	r10, r0
	vld1.32	{d8-d9}, [r3:64]
	vmov	q5, q4  @ v4sf
	vmov	q6, q4  @ v4sf
	vmov	q7, q4  @ v4sf
	vmov	q8, q4  @ v4sf
	b	.L28
.L57:
	add	r3, sp, #472
	vld1.32	{d8-d9}, [r3:64]
	vmov	q5, q4  @ v4sf
	vmov	q6, q4  @ v4sf
	vmov	q7, q4  @ v4sf
	vmov	q9, q4  @ v4sf
	b	.L32
.L58:
	add	r3, sp, #728
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d18-d19}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d20-d21}, [r3:64]
	b	.L36
.L59:
	add	r3, sp, #728
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d18-d19}, [r3:64]
	b	.L40
.L60:
	add	r3, sp, #728
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	b	.L44
.L61:
	add	r3, sp, #728
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	b	.L48
.L62:
	add	r3, sp, #728
	vld1.32	{d8-d9}, [r3:64]
	add	r3, sp, #712
	vld1.32	{d12-d13}, [r3:64]
	add	r3, sp, #696
	vld1.32	{d14-d15}, [r3:64]
	add	r3, sp, #680
	vld1.32	{d10-d11}, [r3:64]
	add	r3, sp, #664
	vld1.32	{d22-d23}, [r3:64]
	b	.L52
	.size	main, .-main
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
.LC0:
	.word	1065353216
	.word	1073741824
	.word	1077936128
	.word	1082130432
.LC1:
	.word	1065353216
	.word	1065353216
	.word	1065353216
	.word	1065353216
.LC2:
	.word	1084227584
	.word	1086324736
	.word	1088421888
	.word	1090519040
.LC3:
	.word	1091567616
	.word	1092616192
	.word	1093664768
	.word	1094713344
.LC4:
	.word	1095761920
	.word	1096810496
	.word	1097859072
	.word	1098907648
.LC5:
	.word	1099431936
	.word	1099956224
	.word	1100480512
	.word	1101004800
.LC6:
	.word	-1082130432
	.word	-1073741824
	.word	-1069547520
	.word	-1065353216
.LC7:
	.word	-1063256064
	.word	-1061158912
	.word	-1059061760
	.word	-1056964608
.LC8:
	.word	-1055916032
	.word	-1054867456
	.word	-1053818880
	.word	-1052770304
.LC9:
	.word	-1051721728
	.word	-1050673152
	.word	-1049624576
	.word	-1048576000
.LC10:
	.word	-1048051712
	.word	-1047527424
	.word	-1047003136
	.word	-1046478848
.LC11:
	.word	1073741824
	.word	1077936128
	.word	1082130432
	.word	1084227584
.LC12:
	.word	1086324736
	.word	1088421888
	.word	1090519040
	.word	1091567616
.LC13:
	.word	1092616192
	.word	1093664768
	.word	1094713344
	.word	1095761920
.LC14:
	.word	1096810496
	.word	1097859072
	.word	1098907648
	.word	1099431936
.LC15:
	.word	1099956224
	.word	1100480512
	.word	1101004800
	.word	1101529088
.LC16:
	.word	1056964608
	.word	1051372203
	.word	1048576000
	.word	1045220557
.LC17:
	.word	1042983595
	.word	1041385765
	.word	1040187392
	.word	1038323257
.LC18:
	.word	1036831949
	.word	1035611788
	.word	1034594987
	.word	1033734617
.LC19:
	.word	1032997157
	.word	1032358025
	.word	1031798784
	.word	1030811889
.LC20:
	.word	1029934649
	.word	1029149750
	.word	1028443341
	.word	1027804209
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC21:
	.ascii	"i:t:\000"
	.space	3
.LC22:
	.ascii	"\000"
	.space	3
.LC23:
	.ascii	"iteration:%'d\012\000"
	.space	1
.LC24:
	.ascii	"trial:%'d\012\000"
	.space	1
.LC25:
	.ascii	"add\000"
.LC26:
	.ascii	"\011 min:%fusec\012\000"
	.space	2
.LC27:
	.ascii	"\011 med:%fusec\012\000"
	.space	2
.LC28:
	.ascii	"\011mean:%fusec\012\000"
	.space	2
.LC29:
	.ascii	"\011 max:%fusec\012\000"
	.space	2
.LC30:
	.ascii	"\011vx1:{%f, %f, %f, %f}\012\000"
	.space	1
.LC31:
	.ascii	"\011vx2:{%f, %f, %f, %f}\012\000"
	.space	1
.LC32:
	.ascii	"\011vx3:{%f, %f, %f, %f}\012\000"
	.space	1
.LC33:
	.ascii	"\011vx4:{%f, %f, %f, %f}\012\000"
	.space	1
.LC34:
	.ascii	"\011vx5:{%f, %f, %f, %f}\012\000"
	.space	1
.LC35:
	.ascii	"mul\000"
.LC36:
	.ascii	"div0\000"
	.space	3
.LC37:
	.ascii	"div2\000"
	.space	3
.LC38:
	.ascii	"div3\000"
	.space	3
.LC39:
	.ascii	"div4\000"
	.space	3
.LC40:
	.ascii	"div8\000"
	.ident	"GCC: (Raspbian 6.3.0-18+rpi1+deb9u1) 6.3.0 20170516"
	.section	.note.GNU-stack,"",%progbits
