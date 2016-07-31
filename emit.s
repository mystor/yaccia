# -*- gas -*-
pop_type:
              ret

emit_assign:
              printf "ASSIGN\n"
              ret

emit_logical_eq:
              printf "LOGICAL EQ\n"
              ret

emit_add:     
              printf "ADD\n"
              ret

emit_sub:
              printf "SUB\n"
              ret

emit_int:
              push  rax
              printf "INT %d\n"
              ret

emit_str_lit:
              push  rax
              printf "STR %s\n"
              ret

