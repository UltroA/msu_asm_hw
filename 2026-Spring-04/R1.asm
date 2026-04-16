extern io_get_udec, io_print_udec, io_newline

section .text

global main
main:
    call  io_get_udec
    call  f
    call  io_print_udec
    call  io_newline
    xor   eax, eax
    ret

f:
    cmp   eax, 0
    jnz   rec
    mov   eax, 1
    ret
rec:
    dec   eax
    call  f
    lea   eax, [eax + 2 * eax]
    ret
