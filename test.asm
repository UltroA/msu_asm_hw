%include 'io.inc'
section .text
global main
main:
    mov ebp, esp; for correct debugging
   read:
    GET_CHAR al
    cmp al, '.'
    je finish

    cmp al, 'A'
    jb print
    cmp al, 'Z'
    ja print

    mov bl, 'Z'
    sub bl, al
    add bl, 'A'
    mov al, bl

   print:
    PRINT_CHAR al
    jmp read

   finish:
    NEWLINE

   xor eax, eax
   ret
