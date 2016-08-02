# -*- gas -*-

              .Set  SHT_NULL, 0
              .Set  SHT_PROGBITS, 1
              .Set  SHT_SYMTAB, 2
              .Set  SHT_RTRTAB, 3
              .Set  SHT_RELA, 4

              .Equ  ELF_shoff, ELF_shdr_null - ELF_begin
              .Equ  ELF_hdr_size, ELF_shoff
              .Equ  ELF_shdr_size, ELF_shdr_text - ELF_shdr_null

              .Data
ELF_begin:    
### Elf64_Ehdr ###
ei_mag:       .Ascii "\x7FELF"      # Magic number
ei_class:     .Byte 2               # pointer size (32-bit = 1, 64-bit = 2)
ei_data:      .Byte 1               # 1 = little endian, 2 = big endian
ei_version:   .Byte 1               # version 1 of ELF
ei_osabi:     .Byte 0x03            # Operating System ABI (linux = 0x03)
ei_abiversion: .Byte 0              # ignored by linux
ei_pad:       .Fill 7, 1, 0         # Padding
e_type:       .Word 1               # 1 = relocatable, 2 = executable, 3 = shared, 4 = core
e_machine:    .Word 0x3E            # ISA (x86 = 0x03, x86-64 = 0x3E)
e_version:    .Double 1             # version 1 of ELF
e_entry:      .Quad 0               # Memory address of entry point (executable only)
e_phoff:      .Quad 0               # Program header offset (executable only)
e_shoff:      .Quad ELF_shoff       # Section header offset
e_flags:      .Double 0             # Flags
e_ehsize:     .Word ELF_hdr_size    # Size of this header
e_phentsize:  .Word 0               # Size of a program header table entry (executable only)
e_phnum:      .Word 0               # Number of entries in program header table
e_shentsize:  .Word ELF_shdr_size   # Size of a section header entry
e_shnum:      .Word 6               # Number of entries in the section header
e_shstrndx:   .Word 3               # Section header table for names index

ELF_shdr_null:
null.sh_name: .Double 0             # Section name, index in string tbl
null.sh_type: .Double 0             # Miscellaneous section attributes
null.sh_flags: .Quad 0              # Type of section
null.sh_addr: .Quad 0               # Section virtual addr at execution
null.sh_offset: .Quad 0             # Section file offset
null.sh_size: .Quad 0               # Size of section in bytes
null.sh_link: .Double 0             # Index of another section
null.sh_info: .Double 0             # Additional section information
null.sh_addralign: .Quad 0          # Section alignment
null.sh_entsize: .Quad 0            # Entry size if section holds table

ELF_shdr_text:
text.sh_name: .Double 1             # Section name, index in string tbl 
text.sh_type: .Double 0             # Miscellaneous section attributes 
text.sh_flags: .Quad 0              # Type of section 
text.sh_addr: .Quad 0               # Section virtual addr at execution 
text.sh_offset: .Quad 0             # Section file offset 
text.sh_size: .Quad 0               # Size of section in bytes 
text.sh_link: .Double 0             # Index of another section 
text.sh_info: .Double 0             # Additional section information 
text.sh_addralign: .Quad 0          # Section alignment 
text.sh_entsize: .Quad 0            # Entry size if section holds table 

ELF_shdr_data:
data.sh_name: .Double 2             # Section name, index in string tbl 
data.sh_type: .Double 0             # Miscellaneous section attributes 
data.sh_flags: .Quad 0              # Type of section 
data.sh_addr: .Quad 0               # Section virtual addr at execution 
data.sh_offset: .Quad 0             # Section file offset 
data.sh_size: .Quad 0               # Size of section in bytes 
data.sh_link: .Double 0             # Index of another section 
data.sh_info: .Double 0             # Additional section information 
data.sh_addralign: .Quad 0          # Section alignment 
data.sh_entsize: .Quad 0            # Entry size if section holds table 

ELF_shdr_rodata:
rodata.sh_name: .Double 3           # Section name, index in string tbl
rodata.sh_type: .Double 0           # Miscellaneous section attributes
rodata.sh_flags: .Quad 0            # Type of section
rodata.sh_addr: .Quad 0             # Section virtual addr at execution
rodata.sh_offset: .Quad 0           # Section file offset
rodata.sh_size: .Quad 0             # Size of section in bytes
rodata.sh_link: .Double 0           # Index of another section
rodata.sh_info: .Double 0           # Additional section information
rodata.sh_addralign: .Quad 0        # Section alignment
rodata.sh_entsize: .Quad 0          # Entry size if section holds table

ELF_shdr_rela_text:
rela_text.sh_name: .Double 3           # Section name, index in string tbl
rela_text.sh_type: .Double 0           # Miscellaneous section attributes
rela_text.sh_flags: .Quad 0            # Type of section
rela_text.sh_addr: .Quad 0             # Section virtual addr at execution
rela_text.sh_offset: .Quad 0           # Section file offset
rela_text.sh_size: .Quad 0             # Size of section in bytes
rela_text.sh_link: .Double 0           # Index of another section
rela_text.sh_info: .Double 0           # Additional section information
rela_text.sh_addralign: .Quad 0        # Section alignment
rela_text.sh_entsize: .Quad 24         # Entry size if section holds table

ELF_shdr_rela_data:
rela_data.sh_name: .Double 3           # Section name, index in string tbl
rela_data.sh_type: .Double 0           # Miscellaneous section attributes
rela_data.sh_flags: .Quad 0            # Type of section
rela_data.sh_addr: .Quad 0             # Section virtual addr at execution
rela_data.sh_offset: .Quad 0           # Section file offset
rela_data.sh_size: .Quad 0             # Size of section in bytes
rela_data.sh_link: .Double 0           # Index of another section
rela_data.sh_info: .Double 0           # Additional section information
rela_data.sh_addralign: .Quad 0        # Section alignment
rela_data.sh_entsize: .Quad 24         # Entry size if section holds table

ELF_shdr_shstrtab:
shstrtab.sh_name: .Double 3           # Section name, index in string tbl
shstrtab.sh_type: .Double 0           # Miscellaneous section attributes
shstrtab.sh_flags: .Quad 0            # Type of section
shstrtab.sh_addr: .Quad 0             # Section virtual addr at execution
shstrtab.sh_offset: .Quad 0           # Section file offset
shstrtab.sh_size: .Quad 0             # Size of section in bytes
shstrtab.sh_link: .Double 0           # Index of another section
shstrtab.sh_info: .Double 0           # Additional section information
shstrtab.sh_addralign: .Quad 0        # Section alignment
shstrtab.sh_entsize: .Quad 0          # Entry size if section holds table

ELF_shdr_symtab:
symtab.sh_name: .Double 3           # Section name, index in string tbl
symtab.sh_type: .Double 0           # Miscellaneous section attributes
symtab.sh_flags: .Quad 0            # Type of section
symtab.sh_addr: .Quad 0             # Section virtual addr at execution
symtab.sh_offset: .Quad 0           # Section file offset
symtab.sh_size: .Quad 0             # Size of section in bytes
symtab.sh_link: .Double 0           # Index of another section
symtab.sh_info: .Double 0           # Additional section information
symtab.sh_addralign: .Quad 0        # Section alignment
symtab.sh_entsize: .Quad 0          # Entry size if section holds table
