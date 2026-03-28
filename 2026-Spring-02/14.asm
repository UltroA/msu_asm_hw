extern io_get_udec
extern io_print_udec

section .text
global main
main:
    call io_get_udec
    mov ebx, eax

    call io_get_udec
    imul ebx, eax

    call io_get_udec
    imul ebx, eax

    call io_get_udec
    mov esi, eax

    call io_get_udec
    mov edi, eax

    call io_get_udec
    mov ebp, eax

    ; ebx = ceil(N*M*K / D) = (N*M*K + D - 1) / D
    mov eax, ebx
    add eax, esi
    dec eax
    xor edx, edx
    div esi
    mov ebx, eax

    ; edi = X*60 + Y
    imul edi, 60
    add edi, ebp

    ; dm
    mov eax, 359
    sub eax, edi
    sar eax, 31
    mov esi, eax

    ; eax = ceil(boxes / 3) = (boxes + 2) / 3
    mov eax, ebx
    add eax, 2
    xor edx, edx
    mov ecx, 3
    div ecx

    ; eax = eax & dm
    and eax, esi

    ; eax = ebx - eax
    sub ebx, eax
    mov eax, ebx

    call io_print_udec

    xor eax, eax
    ret
