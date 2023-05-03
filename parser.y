%{
    #include<stdio.h>
    int yylex(void);
    int yyerror(const char* s);
    int main(void);
%}

//Tokens Definition
%union {
    int iVal;
    char* sVal;
    float fVal;
    char* cVal;  
}
%token INT CHAR FLOAT STRING DOUBLE CONST BOOL VOID
%token PLUS MINUS MULTIPLY  DIVIDE  MODULO  INCREMENT  DECREMENT  GREATER  LESS  GREATER_EQUAL  LESS_EQUAL  EQUAL  NOT_EQUAL  AND  OR  NOT  ASSIGN  IF  ELSE  SWITCH  CASE  DEFAULT  CONTINUE   BREAK  THEN  WHILE  DO  FOR  RETURN  REPEAT  UNTIL  TRUE  FALSE  LEFT_CURLY_BRACE  RIGHT_CURLY_BRACE  LEFT_PARENTHESIS  RIGHT_PARENTHESIS  LEFT_SQUARE_BRACKET  RIGHT_SQUARE_BRACKET  ENUM  FUNCTION  MAIN  PRINT  SCAN   DIGIT  FLOAT_LITERAL  STRING_LITERAL  CHAR_LITERAL  COMMENT 

%token <INTGR> IDENTIFIER
%%

program                         :   statement
                                |   program statement
                                
statement                       :   variableDeclarationStatement
                                |   ConstDeclarationStatement

Boolean                         :   TRUE
                                |   FALSE

variableDeclarationStatement    :   INT IDENTIFIER ';' {printf("variableDeclaration with int \n");} ;
                                    |INT IDENTIFIER ASSIGN DIGIT ';' {printf("variableDeclaration with int \n");} ;
                                    | CHAR IDENTIFIER ';' {printf("variableDeclaration with char \n");} ;
                                    | CHAR IDENTIFIER ASSIGN CHAR_LITERAL ';' {printf("variableDeclaration with char \n");} ;
                                    | FLOAT IDENTIFIER ';' {printf("variableDeclaration with float \n");} ;
                                    | FLOAT IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("variableDeclaration with float \n");} ;
                                    | STRING IDENTIFIER ';' {printf("variableDeclaration with string \n");} ;
                                    | STRING IDENTIFIER ASSIGN STRING_LITERAL ';' {printf("variableDeclaration with string \n");} ;
                                    | DOUBLE IDENTIFIER ';' {printf("variableDeclaration with double \n");} ;
                                    | DOUBLE IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("variableDeclaration with double \n");} ;
                                    | BOOL IDENTIFIER ';' {printf("variableDeclaration with bool \n");} ;
                                    | BOOL IDENTIFIER ASSIGN Boolean ';' {printf("variableDeclaration with bool \n");} ;


ConstDeclarationStatement           :   CONST INT IDENTIFIER ASSIGN DIGIT ';' {printf("ConstDeclaration with int \n");} ;
                                    | CONST CHAR IDENTIFIER ASSIGN CHAR_LITERAL ';' {printf("ConstDeclaration with char \n");} ;
                                    | CONST FLOAT IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("ConstDeclaration with float \n");} ;
                                    | CONST STRING IDENTIFIER ASSIGN STRING_LITERAL ';' {printf("ConstDeclaration with string \n");} ;
                                    | CONST DOUBLE IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("ConstDeclaration with double \n");} ;
                                    | CONST BOOL IDENTIFIER ASSIGN Boolean ';' {printf("ConstDeclaration with bool \n");} ;
                                    
%%

int yyerror(const char* s)
{
  fprintf(stderr, "%s\n",s);
  return 1;
}

int main(void)
{
  yyparse();
  return 0;
}