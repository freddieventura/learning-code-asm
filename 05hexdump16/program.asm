; ---------------------------------------
; Author: freddieventura
; Website: https://github.com/freddieventura/
; Date: 25/07/2023
; ProjectName: hexdump16
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; ./program
; nasm -f elf32 -g -F dwarf program.asm -o program.o ; ld -m elf_i386 program.o -o program ; gdb --tui ./program
;	Debugging commands
;		b firstBreak
;		print (char[64])inputBuffer
;		display (char[64])outputBuffer
;	    display $esi
;	    display $edx
; 0123456789ABCDEF
; 0123456789ABCDEFqwertyuiopasdfhj
; ________________----------------________________
; 0123456789ABCDEFqwertyuiopasdfhjklzxcbnmasdfghjk
; 0123456789ABCDEFqwertyuiopasdfhjklzxcbnmasdfghjkasda
;
; fakuve@elitebookx360:~$ echo "0123456789ABCDEFqwertyuiopasdfhj" | hexdump -C
; 00000000  30 31 32 33 34 35 36 37  38 39 41 42 43 44 45 46  |0123456789ABCDEF|
; 00000010  71 77 65 72 74 79 75 69  6f 70 61 73 64 66 68 6a  |qwertyuiopasdfhj|
; Notes:
; - hexdump example
; 00000000  e6 b1 9d d5 19 2b 0b 00  8e 5e 5c 93 70 76 6a 70  |.....+...^\.pvjp|
; 00000010  81 6c d0 6f 1e 90 0a 04  f4 a6 2f 51 1a cb 9e a4  |.l.o....../Q....|
; 00000020  fd f3 2a 7f ab dd a6 b8  f4 e0 6a d3 3e 88 69 11  |..*.......j.>.i.|
; (a hexdump is has 16 bytes per line)
; we will only do the hexadecimal representation (not the memory offset, neither the ASCII conversion)
; - Notes
; 	 - It gets a string from stdin and prints its hexadecimal value in pairs
;		- 1st) It gets user input (maximum input length 1024 bytes(
;		- 2nd)If user hasnt input anything (newline) , or it hasnt been piped anything (eax = 0 from write() ) exitProgram
;		- 3rd)It reads in buffers of 16 bytes 
;			- Get the noOfLines to output (it will be the iteration of outterloop)
;			- Clean the outputBuffer from previous outputs
;			- a) Read first 16 bytes
;					- Go byte per byte breaking down to 2 hex values to outputBuffer (32 bytes)			
;			- b) Serve 32Bytes of hex Representation outputBuffer + line break  (write())
;			- c) Iterate again (outterloop)
;			Desired functioning i.e. Input "0123456789ABCDEFqwertyuiopasdfhj"
;  
;
;
; PROBLEMS
;	- It discriminate partial inputs , input gets truncated to lines , 16 bytes.
;		Meaning if the input is below 16 or multiples , the bytes in between wont be shown
; ---------------------------------------------------------------------------------------------



section .data
    lookupTable db "0123456789ABCDEF"
section .bss
	inputBufferLength equ 1024
	inputBuffer resb inputBufferLength
	outputBufferLength equ 65				; Is 4 * 16 +1 = 4 Spaces of print out (2 whitespaces) + 1 line feed at the end
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
	xor edi, edi				; Initiating the Breaking Constant = 0
	mov edi, eax
	xor esi, esi		        ; outterLoopCounter = 0		

outterLoopCond:
	cmp edi, esi				
	jle outterLoopEnd            ; Looping condition breaking Constant < loopCounter

	pushad						; Pushing registers to Stack so I can 
								; Inner loop


; outterLOOPCODE HERE outterLOOPCODE HERE

;- Clean the outputBuffer from previous outputs
;	eax= 32 bits = 4 bytes
;  Need to clean 64 bytes
;   eax * 16

	xor eax, eax
	mov [outputBuffer] , eax
	mov [outputBuffer+4] , eax
	mov [outputBuffer+8] , eax
	mov [outputBuffer+12] , eax
	mov [outputBuffer+16] , eax
	mov [outputBuffer+20] , eax
	mov [outputBuffer+24] , eax
	mov [outputBuffer+28] , eax
	mov [outputBuffer+32] , eax
	mov [outputBuffer+36] , eax
	mov [outputBuffer+40] , eax
	mov [outputBuffer+44] , eax
	mov [outputBuffer+48] , eax
	mov [outputBuffer+52] , eax
	mov [outputBuffer+56] , eax
	mov [outputBuffer+60] , eax

; passing currentLine into a non-used register ecx
	mov edx, esi
; outterLOOPCODE HERE outterLOOPCODE HERE


;=================INNERLOOP==============================================
innerLoopStart:
	mov edi, 16 				; Initiating the Breaking Constant = 16
	mov esi, 0   				; innerLoopCounter
innerLoopCond:				
	cmp edi, esi 				
	jle innerLoopEnd 		    ; Looping condition breaking Constant < loopCounter

; INNERLOOPCODE HERE INNERLOOPCODE HERE

firstBreak: 	nop
; calculating the inputBuffer offset
; Remember when performing a multiplication of <256 try using 8-bit registers otherwise edx will be cluttered
; I need to keep edx but have run out of registers to perform following calculations so I need to push it and pop it
	push edx 					; Pushing currentLine => Stack
	mov al, dl
	mov bl, 16					; currentLine * 16
	mul bl
	mov dl, al	    			; dl = inputBufferOffset

; As dl will get cluttered on the next multiplication (because esi has no 8-bit counterpart)
; Contents of dl will be moved to cl
	xor ecx, ecx
	mov cl, dl
	xor dl, dl

; calculating the ouputBuffer offset
	mov ax, si 				
	mov bx, 4					; 4 characters per decoding 2 of the hex value 2 white spaces
	mul bx, 					; eax = outputBufferOffset

; grabbing back cl into dl
	mov dl, cl

; Checking Lower nibble
	mov cl,[inputBuffer+esi+edx]	; charToScan = inputBufferAddress + esi + inputBufferOffset
	and ecx, 0b11110000
	shr ecx, 4
	mov cl,[lookupTable+ecx]
	mov [outputBuffer+eax], cl

; Checking Higher nibble
	mov cl,[inputBuffer+esi+edx] 	; Store charToScan again as registers had been used
	and ecx, 0b00001111
	mov cl,[lookupTable+ecx]
	mov [outputBuffer+eax+1], cl

; Padding white spaces
	mov byte [outputBuffer+eax+2], 0x20 
	mov byte [outputBuffer+eax+3], 0x20 

; INNERLOOPCODE HERE INNERLOOPCODE HERE


innerLoopInc:
	inc esi						; innerLoopCounter++
	pop edx						; Poping currentLine <= Stack
	jmp innerLoopCond 			; Looping back
innerLoopEnd:
;==============EOFINERLOOP==============================================


; Serve that 16Bytes outputBuffer + line break  (write())
; 1st add the line break
mov byte [outputBuffer+64] , 0x0A



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

