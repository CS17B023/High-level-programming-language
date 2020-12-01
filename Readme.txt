LAB DESCRIPTION:
    To make a mini compiler that can convert code to three address code;
GRAMMER FOLLOWED:
    S_ : { S } | Func S_;
    Func: G variable openingBracket Args1 closingBracket S openingBraces closingBraces;
    Arg1: G B Arg2 | 
    Arg2: , Arg1 | 
    R: return; | return C;
    S : A ; S | F ; S | { S } S | N S | R S | LOOP S | e ;
    A : A , B | G B
    B : variable = C | variable
    C : C + D | C - D | D
    D : D * Q | D / Q | D % Q | Q
    Q : ! { J } | ! variable | E
    E : ( J ) | Call | integerConstant | floatConstant
    Call : variable ( Argument1 ) | variable ;
    Argument1 : C Argument2 | 
    Argument2 : , Argument1 | 
    F : variable = C
    G : variableType
	LOOP: while ( H ) M
    REL: if ( H ) M
    REL_ELSE_IF: else if ( H ) cd M
    REL_ELSE: else M
    H: H or I | I
    I: I and J | J
    J: J == K | J != K | K
    K: K < L | K > L | K <= L | K >= L | L
    L: C
    M: A ; | F ; | REL | { S }
    N: REL O | REL 
    O: P REL_ELSE | P | REL_ELSE
    P: P REL_ELSE_IF | REL_ELSE_IF 
ABOUT MY PROGRAM:
    Going by the non terminal wise:
        S_ : it is the represantation of the parent block of the code given
        S : it is the represantation of the contents inside curly braces
        A : it is the represantation of the content consists of declarations of variables
        F : it is the represantation of the content consists of arithematic operations
        B : here is the represantion of declaration of a variable(it consists all the ways a variable can be declared)
        C : represant all the arithematic expression possible for (+,-)
        D : represant all the arithematic expression possible for (*,/)
        E : consists of brakets enclosed arithematic expressions
        G : denotes the variable types
        
