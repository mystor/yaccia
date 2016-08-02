# -*- gas -*-
# A bunch of simple defines for basic numbers etc.
              .Set  SYS_READ, 0
              .Set  SYS_WRITE, 1
              .Set  SYS_OPEN, 2
              .Set  SYS_CLOSE, 3
              .Set  SYS_EXIT, 60

              .Set  STDIN, 0
              .Set  STDOUT, 1
              .Set  STDERR, 2

# Implementation code and logic for the printf macro, which prints a
# formatted string to the screen.
              .Macro pushstr str
              LOCAL literal
              .Data
literal:      .Asciz str
              .Text
              push  offset literal
              .Endm

              .Macro printf, str
              pushstr str
              call  do_printf
              .Endm

              .Set  all_regs_size, 112
              .Macro nonrec_save_all_regs to
              mov   [to+0], rax
              mov   [to+8], rbx
              mov   [to+16], rcx
              mov   [to+24], rdx
              mov   [to+32], rsi
              mov   [to+40], rdi
              mov   [to+48], r8
              mov   [to+56], r9
              mov   [to+64], r10
              mov   [to+72], r11
              mov   [to+80], r12
              mov   [to+88], r13
              mov   [to+96], r14
              mov   [to+104], r15
              .Endm
              .Macro nonrec_restore_all_regs from
              mov   rax, [from+0]
              mov   rbx, [from+8]
              mov   rcx, [from+16]
              mov   rdx, [from+24]
              mov   rsi, [from+32]
              mov   rdi, [from+40]
              mov   r8, [from+48]
              mov   r9, [from+56]
              mov   r10, [from+64]
              mov   r11, [from+72]
              mov   r12, [from+80]
              mov   r13, [from+88]
              mov   r14, [from+96]
              mov   r15, [from+104]
              .Endm

              .Comm _printf_regs, all_regs_size # Place to store regs while running printf

              .Text
do_printf:
              nonrec_save_all_regs _printf_regs
              pop   r10             # Put the return value in r10 so that we can use the stack
              pop   r8              # Load the format string
              mov   r9, r8
_printf_loop:
              cmpb  [r9], 0
              je    _printf_eos
              cmpb  [r9], '%'
              je    _printf_format
              inc   r9
              jmp   _printf_loop
_printf_format:
# Print the string so far
              mov   rax, SYS_WRITE
              mov   rsi, r8
              mov   rdx, r9
              sub   rdx, rsi
              mov   rdi, STDOUT
              syscall
              inc   r9
              cmpb  [r9], 's'
              je    _printf_format_str
              cmpb  [r9], 'd'
              je    _printf_format_signed
              cmpb  [r9], 'u'
              je    _printf_format_unsigned
              cmpb  [r9], 'c'
              je    _printf_format_char
              jmp   _printf_format_none
_printf_format_str:
              inc   r9
              pop   rax
              call  print_str
              mov   r8, r9
              jmp   _printf_loop
_printf_format_signed:
              inc   r9
              pop   rax
              call  print_signed
              mov   r8, r9
              jmp   _printf_loop
_printf_format_unsigned:
              inc   r9
              pop   rax
              call  print_unsigned
              mov   r8, r9
              jmp   _printf_loop
_printf_format_char:
              inc   r9
              pop   rax
              call  print_char
              mov   r8, r9
              jmp   _printf_loop
_printf_format_none:
              mov   rax, SYS_EXIT
              mov   rdi, 15
              syscall
_printf_eos:
# Load the length into rdx
              mov   rax, SYS_WRITE
              mov   rsi, r8
              mov   rdx, r9
              sub   rdx, rsi
              mov   rdi, STDOUT
              syscall
              push  r10
              nonrec_restore_all_regs _printf_regs
              ret

strlen:
              mov   rbx, rax
_strlen_loop:
              cmpb  [rax], 0
              je    _strlen_done
              inc   rax
              jmp   _strlen_loop
_strlen_done:
              sub   rax, rbx
              ret

print_str:
              push  rax
              call  strlen
              mov   rdx, rax
              pop   rsi
              mov   rdi, STDOUT
              mov   rax, SYS_WRITE
              syscall
              ret

              .Data
_print_signed_neg_sign:
              .Ascii "-"

              .Text
print_signed:
              cmp   rax, 0
              jge   _print_signed_pos
_print_signed_neg:
              push  rax
              mov   rax, SYS_WRITE
              mov   rdi, STDOUT
              mov   rsi, offset _print_signed_neg_sign
              mov   rdx, 1
              syscall
              pop   rax
              neg   rax
_print_signed_pos:
              call  print_unsigned
              ret

              .Comm _print_unsigned_buf, 256
print_unsigned:
              push  r8
              push  r9
              mov   r9, 0
              mov   r8, rax
_print_unsigned_loop:
              xor   rdx, rdx
              mov   rax, r8
              mov   rcx, 10         # divide input number by 10
              div   rcx
              mov   r8, rax         # save the new value back into r8
              add   rdx, '0'        # offset remainder by char code for '0'
              sub   rsp, 1
              mov   [rsp], dl
              inc   r9
              cmp   r8, 0
              jne   _print_unsigned_loop
_print_unsigned_done:
              mov   rax, SYS_WRITE
              mov   rdi, STDOUT
              mov   rsi, rsp
              mov   rdx, r9
              syscall
              add   rsp, r9
              pop   r9
              pop   r8
              ret

              .Comm _print_char_buf, 1
print_char:
              cmp   al, 32
              jge   _print_char_visible
              call  print_unsigned
              ret
_print_char_visible:
              mov   _print_char_buf, al
              mov   rax, SYS_WRITE
              mov   rdi, STDOUT
              mov   rsi, offset _print_char_buf
              mov   rdx, 1
              syscall
              ret

