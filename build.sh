#!/bin/bash

AS_FLAGS="-mmnemonic=intel -msyntax=intel -mnaked-reg --64 --gdwarf-2"

set -x
# Codegen
python gen_lexjmptbl.py

# Build and link
as -o yaccia.o main.s $AS_FLAGS || exit $?
ld -o yaccia yaccia.o || exit $?
