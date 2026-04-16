extern io_print_string
extern io_get_udec
extern io_newline

section .data
    yy: db "YES", 10, 0
    nn: db "NO", 10, 0

section .text
global main
main:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ebx

    call io_get_udec
    mov esi, eax

    .s_w_esi:
    cmp esi, 0
    je .e_w_esi

    call io_get_udec

    push eax
    call div3
    add esp, 4

    cmp eax, 1
    je .yes
    jmp .no

    .yes:
    mov eax, yy
    jmp .cont_m
    .no:
    mov eax, nn
    jmp .cont_m

    .cont_m:
    call io_print_string
    dec esi
    jmp .s_w_esi
    .e_w_esi:

    pop ebx
    pop esi
    pop edi
    mov esp, ebp
    pop ebp

    xor eax, eax
    ret

div3:
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi

    mov eax, [ebp + 8]

    cmp eax, 0
    je .re1
    cmp eax, 1
    je .re0
    cmp eax, 2
    je .re0
    cmp eax, 3
    je .re1

    xor edx, edx
    mov ebx, 1

    .s_w_eax:
    cmp eax, 0
    je .e_w_eax

    mov ecx, eax
    and ecx, 1
    je .skip
    add edx, ebx

    .skip:
    shr eax, 1
    neg ebx

    jmp .s_w_eax
    .e_w_eax:

    cmp edx, 0
    jge .pos

    neg edx

    .pos:
    cmp edx, 0
    je .re1
    cmp edx, 1
    je .re0
    cmp edx, 2
    je .re0
    cmp edx, 3
    je .re1

    mov eax, edx
    push eax
    call div3
    add esp, 4
    jmp .end

    .re1:
    mov eax, 1
    jmp .end

    .re0:; ЭТО ЧТО ОТСЫЛКА НА RE:ZERO?!!!!
    xor eax, eax

    .end:
    pop esi
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp

    ret
