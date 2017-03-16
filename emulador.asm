%include "linux64.inc"
extern system
section .data
	regiszero db "$zero"
	regis db "$at,$v0,$v1,$a0,$a1,$a2,$a3,$t0,$t1,$t2,$t3,$t4,$t5,$t6,$t7,$s0,$s1,$s2,$s3,$s4,$s5,$s6,$s7,$t8,$t9,$k0,$k1,$gp,$sp,$fp,$ra"
	instruc db "add addi addu and andi beq bne j jal jr lw nor or ori slt slti sltiu sltu sll srl sub subu mult mflo sw "
	enteer db "",0xa
	tab db "",9
	coma db ","
	par1 db "("
	par2 db ")"	
	igual db "="
	filename db "ROM.txt",0
	filename2 db "resultado.txt",0
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
	msj1 db "Presione Enter para salir:",0xa
	lmsj1: equ $- msj1
	int1: db "Jorge Jimenez Mora       2014085036",0xa
	len1: equ $-int1
	int2: db "Jose Hernandez Castro    2014086307",0xa
	len2: equ $-int2
	int3: db "Gabino Venegas Rodriguez 2014013616",0xa,0xa
	len3: equ $-int3
	msjfun db "funcion invalido linea: ",0
	lmsjfun equ $- msjfun
	msjopcode db "opcode invalido linea: ",0
	lmsjopcode equ $- msjopcode
	msjdrinv db "direccion de memoria invalida linea: ",0
	lmsjdrinv: equ $-msjdrinv
	msjinvcar db "caracter no valido en la rom",0xa
	lmsjinvcar: equ $-msjinvcar
	Exitosa db "Ejecusion Exitosa",0xa
	lExitosa equ $-Exitosa
	Contenido db "Contenido de los registros",0xa
	lContenido  equ $-Contenido
	Fallida db "Ejecución Fallida",0xa
	lFallida equ $- Fallida
	argrande db "El argumento es mayor a 3 digitos",0xa
	largrande equ $- argrande

	cadena db "lscpu | grep ID ; lscpu | grep name ; lscpu | grep Fam ; lscpu | grep Ar ; top -bn1 | grep 'Cpu(s)' ; lscpu | grep ID >> resultado.txt ; lscpu | grep name >> resultado.txt ; lscpu | grep Fam >> resultado.txt ; lscpu | grep Ar >> resultado.txt ; top -bn1 | grep 'Cpu(s)' >> resultado.txt ",0xa
section .bss
	text resb 4950 ;rom
	mem resb 600   ;memoria de programa
	data resb 800 ;memoria de datos y stack unidos 0-400 memoria 401-800 stack
	reg resb 128    ;banco de registros
	tecla resb 16
	PC resb 4      ;registro para pc
	frs resb 8
	prueba resb 4 
	arg0 resb 4
	arg1 resb 4
	arg2 resb 4
	arg3 resb 4

section .text
	global _start
_start:	
	pop rax	
	mov r14, rax
	pop rax
	cmp r14,1
	je aqui
n1:
	pop rax			;SACA LA CANTIDAD DE ARGUMENTOS	
trx:	mov r10d, [rax]	
	mov dword [arg0],r10d
	cmp r14,2
	je cargA0
	pop rax			;SACA LA CANTIDAD DE ARGUMENTOS
	mov r11d, [rax]
	mov dword [arg1],r11d
d1:	
	cmp r14,3
	je cargA1
	pop rax			;SACA LA CANTIDAD DE ARGUMENTOS
rev:	mov r11d, [rax]
	mov dword [arg2],r11d
	cmp r14,4
	je cargA2
	pop rax			;SACA LA CANTIDAD DE ARGUMENTOS
	mov r11d, [rax]
	mov dword [arg3],r11d

cargA3:
	mov r10b, [arg3+1]
	cmp r10b ,00
	je or31
	mov r10b, [arg3+2]
	cmp r10b, 00
	je or32
	jmp centena3
	mov r10b, [arg3+3]
	cmp r10b, 00
	jne aqui
or31:
	mov r10d,[arg3]
	and r10d,0000000ffh
	shl r10d, 16
	mov dword [arg3], r10d
	jmp unidad3
or32:
	mov r10d,[arg3]
	and r10d,00000ffffh
	shl r10d, 8
	mov dword [arg3], r10d
	jmp decena3

centena3:
	mov r9b, [arg3]
	sub r9b, 48
	imul r9d,100
	add r8d, r9d

decena3:
	mov r9b, [arg3+1]
	sub r9b, 48
	imul r9d,10
	add r8d, r9d

unidad3:
	mov r9b, [arg3+2]
	sub r9b, 48
	add r8d, r9d
u3:
	mov dword [reg+28],r8d
	mov r8,0
	

cargA2:
	mov r10b, [arg2+1]
	cmp r10b ,00
	je or21
	mov r10b, [arg2+2]
	cmp r10b, 00
	je or22
	jmp centena2
	mov r10b, [arg2+3]
	cmp r10b, 00
	jne aqui
or21:
	mov r10d,[arg2]
	and r10d,0000000ffh
	shl r10d, 16	
	mov dword [arg2], r10d
	jmp unidad2
