extern printf
extern scanf
extern fscanf
extern fopen
extern fclose
extern fgets
extern fprintf
extern malloc
extern memset

section .data
    fmt_in_file: db "input.txt", 0
    fmt_out_file: db "output.txt", 0
    fmt_r: db "r", 0
    fmt_w: db "w", 0
    fmt_uint: db "%u", 0
    fmt_int_neg: db "-1", 10, 0
    fmt_uint_out: db "%u", 10, 0
    fmt_str: db "%100s", 0
    fmt_str_uint: db "%100s %u", 0

section .bss
    n: resd 1
    m: resd 1
    fp_in: resd 1
    fp_out: resd 1
    ht_ptr: resd 1
    name_buf: resb 104
    ip_buf: resd 1

section .text
global main
main:
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi
    and esp, ~15

    sub esp, 8
    push fmt_r
    push fmt_in_file
    call fopen
    add esp, 8
    mov [fp_in], eax

    sub esp, 8
    push fmt_w
    push fmt_out_file
    call fopen
    add esp, 8
    mov [fp_out], eax

    sub esp, 12
    push dword 29360128
    call malloc
    add esp, 4
    mov [ht_ptr], eax

    sub esp, 4
    push dword 29360128
    push 0
    push eax
    call memset
    add esp, 12

    sub esp, 4
    push n
    push fmt_uint
    push dword [fp_in]
    call fscanf
    add esp, 12

    mov dword [ip_buf], 0
    xor esi, esi

    .s_insert_l:
    cmp esi, [n]
    jge .e_insert_l

    push ip_buf
    push name_buf
    push fmt_str_uint
    push dword [fp_in]
    call fscanf
    add esp, 16

    sub esp, 8
    push dword [ip_buf]
    push name_buf
    call ht_insert
    add esp, 8

    inc esi
    jmp .s_insert_l
    .e_insert_l:

    sub esp, 4
    push m
    push fmt_uint
    push dword [fp_in]
    call fscanf
    add esp, 12

    xor esi, esi

    .s_query_l:
    cmp esi, [m]
    jge .e_query_l

    sub esp, 4
    push name_buf
    push fmt_str
    push dword [fp_in]
    call fscanf
    add esp, 12

    sub esp, 12
    push name_buf
    call ht_lookup
    add esp, 4

    cmp eax, 0xFFFFFFFF
    je .print_notfound

    sub esp, 4
    push eax
    push fmt_uint_out
    push dword [fp_out]
    call fprintf
    add esp, 12
    jmp .after_print

    .print_notfound:
    sub esp, 8
    push fmt_int_neg
    push dword [fp_out]
    call fprintf
    add esp, 8

    .after_print:
    inc esi
    jmp .s_query_l
    .e_query_l:

    sub esp, 12
    push dword [fp_in]
    call fclose
    add esp, 4

    sub esp, 12
    push dword [fp_out]
    call fclose
    add esp, 4

    pop esi
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret


hash_func:
    push ebp
    mov ebp, esp
    push esi
    push ebx

    mov esi, [ebp + 8]
    ; волшебное число хэша)
    mov eax, 5381
    xor ebx, ebx

    .s_hash_l:
    movzx ebx, byte [esi]
    test bl, bl
    jz .e_hash_l

    ; hash = hash  *  33
    lea eax, [eax  +  eax * 8]
    lea eax, [eax  +  eax * 2]
    ; djb2: hash = hash  *  33  +  c
    ; eax * 33 = eax * 32  +  eax = eax<<5  +  eax
    mov ecx, eax
    shl ecx, 5
    add eax, ecx
    xor eax, ebx

    inc esi
    jmp .s_hash_l
    .e_hash_l:

    and eax, 262143

    pop ebx
    pop esi
    pop ebp
    ret

; 0 если равны
strcmp_local:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

    .s_cmp_l:
    movzx eax, byte [esi]
    movzx ecx, byte [edi]
    cmp al, cl
    jne .ne_cmp
    test al, al
    jz .eq_cmp
    inc esi
    inc edi
    jmp .s_cmp_l

    .eq_cmp:
    xor eax, eax
    jmp .end_cmp
    .ne_cmp:
    mov eax, 1

    .end_cmp:
    pop edi
    pop esi
    pop ebp
    ret

strcpy_local:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov edi, [ebp + 8]
    mov esi, [ebp + 12]

    .s_cpy_l:
    movzx eax, byte [esi]
    mov [edi], al
    test al, al
    jz .e_cpy_l
    inc esi
    inc edi
    jmp .s_cpy_l
    .e_cpy_l:

    pop edi
    pop esi
    pop ebp
    ret

ht_insert:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    ; вычислить хэш
    sub esp, 12
    push dword [ebp + 8]
    call hash_func
    add esp, 4

    mov esi, eax

    .s_ins_probe:
    mov eax, esi
    imul eax, 112
    mov ebx, [ht_ptr]
    add ebx, eax

    mov eax, [ebx + 108]
    test eax, eax
    jz .ins_here

    push dword [ebp + 8]
    mov eax, ebx
    sub esp, 8
    push eax
    call strcmp_local
    add esp, 8
    test eax, eax
    jz .ins_here

    inc esi
    and esi, 262143
    jmp .s_ins_probe

    .ins_here:
    ; скопировать ключ в ячейку
    sub esp, 8
    push dword [ebp + 8]
    mov eax, ebx
    push eax
    call strcpy_local
    add esp, 8

    ; записать IP
    mov eax, [ebp + 12]
    mov [ebx + 104], eax
    ; пометить ячейку занятой
    mov dword [ebx + 108], 1

    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; IP или 0xFFFFFFFF если не найдено
ht_lookup:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    sub esp, 12
    push dword [ebp + 8]
    call hash_func
    add esp, 4
    mov esi, eax

    .s_lkp_probe:
    mov eax, esi
    imul eax, 112
    mov ebx, [ht_ptr]
    add ebx, eax

    mov eax, [ebx + 108]
    test eax, eax
    jz .lkp_not_found

    sub esp, 8
    push dword [ebp + 8]
    mov eax, ebx
    push eax
    call strcmp_local
    add esp, 8
    test eax, eax
    jz .lkp_found

    inc esi
    and esi, 262143
    jmp .s_lkp_probe

    .lkp_found:
    mov eax, [ebx + 104]
    jmp .lkp_end

    .lkp_not_found:
    mov eax, 0xFFFFFFFF

    .lkp_end:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret
