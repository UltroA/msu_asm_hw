extern io_get_dec
extern io_print_dec

section .bss
    n: resd 1
    k: resd 1
    c: resd 1024
    a: resd 32

section .data
    l: dd 0
    ex: dd 0
    cnt: dd 0

section .text
global main
main:
    call io_get_dec
    mov [n], eax
    mov [ex], dword 0

    call io_get_dec
    mov [k], eax

    cmp dword [k], 31
    jg no

fill_c:
    xor ebx, ebx
fill_outer:
    cmp ebx, 32
    jge fill_c_done
    xor ecx, ecx
fill_inner:
    cmp ecx, ebx
    jg fill_inner_done

    test ecx, ecx
    jz set_one
    cmp ecx, ebx
    je set_one

    mov eax, ebx
    dec eax
    imul eax, 32
    add eax, ecx
    mov edx, [c + eax*4]
    dec eax
    add edx, [c + eax*4]
    jmp store

set_one:
    mov edx, 1

store:
    mov eax, ebx
    imul eax, 32
    add eax, ecx
    mov [c + eax*4], edx

    inc ecx
    jmp fill_inner

fill_inner_done:
    inc ebx
    jmp fill_outer

fill_c_done:
    mov edx, [n]
    xor esi, esi
bits_loop:
    test edx, edx
    jz bits_done

    mov ecx, edx
    and ecx, 1
    mov [a + esi*4], ecx
    shr edx, 1

    inc esi
    jmp bits_loop
bits_done:
    mov [l], esi

    mov eax, [k]
    mov ecx, [l]
    dec ecx
    cmp eax, ecx
    jg no

    mov ebx, [k]
    inc ebx
ex_loop1:
    mov ecx, [l]
    cmp ebx, ecx
    jge ex_loop1_done

    mov eax, ebx
    dec eax
    imul eax, 32
    add eax, [k]
    mov edx, [c + eax*4]
    add [ex], edx

    inc ebx
    jmp ex_loop1
ex_loop1_done:

    mov dword [cnt], 0

    mov ebx, [l]
    sub ebx, 2
ex_loop2:
    cmp ebx, 0
    jl ex_loop2_done

    mov eax, [a + ebx*4]
    test eax, eax
    jz bit_is_zero

    mov ecx, [k]
    sub ecx, [cnt]
    dec ecx
    js skip_add

    mov eax, ebx
    imul eax, 32
    add eax, ecx
    mov edx, [c + eax*4]
    add [ex], edx
    jmp skip_add

bit_is_zero:
    inc dword [cnt]

skip_add:
    dec ebx
    jmp ex_loop2
ex_loop2_done:

    mov eax, [cnt]
    cmp eax, [k]
    jne print

    inc dword [ex]

print:
    mov eax, [ex]
    call io_print_dec
    xor eax, eax
    ret

no:
    xor eax, eax
    call io_print_dec
    xor eax, eax
    ret
