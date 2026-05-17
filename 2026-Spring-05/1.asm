extern scanf
extern printf
extern io_print_udec

section .data
  std_in_arg: db "%u", 0
  std_out_arg: db "0x%08X", 10, 0

section .bss
  buf: resd 1

section .text
global main
main:
  push ebp
  mov ebp, esp
  push ebx
  push edi
  push esi
  and esp, ~15

  .w_eax:
  sub esp, 8

  push buf
  push std_in_arg
  xor eax, eax
  call scanf
  add esp, 8

  cmp eax, 1
  jne .re0
  sub esp, 8

  push dword [buf]
  push std_out_arg
  call printf
  add esp, 8
  jmp .w_eax

  .re0:
  pop esi
  pop edi
  pop ebx
  mov esp, ebp
  pop ebp
  xor eax, eax
  ret
