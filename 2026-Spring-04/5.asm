extern io_get_udec
extern io_print_string
extern io_print_udec

section .bss
    m: resd 1

section .data
    yy: db "Yes", 10, 0
    nn: db "No", 0

section .text
global main
main:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    call io_get_udec
    mov [m], eax
    call io_get_udec
    mov ebx, eax

    mov eax, [m]
    s_wh_n:
    cmp ebx, 0
    je e_wh_n

    mov edi, eax
    xor edx, edx
    push eax
    call rotate
    add esp, 4
    add eax, edi

    dec ebx
    jmp s_wh_n
    e_wh_n:

    mov ebx, eax
    xor edx, edx
    push eax
    call rotate
    add esp, 4

    cmp eax, ebx
    jne no

    mov esi, eax
    mov eax, yy
    call io_print_string
    mov eax, esi
    call io_print_udec

    xor eax, eax
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

no:
    mov eax, nn
    call io_print_string

    xor eax, eax
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

rotate:
    push ebp
    mov ebp, esp
    push ebx
    push edi

    mov eax, [ebp + 8]
    xor ecx, ecx
    mov edi, 10
    .w_m:
    xor edx, edx
    div edi

    imul ecx, ecx, 10
    add ecx, edx
    cmp eax, 0
    jne .w_m

    mov eax, ecx

    pop edi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
