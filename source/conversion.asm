section .text
	global CharToInt, IntToChar
;notes
;IntToChar and CharToInt are working perfectly fine next time please dont waste your time so much

;function converting a null terminated string of chararacters into 4byte integer
;arguments:
;string to convert at ebp+8
;return value:
;converted integer in eax
CharToInt:
	push ebp
	mov ebp,esp
	sub esp, 4
	pusha
	mov ebx, [ebp+8]; ebx holds the adress of string to convert
	mov ecx, 0; zero out the counter
	CTI_counting_loop: ;counts the number of digits
		
		mov eax, [ebx+ecx];load the character 
		test al, al
		jz CTI_counting_loop_end_condition
		inc ecx
		jmp CTI_counting_loop

	CTI_counting_loop_end_condition:
	
	mov dword eax,0 ; eax will hold converted integer
	mov esi, [ebp+8] ; adress of string
	mov dword ebx, 1; holds base for multiplication

	CTI_convertion_loop: ; converts string to integer
		
		mov edx, 0
		mov edx, [esi+ecx-1]; load character to convert
		movzx edx, dl
		sub edx, 48
		imul edx, ebx
		imul dword ebx,10
		add eax, edx
		loop CTI_convertion_loop
			
	mov [ebp-4], eax	
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp,8
	ret
;Function for converting a 4 byte integer to null 
;terminated character string
;arguments:
;4 byte integer at ebp+8 passed by value at ebp+8
; address of buffer to write the string into at ebp+12
;return value:
;address of string in eax
IntToChar:
	push ebp
	mov ebp,esp
	sub esp,4; room for return value
	pusha
	
	mov eax, [ebp+8]; holds integer to convert
	mov esi, [ebp+12]; holds address of output string
	mov dword ecx, 0; counter
	mov dword ebx, 10
	
	ITC_convertion_loop:; working
		cdq
		idiv ebx
		add edx, 48
		mov [esi+ecx], dl
		inc ecx
		mov edx, 0
		cmp eax, 0
		jnz ITC_convertion_loop
	
	
	mov byte [esi+ecx], 0
	mov eax, ecx; eax is a new counter
	cdq
	mov ebx, 2
	idiv ebx
	dec ecx
	mov edx, 0

	ITC_reorganization_loop:
		
		cmp eax, 0
		jz ITC_reorganization_loop_exit
		mov bl, [esi+edx]
		mov bh, [esi+ecx]
		mov [esi+edx], bh
		mov [esi+ecx], bl
		dec eax
		dec ecx
		inc edx
		jmp ITC_reorganization_loop
	ITC_reorganization_loop_exit:
	
	mov [ebp-4], esi
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp, 8
	ret
