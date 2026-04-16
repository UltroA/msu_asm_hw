extern io_get_udec
extern io_print_udec
extern io_print_string


section .bss
    a: resd 1
    b: resd 1
    c: resd 1
    sf_hi: resd 1
    sf_mi: resd 1
    sf_lo: resd 1
    res: resd 3

section .text
global main
main:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    call io_get_udec
    mov [a], eax
    call io_get_udec
    mov [b], eax
    call io_get_udec
    mov [c], eax

    mov eax, [a]
    mul dword [b]
    mov [sf_lo], eax
    mov [sf_hi], edx

    ; умножение младшей части (eax) на c
    mov eax, [sf_lo]
    mul dword [c]
    mov [res], eax
    mov [sf_mi], edx

    ; умножение старшей части (edx) на c
    mov eax, [sf_hi]
    mul dword [c]

    ; учет переносов
    add eax, [sf_mi]
    mov [res + 4], eax
    adc edx, 0
    mov [res + 8], edx

    mov esi, 0
.s_p:
    ; пока число не 0 мы делим его на 10 и
    ; получаем в остаток т.е. цифру в числе
    push res
    call cmpZer
    add esp, 4
    cmp eax, 1
    je .p_d

    push res
    call div10
    add esp, 4

    push eax
    inc esi
    jmp .s_p

.p_d:
    cmp esi, 0
    jne .p_s
    mov eax, 0
    call io_print_udec
    jmp .end

.p_s:
    pop eax
    call io_print_udec
    dec esi
    jnz .p_s

.end:
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

div10:
    ; тут очев
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    mov esi, [ebp + 8]
    mov ebx, 10

    mov eax, [esi + 8]
    xor edx, edx
    div ebx
    mov [esi + 8], eax

    mov eax, [esi + 4]
    div ebx
    mov [esi + 4], eax

    mov eax, [esi]
    div ebx
    mov [esi], eax

    mov eax, edx

    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

cmpZer:
    ; очев
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx

    mov esi, [ebp + 8]

    mov eax, [esi]
    or eax, [esi + 4]
    or eax, [esi + 8]

    cmp eax, 0
    jne .n_z

    mov eax, 1
    jmp .retZ

.n_z:
    xor eax, eax

.retZ:
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
