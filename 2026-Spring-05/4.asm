extern printf
extern fopen, fscanf, fclose

section .data
  std_file_name: db "data.in", 0
  std_file_mode: db "r", 0
  std_print_mode: db "%u", 0

section .bss
  buf: resd 1
  std_file_ptr: resd 1

section .text
global main
main:
  push ebp
  mov ebp, esp
  push ebx
  push edi
  push esi
  and esp, ~15
  
  push std_file_mode 
  push std_file_name
  call fopen
  add esp, 8
  mov [std_file_ptr], eax
  
  xor esi, esi
  .w_n_eof:
  push buf 
  push std_print_mode
  push dword [std_file_ptr]
  call fscanf
  add esp, 12


  cmp eax, 1
  jne .re0
  inc esi
  jmp .w_n_eof
  
  .re0:
  push esi
  push std_print_mode
  call printf
  add esp, 8


  pop esi
  pop edi
  pop ebx
  mov esp, ebp
  pop ebp
  xor eax, eax
  ret
