extern io_get_udec, io_print_dec, io_newline

section .text
global main
main:
    sub     esp, 4
    call    io_get_udec
    mov     dword [esp], eax
    call    f
    add     esp, 4
    call    io_print_dec
    call    io_newline
    xor     eax, eax
    ret

f:
    mov     eax, 32
    cmp     dword [esp], .r
    cmovnz  ecx, eax
    cmovz   ecx, dword [esp + 8]
    mov     eax, dword [esp + 4]
    and     ecx, ecx
    jnz     .l
    xor     eax, eax
    ret
.l:
    push    ebx
    mov     ebx, eax
    and     ebx, 1
    shr     eax, 1
    dec     ecx
    push    ecx
    push    eax
    call    f
.r:
    add     esp, 8
    inc     eax
    sub     eax, ebx
    pop     ebx
    ret
