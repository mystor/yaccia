# -*- gas -*-

# Buffer space for read char lookahead
# These are all initialized as 0, which is a legal state,
# as there are 0 bytes in the buffer, and 0 bytes behind the cursor
              #.Set  INPUT_BUF_SIZE, 256
              .Set  INPUT_BUF_SIZE, 256
              .Comm input_buffer, INPUT_BUF_SIZE
              .Comm input_cursor, 8
              .Comm input_end, 8

              .Data
in_file:      .8byte STDIN

              .Text
# Look at the upcoming character in the buffer. This must be called after at
# least one call to next_chr.
peek_chr:
              mov   rcx, input_cursor
              cmp   rcx, -1
              je    _peek_chr_eof
              xor   rax, rax
              mov   al, [input_buffer+rcx]
              ret
_peek_chr_eof:
              mov   rax, -1
              ret

# Look at the buffer, finding the next character 
next_chr:
              incq  input_cursor
              mov   rax, input_end
              cmpq  input_cursor, rax
              jb    _next_chr_done
_next_chr_read:
              movq  input_cursor, 0
              mov   rax, SYS_READ
              mov   rdi, in_file
              lea   rsi, input_buffer
              mov   rdx, INPUT_BUF_SIZE
              syscall
              cmp   rax, 0
              jg    _next_chr_done
_next_chr_eof:
              movq  input_cursor, -1
_next_chr_done:
              movq  input_end, rax
              ret
