lex Lexer.l
yacc -v -d parser.y
cc lex.yy.c y.tab.c -o scanner
cat phase2.txt | ./scanner

