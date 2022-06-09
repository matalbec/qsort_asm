%include "../inc/conversion.inc"
%include "../inc/fio.inc"
section .bss
	output resb 256
	buffer resb 20
	int_buffer resd 256
section .text
	global qprintf, qscanf
; function printing an 4byte table integer to specified file as char string
; arguments:
; addres of integer table to print at ebp+8
; name of the file at ebp+12	
qprintf:
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp+8]	
	mov edi, output
	mov ecx, 0;zero out counter

QPF_string_create:
	mov ebx, [esi+4*ecx]; ebx=integer to convert
	cmp ebx, -1
	je QPF_string_create_exit
	push buffer
	push ebx
	call IntToChar
	add esp,8
	mov esi, eax
	cld
	QPF_create_output:
		lodsb
		test al, al
		jz QPF_create_output_exit
		stosb
		jmp QPF_create_output
	QPF_create_output_exit:
		mov al, 10
		stosb

	mov esi, [ebp+8]
		
	inc ecx
	jmp QPF_string_create

QPF_string_create_exit:
	mov al, 0
	stosb

	push dword [ebp+12]
	push output
	call fprintf
	add esp, 8

	popa
	mov ebp, [ebp]
	add esp, 4
	ret
;function that returns a table of integers
;arguments:
;path to a file at ebp+8
;return value:
;address to an integer table at eax
qscanf:
	push ebp
	mov ebp, esp
	sub esp, 4;room for return value
	pusha

	;string aquisition part of qscanf
	push dword [ebp+8]
	call fscanf; eax= address to a null terminated string
	add esp, 4

	;part of the function responsible for converting char string to int table
	mov edi, int_buffer
	mov esi, eax
	cld
	mov ecx, 0; offset for esi
	mov edx, 0; offset for buffer


QSF_convertion_loop:

	QSF_substring_create:

	mov eax, [esi+ecx]; load a byte to compare

	test al, al
	jz QSF_convertion_loop_exit

	cmp al, 10
	je QSF_substring_create_exit

	mov [buffer+edx], al
	
	inc ecx
	inc edx

	jmp QSF_substring_create
	QSF_substring_create_exit:

	mov byte [buffer+edx], 0

	push buffer
	call CharToInt; eax= int
	add esp,4

	stosd
	
	inc ecx
	mov edx, 0

	jmp QSF_convertion_loop

QSF_convertion_loop_exit:

	mov eax, -1
	stosd

	mov dword [ebp-4], int_buffer
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp, 8
	ret
