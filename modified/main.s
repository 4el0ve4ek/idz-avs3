    .file	"main.c"
    .intel_syntax noprefix
    .section	.rodata
.LC0:
    .string	"r"
.LC1:
    .string	"w"
.LC2:
    .string	"%lf %lf %lf %lf"
    .align 8
.LC3:
    .string	"left side must be lower then right"
.LC5:
    .string	"segment must not include 0"
.LC6:
    .string	"%f\n"
    .text
    .globl	main
    .type	main, @function
main:
    push	rbp
    mov	rbp, rsp
    push	r15                             # output
    push	r14                             # input
    sub	rsp, 80
    mov	DWORD PTR [rbp-68], edi
    mov	QWORD PTR [rbp-80], rsi

    mov	r14, QWORD PTR stdin[rip]           # начальное значение input - stdin
    mov	r15, QWORD PTR stdout[rip]          # начальное занчение output - stdout
    cmp	DWORD PTR [rbp-68], 2
    jle	.L2
    
    mov	rax, QWORD PTR [rbp-80]
    add	rax, 8
    mov	rax, QWORD PTR [rax]
    mov	esi, OFFSET FLAT:.LC0
    mov	rdi, rax
    call	fopen
    mov	r14, rax                            # открываем файл для чтения и кладем его в r14
    
    mov	rax, QWORD PTR [rbp-80]
    add	rax, 16
    mov	rax, QWORD PTR [rax]
    mov	esi, OFFSET FLAT:.LC1
    mov	rdi, rax
    call	fopen
    mov	r15, rax                            # открываем файл для записи и кладем его в r15

.L2:
    mov	rdi, r14                            # читаем входные данные из input
    lea	rsi, [rbp-32]
    lea	rcx, [rbp-40]
    lea	rdx, [rbp-48]
    lea	rax, [rbp-56]
    mov	r9, rsi
    mov	r8, rcx
    mov	rcx, rdx
    mov	rdx, rax
    mov	esi, OFFSET FLAT:.LC2
    mov	eax, 0
    call	__isoc99_fscanf
    
    movsd	xmm1, QWORD PTR [rbp-32]
    movsd	xmm0, QWORD PTR [rbp-40]
    ucomisd	xmm0, xmm1
    jbe	.L13

    mov	rcx, r15                            # пишем ответ в output
    mov	edx, 34
    mov	esi, 1
    mov	edi, OFFSET FLAT:.LC3
    call	fwrite
    mov	eax, 1
    jmp	.L9

.L13:
    movsd	xmm1, QWORD PTR [rbp-40]
    movsd	xmm0, QWORD PTR [rbp-32]
    mulsd	xmm0, xmm1
    pxor	xmm1, xmm1
    ucomisd	xmm1, xmm0
    jb	.L14

    mov	rcx, r15                            # пишем ответ в output
    mov	edx, 26
    mov	esi, 1
    mov	edi, OFFSET FLAT:.LC5
    call	fwrite
    mov	eax, 1
    jmp	.L9
.L14:
    movsd	xmm2, QWORD PTR [rbp-32]
    movsd	xmm1, QWORD PTR [rbp-40]
    movsd	xmm0, QWORD PTR [rbp-48]
    mov	rax, QWORD PTR [rbp-56]
    movapd	xmm3, xmm2
    movapd	xmm2, xmm1
    movapd	xmm1, xmm0
    mov	QWORD PTR [rbp-88], rax
    movsd	xmm0, QWORD PTR [rbp-88]
    call	integrate

    mov	esi, OFFSET FLAT:.LC6
    mov	rdi, r15                            # пишем ответ в output
    mov	eax, 1          
    call	fprintf
    cmp	DWORD PTR [rbp-68], 2
    jle	.L8
    mov	rax, r14					        # закрываем файл в input
    mov	rdi, rax
    call	fclose
    mov	rax, r15                            # закрываем файл в output
    mov	rdi, rax
    call	fclose
.L8:
    mov	eax, 0
.L9:
    add	rsp, 80
    pop	r14
    pop	r15
    pop	rbp
    ret
    .size	main, .-main
    .ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
    .section	.note.GNU-stack,"",@progbits
