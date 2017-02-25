section .data
	filename db "ROM.txt",0
	msg1 db "bienvenido a ensamblador mips ",10
section .bss
	PC resb 8
	text resb 4950 ;rom
	mem resb 600   ;memoria de programa
	data resb 400 ;memoria de datos
	stack resb 400 ; capacidad de cien palabras
	reg reb 128    ;banco de registros
	PC resb 4      ;registro para pc
	
section .text
	global _start
_start:
	mov rdi, rax; sys write
	mov rax, 1
	mov rsi, msg1
	mov rdx, 576
	syscall
	
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
 
	;funcion de escritura en pantalla 
	mov rdi, rax; sys write	
	mov rax, 1
	mov rsi, text
	mov rdx, 576
	syscall
	
	;funcion para llenar mem

	mov r8, 0
	mov r13, 33
	mov r10, 32
	mov r11, 0ffffffffffffffffh

loop:	
	mov r9b, [text + r8]
	cmp r9b, 31h ;49	
	jne enter
	rol r11, 1
prueba:
	add r8,1
	cmp r8, r13
	jne loop
	jmp sigue
	
enter:	
	cmp r9b,10d
	jne cero
	add r8, 1
	cmp r8, r13 
	jne loop
	jmp sigue
cero:
	shl r11,1
prueba2:
	add r8,1
	cmp r8, r13
	jne loop

sigue:
	mov r12, r10
	shr r12, 3
	add r12,-4
valor:
	mov dword [mem+r12], r11d
	add r10,32
	add r13, 33
	mov r11, 0ffffffffffffffffh
	cmp r10, 3200
	jne loop

	mov eax, [mem]
	mov r10d, [mem+4]
	mov r11d, [mem+8]

	;funcion de escritura en pantalla 
	mov rdi, rax; sys write	
	mov rax, 1
	mov rsi, mem
	mov rdx, 64
	syscall

	call opcode
	cmp r10d,0
	je Rformat
	mov eax,[PC]
	add eax,4
	mov dword [PC],eax

	
	

holis:
	mov rax, 60; sysexit
	mov rdi, 0
	syscall









opcode:
	mov r8,[PC]
	mov r9d,[mem+r8]
	shr r9d,26
	and r9d,31
	shl r9d,2
	mov r10d,[reg+r9d]
	ret
rd:
	mov r8,[PC]
	mov r9d,[mem+r8]
	shr r9d,21
	and r9d,31
	shl r9d,2
	mov r11d,r9d
	ret
rs:
	mov r8,[PC]
	mov r9d,[mem+r8]
	shr r9d,16
	and r9d,31
	shl r9d,2
	mov r12d,[reg+r9d]
	ret
rt:
	mov r8,[PC]
	mov r9d,[mem+r8]
	shr r9d,11
	and r9d,31
	shl r9d,2
	mov r13d,[reg+r9d]
	ret

sham:
	mov r8,[PC]
	mov r9d,[mem+r8]
	shr r9d,6
	and r9d,31
	shl r9d,2
	mov r13d,[reg+r9d]
	ret
func:
	mov r8,[PC]
	mov r9d,[mem+r8]
	and r9d,31
	shl r9d,2
	mov r13d,[reg+r9d]
	ret

Rformat:
	call func
	cmp r13d,20h
	call add
	ret

add:
	call rs
	call rt
	add r12d,r13d
	call rd
	mov dword [reg+r11d],r12d
	ret
	















