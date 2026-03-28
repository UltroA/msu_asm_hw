extern io_get_dec, io_print_dec, io_newline

section .bss

    n               resd 1
    k               resd 1

    a               resd 21
    b               resd 21

section .text

global main
main:
    call    io_get_dec
    mov     dword[n], eax

    call    io_get_dec
    mov     dword[k], eax

    mov     esi, a
    mov     edi, b

    mov     dword [esi], 1
    xor     ecx, ecx

.1:
    cmp     ecx, dword [n]
    jz      .4

    inc     ecx

    mov     dword [edi], 1
    xor     edx, edx

.2:
    cmp     edx, ecx
    jz      .3

    inc     edx

    mov     eax, dword [esi + 4 * edx]
    add     eax, dword [esi + 4 * edx - 4]

    mov     dword [edi + 4 * edx], eax

    jmp     .2

.3:
    mov     dword [edi + 4 * edx], 1

    mov     eax, esi
    mov     esi, edi
    mov     edi, eax

    jmp     .1

.4:
    mov     edi, dword [k]
    mov     eax, dword [esi + 4 * edi]

    call    io_print_dec
    call    io_newline

    xor     eax, eax
    ret
