# -*- gas -*-

              .Set  SHT_NULL, 0
              .Set  SHT_PROGBITS, 1
              .Set  SHT_SYMTAB, 2
              .Set  SHT_STRTAB, 3
              .Set  SHT_RELA, 4

              .Set  SHF_WRITE, 0x1
              .Set  SHF_ALLOC, 0x2
              .Set  SHF_EXECINSTR, 0x4
              .Set  SHF_MERGE, 0x10
              .Set  SHF_STRINGS, 0x20
              .Set  SHF_INFO_LINK, 0x40

              .Set  STB_LOCAL, 0
              .Set  STB_GLOBAL, 1
              .Set  STB_WEAK, 2

              .Equ  ELF_shoff, ELF_shdr_null - ELF_begin
              .Equ  ELF_hdr_size, ELF_shoff
              .Equ  ELF_shdr_size, ELF_shdr_text - ELF_shdr_null

              .Data
              .Align 8
ELF_begin:
### Elf64_Ehdr ###
ei_mag:       .Ascii "\x7F"
              .Ascii "ELF"          # Magic number
ei_class:     .Byte 2               # pointer size (32-bit = 1, 64-bit = 2)
ei_data:      .Byte 1               # 1 = little endian, 2 = big endian
ei_version:   .Byte 1               # version 1 of ELF
ei_osabi:     .Byte 0x03            # Operating System ABI (linux = 0x03)
ei_abiversion: .Byte 0              # ignored by linux
ei_pad:       .Fill 7, 1, 0         # Padding
e_type:       .2byte 1              # 1 = relocatable, 2 = executable, 3 = shared, 4 = core
e_machine:    .2byte 0x3E           # ISA (x86 = 0x03, x86-64 = 0x3E)
e_version:    .4byte 1              # version 1 of ELF
e_entry:      .8byte 0              # Memory address of entry point (executable only)
e_phoff:      .8byte 0              # Program header offset (executable only)
e_shoff:      .8byte ELF_shoff      # Section header offset
e_flags:      .4byte 0              # Flags
e_ehsize:     .2byte ELF_hdr_size   # Size of this header
e_phentsize:  .2byte 0              # Size of a program header table entry (executable only)
e_phnum:      .2byte 0              # Number of entries in program header table
e_shentsize:  .2byte ELF_shdr_size  # Size of a section header entry
e_shnum:      .2byte 8              # Number of entries in the section header
e_shstrndx:   .2byte SHN_SHSTRTAB   # Section header table for names index

ELF_shdr_null:                      # SECTION 0 #
null.sh_name: .4byte 0              # Section name, index in string tbl
null.sh_type: .4byte SHT_NULL       # Section Type (SHT_)
null.sh_flags: .8byte 0             # Section Flags (SHF_)
null.sh_addr: .8byte 0
null.sh_offset: .8byte 0            # Section file offset
null.sh_size: .8byte 0              # Size of section in bytes
null.sh_link: .4byte 0
null.sh_info: .4byte 0
null.sh_addralign: .8byte 0         # Section alignment
null.sh_entsize: .8byte 0           # Entry size if section holds table

              .Set  SHN_TEXT, 1
ELF_shdr_text:
text.sh_name: .4byte (shstrtab.text - ELF_shstrtab)
text.sh_type: .4byte SHT_PROGBITS   # Section Type (SHT_)
text.sh_flags: .8byte SHF_ALLOC | SHF_EXECINSTR # Section Flags (SHF_)
text.sh_addr: .8byte 0
text.sh_offset: .8byte 0xDEADBEEF # Section file offset
text.sh_size: .8byte 0xDEADBEEF # Size of section in bytes
text.sh_link: .4byte 0
text.sh_info: .4byte 0
text.sh_addralign: .8byte 1         # Section alignment
text.sh_entsize: .8byte 0

              .Set  SHN_DATA, 2
ELF_shdr_data:
data.sh_name: .4byte shstrtab.data - ELF_shstrtab
data.sh_type: .4byte SHT_PROGBITS   # Section Type (SHT_)
data.sh_flags: .8byte SHF_ALLOC | SHF_WRITE # Section Flags (SHF_)
data.sh_addr: .8byte 0
data.sh_offset: .8byte 0            # Section file offset
data.sh_size: .8byte 0              # Size of section in bytes
data.sh_link: .4byte 0
data.sh_info: .4byte 0
data.sh_addralign: .8byte 8         # Section alignment
data.sh_entsize: .8byte 0

              .Set  SHN_RODATA, 3
ELF_shdr_rodata:
rodata.sh_name: .4byte shstrtab.rodata - ELF_shstrtab
rodata.sh_type: .4byte SHT_PROGBITS # Section Type (SHT_)
rodata.sh_flags: .8byte SHF_ALLOC   # Section Flags (SHF_)
rodata.sh_addr: .8byte 0
rodata.sh_offset: .8byte 0          # Section file offset
rodata.sh_size: .8byte 0            # Size of section in bytes
rodata.sh_link: .4byte 0
rodata.sh_info: .4byte 0
rodata.sh_addralign: .8byte 8       # Section alignment
rodata.sh_entsize: .8byte 0

              .Set  SHN_RELA_TEXT, 4
