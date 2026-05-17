extern printf
extern scanf
extern malloc

section .data
	std_uns_mode: db "%u", 0
	std_int_mode: db "%d", 0
	std_int_out: db "%d", 0
	std_spc_out: db " ", 0
	std_nl_out: db 10, 0
	high_trace_lo: dd 0
	high_trace_hi: dd 2147483648
	high_ptr: dd 0
	high_size: dd 0
	cntr: dd 0
; TODO: надо придумать что-то с названиями переменных

section .bss
	n: resd 1
	cur_size: resd 1
	cur_ptr: resd 1
	cur_trace_lo: resd 1
	cur_trace_hi: resd 1

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
	push n
	push std_uns_mode
	call scanf
	add esp, 8

	.s_main_l:
	mov eax, [cntr]
	cmp eax, [n]
	jge .e_main_l

	sub esp, 8
	push cur_size
	push std_uns_mode
	call scanf
	add esp, 8

	mov eax, [cur_size]
	imul eax, eax
	shl eax, 2
	sub esp, 12
	push eax
	call malloc
	add esp, 4
	mov [cur_ptr], eax

	mov esi, 0
	.s_w_n:
	mov eax, [cur_size]
	imul eax, eax
	cmp esi, eax
	jge .e_w_n
	mov eax, [cur_ptr]
	lea eax, [eax + esi*4]
	sub esp, 8
	push eax
	push std_int_mode
	call scanf
	add esp, 8
	inc esi
	jmp .s_w_n
	.e_w_n:

	mov dword [cur_trace_lo], 0
	mov dword [cur_trace_hi], 0
	mov esi, 0
	.s_w_tr:
	cmp esi, [cur_size]
	jge .e_w_tr
	mov eax, [cur_size]
	inc eax
	imul eax, esi
	mov ebx, [cur_ptr]
	mov eax, [ebx + eax*4]
	cdq
	add [cur_trace_lo], eax
	adc [cur_trace_hi], edx
	inc esi
	jmp .s_w_tr
	.e_w_tr:

	cmp dword [high_ptr], 0
	je .update_high
	mov eax, [cur_trace_hi]
	cmp eax, [high_trace_hi]
	jg .update_high
	jl .skip_update
	mov eax, [cur_trace_lo]
	cmp eax, [high_trace_lo]
	ja .update_high
	jmp .skip_update
	.update_high:
	mov eax, [cur_ptr]
	mov [high_ptr], eax
	mov eax, [cur_size]
	mov [high_size], eax
	mov eax, [cur_trace_lo]
	mov [high_trace_lo], eax
	mov eax, [cur_trace_hi]
	mov [high_trace_hi], eax
	.skip_update:

	inc dword [cntr]
	jmp .s_main_l
	.e_main_l:

	mov esi, 0
	.s_p_rows:
	cmp esi, [high_size]
	jge .e_p_rows
	mov edi, 0
	.s_p_col:
	cmp edi, [high_size]
	jge .e_p_col
	mov eax, [high_size]
	imul eax, esi
	add eax, edi
	mov ebx, [high_ptr]
	mov eax, [ebx + eax*4]
	sub esp, 8
	push eax
	push std_int_out

	call printf
	add esp, 8
	mov eax, edi
	inc eax
	cmp eax, [high_size]
	jge .no_space

	sub esp, 12
	push std_spc_out
	call printf
	add esp, 4
	.no_space:
	inc edi
	jmp .s_p_col
	.e_p_col:
	sub esp, 12
	push std_nl_out
	call printf
	add esp, 4
	inc esi
	jmp .s_p_rows
	.e_p_rows:

	pop esi
	pop edi
	pop ebx
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret

; Отвратный код, я извиняюсь перед каждым, кто прочитал его
; Я не вижу возможости сделать его лучше
; ____________
; | []    [] |
; |   \_/    |
; | -------  |
; ------------