or22:
	mov r10d,[arg2]
	and r10d,00000ffffh
	shl r10d, 8
	mov dword [arg2], r10d
	jmp decena2

centena2:
	mov r9b, [arg2]
	sub r9b, 48
	imul r9d,100
	add r8d, r9d

decena2:
	mov r9b, [arg2+1]
	sub r9b, 48
	imul r9d,10
	add r8d, r9d

unidad2:
	mov r9b, [arg2+2]
	sub r9b, 48
	add r8d, r9d
	mov dword [reg+24],r8d
u2:
	mov r8,0
	

cargA1:
	mov r10b, [arg1+1]
	cmp r10b ,00
	je or11
	mov r10b, [arg1+2]
	cmp r10b, 00
	je or12
	mov r10b, [arg1+3]
	cmp r10b, 00
	jne aqui
	jmp centena1
or11:
	mov r10d,[arg1]
	and r10d,0000000ffh
	shl r10d, 16
	mov dword [arg1], r10d
	jmp unidad1
or12:
	mov r10d,[arg1]
	and r10d,00000ffffh
	shl r10d, 8
	mov dword [arg1], r10d
	jmp decena1
centena1:
	mov r9b, [arg1]
	sub r9b, 48	
	imul r9d,100
	add r15d, r9d

decena1:
	mov r9,0
	mov r9b, [arg1+1]	
	sub r9b, 48
	imul r9d,10	
	add r15d, r9d

unidad1:
	mov r9, 0
r1:	
	mov r9b, [arg1+2]	
q1:	
	sub r9b, 48
w1:
	add r15d, r9d
u1:
	mov dword [reg+20],r15d

cargA0:
	mov r10b, [arg0+1]
	cmp r10b ,00
	je or01
	mov r10b, [arg0+2]
	cmp r10b, 00
	je or02
	jmp centena
	mov r10b, [arg0+3]
	cmp r10b, 00
	jne aqui
or01:
	mov r10d,[arg0]
	and r10d,0000000ffh
	shl r10d, 16
	mov dword [arg0], r10d
	jmp unidad
or02:
	mov r10d,[arg0]
	and r10d,00000ffffh
	shl r10d, 8
	mov dword [arg0], r10d
	jmp decena

centena:
	mov r9b, [arg0]
	sub r9b, 48
	imul r9d,100
	add r8d, r9d

decena:
	mov r9b, [arg0+1]
	sub r9b, 48
	imul r9d,10
	add r8d, r9d

unidad:
	mov r9b, [arg0+2]
	sub r9b, 48
	add r8d, r9d
u0:
	mov dword [reg+16],r8d
	

aqui:
;------------------------------se crea el resultado.txt para guardar los datos de pantalla	
	mov rax, SYS_OPEN
	mov rdi, filename2
	mov rsi, O_CREAT+O_TRUNC
	mov rdx, 0644o
	syscall

	mov rax, SYS_CLOSE
	pop rdi
	syscall
;------------------------------------------------------------
	mov r8,0
_REGLOP:
	mov dword [reg+r8],0d	
	add r8,4
	cmp r8,124
	jne _REGLOP
;___________________________________________________________________________________________________________________________---

	mov dword [PC], 0		;inicializo el pc en 0
	mov dword [reg+0],0		;$zero en 0
	mov dword [reg+116],800d	;$sp en el limite de la memoria 
	mov dword [data+192],1d		;Datos guardados en la memoria de mips
	mov dword [data+196],2d
	mov dword [data+200],3d
	mov dword [data+204],4d
	mov dword [data+208],5d
	mov dword [data+212],6d
	mov dword [data+216],7d
	mov dword [data+220],8d
	mov dword [reg+124],600d		;$ra inicial es igual a la direccion limite del pc para salir del progrma despues de la ejecuccion
;-----------------------------------------------INPRIMO EL MENSAJE DE BIENVENIDA-----------------------------------------------

;--------------imprime la bienvenida------------
		
	mov rdi, 1					; sys write
	mov rax, 1
	mov rsi, welcome				;Bienvanido al emulador MIPS
	mov rdx, lwelcome				;tamaño del mensaje
	syscall
	
	Wfile welcome,lwelcome
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, bienv2					;codigo del curso
	mov rdx, lbienv2				;tamaño del codigo del curso
	syscall

	Wfile bienv2,lbienv2
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, bienv3					;semestre y año
	mov rdx, lbienv3				;tamaño del semestre
	syscall
	Wfile bienv3,lbienv3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, busqR					;buscando ROM.txt
	mov rdx, lbusqR					;tamaño de buscando ROM
	syscall
	Wfile busqR,lbusqR

;-----------------------------------------------OBTENCION Y ESCRITURA DE LA ROM------------------------------------------------
;----------funcion para abrir el doc-------------------
	mov rax, 2 					;sys open
	mov rdi, filename				;nombre de la ROM
	mov rsi, 0 					;bandera de solo lectura
	mov rdx, 0
	syscall

;----------funcion para leer el doc--------------------
	push rax
	mov rdi, rax
	mov rax, 0 					; sys read
	mov rsi, text	
	mov rdx, 4950
	syscall
;----------si no se encuentra la rom se sale-----------
	mov r14,[text]
	cmp r14,0
	je salida
