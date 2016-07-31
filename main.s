# -*- gas -*-
# Enable the alternate macro extensions
              .Altmacro

              .Macro exit status
              mov   rdi, status
              mov   rax, SYS_EXIT
              syscall
              movb  [0], 1
              .Endm

# Defines "printf" which prints to STDOUT
              .Include "print.s"
              .Include "enums.s"
              .Include "read.s"
              .Include "lex.s"
              .Include "emit.s"
              .Include "parse.s"

              .Text
strcmp:
              mov   cl, [rax]
              mov   dl, [rbx]
              cmp   cl, dl
              jne   _strcmp_ne
              cmp   cl, 0
              je    _strcmp_cl0
              cmp   dl, 0
              je    _strcmp_ne
              inc   rax
              inc   rbx
              jmp   strcmp
_strcmp_cl0:
              cmp   dl, 0
              je    _strcmp_eq
_strcmp_ne:
              mov   rax, 1
              ret
_strcmp_eq:
              mov   rax, 0
              ret

              .Global _start
_start:
              # Read the first tokens and characters
              call  next_chr
              call  next_token
              # Parse an expression!
              call  parse_expr
              cmpq  token_type, TOK_EOF
              jne   _expected_eof
              exit 0
_expected_eof:
              mov rax, token_type
              pushq [TOK_names + rax*8]
              printf "Expected EOF, instead found %s\n"
              exit 100
