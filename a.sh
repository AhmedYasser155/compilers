yacc -d parser.y
lex Lexer.l
cc lex.yy.c y.tab.c -o scanner
./scanner