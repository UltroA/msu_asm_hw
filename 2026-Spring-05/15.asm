section .data
    input_fmt db "%s %d %d", 0
    output_fmt db "|%-*s|%5d|%2d|\n", 11, 0

section .bss
    MAX_TEAMS equ 40000
    NAME_LEN  equ 64

    team_names resb MAX_TEAMS * NAME_LEN
    penalty_times resd MAX_TEAMS
    solved_counts resd MAX_TEAMS
    indices resd MAX_TEAMS
    team_count dd 0
    max_name_len dd 1
    temp_buffer resb 512

section .text
    extern scanf
    extern printf
    extern qsort
    extern strcmp
    global main

compare_func:
    push ebp
    mov ebp, esp

    ; a and b are pointers to elements in the indices array (int*)
    mov eax, [ebp+8]      ; pointer to idx1 (const void *a)
    mov eax, [eax]        ; eax = idxA
    mov edx, [ebp+12]     ; pointer to idx2 (const void *b)
    mov edx, [edx]        ; edx = idxB

    ; 1. Compare solved counts (descending order)
    mov ecx, [solved_counts + eax*4]
    mov ebx, [solved_counts + edx*4]
    cmp ecx, ebx
    jne .not_equal_solved

    ; 2. If equal, compare penalty times (ascending order)
    mov ecx, [penalty_times + eax*4]
    mov ebx, [penalty_times + edx*4]
    cmp ecx, ebx
    jne .not_equal_penalty

    ; 3. If both equal, compare names (lexicographical order)
    mov esi, eax
    imul esi, NAME_LEN
    lea esi, [team_names + esi]
    mov edi, edx
    imul edi, NAME_LEN
    lea edi, [team_names + edi]

    push esi
    push edi
    call strcmp
    add esp, 8
    jmp .done

.not_equal_solved:
    cmp ecx, ebx
    jg .descending_a_first ; solved[a] > solved[b] => a comes first (return -1)
    mov eax, 1             ; solved[a] < solved[b] => a comes last (return 1)
    jmp .done

.descending_a_first:
    mov eax, -1
    jmp .done

.not_equal_penalty:
    cmp ecx, ebx
    jl .ascending_a_first  ; penalty[a] < penalty[b] => a comes first (return -1)
    mov eax, 1             ; penalty[a] > penalty[b] => a comes last (return 1)
    jmp .done

.ascending_a_first:
    mov eax, -1
    jmp .done

.done:
    pop ebp
    ret

main:
    push ebp
    mov ebp, esp

    xor ebx, ebx ; team_count counter

.read_loop:
    lea eax, [temp_buffer]
    push eax
    lea eax, [penalty_times + ebx*4]
    push eax
    lea eax, [solved_counts + ebx*4]
    push eax
    push dword input_fmt
    call scanf
    add esp, 16

    cmp eax, 3
    jne .sort_and_print

    ; Copy temp_buffer to team_names[ebx * NAME_LEN]
    mov edi, ebx
    imul edi, NAME_LEN
    lea edi, [team_names + edi]
    lea esi, [temp_buffer]

.copy_name:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jne .copy_name

    ; Update max_name_len
    lea esi, [temp_buffer]
    xor ecx, ecx
.count_len:
    cmp byte [esi + ecx], 0
    je .found_len
    inc ecx
    jmp .count_len
.found_len:
    cmp ecx, [max_name_len]
    jg .update_max
    jmp .next_team

.update_max:
    mov [max_name_len], ecx

.next_team:
    ; Set indices[ebx] = ebx
    mov eax, ebx
    mov [indices + ebx*4], eax

    inc ebx
    cmp ebx, MAX_TEAMS
    jl .read_loop

.sort_and_print:
    mov [team_count], ebx

    test ebx, ebx
    jz .done

    ; qsort(indices, team_count, 4, compare_func)
    push dword compare_func
    push dword 4
    push ebx
    push dword indices
    call qsort
    add esp, 16

    xor ecx, ecx
.print_loop:
    mov esi, [indices + ecx*4] ; current team index

    ; Prepare arguments for printf("|%-*s|%5d|%2d|\n", max_name_len, name, penalty, solved)
    ; 1. width (int)
    mov eax, [max_name_len]
    push eax

    ; 2. Name string pointer
    mov edi, esi
    imul edi, NAME_LEN
    lea eax, [team_names + edi]
    push eax

    ; 3. Penalty (int)
    mov eax, [penalty_times + esi*4]
    push eax

    ; 4. Solved count (int)
    mov eax, [solved_counts + esi*4]
    push eax

    ; 5. Format string pointer
    push dword output_fmt
    call printf
    add esp, 20

    inc ecx
    cmp ecx, [team_count]
    jl .print_loop

.done:
    pop ebp
    xor eax, eax
    ret
