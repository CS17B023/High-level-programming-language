%{
    #include<iostream>
    #include<cstdio>
    #include<cstdlib>
    #include<cstring>
    #include<string>
    #include<vector>
    using namespace std;
    #include"y.tab.h"
    int ConvertToInteger(char *s){
        return atoi(s);
    }
    float ConvertToFloat(char *s){
        return stof(string(s));
    }
%}
keywords "int"|"float"|"char"
variable [a-zA-Z][a-zA-Z0-9]*
equal "="
closingBraces "}"
openingBraces "{"
integerConstant [0-9]+
floatingConstant ([0-9]*"."[0-9]+)|([0-9]+"."[0-9]*)
semicolon ";"
colon ","
openingBracket "("
closingBracket ")"
plus "+"
minus "-"
multiply "*"
divide "/"
modulus "%"
while "while"
if "if"
else "else"
elseIf "else"" "*"if"
or "||"
and "&&"
smallerThan "<"
greaterThan ">"
smallerThanOrEqualTo "<="
greaterThanOrEqualTo ">="
isEqual "=="
isNotEqual "!="
negate "!"
openSquareBracket "["
closeSquareBracket "]"
function "function"
RETURN "return"
%%
{RETURN} {
//     cout<<yytext<<" is a return"<<endl;
    return RETURN;
}
{function} {
//     cout<<yytext<<" is a function"<<endl;
    return function;
}

{negate} {
//     cout<<yytext<<" is a negate"<<endl;
    return NEG;
}
{while} {
//     cout<<yytext<<" is a while"<<endl;
    return WHILE;
}
{if} {
//     cout<<yytext<<" is a if"<<endl;
    return IF;
}
{else} {
//     cout<<yytext<<" is a else"<<endl;
    return ELSE;
}
{elseIf} {
//     cout<<yytext<<" is a else-if"<<endl;
    return ELSEIF;
}
{isEqual} {
//     cout<<yytext<<" is a isEqual"<<endl;
    return isEqual;
}
{isNotEqual} {
//     cout<<yytext<<" is a not equal"<<endl;
    return isNotEqual;
}
{or} {
//     cout<<yytext<<" is a or"<<endl;
    return Or;
}
{and} {
//     cout<<yytext<<" is a and"<<endl;
    return And;
}
{smallerThan} {
//     cout<<yytext<<" is a smaller than"<<endl;
    return st;
}
{greaterThan} {
//     cout<<yytext<<" is a greater than"<<endl;
    return gt;
}
{smallerThanOrEqualTo} {
//     cout<<yytext<<" is a smaller than or equal to"<<endl;
    return ste;
}
{greaterThanOrEqualTo} {
//     cout<<yytext<<" is a greater than or equal to"<<endl;
    return gte;
}
{keywords} {
//     cout<<yytext<<" is a keyword"<<endl;
    strcpy(yylval.Type,yytext);
    return variable_type;
}
{variable} {
//     cout<<yytext<<" is a variable"<<endl;
    strcpy(yylval.Name,yytext);
    return variable;
}
{integerConstant} {
//     cout<<yytext<<" is a integer constant"<<endl;
    yylval.Integer=ConvertToInteger(yytext);
    return i_constant;
}
{floatingConstant} {
//     cout<<yytext<<" is a floating constant"<<endl;
    yylval.Float=ConvertToFloat(yytext);
    return f_constant;
}
{plus} {
//     cout<<yytext<<" is a plus"<<endl;
    return plus;
}
{modulus} {
//     cout<<yytext<<" is a modulus"<<endl;
    return modulus;
}
{minus} {
//     cout<<yytext<<" is a minus"<<endl;
    return minus;
}
{multiply} {
//     cout<<yytext<<" is a multiply"<<endl;
    return multiply;
}
{divide} {
//     cout<<yytext<<" is a divide"<<endl;
    return divide;
}
{equal} {
//     cout<<yytext<<" is a equal sign"<<endl;
    return equal;
}
{closingBraces} {
//     cout<<yytext<<" is a closing brace"<<endl;
    return closingBraces;
}
{openingBraces} {
//     cout<<yytext<<" is a opening brace"<<endl;
    return openingBraces;
}
{openingBracket} {
//     cout<<yytext<<" is a opening bracket"<<endl;
    return openingBracket;
}
{closingBracket} {
//     cout<<yytext<<" is a closing bracket"<<endl;
    return closingBracket;
}
{semicolon} {
//     cout<<yytext<<" is a semicolon"<<endl;
    return semicolon;
}
{colon} {
//     cout<<yytext<<" is a colon"<<endl;
    return colon;
}
" "|"\t"|"\n" {
//     cout<<yytext<<" is a space"<<endl;
}
. {
//     cout<<yytext<<" is not well received"<<endl;
    return yytext[0];
}
%%