;----------imprime ROM encontrada----------------------
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, RFind
	mov rdx, lRFind
	syscall


;------------muestra buscando archivo rom---------------
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, msj					;presione entre para continuar
	mov rdx, lmsj					;tamaño del mensaje
	syscall
	Wfile msj,lmsj
	Wfile enteer,1
;-----para reconocer el enter----
	mov rax,0
	mov rdi,0
	mov rsi,tecla					;resibe la entrada, no importa si se escribe basura
	mov rdx, 16					;permite 16 char de basura antes de presionar enter
	syscall


;funcion para cerrar el doc
	mov rax, 3 					; sys close
	pop rdi
	syscall

;--------------------------------------OBTENCION DE LAS FUNCIONES MIPS A PARTIR DE LA ROM---------------------------------------- 
;funcion para llenar mem

	mov r8, 0					;contador de chars
	mov r13, 33					;comparador 
	mov r10, 32					;comparador
	mov r11, 0ffffffffffffffffh			;registro llenos de 1 para copiar la instruccion

loop:	
	mov r9b, [text + r8]				;mover el primer char del txt a el registro r9
	cmp r9b, 31h					;49 (comparo si es un 1)
	jne enter					;sino es igual brinca al enter
	rol r11, 1					;rota el registro r9 para agregar un 1 
	add r8,1					;sumo al contador de chars
	cmp r8, r13					;compare si ya llego a 33(r13)
	jne loop					;sino es igual vuelva a realizar lo anterior
	jmp sigue					;si ya llego brinca a sigue
	
enter:	
	cmp r9b,10d					;compara si el char leido es un enter
	jne cero					;sino es un enter brinca a cero
	add r8, 1					;sumo al contador de chars
	cmp r8, r13 					;compare si ya llego a 33(r13)
	jne loop					;repita lo mismo
	jmp sigue					;brinque a sigue si ya termino

cero:
	cmp r9b,48d
	jne vacio
lawea:	
	shl r11,1					;haga un shift para agregar un cero
	add r8,1					;sumo al contador de chars
	cmp r8, r13					;compare si ya llego a 33(r13)
	jne loop					;repita lo mismo
	jmp sigue
vacio:
	cmp r9b,0d
	jne invcar
	jmp lawea 

sigue:
	mov r12, r10					;guarda un 32 en r12
	shr r12, 3					;multiplico 32*4
	add r12,-4					;resto 4 r12=(32*4)-4
	mov dword [mem+r12], r11d			;guarda la instruccion copiada en la memoria de programa
	add r10,32					;sumo un 32 para cambiar de linea en la memoria de rom
	add r13, 33					;sumo un 33 para cambiar de linea en la rom
	mov r11, 0ffffffffffffffffh			;reinicio de nuevo el registro base
	cmp r10, 3200					;compara si ya termine de leer la rom
	jne loop					;sino repita el proceso 

;------------------------------------------------IDENTIFICACION DE LA INSTRUCCION MIPS--------------------------------------------------------

;--------------------------------------------------------------loop principal del pc counter -------------------
lop:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;carga la instruccion en r9
	cmp r9d,0					; si la intrucion es cero
	je sis						; brinca a sis
	call opcode					;llama la funcion de opcode para saber el tipo de instruccion MIPS (R,I,J)
	cmp r10d,0					;Compara si es cero de ser asi es una tipo R
	je Rformat					;brinca a las instrucciones tipo R
	cmp r10d,2h					;compara si el opcode es del J
	je j						;brinca a la instruccion jump
	cmp r10d,3h					;compara si el opcode es del 
	je jaal						;brinca a la funcion jump and link
	jmp Iformat					;brinca a las instrucciondes tipo I				
casi:							;Funcion de PC+4
	mov eax,[PC]					;Optengo el valor actual del PC					
	add eax,4					;sumo 4 a ese valor
	mov dword [PC],eax				;guardo el PC actualizado
comparar:
	mov r8,[reg+20]	
	cmp eax,600					;comparo si ya termino de recorrer la memoria del programa	
	jne lop						;brinco a lop para realizar la siguiente instruccion MIPS
;------------------------------------------------------------Imprecion del mensaje de salida---------------------------------------
salida:
	mov r8,[PC]					;muevo lo que hay en PC a r8				
	cmp r8,0
	jne sis
	
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, RNoFind
	mov rdx, lRNoFind
	Wfile RNoFind,lRNoFind
	syscall
;------------------------------------------------------------------------
; funcion para imprimir los requerimientos al final del programa
;-------------------------------------------------------------------------
sis:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, Exitosa
	mov rdx, lExitosa
	syscall
	Wfile Exitosa,lExitosa
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, Contenido
	mov rdx, lContenido
	syscall
	Wfile Contenido,lContenido
	
	call _Preg
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1

	mov rdi, 1					; sys write
	mov rax, 1
	mov rsi, int1
	mov rdx, len1
	syscall
	Wfile int1,len1


	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, int2
	mov rdx, len2
	syscall
	Wfile int2,len2

	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, int3
	mov rdx, len3
	syscall
	Wfile int3,len3
         
	push rbp
	mov rbp,rsp
	mov rdi,cadena
	call system                            
	
                                                   
	jmp _salir
