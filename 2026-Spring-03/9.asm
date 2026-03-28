extern io_get_dec
extern io_print_string
extern io_print_dec

section .bss
    minX: resd 1
    maxX: resd 1
    minY: resd 1
    maxY: resd 1

section .data
    yy: db "YES", 0
    nn: db "NO", 0

section .text
global main
main:
    call io_get_dec
    mov [minX], eax
    mov [maxX], eax

    call io_get_dec
    mov [minY], eax
    mov [maxY], eax

    xor edi, edi
    read:
        cmp edi, 3
        jge read_end

        call io_get_dec
        cmp [minX], eax
        jl minXW
        cmp [maxX], eax
        jg maxXW

        con1:

        call io_get_dec
        cmp [minY], eax
        jl minYW
        cmp [maxY], eax
        jg maxYW

        con2:

        inc edi
        jmp read
    read_end:

    call io_get_dec
    push eax
    call io_get_dec
    mov ebx, eax
    pop eax

    cmp [minX], eax
    jle no
    cmp [maxX], eax
    jge no

    cmp [minY], ebx
    jle no
    cmp [maxY], ebx
    jge no


    mov eax, yy
    call io_print_string
    xor eax, eax
    ret

    minXW:
        mov [minX], eax
        jmp con1
    maxXW:
        mov [maxX], eax
        jmp con1

    minYW:
        mov [minY], eax
        jmp con2
    maxYW:
        mov [maxY], eax
        jmp con2

    no:
        mov eax, nn
        call io_print_string
        xor eax, eax
        ret
