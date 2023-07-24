; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 24/07/2023
; ProjectName: ReverseString
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; ./program
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; gdb --tui ./program
;	Debugging commands
;		print (char[64])inputBuffer
;		display (char[17])outputBuffer
;	    display $esi
; 0123456789ABCDEF
; 0123456789ABCDEFqwertyuiopasdfhj
; ________________----------------________________
; 0123456789ABCDEFqwertyuiopasdfhjklzxcbnmasdfghjk
; 0123456789ABCDEFqwertyuiopasdfhjklzxcbnmasdfghjkasda
; Notes:
;	- It gets a string from stdin and prints it inverted (from last char to first char)
;		- 1st) It gets user input (maximum input length 1024 bytes(
;		- 2nd)If user hasnt input anything (newline) , or it hasnt been piped anything (eax = 0 from write() ) exitProgram
;		- 3rd)It reads in buffers of 16 bytes 
;			- Get the noOfLines to output (it will be the iteration of outterloop)
;			- Clean the outputBuffer from previous outputs
;			- a) Read first 16 bytes
;				1)Reversing Function: 
;					- Place on 0 offset of outputBuffer 16 (last) offset * currentLine of inputBuffer
;						(Note there is no way to calculate whichone is the last)
;						Thus we just have to iterate until we find a line break or end of input which will jump innerLoopEnd
;					- Place on 1 offset of outputBuffer 15 offset * currentLine of inputBuffer
;					- Note the input buffer has to be checked * currentLine which is the current inputLine
;				2)Iterate again (innerloop)
;			- b) Serve that 16Bytes outputBuffer + line break  (write())
;			- c) Iterate again (outterloop)
;			i.e.0123456789ABCDEFqwertyuiopasdfh
; 				would output
;				 FEDCBA9876543210
;				 hgfdsapoiuytrewq
; PROBLEMS
;	- It discriminate partial inputs , input gets truncated to lines , 16 bytes.
;		Meaning if the input is below 16 or multiples , the bytes in between wont be shown
; ---------------------------------------------------------------------------------------------



section .data
section .bss
	inputBufferLength equ 1024
	inputBuffer resb inputBufferLength
	outputBufferLength equ 17
	outputBuffer resb outputBufferLength
section .text
	global _start


_start: 


; GET USER INPUT (X86)
; --------------------------------------
    mov eax, 3                   ; Syscall 3 read()
    mov ebx, 0                   ; 0 for Stdin
    mov ecx, inputBuffer           ; Buffer defined in .bss as
    mov edx, inputBufferLength     ; Buffer length
    int 80h
; --------------------------------------


; If user hasnt input anything (newline) or nothing has been piped to the program exitProgram
cmp eax, 0
je exitProgram

cmp byte [inputBuffer], 0x0A 
je exitProgram

; Get the noOfLines to output
xor edx, edx
; eax is MSB divisor already , no need to mov it
mov ebx, 16
div ebx
; eax = noOfLines


;------------------------2LOOPS(X86)-----------------------------------
;-------------------------outterLOOP------------------------------------
outterLoopStart:
	xor edi, edi				; Initiating the Breaking Constant =  noOfLines + 1
	add edi, 1
	mov edi, eax
	xor esi, esi		        ; outterLoopCounter = 0		
	mov esi, 1

outterLoopCond:
	cmp edi, esi				
	jl outterLoopEnd            ; Looping condition breaking Constant < loopCounter

	pushad						; Pushing registers to Stack so I can 
								; Inner loop


; outterLOOPCODE HERE outterLOOPCODE HERE

;- Clean the outputBuffer from previous outputs
;	eax= 32 bits = 4 bytes
;  Need to clean 16 bytes
;   eax * 4

	xor eax, eax
	mov [outputBuffer] , eax
	mov [outputBuffer+4] , eax
	mov [outputBuffer+8] , eax
	mov [outputBuffer+12] , eax


; passing currentLine into a non-used register ecx
	mov ecx, esi
; outterLOOPCODE HERE outterLOOPCODE HERE


;=================INNERLOOP==============================================
innerLoopStart:
	mov edi, 15 				; Initiating the Breaking Constant = 16
	mov esi, 0   				; innerLoopCounter
innerLoopCond:				
	cmp edi, esi 				
	jl innerLoopEnd 		    ; Looping condition breaking Constant < loopCounter

; INNERLOOPCODE HERE INNERLOOPCODE HERE

; Place on 0 offset of outputBuffer 16 (last) offset of inputBuffer
; Place on 1 offset of outputBuffer 15 offset of inputBuffer
; Etc ... until reached end of input or 16 offset to 0
; 	Remember X86 cannot move from memory position to memory position directly
; mov [outputBuffer+esi], [inputBuffer+edi-esi]  (NOT VALID)
; 	remember also [inputBuffer+edi-esi] is not a valid operation
; 	remember to read the inputBuffer offset according to the currentLine (eax)


;							  eax
;				   _______________________________
;			         	eax            esi
;				  _________________  ____________
; you have to get (currentLine)*15-innerLoopCounter
mov eax, 16 
mul ecx

;mov ebx, edi
;sub ebx, esi		; 16-innerLoopCounter
sub eax, esi

;mul ebx				; eax = currentLine*(16-innerLoopCounter)

mov al, [inputBuffer+eax-1]
mov [outputBuffer+esi], al
; INNERLOOPCODE HERE INNERLOOPCODE HERE


innerLoopInc:
	inc esi						; innerLoopCounter++
	jmp innerLoopCond 			; Looping back
innerLoopEnd:
;==============EOFINERLOOP==============================================



; Serve that 16Bytes outputBuffer + line break  (write())
; 1st add the line break
mov byte [outputBuffer+16] , 0x0A


; PRINT TO STDOUT (X86)
; --------------------------------------
    mov eax, 4                  ; Syscall 4 
    mov ebx, 1                  ; 1 for Stdout
    mov ecx, outputBuffer		; oneMessage defined in .data
    mov edx, outputBufferLength ; oneMessageLenght defined in .data as
    int 80h
; --------------------------------------




	popad						; Recovering the registers from inner loop
outterLoopInc:
	inc esi						; outterLoopCounter++
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