;--------------------------------------------------------------salir del programa (el loop es muy raro XD)

;-------------------------------------------------
;mensaje indica argumento invalido
;-------------------------------------------------
invarg:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, argrande
	mov rdx, largrande
	syscall
	Wfile argrande,largrande
	jmp _salir

	

;-------------------------------------------------
;mensaje indica caracter invalido
;-------------------------------------------------
invcar:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, msjinvcar
	mov rdx, lmsjinvcar
	syscall
	Wfile msjinvcar,lmsjinvcar
	jmp _salir

	
;-------------------------------------------------
;mensaje indica function invalido
;-------------------------------------------------
invfun:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, msjfun
	mov rdx, lmsjfun
	syscall
	Wfile msjfun,lmsjfun
	mov r9,[PC]
	shr r9,2
	printVal r9
	Wfile msjfun,lmsjfun
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, Fallida
	mov rdx, lFallida
	syscall
	Wfile Fallida,lFallida
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	jmp _salir

;-------------------------------------------------
;mensaje indica opocde invalido
;-------------------------------------------------
invopcode:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, msjopcode
	mov rdx, lmsjopcode
	syscall
	mov r9,[PC]
	shr r9,2
	printVal r9
	
	Wfile msjopcode,lmsjopcode
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, Fallida
	mov rdx, lFallida
	syscall
	Wfile Fallida,lFallida
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	jmp _salir
;-------------------------------------------------
;mensaje indica direccion de memoria invalida
;-------------------------------------------------

drinv: 
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, msjdrinv
	mov rdx, lmsjdrinv
	syscall
	Wfile msjdrinv,lmsjdrinv
	mov r8,[PC]
	shr r8,2
	printVal r8
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp _salir
;-------------------------------------------------
;sale del programa
;-------------------------------------------------
_salir:	     
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, msj1
	mov rdx, lmsj1
	syscall
	Wfile enteer,1
	Wfile msj1,25
	Wfile enteer,1

	mov rdi, 0					; sys write	
	mov rax, 0	
	mov rsi, tecla
	mov rdx, 16
	syscall
      
	mov rax, 60					;sys_exit
	mov rdi, 0
	syscall
;-------------------------------------------------codigo para escribir las instrucciones ejecutadas--------------------------


_register:
	cmp r9d,0
	je zz
	mov r15d,r9d
	shl r15,2
	sub r15,4
	mov rcx,regis
	add rcx,r15
	mov rdi, 1					; sys write
	mov rax, 1
	mov rsi, rcx
	mov rdx, 3
	syscall

	cmp r15,0
	je _at
	cmp r15,4
	je _v0
	cmp r15,8
	je _v1
	cmp r15,12
	je _a0
	cmp r15,16
	je _a1
	cmp r15,20
	je _a2
	cmp r15,24
	je _a3
	cmp r15,28
	je _t0
	cmp r15,32
	je _t1
	cmp r15,36
	je _t2
	cmp r15,40
	je _t3
	cmp r15,44
	je _t4
	cmp r15,48
	je _t5
	cmp r15,52
	je _t6
	cmp r15,56
	je _t7
	cmp r15,60
	je _s0
	cmp r15,64
	je _s1
	cmp r15,68
	je _s2
	cmp r15,72
	je _s3
	cmp r15,76
	je _s4
	cmp r15,80
	je _s5
	cmp r15,84
	je _s6
	cmp r15,88
	je _s7
	cmp r15,92
	je _t8
	cmp r15,96
	je _t9
	cmp r15,100
	je _k0
	cmp r15,104
	je _k1
	cmp r15,108
	je _gp
	cmp r15,112
	je _sp
	cmp r15,116
	je _fp
	cmp r15,120
	je _ra
	ret
	
	
_at:
	Wfile regis,3
	ret
_v0:
	Wfile regis+4,3
	ret
_v1:
	Wfile regis+8,3
	ret
_a0:
	Wfile regis+12,3
	ret
_a1:
	Wfile regis+16,3
	ret
_a2:
	Wfile regis+20,3
	ret
_a3:
	Wfile regis+24,3
	ret
_t0:
	Wfile regis+28,3
	ret
_t1:
	Wfile regis+32,3
	ret
_t2:
	Wfile regis+36,3
	ret
_t3:
	Wfile regis+40,3
	ret
_t4:
	Wfile regis+44,3
	ret
_t5:
	Wfile regis+48,3
	ret
_t6:
	Wfile regis+52,3
	ret
_t7:
	Wfile regis+56,3
	ret
_s0:
	Wfile regis+60,3
	ret
_s1:
	Wfile regis+64,3
	ret
_s2:
	Wfile regis+68,3
	ret
_s3:
	Wfile regis+72,3
	ret
_s4:
	Wfile regis+76,3
	ret
_s5:
	Wfile regis+80,3
	ret
_s6:
	Wfile regis+84,3
	ret
_s7:
	Wfile regis+88,3
	ret
_t8:
	Wfile regis+92,3
	ret
_t9:
	Wfile regis+96,3
	ret
_k0:
	Wfile regis+100,3
	ret
_k1:
	Wfile regis+104,3
	ret
_gp:
	Wfile regis+108,3
	ret
_sp:
	Wfile regis+112,3
	ret
