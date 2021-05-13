global _start
	extern printf
	extern exit
	
section .data
	format: db '%d', 10, 0
	title: db 'Fib numbers', 10, 0

section .text
_start:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	mov rdi, title
	push rdi
	xor rax, rax
	call printf
	mov rcx, 20
	mov rax, 0
	mov rbx, 1
	
loop1:
	push rax
	push rcx
	mov rdi, format
	mov rsi, rax
	xor rax, rax
	call printf
	pop rcx
	pop rax
	mov rdx, rax
	mov rax, rbx
	add rbx, rdx
	dec rcx
	jne loop1
	
	pop rbx
	add rsp, 8
	mov rsp, rbp
	pop rbp
	call exit


