extern io_print_dec
extern io_get_dec
extern io_get_udec

section .bss
    k: resd 1
    n: resd 1

section .text
global main
main:
    call io_get_udec
    mov [n], eax
    call io_get_dec
    mov [k], eax

    ; eax = (1 << K) - 1
    mov eax, 1
    mov ecx, [k]
    shl eax, cl
    sub eax, 1

    mov ebx, [n]
    and ebx, eax

    mov eax, ebx
    call io_print_dec
    xor eax, eax
    ret
