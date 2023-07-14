; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 14/07/2023
; ProjectName: touppercase 
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; ./program
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; gdb --tui ./program
; Notes:
;    Program that takes the standard input and converts each char to uppercase	
;		One of the main difficulties was to create the logic for parshingChar , creating different labels accordingly		
;	
;	
; ---------------------------------------

section .data
section .bss
	oneBufferLength equ 1024
	oneBuffer resb oneBufferLength ; Declaring a buffer
section .text
	global _start


_start: 

; GET USER INPUT (X86)
; --------------------------------------
getUserInput:
    mov eax, 3                   ; Syscall 3
    mov ebx, 0                   ; 0 for Stdin
    mov ecx, oneBuffer 			 ; Buffer defined in .bss as
;inputBuffer: resb 2 
    mov edx, oneBufferLength	 ; Buffer length
    int 80h
; --------------------------------------
; eof eof eof eof eof eof eof eof


	mov edi, 0					; Initiating the counter
	mov esi, eax				; Storing in a register the length of input String
parsingCharCond:				; Subroutine where we translate each char
; --------------------------------------
	cmp edi, esi 				; Looping condition
	jae parsingCharEnd 


	cmp byte [oneBuffer+edi], 41H ; Case is non-letter
	jb parsingCharInc 
	cmp byte [oneBuffer+edi], 5AH ; Case is uppercase
	jb parsingCharInc
	cmp byte [oneBuffer+edi], 61H ; Case is non-letter
	jb parsingCharInc
	cmp byte [oneBuffer+edi], 7BH ; Case is any other char
	jae parsingCharInc
	; Else
	sub byte [oneBuffer+edi], 20h

; --------------------------------------
parsingCharInc:
	inc edi						; Increasing the counter
	jmp parsingCharCond 		; Looping back
; --------------------------------------
parsingCharEnd:



; PRINT TO STDOUT (X86)
; --------------------------------------
    mov eax, 4                  ; Syscall 4
    mov ebx, 1                  ; 1 for Stdout
	mov ecx, oneBuffer			; First address of offset to be read
    mov edx, esi 				; To inputStringLength
    int 80h
; --------------------------------------
; eof eof eof eof eof eof eof eof


; EXITING THE PROGRAM (X86)
; --------------------------------------
exitProgram:
	mov eax, 1					; Syscall 1
    mov ebx, 0                  ; 0 Exit Status Code Succesful
	int 80h
; --------------------------------------
; eof eof eof eof eof eof eof eof