_fp:
	Wfile regis+116,3
	ret
_ra:	
	Wfile regis+120,3
	ret	
zz:
	mov rdi, 1					; sys write
	mov rax, 1
	mov rsi, regiszero
	mov rdx, 5
	syscall
	Wfile regiszero,5
	ret



;--------------------------------------------------------------funciones para la decodificacion de la instruccion

opcode:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,26					;Realizo un corrimiento a la derecha para dejar unicamente el valor del OPCODE
	and r9d,63					;limpio el resto del registro por si acaso.
	mov r10d,r9d					;guardo el OPCODE en r10d
	ret						;regreso donde se llamó
rsu:
	mov r8,[PC]					;Optengo el PC
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,21					;corrimiento a la derecha para dejar el valor del RS en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo rs
	call _register					;funcion para escribir el registro en  pantalla
	shl r9d,2					;multiplico RS por 4 para direccionar bytes en memoria				
	mov r12d,[reg+r9d]				;extraigo el valor continido en la direccion de memoria correspondiente a RS
	ret
rs:
	mov r8,[PC]					;Optengo el PC
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,21					;corrimiento a la derecha para dejar el valor del RS en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo rs
	call _register					;funcion para escribir el registro en  pantalla
	shl r9d,2					;multiplico RS por 4 para direccionar bytes en memoria				
	mov r12d,[reg+r9d]				;extraigo el valor continido en la direccion de memoria correspondiente a RS
	cmp r12,7fffffffh				;compara con 0111 1111 1111 1111
	jge extrs					;si es mayor indica bit de signo por lo que se aplica extension
	ret						;regreso donde se llamó

extrs: 
	mov r15,0ffffffff00000000h			;carga la extension de signo en rax
	or r12,r15					;aplica la extension
	ret
rtu:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,16					;corrimiento a la derecha para dejar el valor del RT en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo RT	
	call _register					;funcion para escribir el registro en  pantalla
	shl r9d,2					;multiplico RT por 4 para direccionar bytes en memoria				
	mov r13d,[reg+r9d]				;extraigo el valor contenido en la direccion de memoria correspondiente a RT
	ret						;regreso donde se llamó

rt:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,16					;corrimiento a la derecha para dejar el valor del RT en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo RT	
	call _register					;funcion para escribir el registro en  pantalla
	shl r9d,2					;multiplico RT por 4 para direccionar bytes en memoria				
	mov r13d,[reg+r9d]				;extraigo el valor contenido en la direccion de memoria correspondiente a RT
	cmp r13,7fffffffh				;compara con 0111 1111 1111 1111
	jge extrt					;si es mayor indica bit de signo por lo que se aplica extension
	ret						;regreso donde se llamó
extrt: 
	mov r15,0ffffffff00000000h			;carga la extension de signo en r15	
	or r13,r15					;aplica la extension
	ret
rd:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	shr r9d,11					;corrimiento a la derecha para dejar el valor del RD en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo RD
	call _register					;funcion para escribir el registro en  pantalla
	shl r9d,2					;multiplico RT por 4 para direccionar bytes en memoria
	cmp r9d,0					;compara con $zero
	je casi						;brinca pc+4 xq $zero no se puede modificar 
	mov r11d,r9d					;guardo el valor obtenido en r11d
	ret						;regreso donde se llamó


sham:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	shr r9d,6					;corrimiento a la derecha para dejar el valor del RD en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo SHAM
	mov r14d,r9d					;guardo el valor obtenido en r14d
	ret						;regreso dende me llamo

func:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,63					;limpio el resto del registro a partir del 6bit dejando solo SHAM
	mov r15d,r9d					;guardo el valor obtenido en r15d
	ret						;regreso dende me llamo

