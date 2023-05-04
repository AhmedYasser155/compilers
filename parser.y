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
                                |   switchStatement
                                |   whileStatement
                                |   forStatement
                                |repeatStatement
                                | enumStatement
                                | functionStatement
                                | returnStatement
                                | printStatement
                                | continueBreakStatement
                                |functionCallStatement
                                |comment


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

assignmentStatement                 : IDENTIFIER ASSIGN expression {printf("assignmentStatement \n");} ;
                              

intMathExpression                   :    IDENTIFIER   /*TODO: the type of the identifier should be int*/
                                    |    DIGIT  
                                    |   intMathExpression PLUS intMathExpression {printf("intMathExpression PLUS intMathExpression \n");}
                                    |   intMathExpression MINUS intMathExpression {printf("intMathExpression MINUS intMathExpression \n");}
                                    |   intMathExpression MULTIPLY intMathExpression {printf("intMathExpression MULTIPLY intMathExpression \n");}
                                    |   intMathExpression DIVIDE intMathExpression {printf("intMathExpression DIVIDE intMathExpression \n");}
                                    |   intMathExpression MODULO intMathExpression {printf("intMathExpression MODULO intMathExpression \n");}
                                    |   intMathExpression INCREMENT {printf("intMathExpression INCREMENT \n");}
                                    |   intMathExpression DECREMENT {printf("intMathExpression DECREMENT \n");}
                                    |   LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS {printf("LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS \n");}
                                    
floatMathExpression                 :   IDENTIFIER  /* TODO: the type of the identifier should be float */
                                    |   FLOAT_LITERAL
                                    |   floatMathExpression PLUS floatMathExpression {printf("floatMathExpression PLUS floatMathExpression \n");}
                                    |   floatMathExpression MINUS floatMathExpression {printf("floatMathExpression MINUS floatMathExpression \n");}
                                    |   floatMathExpression MULTIPLY floatMathExpression {printf("floatMathExpression MULTIPLY floatMathExpression \n");}
                                    |   floatMathExpression DIVIDE floatMathExpression {printf("floatMathExpression DIVIDE floatMathExpression \n");}
                                    |   floatMathExpression MODULO floatMathExpression {printf("floatMathExpression MODULO floatMathExpression \n");}
                                    |   floatMathExpression INCREMENT {printf("floatMathExpression INCREMENT \n");}
                                    |   floatMathExpression DECREMENT {printf("floatMathExpression DECREMENT \n");} 
                                    |   LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS {printf("LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS \n");}
                                
stringExpression                    :  IDENTIFIER  /* TODO: the type of the identifier should be string */
                                    |   STRING_LITERAL
                                    |   stringExpression PLUS stringExpression {printf("stringExpression PLUS stringExpression \n");}
                                    |   LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS {printf("LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS \n");}