ELF_shdr_rela_text:
rela_text.sh_name: .4byte shstrtab.rela.text - ELF_shstrtab
rela_text.sh_type: .4byte SHT_RELA  # Section Type (SHT_)
rela_text.sh_flags: .8byte SHF_INFO_LINK # Section Flags (SHF_)
rela_text.sh_addr: .8byte 0
rela_text.sh_offset: .8byte 0       # Section file offset
rela_text.sh_size: .8byte 0         # Size of section in bytes
rela_text.sh_link: .4byte SHN_SYMTAB # Reference to the Symbol Table
rela_text.sh_info: .4byte SHN_TEXT  # Reference to the Text Section
rela_text.sh_addralign: .8byte 8    # Section alignment
rela_text.sh_entsize: .8byte 24     # Entry size if section holds table

              .Set  SHN_SHSTRTAB, 5
ELF_shdr_shstrtab:
shstrtab.sh_name: .4byte shstrtab.shstrtab - ELF_shstrtab
shstrtab.sh_type: .4byte SHT_STRTAB # Section Type (SHT_)
shstrtab.sh_flags: .8byte 0         # Section Flags (SHF_)
shstrtab.sh_addr: .8byte 0
shstrtab.sh_offset: .8byte ELF_shstrtab - ELF_begin # Section file offset
shstrtab.sh_size: .8byte ELF_shstrtab.end - ELF_shstrtab # Size of section in bytes
shstrtab.sh_link: .4byte 0
shstrtab.sh_info: .4byte 0
shstrtab.sh_addralign: .8byte 8     # Section alignment
shstrtab.sh_entsize: .8byte 0

              .Set  SHN_SYMTAB, 6
ELF_shdr_symtab:
symtab.sh_name: .4byte shstrtab.symtab - ELF_shstrtab
symtab.sh_type: .4byte SHT_SYMTAB   # Section Type (SHT_)
symtab.sh_flags: .8byte 0           # Section Flags (SHF_)
symtab.sh_addr: .8byte 0
symtab.sh_offset: .8byte ELF_symtab - ELF_begin # Section file offset
symtab.sh_size: .8byte ELF_symtab.end - ELF_symtab # Size of section in bytes
symtab.sh_link: .4byte SHN_STRTAB
symtab.sh_info: .4byte 0
symtab.sh_addralign: .8byte 8       # Section alignment
symtab.sh_entsize: .8byte 24

              .Set  SHN_STRTAB, 7
ELF_shdr_strtab:
strtab.sh_name: .4byte shstrtab.strtab - ELF_shstrtab
strtab.sh_type: .4byte SHT_STRTAB   # Section Type (SHT_)
strtab.sh_flags: .8byte 0           # Section Flags (SHF_)
strtab.sh_addr: .8byte 0
strtab.sh_offset: .8byte ELF_strtab - ELF_begin # Section file offset
strtab.sh_size: .8byte ELF_strtab.end - ELF_strtab # Size of section in bytes
strtab.sh_link: .4byte 0
strtab.sh_info: .4byte 0
strtab.sh_addralign: .8byte 8       # Section alignment
strtab.sh_entsize: .8byte 0

              .Align 8
ELF_shstrtab:
ststrtab.null: .Asciz ""
shstrtab.text: .Asciz ".text"
shstrtab.data: .Asciz ".data"
shstrtab.rodata: .Asciz ".rodata"
shstrtab.rela.text: .Asciz ".rela.text"
shstrtab.shstrtab: .Asciz ".shstrtab"
shstrtab.symtab: .Asciz ".symtab"
shstrtab.strtab: .Asciz ".strtab"
ELF_shstrtab.end:

              .Align 8
ELF_symtab:
symtab.st_name: .4byte strtab._start - ELF_strtab
symtab.st_info: .byte STB_GLOBAL << 4
symtab.st_other: .byte 0
symtab.st_shndx: .2byte SHN_TEXT
symtab.st_value: .8byte 0
symtab.st_size: .8byte 0
ELF_symtab.end:                     

              .Align 8
ELF_strtab:
strtab.null:  .Asciz ""
strtab._start: .Asciz "_start"
ELF_strtab.end: 

              .Align 8
ELF_begin.end:

              # The .text section
ELF_text_ptr: .8byte ELF_text
              .Set ELF_text.size, 128*MB
              .Set ELF_text.end, ELF_text + ELF_text.size
              .Comm ELF_text, ELF_text.size

              .Text
# Call to write the ELF file out. rax is the FD to write to
write_elf:
# Update headers with the correct values

# Write out the headers
              mov   rdi, rax
              mov   rax, SYS_WRITE
              mov   rsi, offset ELF_begin
              mov   rdx, ELF_begin.end - ELF_begin
              syscall

# Write out the other sections
              ret

