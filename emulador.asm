
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
	msj1 db "Presione Enter para salir:",0xa
	lmsj1: equ $- msj1
	int1: db "Jorge Jimenez Mora       2014085036",0xa
	len1: equ $-int1
	int2: db "Jose Hernandez Castro    2014086307",0xa
	len2: equ $-int2
	int3: db "Gabino Venegas Rodriguez 2014013616",0xa
	len3: equ $-int3

section .bss
	text resb 4950 ;rom
	mem resb 600   ;memoria de programa
	data resb 400 ;memoria de datos
	stack resb 400 ; capacidad de cien palabras
	reg resb 128    ;banco de registros
	tecla resb 16
	PC resb 4      ;registro para pc
	mflos resb 4	;registro para guardar los valores en operacion mult
	mfhis resb 4 	;registro para guardar los valores en operacion mult
	
section .text
	global _start
_start:
	mov dword [PC], 0
;-----------------------------------------------INPRIMO EL MENSAJE DE BIENVENIDA-----------------------------------------------
	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, welcome
	mov rdx, lwelcome
	syscall
 
	mov rdi, 1; sys write	
	mov rax, 1
	mov rsi, int2
	mov rdx, len2
	syscall
	
	mov rdi, 1; sys write	
	mov rax, 1
	mov rsi, bienv3
	mov rdx, lbienv3
	syscall

	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, busqR
	mov rdx, lbusqR
	syscall
;-----------------------------------------------OBTENCION Y ESCRITURA DE LA ROM------------------------------------------------
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
	mov rdx, 4950
	syscall
;si no se encuentra la rom se sale
	mov r14,[text]
	cmp r14,0
	je salida
	
	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, RFind
	mov rdx, lRFind
	syscall
;muestra buscando archivo rom
	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, msj
	mov rdx, lmsj
	syscall
	mov rax,0
	mov rdi,0
	mov rsi,tecla
	mov rdx, 16
	syscall


;funcion para cerrar el doc
	mov rax, 3 ; sys close
	pop rdi
	syscall

;--------------------------------------OBTENCION DE LAS FUNCIONES MIPS A PARTIR DE LA ROM---------------------------------------- 
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
	add r8,1
	cmp r8, r13
	jne loop

sigue:
	mov r12, r10
	shr r12, 3
	add r12,-4
	mov dword [mem+r12], r11d
	add r10,32
	add r13, 33
	mov r11, 0ffffffffffffffffh
	cmp r10, 3200
	jne loop

;------------------------------------------------IDENTIFICACION DE LA INSTRUCCION MIPS--------------------------------------------------------

;--------------------------------------------------------------loop principal del pc counter -------------------
lop:
	call opcode					;llama la funcion de opcode para saber el tipo de instruccion MIPS (R,I,J)
	cmp r10d,0					;Compara si es cero de ser asi es una tipo R
	je Rformat					;brinca a las instrucciones tipo R
	cmp r10d, 2h					;compara si el opcode es del J
	je j						;brinca a la instruccion jump
	;cmp r10d,3h					;compara si el opcode es del JAL
	;je jal						;brinca a la funcion jump and link
	jmp Iformat					;brinca a las instrucciondes tipo I
						
casi:							;Funcion de PC+4
	mov eax,[PC]					;Optengo el valor actual del PC					
	add eax,4					;sumo 4 a ese valor
	mov dword [PC],eax				;guardo el PC actualizado
	cmp eax,600					;comparo si ya termino de recorrer la memoria del programa
	jne lop						;brinco a lop para realizar la siguiente instruccion MIPS
	
;------------------------------------------------------------Imprecion del mensaje de salida---------------------------------------
salida:
	mov r8,[PC]
	cmp r8,0
	jne sis
	
	
	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, RNoFind
	mov rdx, lRNoFind
	syscall
	

sis:
	mov rdi, 1				; sys write	
	mov rax, 1
	mov rsi, msj1
	mov rdx, lmsj1
	syscall
	
	mov rdi, 0				; sys write	
	mov rax, 0
	mov rsi, tecla
	mov rdx, 16
	syscall

	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, int1
	mov rdx, len1
	syscall

	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, int2
	mov rdx, len2
	syscall

	mov rdi, 1; sys write
	mov rax, 1
	mov rsi, int3
	mov rdx, len3
	syscall
;--------------------------------------------------------------salir del programa (el loop es muy raro XD)
	mov rax, 60					;sys_exit
	mov rdi, 0
	syscall