logicalExpression                   :  boolean
                                    |   intMathExpression GREATER intMathExpression {printf("Logical: intMathExpression GREATER intMathExpression \n");}
                                    |   intMathExpression LESS intMathExpression {printf("Logical: intMathExpression LESS intMathExpression \n");}
                                    |   intMathExpression GREATER_EQUAL intMathExpression {printf("Logical: intMathExpression GREATER_EQUAL intMathExpression \n");}
                                    |   intMathExpression LESS_EQUAL intMathExpression {printf("Logical: intMathExpression LESS_EQUAL intMathExpression \n");}
                                    |   intMathExpression EQUAL intMathExpression {printf("Logical: intMathExpression EQUAL intMathExpression \n");}
                                    |   intMathExpression NOT_EQUAL intMathExpression {printf("Logical: intMathExpression NOT_EQUAL intMathExpression \n");}
                                    |   floatMathExpression GREATER floatMathExpression {printf("Logical: floatMathExpression GREATER floatMathExpression \n");}
                                    |   floatMathExpression LESS floatMathExpression {printf("Logical: floatMathExpression LESS floatMathExpression \n");}
                                    |   floatMathExpression GREATER_EQUAL floatMathExpression {printf("Logical: floatMathExpression GREATER_EQUAL floatMathExpression \n");}
                                    |   floatMathExpression LESS_EQUAL floatMathExpression {printf("Logical: floatMathExpression LESS_EQUAL floatMathExpression \n");}
                                    |   floatMathExpression EQUAL floatMathExpression {printf("Logical: floatMathExpression EQUAL floatMathExpression \n");}
                                    |   floatMathExpression NOT_EQUAL floatMathExpression {printf("Logical: floatMathExpression NOT_EQUAL floatMathExpression \n");}
                                    |   stringExpression GREATER stringExpression {printf("Logical: stringExpression GREATER stringExpression \n");}
                                    |   stringExpression LESS stringExpression {printf("Logical: stringExpression LESS stringExpression \n");}
                                    |   stringExpression GREATER_EQUAL stringExpression {printf("Logical: stringExpression GREATER_EQUAL stringExpression \n");}
                                    |   stringExpression LESS_EQUAL stringExpression {printf("Logical: stringExpression LESS_EQUAL stringExpression \n");}
                                    |   stringExpression EQUAL stringExpression {printf("Logical: stringExpression EQUAL stringExpression \n");} 
                                    |   stringExpression NOT_EQUAL stringExpression {printf("Logical: stringExpression NOT_EQUAL stringExpression \n");}
                                    |   LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS {printf("Logical: LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS \n");}
                                    |   logicalExpression AND logicalExpression {printf("Logical: logicalExpression AND logicalExpression \n");}
                                    |   logicalExpression OR logicalExpression {printf("Logical: logicalExpression OR logicalExpression \n");}
                                    |   NOT logicalExpression {printf("NOT logicalExpression \n");}


ifStatement                         :   IF LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("ifStatement \n");} 
                                    |   IF LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE ELSE LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("if-else-Statement \n");}
                                    |   /* ifelse expression?? */ 

whileStatement  : WHILE LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("whileStatement \n");}

repeatStatement : REPEAT LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE UNTIL LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS {printf("repeatStatement \n");}

forStatement    : FOR LEFT_PARENTHESIS assignmentStatement ';' logicalExpression ';' assignmentStatement RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("forStatement \n");}

switchStatement : SWITCH LEFT_PARENTHESIS IDENTIFIER RIGHT_PARENTHESIS LEFT_CURLY_BRACE caseStatement RIGHT_CURLY_BRACE {printf("switchStatement \n");} 

caseStatement   : CASE DIGIT ':' statement BREAK ';' caseStatement 
                | CASE DIGIT ':' statement BREAK ';'
                | DEFAULT ':' statement BREAK ';'
                | DEFAULT ':' statement BREAK ';' caseStatement
                | /* empty */

enumStatement   : ENUM IDENTIFIER LEFT_CURLY_BRACE IDENTIFIER EQUAL DIGIT ',' IDENTIFIER EQUAL DIGIT RIGHT_CURLY_BRACE {printf("enumStatement \n");}

functionStatement : FUNCTION IDENTIFIER LEFT_PARENTHESIS parameter RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("functionStatement \n");}
                  | FUNCTION IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_CURLY_BRACE statement RIGHT_CURLY_BRACE {printf("functionStatement \n");}

parameter       : IDENTIFIER ',' parameter
                | IDENTIFIER
                | /* empty */

returnStatement : RETURN expression ';' {printf("returnStatement \n");}
                | RETURN ';' {printf("returnStatement \n");}

continueBreakStatement  : BREAK ';' {printf("breakStatement \n");}
                | BREAK IDENTIFIER ';' {printf("breakStatement \n");}
                | BREAK {printf("breakStatement \n");}
                | CONTINUE ';' {printf("continueStatement \n");}
                | CONTINUE IDENTIFIER ';' {printf("continueStatement \n");}
                | CONTINUE {printf("continueStatement \n");}
               

printStatement  : PRINT LEFT_PARENTHESIS expression RIGHT_PARENTHESIS ';' {printf("printStatement \n");}
                | PRINT LEFT_PARENTHESIS RIGHT_PARENTHESIS ';' {printf("printStatement \n");}

functionCallStatement   : IDENTIFIER LEFT_PARENTHESIS argument RIGHT_PARENTHESIS {printf("functionCall \n");}
                | IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS {printf("functionCall \n");}

argument        : expression ',' argument
                | expression
                
comment         : COMMENT {printf("comment \n");}

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