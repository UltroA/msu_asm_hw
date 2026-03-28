extern io_get_udec
extern io_print_udec
extern io_print_char

section .bss
    a11: resd 1
    a12: resd 1
    a21: resd 1
    a22: resd 1
    b1:  resd 1
    b2:  resd 1
    d:   resd 1
    x1:  resd 1
    y1:  resd 1
    x:   resd 1
    y:   resd 1

section .text
global main
main:
    call io_get_udec
    mov [a11], eax

    call io_get_udec
    mov [a12], eax

    call io_get_udec
    mov [a21], eax

    call io_get_udec
    mov [a22], eax

    call io_get_udec
    mov [b1], eax

    call io_get_udec
    mov [b2], eax


    ; (a11 & a22)
    mov edx, [a11]
    mov ebx, [a22]
    and edx, ebx
    mov [d], edx

    ; (a12 & a21)
    mov edx, [a12]
    mov ebx, [a21]
    and edx, ebx
    mov ebx, [d]
    xor ebx, edx
    mov [d], ebx; d = (a11 & a22) ^ (a12 & a21)


    ; (b1 & a22)
    mov edx, [b1]
    mov ebx, [a22]
    and edx, ebx
    mov [x1], edx

    ; (b2 & a12)
    mov edx, [b2]
    mov ebx, [a12]
    and edx, ebx
    mov ebx, [x1]
    xor ebx, edx
    mov [x1], ebx; x1 = (b1 & a22) ^ (b2 & a12)


    ; (a11 & b2)
    mov edx, [a11]
    mov ebx, [b2]
    and edx, ebx
    mov [y1], edx

    ; (a21 & b1)
    mov edx, [a21]
    mov ebx, [b1]
    and edx, ebx
    mov ebx, [y1]
    xor ebx, edx
    mov [y1], ebx; y1 = (a11 & b2) ^ (a21 & b1)

    ; (x1 & d)
    mov eax, [x1]
    mov ebx, [d]
    and eax, ebx

    ; (b1 & ~d)
    mov edx, [d]
    not edx
    mov ecx, [b1]
    and ecx, edx
    or eax, ecx
    mov [x], eax; x = (x1 & d) | (b1 & ~d)


    mov eax, [y1]
    mov ebx, [d]
    and eax, ebx
    mov [y], eax; y = y1 & d

    ; prints
    mov eax, [x]
    call io_print_udec

    mov eax, ' '
    call io_print_char

    mov eax, [y]
    call io_print_udec

    xor eax, eax
    ret
