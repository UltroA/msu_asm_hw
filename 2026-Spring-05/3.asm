extern scanf
extern printf
extern strstr, strlen

section .data
	std_str_mode: db "%s", 0
	std_core_out: db "%.*s[%s]%s", 10, 0
	std_str_newl: db 10, 0

section .bss
	a: resb 101
	b: resb 101

section .text
global main
main:
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	and esp, ~15

	push a
	push std_str_mode
	call scanf
	add esp, 8

	push b
	push std_str_mode
	call scanf
	add esp, 8

	; b в а
	lea esi, [a]
	lea edi, [b]
	push edi
	push esi
	call strstr
	add esp, 8
	test eax, eax
	jz .reverse

	; вот тут уже типа кмп или как его
	mov ebx, eax
	push eax
	push edi
	call strlen
	add esp, 4
	pop ebx
	push eax
	lea eax, [a]
	mov ecx, ebx
	sub ecx, eax
	pop eax
	add ebx, eax

	push ebx
	push edi
	push esi
	push ecx
	push std_core_out
	call printf
	add esp, 20
	jmp .re0

	; а в b
	.reverse:
	lea esi, [b]
	lea edi, [a]
	push edi
	push esi
	call strstr
	add esp, 8
	test eax, eax
	jz .def_out

	mov ebx, eax
	push eax
	push edi
	call strlen
	add esp, 4
	pop ebx
	push eax
	lea eax, [b]
	mov ecx, ebx
	sub ecx, eax
	pop eax
	add ebx, eax

	push ebx
	push edi
	push esi
	push ecx
	push std_core_out
	call printf
	add esp, 20
	jmp .re0

	.def_out:
	lea esi, [a]
	push esi
	push std_str_mode
	call printf
	add esp, 8
	push std_str_newl
	call printf
	add esp, 4

	.re0:
	pop esi
	pop edi
	pop ebx
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret
