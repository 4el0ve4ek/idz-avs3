	.file	"common.c"
	.intel_syntax noprefix
	.text
	.globl	calcFunc
	.type	calcFunc, @function
calcFunc:
	push	rbp					# типовое начало функции
	mov	rbp, rsp
		              				# сохраняем на стеке входные аргументы
	movsd	QWORD PTR [rbp-8], xmm0			# a
	movsd	QWORD PTR [rbp-16], xmm1		# b
	movsd	QWORD PTR [rbp-24], xmm2		# x

	movsd	xmm0, QWORD PTR [rbp-24]		# xmm0 := x
	mulsd	xmm0, QWORD PTR [rbp-24]		# xmm0 := x * x
	mulsd	xmm0, QWORD PTR [rbp-24]		# xmm0 := x * x * x
	mulsd	xmm0, QWORD PTR [rbp-24]		# xmm0 := x * x * x * x
	movsd	xmm1, QWORD PTR [rbp-16]		# xmm1 := b
	divsd	xmm1, xmm0				# xmm1 := b / (x ^ 4)
	movapd	xmm0, xmm1				# xmm0 := xmm1
	addsd	xmm0, QWORD PTR [rbp-8]			# xmm0 := a + b / (x ^ 4)
	pop	rbp
	ret



	.size	calcFunc, .-calcFunc
	.globl	integrate
	.type	integrate, @function
integrate:
	push	rbp					# типовое начало функции
	mov	rbp, rsp
	sub	rsp, 72
	movsd	QWORD PTR [rbp-40], xmm0		# rbp-40 := a
	movsd	QWORD PTR [rbp-48], xmm1		# rbp-48 := b
	movsd	QWORD PTR [rbp-56], xmm2		# rbp-56 := L
	movsd	QWORD PTR [rbp-64], xmm3		# rbp-64 := R
	movsd	xmm0, QWORD PTR .LC0[rip]		
	movsd	QWORD PTR [rbp-8], xmm0			# rbp-8 := precision := 0.0001 
	pxor	xmm0, xmm0
	movsd	QWORD PTR [rbp-24], xmm0		# rbp-24 := res := 0
	jmp	.L4


.L7:
	movsd	xmm0, QWORD PTR [rbp-8]		
	movsd	QWORD PTR [rbp-16], xmm0		# step := precision := 0.0001
	movsd	xmm0, QWORD PTR [rbp-64]		# xmm0 := R
	subsd	xmm0, QWORD PTR [rbp-56]		# xmm0 := R - L
	movsd	xmm1, QWORD PTR [rbp-16]		# xmm1 := step
	ucomisd	xmm1, xmm0				# compare step, R-L
	jbe	.L5					# if step <= R - L -> don't process block
	movsd	xmm0, QWORD PTR [rbp-64]		# xmm0 := R
	subsd	xmm0, QWORD PTR [rbp-56]		# xmm0 := R - L
	movsd	QWORD PTR [rbp-16], xmm0		# rbp-16 := R - L | step
.L5:
	movsd	xmm0, QWORD PTR [rbp-16]		# xmm0 := step
	movsd	xmm1, QWORD PTR .LC2[rip]		# xmm1 := 2
	divsd	xmm0, xmm1				# xmm0 := step / 2
	addsd	xmm0, QWORD PTR [rbp-56]		# xmm0 := step / 2 + L
	movsd	xmm1, QWORD PTR [rbp-48]		# xmm1 := b
	mov	rax, QWORD PTR [rbp-40]			# rax := a
	movapd	xmm2, xmm0				# xmm2 := xmm0 := step / 2 + L
	mov	QWORD PTR [rbp-72], rax			# rbp-72 := rax := a
	movsd	xmm0, QWORD PTR [rbp-72]		# xmm0 := rbp-72 := a
	call	calcFunc			        # calcFunc(a, b, L + step / 2)

	mulsd	xmm0, QWORD PTR [rbp-16]		# умножаем результат calcFunc на step
	movsd	xmm1, QWORD PTR [rbp-24]		# res
	addsd	xmm0, xmm1				# вычисляем новый res
	movsd	QWORD PTR [rbp-24], xmm0		# сохраняем его
	movsd	xmm0, QWORD PTR [rbp-56]		# L
	addsd	xmm0, QWORD PTR [rbp-16]		# L + step
	movsd	QWORD PTR [rbp-56], xmm0		# сохраняем новый L

.L4:

	# while (L < R)
	movsd	xmm0, QWORD PTR [rbp-64]	# R
	ucomisd	xmm0, QWORD PTR [rbp-56]	# compare R, L
	ja	.L7				# if R > L -> делаем тело цикла

	movsd	xmm0, QWORD PTR [rbp-24]	# return res;
	leave
	ret


	.size	integrate, .-integrate
	.section	.rodata
	.align 8
.LC0:	# 0.0001
	.long	3944497965
	.long	1058682594
	.align 8
.LC2:	# 2
	.long	0
	.long	1073741824
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits

