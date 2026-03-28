extern io_get_udec
extern io_print_udec

section .bss
    m: resd 1
    d: resd 1

section .data
    exit: dd 0

; exit = (m - 1) * 41 + (m - 1) / 2 + d
section .text
global main
main:
    call io_get_udec
    mov [m], eax
    call io_get_udec
    mov [d], eax

    mov eax, 1
    mov ebx, [m]
    sub ebx, eax
    mov [m], ebx

    ; exit = (m - 1) * 41
    mov eax, [m]
    mov ebx, 41
    imul ebx
    add [exit], eax

    ; exit += (m - 1) / 2
    mov eax, [m]
    mov ebx, 2
    div ebx ; это ужасно
    add [exit], eax

    ; eax = exit + d
    mov ebx, [d]
    mov eax, [exit]
    add eax, ebx

    call io_print_udec
    xor eax, eax
    ret
