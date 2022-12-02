global main
extern printf 
extern scanf
extern clear_stdin

section .data
	EOF equ -1
	NEW_LINE equ 0xA
	prompt db "I picked a number, guess it!", NEW_LINE, "Ohh, and you have %i attempts btw", NEW_LINE, 0x00
	scanf_pattern db "%i", 0x00
	win_text db "You win!", NEW_LINE, 0x00
	less_text db "It's less than that!", NEW_LINE, 0x00
	higher_text db "It's higher than that!", NEW_LINE, 0x00
	lose_text db "You lose!",NEW_LINE, 0x00
	scanf_err_text db "Your guess is not a valid number, try again", NEW_LINE, 0x00
	attempts_count db 0x7
section .bss
	random_num resb 1
	guess_num resb 1
section .text
main:
	push ebp
	mov ebp, esp
	rdtsc ; function for random number (will be available in eax)
	mov ecx, 100
	mov edx, 0
	div ecx ; eax % ecx, result eax - quotient, edx - remainder. Purpose - random number range [0,100]
	mov [random_num], edx
	push dword [attempts_count]
	push prompt
	call printf
	add esp, 8
guess_input:
	mov al, [attempts_count]
	sub al, 1
	mov [attempts_count], al
	push guess_num
	push scanf_pattern
	call scanf ; read user guess
	add esp, 8
	xor ecx, ecx
	call clear_stdin ; scanf should have cleared stdin, but if input is invalid it's not doing it
	cmp eax, 0
	jne guess_format_error ; if something was cleared than input of the scanf was invalid
	mov al, [random_num]
	mov bl, [guess_num]
	cmp al, bl
	je equal
	pushf ; push eflags to the stack, preserve state to jump for less or higher later
	xor ecx, ecx
	mov ecx, [attempts_count]
	cmp ecx, 0
	je lose ; lose if there is 0 attempts left
	popf
	jl less
	jg higher
prolog:
	mov eax, 0 ; exit status
	mov esp, ebp
	pop ebp
	ret
equal:
	push win_text
	call printf
	add esp, 4
	jmp prolog
less:
	push less_text
	call printf
	add esp, 4
	jmp guess_input
higher:
	push higher_text
	call printf
	add esp, 4
	jmp guess_input
lose:
	push lose_text
	call printf
	add esp, 4
	jmp prolog
guess_format_error:
	push scanf_err_text
	call printf
	add esp, 4
	jmp guess_input
