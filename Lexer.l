%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
%}
%%
"int" return INT;
"float" return FLOAT;
"char" return CHAR;
"void" return VOID;
"string" return STRING;
"bool" return BOOL;
"const" return CONST;

"+" return PLUS;
"-" return MINUS;
"*" return MULTIPLY;
"/" return DIVIDE;
"%" return MODULO;
"++" return INCREMENT;
"--" return DECREMENT;
">" return GREATER;
"<" return LESS;
">=" return GREATER_EQUAL;
"<=" return LESS_EQUAL;
"==" return EQUAL;
"!=" return NOT_EQUAL;


"&&" return AND;
"||" return OR;
"!" return NOT;

"=" return ASSIGN;

"if" return IF;
"else" return ELSE;
"switch" return SWITCH;
"case" return CASE;
"default" return DEFAULT;
"continue" return CONTINUE;
"break" return BREAK;
"then" return THEN;
"while" return WHILE;
"do" return DO;
"for" return FOR;
"return" return RETURN;
"repeat" return REPEAT;
"until" return UNTIL;
"true" {
            yylval.bVal=1;
            return BOOL_LITERAL;
        };
"false" {   
            yylval.bVal=0;
            return BOOL_LITERAL;
        };

"{" return LEFT_CURLY_BRACE;
"}" return RIGHT_CURLY_BRACE;
"(" return LEFT_PARENTHESIS;
")" return RIGHT_PARENTHESIS;
"[" return LEFT_SQUARE_BRACKET;
"]" return RIGHT_SQUARE_BRACKET;

"enum" return ENUM;

"function" return FUNCTION;
"main" return MAIN;
"print" return PRINT;
"scan" return SCAN;


[a-zA-Z][a-zA-Z0-9]* {
    yylval.sVal=strdup(yytext); 
    // yylval.iVal = *yytext-'a';


    return IDENTIFIER;
}

\-?[1-9][0-9]* {
    yylval.iVal=atoi(yytext);
    return DIGIT;
}


\-?[0-9]+\.[0-9]+ {
    yylval.fVal=atof(yytext);
    return FLOAT_LITERAL;
}

"0" {
    yylval.iVal=atoi(yytext);
    return DIGIT;
}

\".*\" {
    yylval.sVal=yytext;
    return STRING_LITERAL;
}

\'[a-zA-Z0-9]\' {
    yylval.cVal=yytext[1];
    return CHAR_LITERAL;
}

"//".* {
    yylval.sVal=yytext;
    return COMMENT;
}

[ \t\n]+ {}
[*+-/=%~&|^(){}:;<>.,?!] return *yytext;

. return yytext[0];


%%
int yywrap(void) {
    return 1;
}