immu:
	mov r8, [PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,65535					;enmascaro unicamente los 16 bits del IMMEDITE
	mov r13, r9					;guardo el immedite en r13d
	ret						;regreso donde me llamo

imm:
	mov r8, [PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,65535					;enmascaro unicamente los 16 bits del IMMEDITE
	cmp r9d,07fffh					;compararacion para saber si es negativo
	jge ext						;si es negativo aplica extension de signo
volver:
	mov r13, r9					;guardo el immedite en r13d
	ret						;regreso donde me llamo
ext: 
	mov r11,0ffffffffffff0000h			;carga la extension de signo en r15
	or r9,r11					;aplica la extension
	jmp volver
	
address:
	mov r8, [PC]					;optengo el PC
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,03ffffffh				;enmascaro unicamente los 26 bits del address
	mov r13d, r9d					;guardo el address en r13d
	ret						;regreso donde se llamo
	
	
;------------------------------------------------------- define cual funcion r se ejecuta
Rformat:
	call func
	cmp r15d, 20h					;funcion del add
	je add						;brinca al add
	cmp r15d, 0h					;funcion del sll
	je sll						;brinca al sll
	cmp r15d, 25h					;funcion del or
	je or						;brinca al or
	cmp r15d, 27h					;funcion del nor
	je nor						;brinca al nor
	cmp r15d, 02h					;funcion del srl
	je srl						;brinca al srl
	cmp r15d, 22h					;funcion del sub
	je sub						;brinca al sub
	cmp r15d, 18h					;funcion del mult
	je mult						;brinca al mult
	cmp r15d, 08h					;funcion del jr
	je jr						;brinca jr
	cmp r15d, 2ah					;funcion del slt
	je slt						;brinca a slt
	cmp r15d, 12h					;funcion del mflo
	je mflo						;brinca a mflo	
	cmp r15d,21h					;funcion del addu
	je addu						;brinca a addu
	cmp r15d,23h					;funcion del subbu
	je subu						;brinca a subbu
	cmp r15d,2bh					;funcion del sltu
	je sltu						;brinca a sltu
	cmp r15d,24h					;funcion del sltu
	je and						;brinca a slt
	jmp invfun					;inidica function invalido

;--------------------------------------------------------define cual funcion i se ejecuta
Iformat:
	call opcode	
	cmp r10d, 8h					;opcode del addi
	je addi						;brinque al addi
	cmp r10d, 12					;opcode del andi
	je andi						;brinca al andi
	cmp r10d, 13					;opcode del ori
	je ori						;brinca al ori
	cmp r10d, 4h					;opcode del beq
	je beq						;brinca al beq
	cmp r10d, 5h					;opcode del bne
	je bne						;brinca al bne
	cmp r10d, 23h					;opcode del lw
	je lw						;brinca al lw
	cmp r10d, 0ah					;opcode del slti
	je slti						;brinca al slti
	cmp r10d, 02bh					;opcode del sw
	je sw						;brinca al sw
	cmp r10d, 11					;opcode del sltiu
	je sltiu					;brinca al sltiu	
	jmp invopcode					;indica qeu el opcode es invalido


;------------------------------------------------------- funciones emulades de mips
add:
;----------------------imprime add
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc
	mov rdx, 4
	syscall
	Wfile instruc,4
	call rd						;Llamo a RT
	mov r14,r11					;se mueve a r11
;---------------------imprime una coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rs						;Llamo a rd	
;----------------------otra coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt						;llamo a RS
	add r12,r13					;sumo los datos optenidos en RS y RT
	mov dword [reg+r14d],r12d			;guard la operacion de suma en el registro RD

;------------------imprimo un enter
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4
and:
;----------------------imprime add
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+14
	mov rdx, 4
	syscall
	Wfile instruc+14,4
	call rd						;Llamo a RT
	mov r14,r11					;se mueve a r11
;---------------------imprime una coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rs						;Llamo a rd	
;----------------------otra coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt						;llamo a RS
	and r12,r13					;sumo los datos optenidos en RS y RT
	mov dword [reg+r14],r12d			;guard la operacion de suma en el registro RD

;------------------imprimo un enter
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

sll:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+74
	mov rdx, 4
	syscall
	Wfile instruc+74,4
	call rd						;llamo RD
	mov r10,r11
;---------------------imprimo una coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall		
	Wfile coma,1
	call rt						;Llamo a RT
	
;---------------------otra coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call sham					;Llamo a SHAM
	mov cl, r14b					;muevo la cantidad de corrimientos a CL
	shl r13d,cl					;realizo el corrimiento
	mov dword [reg+r10d],r13d			;Guardo el dato operado en la direccion del RD
	printVal r14

;---------------------imprimo el enter
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4
srl:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+78
	mov rdx, 4
	syscall
	Wfile instruc+78,4
	call rd						;llamo RD
	mov r10,r11
;---------------------imprimo una coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall		
	Wfile coma,1
	call rt						;Llamo a RT
	
;---------------------otra coma
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call sham					;Llamo a SHAM
	mov cl, r14b					;muevo la cantidad de corrimientos a CL
	shr r13d,cl					;realizo el corrimiento
	mov dword [reg+r10d],r13d			;Guardo el dato operado en la direccion del RD
	printVal r14

;---------------------imprimo el enter
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4
or:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+47
	mov rdx, 3
	syscall
	Wfile instruc+47,3
	call rd						;llamo a RD
	mov r14,r11

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rs						;llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rt						;llamo a RT

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	or r12,r13					;realizo la or con los dos registros
	mov dword [reg+r14d],r12d			;Guardo el dato operado en la direccion del RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

nor:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+43
	mov rdx, 4
	syscall
	Wfile instruc+43,4
	call rd						;llamo RD	
	mov r14,r11

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt						;Llamo a RT
	or r12,r13					;realizo la or con los datos obtenidos por RS y RT
	not r12						;niego la operacion or
	mov dword [reg+r14d],r12d			;Guardo el dato operado en la direccion del RD
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	
	jmp casi					;Voy a la parte de codigo donde hago PC+4


sub:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+82
	mov rdx, 4
	syscall
	Wfile instruc+82,4
	call rd
	mov r14, r11

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt						;Llamo a RT
	

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1

	sub r12,r13
	mov dword [reg+r14d],r12d
	jmp casi					;Voy a la parte de codigo donde hago PC+4

addi:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+4
	mov rdx, 5
	syscall
	Wfile instruc+4,5
	call rt						;llamo a RT

	mov r14,r9
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm					;Llamo a IMMEDITE

	add r12, r13					;sumo el registro con el valor ingresado
	mov dword [reg+r14d],r12d			;guard la operacion de suma en el registro RD

	printVal r13
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

andi:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+18
	mov rdx, 5
	syscall
	Wfile instruc+18,5
	call rt						;llamo a RT
	mov r14,r9
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm					;Llamo a IMMEDITE
	and r12, r13					;realizo la and con el dato ingresado
	mov dword [reg+r14d], r12d			;rt=rs + imm
	
	printVal  r13	
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

ori:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+50
	mov rdx, 5
	syscall
	Wfile instruc+50,5
	call rt						;llamo a RD
	mov r14,r9
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm					;Llamo a IMMEDITE
	or r12,r13					;aplico el or con el dato ingresado
	mov dword [reg+r14d],r12d 			;rt=rs or imm			

	printVal r13

	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall	
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

jr:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+37
	mov rdx, 3
	syscall
	Wfile instruc+37,3
	call rs						;Llamo a RS
	Wfile enteer,1
	mov dword [PC],r12d 				;rt=rs or imm----muevo la direccion contenida en $ra al PC
	
	mov rdi, 1
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall	
	jmp comparar;						;a lop sin hacer PC+4

slt:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+54
	mov rdx, 4
	syscall
	Wfile instruc+54,4
	call rd						;Llamo a RD
	mov r14, r11

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1

	call rt						;Llamo a RT

	cmp r12,r13					;comparo lo contenido en RD y RT
	jl poneuno					;si se cumple voy a agregar un 1
	mov dword [reg+r14d], 0				;pongo 0 si la condicion no se cumple
	
	mov rdi,1		
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	
	jmp casi					;Voy a la parte de codigo donde hago PC+4
poneuno:
	mov dword [reg+r14d],1					;pongo 1 si la condicion se cumple
	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall	
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

mult:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+91
	mov rdx, 5
	syscall
	Wfile instruc+91,5
	call rs						;Llamo a RS

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt						;Llamo a RT
	imul r12,r13					;realizo la multiplicacion
	mov [prueba], r12d

	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

mflo:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc + 96
	mov rdx, 5
	syscall
	Wfile instruc+96,5
	call rd						;Llamo a RD
	mov r11d,[prueba]				;muevo el registro LOW de la multiplicacion  a RD
	
	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

j:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc + 31
	mov rdx, 2
	syscall
	Wfile instruc+31,2
	call address					;llamo al address
	
	shl r13d,2					;hago un corrimiento al address
	cmp r13, 600d					;compara con la mayor direccion 
	jge drinv					;inidca que la direccion no es valida
	mov dword [PC],r13d				;guardo la direccion optenida en el PC

	printVal r13
	
	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jmp lop						;ejecuta la instruccion 

beq:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+23
	mov rdx,4
	syscall
	Wfile instruc+23,4
	call rs						;llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall	
	Wfile coma,1
	call rt						;Llamo a RT
	
	mov r10,r13
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	cmp r12,r10					;comparo r12d con r13d
	
	call imm					;optengo el immediate o direccion
	printVal r13	
	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	jne casi					;brinque a casi si no se cumple la condicion 

	shl r13d, 2					;multiplico por 4 para moverme en memoria
	mov eax, [PC]					;cargo la direccion en PC
	add rax, r13					;sumo el immediate al PC
	mov dword [PC], eax				;guardo el nuevo PC
	jmp casi					;realizo un PC+4					

bne:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+27
	mov rdx,4
	syscall
	Wfile instruc+27,4
	call rs
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call rt

	mov r10,r13
	mov rdi, 1					; sys write	
	mov rsi, coma
	mov rax, 1
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm
	printVal r13
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall
	Wfile enteer,1
	cmp r12,r10
	je casi
	
	shl r13d, 2
	mov eax, [PC]
	add rax, r13
	mov dword [PC], eax
	jmp casi
lw:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+40
	mov rdx,3
	syscall
	Wfile instruc+40,3
	call rt						;llama rt
	mov r14,r9
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm					;llama el immediate
	printVal r13	
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, par1
	mov rdx, 1
	syscall
	Wfile par1,1
	call rs						;llama rs
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, par2
	mov rdx, 1
	syscall
	Wfile par2,1
	add r12, r13					;los suma
	cmp r12,797
	jge drinv

	mov r11d, [data+r12d]				;muev el dato a un registro
_rev:
	mov dword [reg+r14d],r11d ;			;guarda en rt

	mov rdi,1	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall	
	Wfile enteer,1
	jmp casi
sw:
;-----------------------imprime la instrucion
	mov r8,[reg+116]
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+101
	mov rdx,3
	syscall
	Wfile instruc+101,3
	call rt						;llama rt
	mov r10,r13
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx, 1
	syscall
	Wfile coma,1
	call imm					;llama el immediate	
	printVal r13
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, par1
	mov rdx, 1
	syscall
	Wfile par1,1
	call rs					;llama rs
	add r12, r13					;los suma		
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, par2
	mov rdx, 1
	syscall
	Wfile par2,1

	cmp r12,797
	jge drinv
	
	mov dword [data+r12d],r10d;			;guarda rt en memoria
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx, 1
	syscall	
	Wfile enteer,1
	jmp casi

jaal:
;-----------------------imprime la instrucion	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+33
	mov rdx,4
	syscall
	Wfile instruc+33,4
	call address					;llamo al address
	printVal r13	
	shl r13d,2					;hago un corrimiento al address
	cmp r13d, 600					;compara con la mayor direccion 
	jge drinv					;inidca que la direccion no es valida
	mov r9d,[PC]					;obtengo el pc
	add r9d, 4					;obtengo el pc+4
	mov [reg+124],r9d				;guardo el pc+4 actual en el $ra registro 31 
	mov dword [PC],r13d				;guardo la direccion optenida en el PC
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall	
	Wfile enteer,1
	jmp lop						;va a la direccion 

slti:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+58
	mov rdx,5
	syscall
	Wfile instruc+58,5
	call rt
	mov r14,r13					;Llamo a RD
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call rs						;Llamo a RS
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call imm					;Llamo a immediate

	printVal r13

	cmp r12,r13					;comparo lo contenido en RS y RT
	jl pone1					;si se cumple voy a agregar un 1	
	mov dword [reg+r14d], 0					;pongo 0 si la condicion no se cumple
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	Wfile enteer,1	
	jmp casi					;Voy a la parte de codigo donde hago PC+4
pone1:
	
	mov dword [reg+r14d],1				;pongo 1 si la condicion se cumple
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall	
	Wfile enteer,1
	jmp casi					;Voy a la parte de codigo donde hago PC+4

sltu:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+69
	mov rdx,5
	syscall	
	Wfile instruc+69,5
	call rd
	mov r14,r11
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall	
	Wfile coma,1
	call rsu
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call rtu
	
	cmp r12,r13
	jl pone11
	mov dword [reg+r14d],0
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall	
	Wfile enteer,1
	jmp casi
pone11:
	mov dword [reg+r14d],0
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	jmp casi
sltiu:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+63
	mov rdx,6
	syscall
	Wfile instruc+63,6
	call rtu
	
	mov r14,r9
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call rsu
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call immu
	
	printVal r13
	
	cmp r12,r13
	jl pone1
	mov dword [reg+r14d],0
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	jmp casi
subu:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+86
	mov rdx,5
	syscall
	Wfile instruc+86,5
	call rd
	mov r14,r11
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call rsu
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	syscall
	Wfile coma,1
	call rtu
	
	sub r12,r13
	mov dword [reg+r14d],r12d
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	jmp casi
	Wfile enteer,1
	syscall
addu:
;-----------------------imprime la instrucion
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, instruc+9
	mov rdx,5
	syscall
	Wfile instruc+9,5
	call rtu
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, coma
	mov rdx,1
	Wfile coma,1
	call rsu
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi,coma
	mov rdx,1
	Wfile coma,1
	call rd
	
	add r12,r13
	mov dword [reg+r11d],r12d
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	jmp casi
_Preg:
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+4
	mov rdx,3
	syscall
	Wfile regis+4,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+8]	
	printVal r9
	Wfile r9,1
	Wfile tab,1

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+64
	mov rdx,3
	syscall
	Wfile regis+64,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+68]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+112
	mov rdx,3
	syscall
	Wfile regis+112,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+116]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1


	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+8
	mov rdx,3
	syscall
	Wfile regis+8,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+12]	
	printVal r9
	Wfile r9,1
	Wfile tab,1

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+68
	mov rdx,3
	syscall
	Wfile regis+68,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+72]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+12
	mov rdx,3
	syscall
	Wfile regis+12,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+16]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+72
	mov rdx,3
	syscall
	Wfile regis+72,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+76]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+16
	mov rdx,3
	syscall
	Wfile regis+16,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+20]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+76
	mov rdx,3
	syscall
	Wfile regis+76,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+80]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+20
	mov rdx,3
	syscall
	Wfile regis+20,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+24]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+80
	mov rdx,3
	syscall
	Wfile regis+80,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+84]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+24
	mov rdx,3
	syscall
	Wfile regis+24,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+28]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+84
	mov rdx,3
	syscall
	Wfile regis+84,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+88]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+60
	mov rdx,3
	syscall
	Wfile regis+60,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+64]	
	printVal r9
	Wfile r9,1
	Wfile tab,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, tab
	mov rdx,1
	syscall

	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, regis+88
	mov rdx,3
	syscall
	Wfile regis+88,3
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, igual
	mov rdx,1
	syscall
	Wfile igual,1
	mov r9d,[reg+92]	
	printVal r9
	Wfile r9,1
	mov rdi, 1					; sys write	
	mov rax, 1
	mov rsi, enteer
	mov rdx,1
	syscall
	Wfile enteer,1
	
	ret
	
	
;00000000101001000010100000100000
;00001000000000000000000000001100

;00100011101111011111111111111000
;00100000101010001111111111111111
;10101111101010000000000000000000
;10101111101111110000000000000100
;00010100101000000000000000000011
;00000000000000000001000000100000
;00100011101111010000000000001000
;00000011111000000000000000001000
;00000000000010000010100000100000
;00001100000000000000000000000000
;10001111101010000000000000000000
;00000000000010000100100100000000
;00000000100010010100100000100000
;10001101001010100000000000000000
;00000000010010100001000000100000
;10001111101111110000000000000100
;00100011101111010000000000001000
;00000011111000000000000000001000
	
;00000000010010100001000000100000
