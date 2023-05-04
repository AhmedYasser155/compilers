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
                                |   constDeclarationStatement
                                |   assignmentStatement
                                |   ifStatement


boolean                         :   TRUE
                                |   FALSE

expression                      : intMathExpression
                                | floatMathExpression
                                | stringExpression
                                | STRING_LITERAL
                                | CHAR_LITERAL
                                /*| boolean*/
                                | logicalExpression

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
                                    | BOOL IDENTIFIER ASSIGN boolean ';' {printf("variableDeclaration with bool \n");} ;


constDeclarationStatement           : CONST INT IDENTIFIER ASSIGN DIGIT ';' {printf("ConstDeclaration with int \n");} ;
                                    | CONST CHAR IDENTIFIER ASSIGN CHAR_LITERAL ';' {printf("ConstDeclaration with char \n");} ;
                                    | CONST FLOAT IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("ConstDeclaration with float \n");} ;
                                    | CONST STRING IDENTIFIER ASSIGN STRING_LITERAL ';' {printf("ConstDeclaration with string \n");} ;
                                    | CONST DOUBLE IDENTIFIER ASSIGN FLOAT_LITERAL ';' {printf("ConstDeclaration with double \n");} ;
                                    | CONST BOOL IDENTIFIER ASSIGN boolean ';' {printf("ConstDeclaration with bool \n");} ;

assignmentStatement                 : IDENTIFIER ASSIGN expression ';' {printf("assignmentStatement \n");} ;
                              

intMathExpression                   :    IDENTIFIER   /*TODO: the type of the identifier should be int*/
                                    |    DIGIT  
                                    |   intMathExpression PLUS intMathExpression
                                    |   intMathExpression MINUS intMathExpression
                                    |   intMathExpression MULTIPLY intMathExpression
                                    |   intMathExpression DIVIDE intMathExpression
                                    |   intMathExpression MODULO intMathExpression
                                    |   intMathExpression INCREMENT
                                    |   intMathExpression DECREMENT
                                    |   LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS
                                    
floatMathExpression                 :   IDENTIFIER  /* TODO: the type of the identifier should be float */
                                    |   FLOAT_LITERAL
                                    |   floatMathExpression PLUS floatMathExpression
                                    |   floatMathExpression MINUS floatMathExpression
                                    |   floatMathExpression MULTIPLY floatMathExpression
                                    |   floatMathExpression DIVIDE floatMathExpression
                                    |   floatMathExpression MODULO floatMathExpression
                                    |   floatMathExpression INCREMENT
                                    |   floatMathExpression DECREMENT
                                    |   LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS
                                
stringExpression                    :  IDENTIFIER  /* TODO: the type of the identifier should be string */
                                    |   STRING_LITERAL
                                    |   stringExpression PLUS stringExpression
                                    |   LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS



logicalExpression                   :  boolean
                                    |   intMathExpression GREATER intMathExpression
                                    |   intMathExpression LESS intMathExpression
                                    |   intMathExpression GREATER_EQUAL intMathExpression
                                    |   intMathExpression LESS_EQUAL intMathExpression
                                    |   intMathExpression EQUAL intMathExpression
                                    |   intMathExpression NOT_EQUAL intMathExpression
                                    |   floatMathExpression GREATER floatMathExpression
                                    |   floatMathExpression LESS floatMathExpression
                                    |   floatMathExpression GREATER_EQUAL floatMathExpression
                                    |   floatMathExpression LESS_EQUAL floatMathExpression
                                    |   floatMathExpression EQUAL floatMathExpression
                                    |   floatMathExpression NOT_EQUAL floatMathExpression
                                    |   stringExpression GREATER stringExpression
                                    |   stringExpression LESS stringExpression
                                    |   stringExpression GREATER_EQUAL stringExpression
                                    |   stringExpression LESS_EQUAL stringExpression
                                    |   stringExpression EQUAL stringExpression
                                    |   stringExpression NOT_EQUAL stringExpression
                                    |   LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS
                                    |   logicalExpression AND logicalExpression
                                    |   logicalExpression OR logicalExpression
                                    |   NOT logicalExpression


ifStatement                         :   IF LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE
                                    |   IF LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE ELSE LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE
                                    |   /* ifelse expression?? */ 





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