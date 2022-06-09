;a program written in 32 bit assembly performing a nonrandomized quicksort on input file
%include "../inc/qsio.inc"
%include "../inc/qsort.inc"
section .data
	dir db "/home/mateusz/Documents/qsort/output.qs",0
section .bss
	int_table resd 1
section .text
	global _start,
_start:

	pop eax
	pop eax
	pop ebx; pops input direcotory from stack

	push ebx
	call qscanf; eax= integer table
	add esp, 4
	
	mov [int_table], eax

	push eax
	call IntTableCounter; eax= offset of the end of table
	add esp, 4

	push eax
	push dword 0
	push dword [int_table]
	call quicksort; eax= address of a sorted array
	add esp, 12

	push dir
	push eax
	call qprintf
	add esp, 8

	
	;exit
	mov eax, 1
	mov ebx, 0
	int 80h
;function for counting number of elements in integer table
;arguments:
;address of an integer table at ebp+8
;return value:
;offset of the last element at eax
IntTableCounter:
	push ebp
	mov ebp, esp
	sub esp, 4
	pusha

	mov esi, [ebp+8]
	mov ecx, 0; counter
counting_loop:
	
	lodsd; eax=integer to compare
	cmp eax, -1
	je counting_loop_exit
	inc ecx
	jmp counting_loop
counting_loop_exit:
	
	dec ecx
	mov [ebp-4], ecx
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp,8
	ret
