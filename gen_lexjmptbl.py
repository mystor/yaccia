#!/usr/bin/env python

import re

with open("lexjmptbl.s", "w") as f:
    for i in range(127):
        c = chr(i)
        f.write("  .8byte _next_token_")
        if re.match('[a-zA-Z_]', c):
            f.write("ident")
        elif re.match('[0-9]', c):
            f.write("int")
        elif re.match('[ \n\t\r]', c):
            f.write("ignore")
        elif c == '=':
            f.write("eq")
        elif c == '+':
            f.write("add")
        elif c == '-':
            f.write("sub")
        elif c == '*':
            f.write("mul")
        elif c == '/':
            f.write("div")
        elif c == '.':
            f.write("dot")
        elif c == '!':
            f.write("not")
        elif c == '&':
            f.write("and")
        elif c == '|':
            f.write("or")
        elif c == '(':
            f.write("lparen")
        elif c == ')':
            f.write("rparen")
        elif c == '[':
            f.write("lbracket")
        elif c == ']':
            f.write("rbracket")
        elif c == '{':
            f.write("lbrace")
        elif c == '}':
            f.write("rbrace")
        elif c == ',':
            f.write("comma")
        elif c == '"':
            f.write("str")
        elif c == "'":
            f.write("char")
        elif c == '<':
            f.write("lt")
        elif c == '>':
            f.write("gt")
        else:
            f.write("invalid")
        f.write(" # " + c.__repr__() + "\n")
        # f.write(" // " + c.__repr__() + "\n");
