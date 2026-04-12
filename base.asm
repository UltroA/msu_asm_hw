extern io_get_udec
extern io_print_udec


section .text
global main:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    

    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret
