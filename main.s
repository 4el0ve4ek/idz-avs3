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
main:                                               # начало программы, отсюда все начинается
	push	rbp                                 # кладем указатель на начало стека вызывающей фукнции
	mov	rbp, rsp                            # начало нашего стека - это конец вызывающего
	sub	rsp, 96                             # занимаем 96 битов памяти
	mov	DWORD PTR [rbp-68], edi	            # rbp-68 := argc
	mov	QWORD PTR [rbp-80], rsi             # rbp-80 := argv


	mov	rax, QWORD PTR stdin[rip]           # input := stdin
	mov	QWORD PTR [rbp-24], rax             # rbp-24 := input

	mov	rax, QWORD PTR stdout[rip]          # output := stdout
	mov	QWORD PTR [rbp-16], rax             # rbp-16 := output
	
    cmp	DWORD PTR [rbp-68], 2                       # if (argc > 2)
	jle	.L2                                 # пропускаем блок, если argc <= 2

    # input := fopen(argv[1], "r")
	mov	rax, QWORD PTR [rbp-80]
	add	rax, 8
	mov	rax, QWORD PTR [rax]                # rax := argv[1]    
	mov	esi, OFFSET FLAT:.LC0
	mov	rdi, rax
	call	fopen                               # открываем файл на чтение
	mov	QWORD PTR [rbp-24], rax
	
    # output := fopen(argv[2], "w")
    mov	rax, QWORD PTR [rbp-80]
	add	rax, 16
	mov	rax, QWORD PTR [rax]                # rax := argv[2]
	mov	esi, OFFSET FLAT:.LC1
	mov	rdi, rax
	call	fopen                               # открываем файл на запись
	mov	QWORD PTR [rbp-16], rax

.L2:
    # fscanf(input, "%lf %lf %lf %lf", &a, &b, &L, &R);
	lea	rdi, [rbp-32]                       # rdi := &R
	lea	rsi, [rbp-40]                       # rsi := &L
	lea	rcx, [rbp-48]                       # rcx := &b
	lea	rdx, [rbp-56]                       # rdx := &a
	mov	rax, QWORD PTR [rbp-24]             # rax := input | поток ввода
	mov	r9, rdi                             # r9 := rdi := &R
	mov	r8, rsi                             # r8 := rsi := &L
	mov	esi, OFFSET FLAT:.LC2               # формат ввода
	mov	rdi, rax                            # rdi := rax := input
	mov	eax, 0                              # нет переменного числа аргументов
	call	__isoc99_fscanf                     # вызов функции.
    # Аргументы передаются в регистрах в таком порядке: rdi, esi, rdx, rcx, r8, r9

    # .if (L > R)
	movsd	xmm1, QWORD PTR [rbp-32]            # R
	movsd	xmm0, QWORD PTR [rbp-40]            # L
	ucomisd	xmm0, xmm1                          # compare L, R
	jbe	.L13                                # if L <= R -> пропускам блок
	# fwrite("left side must be lower then right", 1, 34, output)
    mov	rax, QWORD PTR [rbp-16]         
	mov	rcx, rax
	mov	edx, 34
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC3
	call	fwrite
	mov	eax, 1                              # return 1;
	jmp	.L9

.L13:

	movsd	xmm1, QWORD PTR [rbp-40]    # L
	movsd	xmm0, QWORD PTR [rbp-32]    # R
	mulsd	xmm0, xmm1                  # L * R
	pxor	xmm1, xmm1                  # 0
	ucomisd	xmm1, xmm0                  # compare 0, L * R
	jb	.L14                        # if 0 < L * R -> пропускаем блок
	# fwrite("segment must not include 0", 1, 26, output);
    mov	rax, QWORD PTR [rbp-16]
	mov	rcx, rax
	mov	edx, 26
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC5
	call	fwrite
	mov	eax, 1                      # return 1;
	jmp	.L9

.L14:

    # integrate(a, b, L, R);
	movsd	xmm2, QWORD PTR [rbp-32]        # xmm2 := R
	movsd	xmm1, QWORD PTR [rbp-40]        # xmm1 := L
	movsd	xmm0, QWORD PTR [rbp-48]        # xmm0 := b
	mov	rax, QWORD PTR [rbp-56]         # rax := a
	movapd	xmm3, xmm2                      # xmm3 := xmm2 := R
	movapd	xmm2, xmm1                      # xmm2 := xmm1 := L
	movapd	xmm1, xmm0                      # xmm1 := xmm0 := b
	mov	QWORD PTR [rbp-88], rax         # rbp-88 :=  rax := a
	movsd	xmm0, QWORD PTR [rbp-88]        # xmm0 := rbp-88 := a
	call	integrate                      

    # fprintf(output, "%f\n", integrate(a, b, L, R));
	mov	rax, QWORD PTR [rbp-16]
	mov	esi, OFFSET FLAT:.LC6
	mov	rdi, rax
	mov	eax, 1
	call	fprintf

	cmp	DWORD PTR [rbp-68], 2           # закрываем файлы, если их передали
	jle	.L8
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	fclose                          # fclose(input)
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	fclose                          # fclose(output)

.L8:
	mov	eax, 0                          # return 0
.L9:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