;--------------------------------------------------------------funciones para la decodificacion de la instruccion

opcode:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,26					;Realizo un corrimiento a la derecha para dejar unicamente el valor del OPCODE
	and r9d,63					;limpio el resto del registro por si acaso.
	mov r10d,r9d					;guardo el OPCODE en r10d
	ret						;regreso donde se llamó
rs:
	mov r8,[PC]					;Optengo el PC
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,21					;corrimiento a la derecha para dejar el valor del RS en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo rs
	shl r9d,2					;multiplico RS por 4 para direccionar bytes en memoria
	mov dword [reg+r9d],4				
	mov r12d,[reg+r9d]				;extraigo el valor continido en la direccion de memoria correspondiente a RS
	ret						;regreso donde se llamó
rt:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC	
	shr r9d,16					;corrimiento a la derecha para dejar el valor del RT en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo RT
	shl r9d,2					;multiplico RT por 4 para direccionar bytes en memoria
	mov dword [reg+r9d],8				
	mov r13d,[reg+r9d]				;extraigo el valor continido en la direccion de memoria correspondiente a RT
	ret						;regreso donde se llamó
rd:
	mov r8,[PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	shr r9d,11					;corrimiento a la derecha para dejar el valor del RD en lo mas significativo
	and r9d,31					;limpio el resto del registro a partir del 5bit dejando solo RD
	shl r9d,2					;multiplico RT por 4 para direccionar bytes en memoria
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
imm:
	mov r8, [PC]					;Optengo el PC 
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,65535					;enmascaro unicamente los 16 bits del IMMEDITE
	mov r13d, r9d					;guardo el immedite en r13d
	ret						;regreso dende me llamo
address:
	mov r8, [PC]					;optengo el PC
	mov r9d,[mem+r8]				;Me muevo en la memoria de programa con el offset del PC
	and r9d,03ffffffh				;enmascaro unicamente los 26 bits del address
	mov r13d, r9d					;guardo el address en r13d
	ret						;regreso donde se llamo
	
	
;------------------------------------------------------- define cual funcion r se ejecuta
Rformat:
	call func
	cmp r15d,20h					;funcion del add
	je add						;brinca al add
	cmp r15d, 0h					;funcion del sll
	je sll						;brinca al sll
	call func					;
	cmp r15d,25h					;funcion del or
	je or						;brinca al or
	cmp r15d, 27h					;funcion del nor
	je sll						;brinca al nor
	cmp r15d,02h					;funcion del srl
	je srl						;brinca al srl
	cmp r15d, 22h					;funcion del sub
	je sub						;brinca al sub
	cmp r15d,18h					;funcion del mult
	je mult						;brinca al mult
	cmp r15d,10h					;funcion del mfhi
	je mfhi						;brinca mfhi
	cmp r15d,12h					;funcion del mflo
	je mflo						;brinca a mflo
	jmp casi					;regresa para realizar el PC+4


;--------------------------------------------------------define cual funcion i se ejecuta
Iformat:
	cmp r10d, 8h					;funcion del addi
	je addi						;brinque al addi
	cmp r10d, 0ch					;funcion del andi
	je andi						;brinca al andi
	cmp r10d, 0dh					;funcion del ori
	je ori						;brinca al ori

;------------------------------------------------------- funciones emulades de mips
add:
	call rs						;llamo a RS
	call rt						;Llamo a RT
	add r12d,r13d					;sumo los datos optenidos en RS y RT
	call rd						;Llamo a rd
	mov dword [reg+r11d],r12d			;guard la operacion de suma en el registro RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

sll:
	call rt						;Llamo a RT
	call sham					;Llamo a SHAM
	mov cl, r14b					;muevo la cantidad de corrimientos a CL
	shl r13d,cl					;realizo el corrimiento
	call rd						;llamo RD
	mov dword [reg+r11d],r13d			;Guardo el dato operado en la direccion del RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

or:
	call rs						;llamo a RS
	call rt						;llamo a RT
	or r12d,r13d					;realizo la or con los dos registros
	call rd						;llamo a RD
	mov dword [reg+r11d],r12d			;Guardo el dato operado en la direccion del RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

nor:
	call rs						;Llamo a RS
	call rt						;Llamo a RT
	or r12d,r13d					;realizo la or con los datos obtenidos por RS y RT
	not r12d					;niego la operacion or
	call rd						;llamo RD
	mov dword [reg+r11d],r12d			;Guardo el dato operado en la direccion del RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

srl:
	call rs						;Llamo a RS
	call rt						;Llamo a RT
	mov cl, r13b					;muevo el dato a correr a cl
	shr r12d, cl					;realizo el corrimiento
	call rd						;llamo RD
	mov dword [reg+r11d],r12d			;Guardo el dato operado en la direccion del RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

sub:
	call rs						;Llamo a RS
	call rt						;Llamo a RT
	sub r12d,r13d
	call rd
	mov dword [reg+r11d],r12d
	jmp casi					;Voy a la parte de codigo donde hago PC+4

addi:
	call rs						;Llamo a RS
	call imm					;Llamo a IMMEDITE
	add r12d, r13d					;sumo el registro con el valor ingresado
	call rt						;llamo a RT
	mov dword [reg+r9d], r12d 			;rt=rs + imm
	jmp casi					;Voy a la parte de codigo donde hago PC+4

andi:
	call rs						;Llamo a RS
	call imm					;Llamo a IMMEDITE
	and r12d, r13d					;realizo la and con el dato ingresado
	call rt						;llamo a RT
	mov dword [reg+r9d], r12d			;rt=rs + imm
	jmp casi					;Voy a la parte de codigo donde hago PC+4

ori:
	call rs						;Llamo a RS
	call imm					;Llamo a IMMEDITE
	or r12d,r13d					;aplico el or con el dato ingresado
	call rd						;llamo a RD
	mov dword [reg+r11d],r12d 			;rt=rs or imm			
	jmp casi					;Voy a la parte de codigo donde hago PC+4

jr:
	call rs						;Llamo a RS
	mov dword [PC],r12d 				;rt=rs or imm----muevo la direccion contenida en $ra al PC
	jmp lop						;a lop sin hacer PC+4

slt:
	call rs						;Llamo a RS
	call rt						;Llamo a RT
	call rd						;Llamo a RD
	cmp r12d,r13d					;comparo lo contenido en RD y RT
	jl poneuno					;si se cumple voy a agregar un 1
	mov r11d,0					;pongo 0 si la condicion no se cumple
	jmp casi					;Voy a la parte de codigo donde hago PC+4
poneuno:
	mov r11d,1					;pongo 1 si la condicion se cumple
	jmp casi					;Voy a la parte de codigo donde hago PC+4

mult:
	call rs						;Llamo a RS
	call rt						;Llamo a RT
	imul r12,r13					;realizo la multiplicacion
	mov dword [mflos],r12d
	jmp casi					;Voy a la parte de codigo donde hago PC+4

mflo:
	call rd						;Llamo a RD
	mov r11d,[mflos]				;muevo el registro LOW de la multiplicacion  a RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4
mfhi:
	call rd						;Llamo a RD
	mov r11d,[mfhis]				;muevo el registro HIGHT de la multiplicacion  a RD
	jmp casi					;Voy a la parte de codigo donde hago PC+4

j:
	call address					;llamo al address
	shl r13d,2					;hago un corrimiento al address
	mov r9d,[PC]					;optengo el pc
	and r9d,0f0000000h				;aplico mascara para obtener los 4 bits mas significativos del PC
	or r13d,r9d					;concateno los 4 bits del PC con el Address 
	mov dword [PC],r13d				;guardo la diresccion optenida en el PC
	jmp lop						;voy a realizar la instruccion indicada
beq:
	call rs						;llamo a RS
	call rt						;Llamo a RT
	cmp r12d,r13d					;comparo r12d con r13d
	jne casi					;brinque a casi si no se cumple la condicion 
	call imm					;optengo el immediate o direccion
	shl r13d, 2					;multiplico por 4 para moverme en memoria
	mov eax, [PC]					;cargo la direccion en PC
	add eax, r13d					;sumo el immediate al PC
	mov dword [PC], eax				;guardo el nuevo PC
	jmp casi					;realizo un PC+4					

bne:
	call rs
	call rt
	cmp r12d,r13d
	je casi
	call imm
	shl r13d, 2
	mov eax, [PC]
	add eax, r13d
	mov dword [PC], eax
	jmp casi
lw:
	call rs
	call imm
	add r12d, r13d
	shl r12d,2
	mov eax, 5
	mov dword [data+r12d], eax	
	mov r9d, [data+r12d]
	call rt
	mov dword [reg+r13d],r9d ;
	mov r11d, [reg+r13d]
	jmp casi

	

