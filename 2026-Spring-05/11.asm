extern printf
extern scanf
extern malloc
extern fopen
extern fscanf
extern fprintf
extern fclose

section .data
	std_uns_mode: db "%u", 0
	std_spc_out: db " ", 0
	std_nl_out: db 10, 0
	input_file: db "input.txt", 0
	output_file: db "output.txt", 0
	std_file_read_mode: db "r", 0
	std_file_write_mode: db "w", 0

section .bss
	n: resd 1
	m: resd 1
	head_val: resd 1
	b_val: resd 1
	c_val: resd 1
	prev_ptr: resd 1
	next_ptr: resd 1
	iter: resd 1
	buf_in: resd 1
	buf_out: resd 1

; я очень люблю связанные списки благодаря leet code)
section .text
global main
main:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	and esp, ~15

	sub esp, 8
	push std_file_read_mode
	push input_file
	call fopen
	add esp, 8
	mov [buf_in], eax

	sub esp, 8
	push std_file_write_mode
	push output_file
	call fopen
	add esp, 8
	mov [buf_out], eax

	sub esp, 4
	push n
	push std_uns_mode
	push dword [buf_in]
	call fscanf
	add esp, 12

	sub esp, 4
	push m
	push std_uns_mode
	push dword [buf_in]
	call fscanf
	add esp, 12

	mov eax, [n]
	inc eax
	shl eax, 2
	sub esp, 12
	push eax
	call malloc
	add esp, 4
	mov [prev_ptr], eax

	mov eax, [n]
	inc eax
	shl eax, 2
	sub esp, 12
	push eax
	call malloc
	add esp, 4
	mov [next_ptr], eax

	mov dword [head_val], 1
	mov esi, 1
	.s_init_l:
	cmp esi, [n]
	jg .e_init_l

	mov eax, esi
	dec eax
	mov ebx, [prev_ptr]
	mov [ebx + esi*4], eax

	mov eax, esi
	inc eax
	cmp esi, [n]
	jne .s_init_not_last
	xor eax, eax
	.s_init_not_last:
	mov ebx, [next_ptr]
	mov [ebx + esi*4], eax

	inc esi
	jmp .s_init_l
	.e_init_l:

	mov dword [iter], 0
	.s_trans_l:
	mov eax, [iter]
	cmp eax, [m]
	jge .e_trans_l
	sub esp, 4
	push b_val
	push std_uns_mode
	push dword [buf_in]
	call fscanf
	add esp, 12

	sub esp, 4
	push c_val
	push std_uns_mode
	push dword [buf_in]
	call fscanf
	add esp, 12

	mov esi, [b_val]
	mov edi, [c_val]

	mov ebx, [prev_ptr]
	mov ecx, [ebx + esi*4]
	mov ebx, [next_ptr]
	mov edx, [ebx + edi*4]

	mov eax, [head_val]
	test ecx, ecx
	jz .s_trans_b_is_head
	mov ebx, [next_ptr]
	mov [ebx + ecx*4], edx
	jmp .s_trans_b_done
	.s_trans_b_is_head:
	mov eax, edx
	.s_trans_b_done:

	test edx, edx
	jz .s_trans_no_nc
	mov ebx, [prev_ptr]
	mov [ebx + edx*4], ecx
	.s_trans_no_nc:

	mov ebx, [prev_ptr]
	mov dword [ebx + esi*4], 0

	mov ebx, [next_ptr]
	mov [ebx + edi*4], eax

	test eax, eax
	jz .s_trans_no_nh
	mov ebx, [prev_ptr]
	mov [ebx + eax*4], edi
	.s_trans_no_nh:

	mov [head_val], esi

	inc dword [iter]
	jmp .s_trans_l
	.e_trans_l:

	mov esi, [head_val]
	.s_print_l:
	test esi, esi
	jz .e_print_l

	sub esp, 4
	push esi
	push std_uns_mode
	push dword [buf_out]
	call fprintf
	add esp, 12

	mov ebx, [next_ptr]
	mov eax, [ebx + esi*4]
	test eax, eax
	jz .s_print_no_sp
	sub esp, 8
	push std_spc_out
	push dword [buf_out]
	call fprintf
	add esp, 8
	.s_print_no_sp:

	mov ebx, [next_ptr]
	mov esi, [ebx + esi*4]
	jmp .s_print_l
	.e_print_l:

	sub esp, 8
	push std_nl_out
	push dword [buf_out]
	call fprintf
	add esp, 8

	sub esp, 12
	push dword [buf_in]
	call fclose
	add esp, 4

	sub esp, 12
	push dword [buf_out]
	call fclose
	add esp, 4

	pop esi
	pop edi
	pop ebx
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret
