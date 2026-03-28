extern io_print_dec
extern io_print_char

section .text
global main
main:
mov eax, 1
call io_print_dec
mov eax, 10
call io_print_char
mov eax, 1
call io_print_dec
xor eax, eax
ret
