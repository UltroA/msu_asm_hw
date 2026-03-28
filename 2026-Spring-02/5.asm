extern io_print_udec
extern io_get_dec
extern io_get_udec

section .text
global main
main:
    call io_get_udec
    mov ebx, eax
    call io_get_dec
    mov ecx, eax

    ror ebx, cl

    mov eax, ebx

    call io_print_udec
    xor eax, eax
    ret
