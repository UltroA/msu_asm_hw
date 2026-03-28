extern io_get_udec
extern io_print_udec

section .text
global main
main:
    call io_get_udec
    mov ecx, 0

start_while:
    test eax, eax; while(eax != 0)
    jz end_while

    mov edx, eax
    dec edx
    and eax, edx; eax & (eax - 1)
    inc ecx

    jmp start_while

end_while:
    mov eax, ecx
    call io_print_udec

    xor eax, eax
    ret
