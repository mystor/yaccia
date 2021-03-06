# -*- gas -*-
              .Set  STRINGS_BUF_CAP, 1048576
              .Comm strings_buf_len, 8
              .Comm strings_buf, STRINGS_BUF_CAP

              .Section .rodata
_next_token_jmptbl:
# Include the generated table lexjmptbl.s. This table is generated by the
# python script gen_lexjmptbl.py
              .Include "lexjmptbl.s"

              .Comm token_type, 8
              .Comm token_data, 8

              .Macro token_combine chr, label
              LOCAL no_match, match
              call  peek_chr
              cmp   rax, chr
              jne   no_match
match:
              call  next_chr
              jmp   label
no_match:
              .Endm

              .Macro token_ret tok, data
              movq  token_data, data
              movq  token_type, tok
              ret
              .Endm

              .Text
next_token:
_next_token_ignore:
              call  peek_chr
              cmp   rax, -1
              je    _next_token_eof
              cmp   rax, 127
              ja    _next_token_invalid

              push  rax # Preserve the current char value
              call  next_chr
              pop   rax

              jmp   [_next_token_jmptbl+rax*8]
_next_token_eof:
              token_ret TOK_EOF, 0
_next_token_invalid:
              mov   rax, 60
              mov   rdi, 1
              syscall
              ret
_next_token_ident:
# Save the first char
              mov   rcx, strings_buf_len
              lea   rdx, strings_buf[rcx]
              mov   token_data, rdx
              movb  strings_buf[rcx], al
              incq  strings_buf_len
              jmp   _next_token_ident_start
_next_token_ident_loop:
              mov   rcx, strings_buf_len
              movb  strings_buf[rcx], al
              incq  strings_buf_len
              call  next_chr
_next_token_ident_start:
              call  peek_chr
              cmp   rax, '_'
              je    _next_token_ident_loop
              cmp   rax, 'A'
              jb    _next_token_ident_done
              cmp   rax, 'Z'
              jbe   _next_token_ident_loop
              cmp   rax, 'a'
              jb    _next_token_ident_done
              cmp   rax, 'z'
              jbe   _next_token_ident_loop
_next_token_ident_done:
              mov   rcx, strings_buf_len # Add a null to the end of the string
              movb  strings_buf[rcx], 0
              incq  strings_buf_len
              movq  token_type, TOK_IDENT
              ret

_next_token_int:
              sub   rax, '0'
              mov   rbx, rax
              push  rbx
              jmp   _next_token_int_start
_next_token_int_loop:
              imul  rbx, 10
              sub   rax, '0'
              add   rbx, rax
              push  rbx
              call  next_chr
_next_token_int_start:
              call  peek_chr
              pop   rbx
              cmp   rax, '0'
              jl    _next_token_int_done
              cmp   rax, '9'
              jle   _next_token_int_loop
_next_token_int_done:
# rbx already contains the value
              token_ret TOK_INT, rbx

_next_token_str:
# Save the first char
              mov   rcx, strings_buf_len
              lea   rdx, strings_buf[rcx]
              mov   token_data, rdx
_next_token_str_loop:
              call  peek_chr
              mov   rcx, strings_buf_len
              movb  strings_buf[rcx], al
              incq  strings_buf_len
              call  next_chr
              call  peek_chr
              cmp   rax, 34 # 34 is double quote
              je    _next_token_str_done
              cmp   rax, '\\'
              je    _next_token_str_special
              cmp   rax, -1
              je    _next_token_str_unclosed

              jmp   _next_token_str_loop
_next_token_str_special:
# XXX: IMPLEMENT
              jmp   _next_token_str_loop
_next_token_str_done:
              call next_chr
              mov   rcx, strings_buf_len # Add a null to the end of the string
              movb  strings_buf[rcx], 0
              incq  strings_buf_len
              movq  token_type, TOK_STR
              ret
_next_token_str_unclosed:
              printf "Unexpected unclosed string\n"
              exit 100

_next_token_char:
              printf "Looking at a char start...\n"
              exit  0

_next_token_eq:
              token_combine '=', _next_token_eqeq
              token_ret TOK_EQ, 0
_next_token_eqeq:
              token_ret TOK_EQEQ, 0
_next_token_add:
              token_ret TOK_ADD, 0
_next_token_sub:
              token_ret TOK_SUB, 0
_next_token_mul:
              token_ret TOK_MUL, 0
_next_token_div:
              token_ret TOK_DIV, 0
_next_token_dot:
              token_ret TOK_DOT, 0
_next_token_not:
              token_ret TOK_NOT, 0
_next_token_and:
              token_ret TOK_AND, 0
_next_token_or:
              token_ret TOK_OR, 0
_next_token_lparen:
              token_ret TOK_LPAREN, 0
_next_token_rparen:
              token_ret TOK_RPAREN, 0
_next_token_lbracket:
              token_ret TOK_LBRACKET, 0
_next_token_rbracket:
              token_ret TOK_RBRACKET, 0
_next_token_lbrace:
              token_ret TOK_LBRACE, 0
_next_token_rbrace:
              token_ret TOK_RBRACE, 0
_next_token_comma:
              token_ret TOK_COMMA, 0
_next_token_lt:
              token_ret TOK_LT, 0
_next_token_gt:
              token_ret TOK_GT, 0
