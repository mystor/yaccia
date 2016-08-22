# -*- gas -*-

# rsi = from, rdi = to, rdx = length
memcpy:
              cmp   rdx, 0
              je    _memcpy_done
              movb  al, [rsi]
              movb  [rdi], al
              inc   rsi
              inc   rdi
              dec   rdx
              jmp   memcpy
_memcpy_done:
              ret
