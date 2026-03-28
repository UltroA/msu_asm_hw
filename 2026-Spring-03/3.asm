extern io_print_udec
extern io_get_udec
extern io_print_char

section .bss
    n: resd 1
    a: resd 500000
    sup: resd 500000
    inf: resd 500000

section .data
    sup_s: dd 0
    inf_s: dd 0

section .text
global main
main:
    call io_get_udec
    mov [n], eax
    xor ebx, ebx

    for_s:; ebx, eax - заняты
        cmp ebx, [n]
        jge for_e
        call io_get_udec
        mov [a + ebx * 4], eax
        inc ebx
        jmp for_s
    for_e:

    xor ebx, ebx
    inc ebx
    mov eax, [n]
    dec eax
    mov ecx, eax

    fill_inf_sup:; заняты 1<=ebx<=n-1, eax = a[ebx], esi = a[ebx-1], edi = a[ebx + 1]
        cmp ebx, ecx
        jge fill_inf_sup_e
        mov esi, [a + ebx*4 - 4]   ; esi = a[i-1]
        mov eax, [a + ebx*4]       ; eax = a[i]
        mov edi, [a + ebx*4 + 4]   ; edi = a[i+1]
        cmp esi, eax
        jge else_if
        cmp eax, edi
        jle else_if
        ; if (esi < eax && eax > edi)
            mov edx, [sup_s]
            mov [sup + edx*4], ebx
            inc dword [sup_s]
            jmp end_if
        else_if:
        cmp esi, eax
        jle end_if
        cmp eax, edi
        jge end_if
        ; else if (esi > eax && eax < edi)
            mov edx, [inf_s]
            mov [inf + edx*4], ebx
            inc dword [inf_s]
        end_if:
            inc ebx
            jmp fill_inf_sup
    fill_inf_sup_e:

    mov eax, [inf_s]
    call io_print_udec
    mov eax, 10
    call io_print_char
    mov ecx, 0
    cmp ecx, [inf_s]
    je done_inf

    output_inf_loop:
        cmp ecx, [inf_s]
        jge done_inf
        push ecx
        mov eax, [inf + ecx*4]
        call io_print_udec
        mov eax, ' '
        call io_print_char
        pop ecx
        inc ecx
        jmp output_inf_loop
    done_inf:

    mov eax, [inf_s]
    cmp eax, 0
    je skip_inf_newline
    mov eax, 10
    call io_print_char

    skip_inf_newline:
    mov eax, [sup_s]
    call io_print_udec
    mov eax, 10
    call io_print_char
    mov ecx, 0
    cmp ecx, [sup_s]
    je done_sup
    output_sup_loop:
        cmp ecx, [sup_s]
        jge done_sup
        push ecx
        mov eax, [sup + ecx*4]
        call io_print_udec
        mov eax, ' '
        call io_print_char
        pop ecx
        inc ecx
        jmp output_sup_loop
    done_sup:

    mov eax, [sup_s]
    cmp eax, 0
    je skip_sup_newline
    mov eax, 10
    call io_print_char
    skip_sup_newline:

    xor eax, eax
    ret
