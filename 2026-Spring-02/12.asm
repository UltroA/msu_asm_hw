extern io_get_udec
extern io_print_char

section .data
    col: db 'SCDH'
    num: db '23456789TJQKA'

section .text
global main
main:
    call io_get_udec
    dec eax

    ; edx = (eax - 1) % 13
    ; ebx = (eax - 1) / 13
    xor edx, edx
    mov ecx, 13
    div ecx
    mov ebx, eax

    movzx eax, byte [num + edx]
    call io_print_char

    movzx eax, byte [col + ebx]
    call io_print_char

    xor eax, eax
    ret
