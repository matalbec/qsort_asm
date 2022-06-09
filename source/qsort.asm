	global quicksort
section .text
;function performing a non randomized algorithm on a non negative integer table
;arguments:
;address to an integer table at ebp+8
;integer indicating a starting point at ebp+12 passed by value
;integer indicating an ending point at ebp+16 passed by value
;return value:
;address to a sorted array at eax
quicksort:
	push ebp
	mov ebp, esp
	sub esp, 16;room for return value, value of the pivot, j value adn i value
	pusha

	mov esi, [ebp+8]; esi stores an address to table

	mov eax, [ebp+16]
	mov edx, [esi+4*eax]
	mov [ebp-8], edx;save pivot value on the stack
	mov ebx, [ebp+12]
	sub eax, ebx
	mov ecx, eax; ecx= number of elements in a table minus 1
	cmp ecx, 1
	je QS_primitive_case;jumps to the block of code responsible for handling primitive case
	
	mov eax, [ebp+12]
	dec eax; eax=i in quicksort algorithm

	mov ebx, [ebp+12]; ebx=j
QS_init_loop:
	mov edx, [esi+4*ebx];load the integer to compare
	mov [ebp-12], ebx; save the value of j
	mov ebx, [ebp-8]; load pivot value
	cmp edx, ebx
	mov ebx, [ebp-12]; restore j
	jge QS_init_loop_exit
	inc ebx
	inc eax
	dec ecx
	jmp QS_init_loop
QS_init_loop_exit:

	cmp ecx, 0
	je QS_recurent_calls

QS_sorting_loop:
	mov edx, [esi+4*ebx];load integer to compare
	mov [ebp-12], ebx; save the value of j
	mov ebx, [ebp-8]; load pivot value
	cmp edx, ebx
	mov ebx, [ebp-12];restore value of j
	jl QS_element_less
	;code for element value greater or equal to pivot goes here
	
	jmp QS_element_exit
QS_element_less:
	;code for ement value less than pivot goes here
	push ecx
	push edx
	mov edx, [esi+4*eax+4]
	mov ecx, [esi+4*ebx]
	mov [esi+4*eax+4], ecx
	mov [esi+4*ebx],edx
	pop edx
	pop ecx
	inc eax
QS_element_exit:
	inc ebx
	loop QS_sorting_loop


	push ecx
	push edx
	mov edx, [esi+4*eax+4]
	mov ecx, [esi+4*ebx]
	mov [esi+4*eax+4], ecx
	mov [esi+4*ebx],edx
	pop edx
	pop ecx


QS_recurent_calls:
	
	;lower table sort
	cmp eax, [ebp+12]
	jle QS_lower_table_jump

	mov [ebp-16], eax
	push eax
	push dword [ebp+12]
	push dword [ebp+8]
	call quicksort
	add esp, 12
	mov eax, [ebp-16];restore i value

QS_lower_table_jump:

	add eax, 2
	cmp  eax, [ebp+16]
	jge QS_upper_table_jump
	
	mov [ebp-16], eax

	push dword [ebp+16]
	push eax
	push dword [ebp+8]
	call quicksort
	add esp, 12
	mov eax, [ebp-16]

QS_upper_table_jump:

jmp QS_exit
	
QS_primitive_case:
	
	mov eax, [ebp+12]; load start int
	mov ebx, [ebp+16]; load end int
	mov edx, [esi+4*eax]; edx= int at the start
	mov ecx, [esi+4*ebx]; ecx= int at the end
	cmp ecx, edx
	jg QS_exit
	mov [esi+4*eax], ecx
	mov [esi+4*ebx], edx

QS_exit:

	
	mov [ebp-4], esi
	popa
	mov eax, [ebp-4]
	mov ebp, [ebp]
	add esp,20
	ret
