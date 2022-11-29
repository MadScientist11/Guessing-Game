extern getchar
global clear_stdin

section .text
clear_stdin:
	call getchar
	cmp eax, 0xA
	je return
	cmp eax, -1
	je return
	inc ecx
	jmp clear_stdin
return:
	mov eax, ecx
	ret
