section .bss
	buffer resb 256
section .text
	global fprintf, fscanf
;outputs a string to a specified file
;arguments:
;address of a null terminated string to print at ebp+8
;path to a file at ebp+12
fprintf:
	push ebp
	mov ebp, esp
	pusha
	mov esi, [ebp+8]

	;count number of bytes in string
	mov ecx, 0
FPF_counting_loop:
	lodsb
	test al, al
	jz FPF_counting_loop_exit
	inc ecx
	jmp FPF_counting_loop

FPF_counting_loop_exit:
	push ecx

	;create file descriptor with sys_open
	mov eax, 8 ;syscreat preparation
	mov ebx, [ebp+12]
	mov ecx, 00644Q
	int 80h
	

	;write to file
	mov ebx, eax
	mov eax, 4
	mov ecx, [ebp+8]
	pop edx
	int 80h

	;close file
	mov eax, 6
	int 80h

	popa
	mov ebp,[ebp]
	add esp,4
	ret
;Reads a string from input file
;arguments:
;path to file to read from at ebp+8
;return value:
;address to a null terminated string of characters
fscanf:
	push ebp
	mov ebp, esp
	sub esp, 8; room for file descriptor, size of file and return value
	pusha

	;sys_open eax= file descriptor
	mov eax, 5
	mov ebx, [ebp+8]
	mov ecx, 0
	int 80h

	mov [ebp-4], eax; save file descriptor on stack

	;sys_lseek eax= size of the file in bytes
	mov ebx, eax
	mov eax, 19
	mov ecx, 0
	mov edx, 2
	int 80h
	
	mov [ebp-8], eax; save the size of file

	;sys_lseek to zero the offset	
	mov ebx, [ebp-4]
	mov eax, 19
	mov ecx, 0
	mov edx, 0
	int 80h
	
	;sys_read into buffer
	mov eax, 3
	mov ebx, [ebp-4]
	mov ecx, buffer
	mov edx, [ebp-8]
	int 80h

	;sys_close
	mov eax, 6
	int 80h

	; create a null terminated string
	mov ecx, [ebp-8]
	mov byte [buffer+ecx], 0

	mov dword [ebp-4], buffer	
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp, 12
	ret
