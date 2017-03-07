section .data
regis db "$at,$v0,$v1,$a0,$a1,$a2,$a3,$t0,$t1,$t2,$t3,$t4,$t5,$t6,$t7,$s0,$s1,$s2,$s3,$s4,$s5,$s6,$s7,$t8,$t9,$k0,$k1,$gp,$sp,$fp,$ra"
section .text
	global main
main:
	mov rdi, 1					; sys write
	mov rax, 1
	mov rsi, regis+4
	mov rdx, 4
	syscall

	mov rax, 60					;sys_exit
	mov rdi, 0
	syscall

