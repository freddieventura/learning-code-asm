; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 26/07/2023
; ProjectName: toupperbylookuptable
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; ./program
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; gdb --tui ./program
;	Debugging commands
;
; - Notes
;	- Practice using a lookup Table in order to perform a functionality
;	- User will input a succession of characters (inputBuffer 1024 bytes)
;	- Prompt user for input (outterLoop)
;		- If user hasnt input anything goto exitProgram
;		- Program will read each char (innerLoop)
;			- pass it against the LookupTable UpCase
;				(note Upcase will 
;							- Uppercase the chars 
;			- Translated char will be placed back on inputBuffer
;				 (inputBuffer will be used as outputBuffer)
;		 - Once loop is finnished , print out inputBuffer
;	   
; ---------------------------------------------------------------------------------------------



section .data
	oneMessage: db "Please input a string to be uppercased", 10
	oneMessageLength: equ $-oneMessage
	upCaseTable: 
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,09h,0Ah,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,21h,22h,23h,24h,25h,26h,27h,28h,29h,2Ah,2Bh,2Ch,2Dh,2Eh,2Fh
	db 30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,3Ah,3Bh,3Ch,3Dh,3Eh,3Fh
	db 40h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh
	db 50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah,5Bh,5Ch,5Dh,5Eh,5Fh
	db 60h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh
	db 50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah,7Bh,7Ch,7Dh,7Eh,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db 20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
section .bss
	inputBufferLength equ 1024
	inputBuffer resb inputBufferLength
section .text
	global _start


_start: 


; PRINT TO STDOUT (X86)
; --------------------------------------
    mov eax, 4                  ; Syscall 4 
    mov ebx, 1                  ; 1 for Stdout
    mov ecx, oneMessage       	; oneMessage defined in .data
    mov edx, oneMessageLength   ; oneMessageLenght defined in .data as
    int 80h
; --------------------------------------



;	- Prompt user for input (outterLoop)
;------------------------2LOOPS(X86)-----------------------------------
;-------------------------outterLOOP------------------------------------
outterLoopCond:

; outterLOOPCODE HERE outterLOOPCODE HERE

; GET USER INPUT (X86)
; --------------------------------------
    mov eax, 3                   ; Syscall 3 read()
    mov ebx, 0                   ; 0 for Stdin
    mov ecx, inputBuffer           ; Buffer defined in .bss as
    mov edx, inputBufferLength     ; Buffer length
    int 80h
; --------------------------------------


;		- If user hasnt input anything goto exitProgram
	cmp eax, 0
	jz exitProgram
	cmp byte [inputBuffer], 0x0A 
	je exitProgram

; outterLOOPCODE HERE outterLOOPCODE HERE

;		- Program will read each char (innerLoop)
;=================INNERLOOP==============================================
innerLoopStart:
	mov edi, eax				; Initiating the Breaking Constant = inputedBufferLength 
	mov esi, 0   				; innerLoopCounter
innerLoopCond:				
	cmp edi, esi 				
	jle innerLoopEnd 		    ; Looping condition breaking Constant <= loopCounter

; INNERLOOPCODE HERE INNERLOOPCODE HERE

;			- pass it against the LookupTable UpCase
	mov ebx, upCaseTable 
	mov	al,[inputBuffer+esi]
	xlat
;			- Translated char will be placed back on inputBuffer
	mov [inputBuffer+esi], al
	
; INNERLOOPCODE HERE INNERLOOPCODE HERE


innerLoopInc:
	inc esi						; innerLoopCounter++
	jmp innerLoopCond 			; Looping back
innerLoopEnd:
;==============EOFINERLOOP==============================================



;		 - Once loop is finnished , print out inputBuffer
; PRINT TO STDOUT (X86)
; --------------------------------------
    mov eax, 4                  ; Syscall 4 
    mov ebx, 1                  ; 1 for Stdout
    mov ecx, inputBuffer		; oneMessage defined in .data
    mov edx, edi				; oneMessageLenght defined in .data as
    int 80h
; --------------------------------------



outterLoopInc:
	jmp outterLoopCond			; Looping back
outterLoopEnd:
;---------------------EOF-outterLOOP------------------------------------
;----------------------------------------------------------------------








; EXITING THE PROGRAM (X86)
; --------------------------------------
exitProgram:
	mov eax, 1					; Syscall 1
    mov ebx, 0                  ; 0 Exit Status Code Succesful
	int 80h
; --------------------------------------

