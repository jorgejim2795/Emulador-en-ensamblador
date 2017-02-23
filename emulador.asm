section .data
	filename db "ROM.txt",0
	welcome db 'Bienvenido al Emulador MIPS', 0xa
	lwelcome equ $- welcome
	bienv2 db 'EL-4313-Lab. Estructura de Microprocesadores', 0xa
	lbienv2 equ $- bienv2
	bienv3 db 'Semestre 1S-2017', 0xa
	lbienv3 equ $- bienv3
	busqR: db 'Buscando ROM.txt', 0xa
	lbusqR equ $- busqR
	RNoFind: db 'Archivo ROM.txt no encontrado', 0xa
	lRNoFind: equ $- RNoFind
	RFind: db 'Archivo ROM.txt encontrado', 0xa
	lRFind: equ $- RFind
	msj db "Presione Enter para continuar:",0xa
	lmsj: equ $- msj
	int1: db "Jorge Jimenez Mora       2014085036",0xa
	len1: equ $-int1
	int2: db "Jose Hernandez Castro    2014086307",0xa
	len2: equ $-int2
	int3: db "Gabino Venegas Rodriguez 2014013616",0xa
	len3: equ $-int3

section .bss
	space resb 100
	pos resb 8
	
	text resb 4950
	mem resb 400  ;memoria de programa
	data resb 600 ;memoria de datos
	stack resb 400 ; capacidad de cien palabras

	PC resb 8
	$v0 resb 8
	$v1 resb 8
	$a0 resb 8
	$a1 resb 8
	$a2 resb 8
	$a3 resb 8
	$s0 resb 8
	$s1 resb 8
	$s2 resb 8
	$s3 resb 8
	$s4 resb 8
	$s5 resb 8
	$s6 resb 8
	$s7 resb 8
	$sp resb 8

	
section .text
	global _start
_start:
	;call _msgbv
	
;funcion para abrir el doc	
	mov rax, 2 ;sys open
	mov rdi, filename
	mov rsi, 0 ;bandera de solo lectura
	mov rdx, 0
	syscall

;funcion para leer el doc
	push rax
	mov rdi, rax
	mov rax, 0 ; sys read
	mov rsi, text
	mov rdx, 576
	syscall

;funcion para cerrar el doc
	mov rax, 3 ; sys close
	pop rdi
	syscall
 
;funcion de escritura de text en pantalla 
;	mov rdi, rax; sys write	
;	mov rax, 1
;	mov rsi, text
;	mov rdx, 576
;	syscall
_hols:
;Primer bit
	mov r10, text
	mov r9b, [r10]
	
	
	mov al,1
	mov dil,1
	mov sil,r9b
_eti:
	mov dl,1
	syscall 

	;cmp r9,0b00110000
	;je _addbit32
	;mov rax,1
	;mov [mem],rax
	;jmp _sigue
	
_addbit32:
	;mov rax,0
	;mov [mem],rax
	;jmp _sigue
_sigue:
;funcion de escritura de mem en pantalla 

	;call _salida 	

	mov rax, 60; sysexit
	mov rdi, 0
	syscall


_msgbv:
	mov rax, 1
	mov rdi, 1
	mov rsi, welcome
	mov rdx, lwelcome
	syscall 
	
	mov rax, 1
	mov rdi, 1	
	mov rsi, bienv2
	mov rdx, lbienv2
	syscall 

	mov rax, 1
	mov rdi, 1
	mov rsi, bienv3
	mov rdx, lbienv3
	syscall 

	mov rax, 1
	mov rdi, 1
	mov rsi, msj
	mov rdx, lmsj
	syscall 
	ret

_salida:	
	mov rax, 1
	mov rdi, 1
	mov rsi, int1
	mov rdx, len1
	syscall 
	
	mov rax, 1
	mov rdi, 1	
	mov rsi, int2
	mov rdx, len2
	syscall 

	mov rax, 1
	mov rdi, 1
	mov rsi, int3
	mov rdx, len3
	syscall 
	ret

