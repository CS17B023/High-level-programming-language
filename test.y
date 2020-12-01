%{
/*
000coool
Manish Kumar Srivastava
IIT Tirupati
*/
#include<iostream>
#include<stdio.h>
#include<set>
#include<string.h>
#include<stdlib.h>
#include<vector>
#include<cassert>
#include<string>
#include<map>
using namespace std;
extern FILE * yyin;
string s="t";
string l="L";
string f="F";
string variableType;
int functionCount=0;
string activeFunction;
int argument=0;
map<string,string> mappingFunction,returnFunction;
int count=0;
int gotoCount=0;
int yylex();
int yyerror(char *);
struct Variable{
    char Name[30];
    char Type[30];
};
vector<string> pass;
vector<string> fail;
int64_t blockCount=0,block=0;
vector<Variable*> v;
vector<pair<string,string> > u;
vector<string> w;
vector<string> toPrint,WarningLevel1,WarningLevel2;
bool noMore;
bool ifFlag;
int Start[1024],Parent[1024];
string findIn(char *arr,int n=0){
    if(v.size()==0){
        return string("None");
    }
    for(int i=v.size()-1;i>=n;i--){
        if(strcmp(v[i]->Name,arr)==0){
            return string(v[i]->Type);
        }
    }
    return string("None");
}
void cleanIt(int n){
    if(v.size()==0){
        return;
    }
    for(int i=v.size()-1;i>=n;i--){
        v.pop_back();
    }
}
%}
%union{
    struct Variable* Var;
    int Integer;
    float Float;
    char Type[30];
    char Name[30];
}
%token NEG Or And st gt ste gte isEqual isNotEqual IF ELSE ELSEIF WHILE modulus openingBraces closingBraces variable_type variable i_constant f_constant equal closing opening openingBracket closingBracket semicolon colon plus minus divide multiply RETURN function
%type<Var> A;
%type<Var> B;
%type<Var> C;
%type<Var> D;
%type<Var> E;
%type<Var> G;
%type<Var> REL;
%type<Var> H;
%type<Var> I;
%type<Var> J;
%type<Var> K;
%type<Var> L;
%type<Var> variable_type;
%type<Var> variable; 
%type<Integer> i_constant;
%type<Float> f_constant;
%%
S_: openingBraces {
    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} S closingBraces {
    cleanIt(Start[block]);
    block=Parent[block];
    if(WarningLevel2.size()){
        for(auto s:WarningLevel2){
            cout<<s<<endl;
        }
    }
    else{
        for(auto s:toPrint){
            cout<<s<<endl;
        }
        for(auto s:WarningLevel1){
            cout<<s<<endl;
        }
    }
} | Func S_ ;
Func: variable openingBracket {
    activeFunction=string($<Name>1);
    // 
        blockCount++;
        Parent[blockCount]=block;
        block=blockCount;
        Start[blockCount]=v.size();
    // 
    toPrint.push_back(f+to_string(functionCount)+":");
    } Arg1 closingBracket {
        mappingFunction[string($<Name>1)]=f+to_string(functionCount++);
        returnFunction[string($<Name>1)]=f+to_string(functionCount++);
        string s="function "+string($<Name>1)+" "+to_string(argument)+":";
        toPrint.push_back(s);
    } openingBraces S closingBraces {
        argument=0;
        activeFunction="-1";
        // 
            cleanIt(Start[block]);
            block=Parent[block];
        // 
    } ;
Arg1: G B {
        argument++;
        string s=string($<Var>2->Name)+"=popParam";
        toPrint.push_back(s);
    } Arg2 | ;
