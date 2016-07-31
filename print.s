	// A bunch of simple defines for basic numbers etc.
	.set SYS_READ, 0
	.set SYS_WRITE, 1
	.set SYS_OPEN, 2
	.set SYS_CLOSE, 3
	.set SYS_EXIT, 60

	.set STDIN, 0
	.set STDOUT, 1
	.set STDERR, 2

  // Implementation code and logic for the printf macro, which prints a
  // formatted string to the screen.
.macro pushstr str
	LOCAL literal
  .data
literal: .asciz str
  .text
  push offset literal
.endm

.macro printf, str
  pushstr str
  call do_printf
.endm

  .text
.comm _printf_r8, 8 # Cache for register values while calling printf
.comm _printf_r9, 8
.comm _printf_r10, 10

do_printf:
  mov _printf_r8, r8 # Save registers across calls
  mov _printf_r9, r9
  mov _printf_r10, r10
  pop r10 # Put the return value in r10 so that we can use the stack
  pop r8 # Load the format string
  mov r9, r8
_printf_loop:
  cmpb [r9], 0
  je _printf_eos
  cmpb [r9], '%'
  je _printf_format
  inc r9
  jmp _printf_loop
_printf_format:
  // Print the string so far
  mov rax, SYS_WRITE
  mov rsi, r8
  mov rdx, r9
  sub rdx, rsi
  mov rdi, STDOUT
  syscall
  inc r9
  cmpb [r9], 's'
  je _printf_format_str
  cmpb [r9], 'd'
  je _printf_format_signed
  cmpb [r9], 'u'
  je _printf_format_unsigned
  jmp _printf_format_none
_printf_format_str:
  inc r9
  pop rax
  call print_str
  mov r8, r9
  jmp _printf_loop
_printf_format_signed:
  inc r9
  pop rax
  call print_signed
  mov r8, r9
  jmp _printf_loop
_printf_format_unsigned:
  inc r9
  pop rax
  call print_unsigned
  mov r8, r9
  jmp _printf_loop
_printf_format_none:
  mov rax, SYS_EXIT
  mov rdi, 15
  syscall
_printf_eos:
  // Load the length into rdx
  mov rax, SYS_WRITE
  mov rsi, r8
  mov rdx, r9
  sub rdx, rsi
  mov rdi, STDOUT
  syscall
  push r10
  mov r10, _printf_r10
  mov r9, _printf_r9
  mov r8, _printf_r8
  ret

strlen:
  mov rbx, rax
_strlen_loop:
  cmpb [rax], 0
  je _strlen_done
  inc rax
  jmp _strlen_loop
_strlen_done:
  sub rax, rbx
  ret

print_str:
  push rax
  call strlen
  mov rdx, rax
  pop rsi
  mov rdi, STDOUT
  mov rax, SYS_WRITE
  syscall
  ret

  .data
_print_signed_neg_sign:
  .ascii "-"

  .text
print_signed:
  cmp rax, 0
  jge _print_signed_pos
_print_signed_neg:
  push rax
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, offset _print_signed_neg_sign
  mov rdx, 1
  syscall
  pop rax
  neg rax
_print_signed_pos:
  call print_unsigned
  ret

.comm _print_unsigned_buf, 256
print_unsigned:
  push r8
  push r9
  mov r9, 0
  mov r8, rax
_print_unsigned_loop:
  xor rdx, rdx
  mov rax, r8
  mov rcx, 10  # divide input number by 10
  div rcx
  mov r8, rax  # save the new value back into r8
  add rdx, '0' # offset remainder by char code for '0'
  sub rsp, 1
  mov [rsp], dl
  inc r9
  cmp r8, 0
  jne _print_unsigned_loop
_print_unsigned_done:
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, rsp
  mov rdx, r9
  syscall
  add rsp, r9
  pop r9
  pop r8
  ret
