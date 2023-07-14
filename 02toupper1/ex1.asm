; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 13/07/2023
; nasm -f elf32 -g -F dwarf ex1.asm -o ex1.o ; ld -m elf_i386 program.o -o ex1 ; ./ex1
; ---------------------------------------

section .data
section .bss
	oneBuffer resb 1		; Declaring a buffer
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
    mov edx, 1                   ; Buffer length
    int 80h
; --------------------------------------
; eof eof eof eof eof eof eof eof


	cmp byte [oneBuffer], 41H
	jb exitProgram
	cmp byte [oneBuffer], 5AH
	jb printStdout
	cmp byte [oneBuffer], 61H
	jb exitProgram
	cmp byte [oneBuffer], 7AH
	jb toUpper
	jmp	exitProgram

toUpper:
	sub byte [oneBuffer], 20H


; PRINT TO STDOUT (X86)
; --------------------------------------
printStdout:
    mov eax, 4                  ; Syscall 4
    mov ebx, 1                  ; 1 for Stdout
    mov ecx, oneBuffer			; oneMessage defined in .data as
;oneMessage: db "My Message",10
    mov edx, 1					; oneMessageLenght defined in .data as
;oneMessageLength: equ $-oneMessage
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


; NOTES FROM HERE
; ---------------------------------------
;
; Program that takes standard input and uppercase it (if its a letter)
; Grab one char of input
; Check if it is a lower case character
;		 	Make it Uppercase
;			Print it
; Check if it is an upper case character
;			Print it
; Check if it is other kind of char
;			TERMINATE
;