Arg2: colon Arg1 | ;
S:  RETURN C {
        if(activeFunction=="-1"){
            WarningLevel1.push_back("Illegal return");
        }
        string s="return "+string($<Var>2->Name);
        toPrint.push_back(s);
    } semicolon S | RETURN {
        string s="return";
        toPrint.push_back(s);
    } semicolon S | A semicolon S | F semicolon S | N S | LOOP S | openingBraces {
    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} S closingBraces {
    cleanIt(Start[block]);
    block=Parent[block];
} S | ;
A: A colon B {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Type,$<Var>3->Type);
    $<Var>$=ptr;
} | G {} B {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Type,$<Var>3->Type);
    $<Var>$=ptr;
};
B: variable {
    string s=findIn($<Name>1,Start[block]);
    if(s==variableType){
        WarningLevel2.push_back("error: redeclarations of '"+string($<Name>1)+"'");
    }
    else if(s!="None"){
        WarningLevel2.push_back("error: conflicting types for '"+string($<Name>1)+"'");
    }
} equal J {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Name>1);
    strcpy(ptr->Type,variableType.c_str());
    $<Var>$=ptr;
    if(!noMore&&!ifFlag){
        toPrint.push_back(string($<Name>1)+"="+string($<Var>4->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(string($<Name>1)+"="+string($<Var>4->Name),"normal"));
    }
    v.push_back(ptr); 
} | variable {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Name>1);
    strcpy(ptr->Type,variableType.c_str());
    $<Var>$=ptr;
    string s=findIn($<Name>1,Start[block]);
    if(s==variableType){
        WarningLevel2.push_back("error: redeclarations of '"+string($<Name>1)+"'");
    }
    else if(s!="None"){
        WarningLevel2.push_back("error: conflicting types for '"+string($<Name>1)+"'");
    }
    else{
        v.push_back(ptr);
    }
};
C: C minus D {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"-"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"-"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | C plus D {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"+"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"+"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | D {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>1->Name);
    $<Var>$=ptr;
};
D: D multiply Q {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"*"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"*"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | D divide Q {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"/"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"/"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | D modulus Q {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"%"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"%"+string($<Var>3->Name),"normal"));
    }   
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | Q {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>1->Name);
    $<Var>$=ptr;
};
Q: NEG openingBracket J closingBracket {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>2->Name);

    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"=!"+string(ptr->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"=!"+string(ptr->Name),"normal"));
    } 
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | NEG variable {
    struct Variable *ptr=new Variable();
    string S($<Name>1);
    if(findIn($<Name>1)=="None"){
        if(!noMore){
            WarningLevel1.push_back("error: var '"+string($<Name>1)+"' is not declared in the scope");
        }
        noMore=1;
    }
    else if(findIn($<Name>1)!=variableType){
        S="("+variableType+")"+S;
    }
    strcpy(ptr->Name,S.c_str());
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"=!"+string(ptr->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"=!"+string(ptr->Name),"normal"));
    } 
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | E ;
E: openingBracket J closingBracket {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>2->Name);
    $<Var>$=ptr;
} | Call1 {
    struct Variable *ptr=new Variable();
    ptr=$<Var>1;
    $<Var>$=ptr;
} | i_constant {
    struct Variable *ptr=new Variable();
    string s=to_string($<Integer>1);
    if(variableType!="int"){
        s="("+variableType+")"+s;
    }
    strcpy(ptr
    ->Name,s.c_str());
    $<Var>$=ptr;
} | f_constant {
    struct Variable *ptr=new Variable();
    string s=to_string($<Float>1);
    if(variableType!="float"){
        s="("+variableType+")"+s;
    }
    strcpy(ptr->Name,s.c_str());
    $<Var>$=ptr;
} ;
Call1: variable openingBracket Argument1 closingBracket {
    string S=s+to_string(count);
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,S.c_str());
    toPrint.push_back("goto "+mappingFunction[string($<Name>1)]);
    toPrint.push_back(S+"=popReturn");
    count++;
    $<Var>$=ptr;
} | variable {
    struct Variable *ptr=new Variable();
    string s($<Name>1);
    if(findIn($<Name>1)=="None"){
        if(!noMore){
            WarningLevel1.push_back("error: var '"+string($<Name>1)+"' is not declared in the scope");
        }
        noMore=1;
    }
    else if(findIn($<Name>1)!=variableType){
        s="("+variableType+")"+s;
    }
    strcpy(ptr->Name,s.c_str());
    $<Var>$=ptr;
};
Argument1: C {
    string s="pushParam "+string($<Var>1->Name);
    toPrint.push_back(s);
} Argument2 | ;
Argument2: colon Argument1 | ;
F: variable {
    string s=findIn($<Name>1);
    if(s!="None"){
        variableType=s;
    }
    else{
        if(!noMore){
            WarningLevel1.push_back("error: var '"+string($<Name>1)+"' is not declared in the scope");
        }
        noMore=1;
    }
} equal C {
    if(!noMore){
        toPrint.push_back(string($<Name>1)+"="+string($<Var>4->Name));
    }
} ;
G: variable_type {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Type,$<Type>1);
    $<Var>$=ptr;
    variableType=string(ptr->Type);
} ;
LOOP: WHILE openingBracket {
    ifFlag=1;
} H closingBracket {
    w.push_back(l+to_string(gotoCount++));
    toPrint.push_back(w.back()+":");
    pass.push_back(l+to_string(gotoCount++));
    fail.push_back(l+to_string(gotoCount++));
    for(auto i:u){
        if(i.second=="normal"){
            toPrint.push_back(i.first);
            continue;
        }
        if(i.second=="or"){
            fail.push_back(l+to_string(gotoCount++));
        }
        if(i.second=="and"){
            pass.push_back(l+to_string(gotoCount++));
        }
        toPrint.push_back("if "+i.first+" goto "+pass.back());
        toPrint.push_back("goto "+fail.back());
        if(i.second=="or"){
            toPrint.push_back(fail.back()+":");
            fail.pop_back();
        }
        if(i.second=="and"){
            toPrint.push_back(pass.back()+":");
            pass.pop_back();
        }
    }
    toPrint.push_back(pass.back()+":");
    pass.pop_back();
    u.clear();
    ifFlag=0;

    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} M {
    cleanIt(Start[block]);
    block=Parent[block];
    toPrint.push_back("goto "+w.back());
    w.pop_back();
    toPrint.push_back(fail.back()+":");
    fail.pop_back();
} ;
REL: IF openingBracket {
    ifFlag=1;
} H closingBracket {
    pass.push_back(l+to_string(gotoCount++));
    fail.push_back(l+to_string(gotoCount++));
    for(auto i:u){
        if(i.second=="normal"){
            toPrint.push_back(i.first);
            continue;
        }
        if(i.second=="or"){
            fail.push_back(l+to_string(gotoCount++));
        }
        if(i.second=="and"){
            pass.push_back(l+to_string(gotoCount++));
        }
        toPrint.push_back("if "+i.first+" goto "+pass.back());
        toPrint.push_back("goto "+fail.back());
        if(i.second=="or"){
            toPrint.push_back(fail.back()+":");
            fail.pop_back();
        }
        if(i.second=="and"){
            toPrint.push_back(pass.back()+":");
            pass.pop_back();
        }
    }
    toPrint.push_back(pass.back()+":");
    pass.pop_back();
    u.clear();
    ifFlag=0;

    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} M {
    cleanIt(Start[block]);
    block=Parent[block];

    toPrint.push_back(fail.back()+":");
    fail.pop_back();
} ;
REL_ELSE_IF: ELSEIF openingBracket {
    ifFlag=1;
} H closingBracket {
    pass.push_back(l+to_string(gotoCount++));
    fail.push_back(l+to_string(gotoCount++));
    for(auto i:u){
        if(i.second=="normal"){
            toPrint.push_back(i.first);
            continue;
        }
        if(i.second=="or"){
            fail.push_back(l+to_string(gotoCount++));
        }
        if(i.second=="and"){
            pass.push_back(l+to_string(gotoCount++));
        }
        toPrint.push_back("if "+i.first+" goto "+pass.back());
        toPrint.push_back("goto "+fail.back());
        if(i.second=="or"){
            toPrint.push_back(fail.back()+":");
            fail.pop_back();
        }
        if(i.second=="and"){
            toPrint.push_back(pass.back()+":");
            pass.pop_back();
        }
    }
    toPrint.push_back(pass.back()+":");
    pass.pop_back();
    u.clear();
    ifFlag=0;

    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} M {
    cleanIt(Start[block]);
    block=Parent[block];

    toPrint.push_back(fail.back()+":");
    fail.pop_back();
} ;
REL_ELSE: ELSE {
    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} M {
    cleanIt(Start[block]);
    block=Parent[block];
};
H: H Or {
    u.back().second="or";
} I | I ;
I: I And {
    u.back().second="and";
} J {
    u.push_back(make_pair(string($<Var>4->Name),""));
} | J {
    u.push_back(make_pair(string($<Var>1->Name),""));
} ;
J: J isEqual K {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"=="+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"=="+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
}  | J isNotEqual K {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"!="+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"!="+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | K {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>1->Name);
    $<Var>$=ptr;
} ;
K: K st L {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"<"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"<"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | K gt L {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+">"+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+">"+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | K ste L {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+"<="+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+"<="+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | K gte L {
    if(!noMore&&!ifFlag){
        toPrint.push_back(s+to_string(count)+"="+string($<Var>1->Name)+">="+string($<Var>3->Name));
    }
    if(!noMore&&ifFlag){
        u.push_back(make_pair(s+to_string(count)+"="+string($<Var>1->Name)+">="+string($<Var>3->Name),"normal"));
    }
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,(s+to_string(count)).c_str());
    $<Var>$=ptr;
    count++;
} | L {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>1->Name);
    $<Var>$=ptr;
}; 
L: C {
    struct Variable *ptr=new Variable();
    strcpy(ptr->Name,$<Var>1->Name);
    $<Var>$=ptr;
};
M: A semicolon | F semicolon | REL | openingBraces {
    blockCount++;
    Parent[blockCount]=block;
    block=blockCount;
    Start[blockCount]=v.size();
} S closingBraces {
    cleanIt(Start[block]);
    block=Parent[block];
} ;
N: REL O | REL ;
O: P REL_ELSE | P | REL_ELSE ;
P: P REL_ELSE_IF | REL_ELSE_IF ;
%%
int main(int argc,char **argv){
    FILE *file;
    file=fopen(argv[1],"r");
    yyin=file;
    yyparse();
}
int yyerror(char *s){
    printf("Error %s\n",s);
}
