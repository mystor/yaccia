enums = {
    "TOK": [
        ("EOF", "end of file"),
        ("EQ", "="),
        ("EQEQ", "=="),
        ("ADD", "+"),
        ("SUB", "-"),
        ("MUL", "*"),
        ("DIV", "/"),
        ("DOT", "."),
        ("NOT", "!"),
        ("AND", "&"),
        ("OR", "|"),
        ("COMMA", ","),
        ("MOD", "%"),
        ("LT", "<"),
        ("GT", ">"),

        ("LPAREN", "("),
        ("RPAREN", ")"),
        ("LBRACKET", "["),
        ("RBRACKET", "]"),
        ("LBRACE", "{"),
        ("RBRACE", "}"),

        ("STR", "string"),
        ("CHAR", "character"),
        ("INT", "integer"),
        ("IDENT", "identifier"),
    ],
}

for name, vals in enums.items():
    # Generate .set values for each of the enum options, so that they can be
    # referred to from other places in the assembly program
    for i, (val, _) in enumerate(vals):
        print(".set " + name + "_" + val + ", " + str(i))
    # Generate the table for getting null-terminated string names of each of the tokens
    print("  .section .rodata")
    # The table itself
    print(name + "_names:")
    for (val, _) in vals:
        print("  .8byte _name_" + name + "_" + val)
    # The backing strings
    for (val, readable) in vals:
        print("_name_" + name + "_" + val + ":")
        print("  .asciz \"" + readable + "\"")
