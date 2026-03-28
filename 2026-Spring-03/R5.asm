extern io_get_dec, io_get_udec, io_print_dec, io_newline

section .data

section .text
global main
main:
    call io_get_udec
    mov esi, eax
	mov edi, 0
	shr esi, 1
	jc end

	l1:
        call io_get_dec
        mov ebx, eax
        call io_get_dec
	imul ebx, eax
	add edi, ebx
	dec esi
	jnz l1

	end:
        mov eax, edi
	call io_print_dec
	call io_newline
	xor eax, eax
	ret
