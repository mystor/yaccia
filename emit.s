# -*- gas -*-
              .Macro EMIT_START
              jmp 200f
100:
              .Endm

              .Macro EMIT_END
200:
              mov   rsi, offset 100b
              mov   rdx, offset 200b
              sub   rdx, rsi
              call  write_text
              .Endm

discard_val:
              EMIT_START
              pop   rax
              EMIT_END
              ret

emit_assign:
              printf "ASSIGN\n"
              mov   rsi, offset _assign_code
              mov   rdx, _assign_code.end - _assign_code
              call  write_text
              ret

_assign_code:
              pop   rbx
              mov   [rbx], rax
              mov   rax, rbx
_assign_code.end:

emit_bitwise_or:
              EMIT_START
              pop   rbx
              or    rax, rbx
              EMIT_END
              ret

emit_bitwise_and:
              EMIT_START
              pop   rbx
              and   rax, rbx
              EMIT_END
              ret

emit_logical_eq:
              printf "LOGICAL EQ\n"
              EMIT_START
              pop   rbx
              cmp   rax, rbx
              je    SHORT 1f
              mov   rax, 0
              jmp   SHORT 2f
1:
              mov   rax, 1
2:
              EMIT_END
              ret

emit_add:
              printf "ADD\n"
              EMIT_START
              add   [rsp], rax
              pop   rax
              EMIT_END
              ret

emit_sub:
              printf "SUB\n"
              EMIT_START
              sub   [rsp], rax
              pop   rax
              EMIT_END
              ret

emit_int:
              push  rax
              printf "INT %d\n"
              push  rax             # save rax before prefix avoiding clobbering

              EMIT_START
              push  rax
              .Byte 0x48
              .Byte 0xb8
              EMIT_END

              mov   rsi, rsp
              mov   rdx, 8
              call  write_text

              pop   rax
              ret

emit_str_lit:
              push  rax
              printf "STR %s\n"
              ret

