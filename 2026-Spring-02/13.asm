extern io_get_string
extern io_print_dec

section .bss
    buf: resb 32

section .text
global main

main:
    mov eax, buf
    mov edx, 32
    call io_get_string

    movzx eax, byte [buf+0]; eax = c1
    movzx edx, byte [buf+3]; edx = c2
    sub eax, edx; eax = c1 - c2
    mov edx, eax
    sar edx, 31; знак
    xor eax, edx
    sub eax, edx; eax = |c1-c2|
    mov esi, eax

    ; Аналогично верзнему, но толко для строк
    movzx eax, byte [buf+1]
    movzx edx, byte [buf+4]
    sub eax, edx
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx

    add eax, esi
    call io_print_dec

    xor eax, eax
    ret
