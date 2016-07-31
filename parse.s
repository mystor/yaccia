# -*- gas -*-
parse_expr:
              call  parse_comma_expr
              ret

# Comma expression, execute left operand followed by right operand
parse_comma_expr:
              call  parse_assign_expr
_parse_comma_expr_loop:
              cmpq  token_type, TOK_COMMA
              jne   _parse_comma_expr_done
              call  next_token
              call  pop_type        # Discard the value of the last operand
              call  parse_assign_expr
              jmp   _parse_comma_expr_loop
_parse_comma_expr_done:
              ret

# Assignment expressions, execute left operand, set value to right operand
parse_assign_expr:
              call  parse_logical_or
_parse_assign_expr_loop:
              cmpq  token_type, TOK_EQ
              jne   _parse_assign_expr_done
              call  next_token
              call  parse_logical_or
              call  emit_assign
              jmp   _parse_assign_expr_loop
_parse_assign_expr_done:
              ret

parse_logical_or:
              call  parse_logical_and
              ret

parse_logical_and:
              call  parse_bitwise_or
              ret

parse_bitwise_or:
              call  parse_bitwise_xor
              ret

parse_bitwise_xor:
              call  parse_bitwise_and
              ret

parse_bitwise_and:
              call  parse_logical_eq
              ret

parse_logical_eq:
              call  parse_compare_expr
_parse_logical_eq_loop:
              cmpq  token_type, TOK_EQEQ
              jne   _parse_logical_eq_done
              call  next_token
              call  parse_compare_expr
              call  emit_logical_eq
              jmp   _parse_logical_eq_loop
_parse_logical_eq_done:
              ret

parse_compare_expr:
              call parse_bitwise_expr
              ret

parse_bitwise_expr:
              call  parse_add_sub_expr
              ret

parse_add_sub_expr:
              call  parse_mul_div_expr
_parse_add_sub_expr_loop:
              cmpq  token_type, TOK_ADD
              jne   _parse_add_sub_expr_sub
              call  next_token
              call  parse_mul_div_expr
              call  emit_add
              jmp   _parse_add_sub_expr_loop
_parse_add_sub_expr_sub:
              cmpq  token_type, TOK_SUB
              jne   _parse_add_sub_expr_done
              call  next_token
              call  parse_mul_div_expr
              call  emit_sub
              jmp   _parse_add_sub_expr_loop
_parse_add_sub_expr_done:
              ret

parse_mul_div_expr:
              call  parse_unary_expr
_parse_mul_div_expr_loop:
              cmpq  token_type, TOK_MUL
              jne   _parse_mul_div_expr_div
              call  next_token
              call  parse_unary_expr
              call  emit_add
              jmp   _parse_mul_div_expr_loop
_parse_mul_div_expr_div:
              cmpq  token_type, TOK_DIV
              jne   _parse_mul_div_expr_mod
              call  next_token
              call  parse_unary_expr
              call  emit_sub
              jmp   _parse_mul_div_expr_loop
_parse_mul_div_expr_mod:
              cmpq  token_type, TOK_MOD
              jne   _parse_mul_div_expr_done
              call  next_token
              call  parse_unary_expr
              call  emit_sub
              jmp   _parse_mul_div_expr_loop
_parse_mul_div_expr_done:
              ret

parse_unary_expr:
              call  parse_trailer_expr
              ret

parse_trailer_expr:
              call  parse_atom
              ret

parse_atom:
              cmpq  token_type, TOK_INT
              je    _parse_atom_int
              cmpq  token_type, TOK_CHAR
              je    _parse_atom_char
              cmpq  token_type, TOK_STR
              je    _parse_atom_str
              cmpq  token_type, TOK_IDENT
              je    _parse_atom_ident
              mov   rax, token_type
              pushq [TOK_names + rax*8]
              printf "Unexpected token %s\n"
              exit 100
_parse_atom_int:
_parse_atom_char:
              mov   rax, token_data
              call  emit_int
              call  next_token
              ret
_parse_atom_str:
              mov   rax, token_data
              call  emit_str_lit
              call  next_token
              ret
_parse_atom_ident:
              mov   rax, token_data
              push  rax
              printf "Identifier: %s\n"
              call  next_token
              ret
