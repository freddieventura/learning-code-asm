; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 14/07/2023
; ProjectName: Show Vertical String
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; ./program
;
; Notes:
;	It gets a string as a variable an print char by char vertically
;	The difficulty in here was using the oneBuffer, an referencing to it
;	Also printing sequences of 2 chars , the letter+ linefeed in one syscall instead of 
;	One syscall per each
; ---------------------------------------------------------------------------------------------


section .bss
section .data
	oneMessage db "Hello World",10
	oneMessageLength equ $-oneMessage
	oneBuffer db 2 " ", 0Ah
	oneBufferLength equ 2
section .text

	global _start

_start:

	nop
	nop

	mov edi, 0					; Initiate the counter
printStdout:
	cmp edi, oneMessageLength-1 ; From top
	jae exitProgram

	
	mov al, [oneMessage+edi]
	mov [oneBuffer] , al
; PRINT TO STDOUT (X86)
; --------------------------------------
    mov eax, 4                  ; Syscall 4
    mov ebx, 1                  ; 1 for Stdout
    mov ecx, oneBuffer			; 
    mov edx, 2					; 2 chars print
    int 80h
; --------------------------------------
; eof eof eof eof eof eof eof eof
	inc edi						; Increase the counter
	jmp	printStdout				; Loopback
	

; EXITING THE PROGRAM (X86)
; --------------------------------------
exitProgram:
	mov eax, 1					; Syscall 1
    mov ebx, 0                  ; 0 Exit Status Code Succesful
	int 80h
; --------------------------------------

