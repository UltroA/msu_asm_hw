extern io_print_dec
extern io_get_dec

section .bss
    a: resd 1
    b: resd 1
    c: resd 1
    d: resd 1
    e: resd 1
    f: resd 1
    tf: resd 1
    sf: resd 1

section .text
global main
main:
    call io_get_dec
    mov [a], eax
    call io_get_dec
    mov [b], eax
    call io_get_dec
    mov [c], eax
    call io_get_dec
    mov [d], eax
    call io_get_dec
    mov [e], eax
    call io_get_dec
    mov [f], eax
    mov eax, [a]
    add eax, [b]
    add eax, [c]
    mov ebx, eax
    mov eax, [d]
    add eax, [e]
    add eax, [f]
    imul ebx, eax
    mov [tf], ebx

    mov eax, [a]
    mov ebx, [d]
    imul eax, ebx
    mov [sf], eax

    mov eax, [b]
    mov ebx, [e]
    imul eax, ebx
    add [sf], eax


    mov eax, [c]
    mov ebx, [f]
    imul eax, ebx
    add [sf], eax

    mov eax, [tf]
    mov ebx, [sf]

    sub eax, ebx

    call io_print_dec
    xor eax, eax
    ret
