extern io_get_dec
extern io_print_dec

section .bss
    x1: resd 1
    y1: resd 1
    x2: resd 1
    y2: resd 1
    x3: resd 1
    y3: resd 1
    gcdS: resd 1 ; тут могло быть красивое выравнивание, но делать его в насме себе дороже

section .text
global main
main:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ebx
    ; тут просто убийственно считается это:
    ; (|x1(y2−y3) + x2(y3−y1) + x3(y1−y2)| - gcd(|x2−x1|, |y2−y1|) + gcd(|x3−x2|, |y3−y2|) + gcd(|x1−x3|, |y1−y3|) + 2) / 2
    ; Смешная формула

    ; быстрее было написать так(по сути я уменьшаю количество мест, где может быть ошибка)
    call io_get_dec
    mov [x1], eax
    call io_get_dec
    mov [y1], eax

    call io_get_dec
    mov [x2], eax
    call io_get_dec
    mov [y2], eax

    call io_get_dec
    mov [x3], eax
    call io_get_dec
    mov [y3], eax

    xor ebx, ebx

    ; gcd(|x2−x1|, |y2−y1|)
    mov eax, [y1]
    mov edx, [y2]
    sub edx, eax
    mov eax, edx

    push eax
    call mod
    add esp, 4
    mov edx, eax

    push edx
    mov edx, [x1]
    mov eax, [x2]
    sub eax, edx

    push eax
    call mod
    add esp, 4

    push eax
    call gcd
    add esp, 8
    add ebx, eax
    ; Это уже не смешно
    mov eax, [y2]
    mov edx, [y3]
    sub edx, eax
    mov eax, edx

    push eax
    call mod
    add esp, 4
    mov edx, eax

    push edx
    mov edx, [x2]
    mov eax, [x3]
    sub eax, edx

    push eax
    call mod
    add esp, 4

    push eax
    call gcd
    add esp, 8
    add ebx, eax
    ; Я должен же визуально определять сегменты кода
    mov eax, [y3]
    mov edx, [y1]
    sub edx, eax
    mov eax, edx

    push eax
    call mod
    add esp, 4
    mov edx, eax

    push edx
    mov edx, [x3]
    mov eax, [x1]
    sub eax, edx

    push eax
    call mod
    add esp, 4

    push eax
    call gcd
    add esp, 8
    add ebx, eax

    mov [gcdS], ebx
    xor ebx, ebx

    mov eax, [y2]
    sub eax, [y3]
    imul eax, [x1]
    add ebx, eax

    mov eax, [y3]
    sub eax, [y1]
    imul eax, [x2]
    add ebx, eax

    mov eax, [y1]
    sub eax, [y2]
    imul eax, [x3]
    add ebx, eax

    mov eax, ebx
    push eax
    call mod
    add esp, 4
    mov ebx, eax

    mov eax, [gcdS]
    sub ebx, eax
    add ebx, 2
    sar ebx, 1
    mov eax, ebx

    call io_print_dec

    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret

gcd:
    push ebp
    mov ebp, esp
    push ebx
    push edi
    push esi

    mov eax, [ebp + 8]
    mov edx, [ebp + 12]

    mov ebx, edx

    .s_w_ebx_nz:
    test ebx, ebx
    jz .e_w_ebx_nz

    xor edx, edx
    div ebx

    mov eax, ebx
    mov ebx, edx

    jmp .s_w_ebx_nz
    .e_w_ebx_nz:

    pop esi
    pop edi
    pop ebx
    mov esp, ebp
    pop ebp

    ret

; была крайняя степень лени как-либо оптимизировать эту задачу, поэтому замедляю еще одной функцией
mod:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]

    test eax, eax
    jns .reM

    neg eax

    .reM:
    mov esp, ebp
    pop ebp
    ret
