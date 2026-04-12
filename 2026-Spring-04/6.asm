extern io_get_udec
extern io_print_udec

section .bss
    a: resd 1000

section .text
global main
main:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    ; тут мог бы быть callee, но он его тут нет)

    call io_get_udec
    mov ebx, eax
    xor esi, esi
    s_r_a:
    cmp esi, ebx
    je e_r_a

    call io_get_udec
    mov [a + esi * 4], eax

    inc esi
    jmp s_r_a
    e_r_a:

    call io_get_udec
    mov edi, eax

    xor esi, esi
    xor edx, edx
    .s_w_n:
    cmp esi, ebx
    je .e_w_n

    mov eax, [a + esi * 4]

    push edx
    push eax
    call count_zeros
    add esp, 4
    pop edx
    cmp eax, edi
    jne .skip
    inc edx

    .skip:
    inc esi
    jmp .s_w_n
    .e_w_n:

    mov eax, edx
    call io_print_udec

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

count_zeros:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    ; я сразу все пушу, чтобы наверняка не ошибиться

    mov eax, [ebp + 8]
    cmp eax, 0
    je .fin

    xor ebx, ebx
    xor esi, esi
    mov ecx, eax
    .s_w_esi:
    cmp ecx, 0
    jle .e_w_esi

    inc esi
    shr ecx, 1

    jmp .s_w_esi
    .e_w_esi:

    xor edi, edi
    mov ecx, eax
    .s_w_edi:
    cmp ecx, 0
    jle .e_w_edi

    ;edi += ebx & 1
    mov ebx, ecx
    and ebx, 1
    add edi, ebx
    shr ecx, 1

    jmp .s_w_edi
    .e_w_edi:


    mov eax, esi
    sub eax, edi

    .fin:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret
