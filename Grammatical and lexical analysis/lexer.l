%{
#include <stdio.h>
#include <string.h>
#include "cal.tab.h"  // 包含 Bison 生成的头文件

extern FILE *yyin;

// 保留字表，按字典序排序
const char *keywords[] = {
    "break", "case", "default", "do", "else",
    "for", "if", "int", "read", "switch", "while", "write"
};

#define KEYWORDS_COUNT (sizeof(keywords) / sizeof(keywords[0]))

int is_keyword(const char *word) {
    int low = 0, high = KEYWORDS_COUNT - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        int cmp = strcasecmp(word, keywords[mid]); 
        if (cmp == 0) return 1;
        if (cmp < 0) high = mid - 1;
        else low = mid + 1;
    }
    return 0; // 未找到
}
int yycolumn = 1;
extern unsigned lexError;

/*void print_token(const char *token, const char *value) {
	fprintf(yyout,"%-12s %-12s\n", token, value);
}*/
%}
%option noyywrap
%option yylineno

digit [0-9]
letter [a-zA-Z]
ID [a-zA-Z][0-9a-zA-Z]*
NUM  0|([1-9][0-9]*)
TYPE int
IF if
ELSE else
FOR for
WHILE while
DO do
INT 0|[1-9]+[0-9]*
WRITE write
STRUCT struct
READ read
RETURN return
RELOP 	>|<|>=|<=|==|!=
COMMENT "/*"([^*]|\*+[^*/])*\*+"/"

%%
[ \t]+ {;}
[\t]           { yycolumn = 1; }
[\n]            { yycolumn = 1; }
{INT} { yylval.node = newTokenNode(yylineno, TOKEN_INT, "INT", yytext); return INT;}
{digit}+{ID} {printf("Error type A at Line %d: Illegal ID \"%s\".\n", yylineno, yytext); }
{IF} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "IF", yytext); return IF; }
{ELSE} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "ELSE", yytext); return ELSE; }
{WHILE} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "WHILE", yytext); return WHILE; }
{STRUCT} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "STRUCT", yytext); return STRUCT; }
{RETURN} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "RETURN", yytext); return RETURN; }
{RELOP} { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "RELOP", yytext); return RELOP; }
{TYPE} { yylval.node = newTokenNode(yylineno, TOKEN_TYPE, "TYPE", yytext); return TYPE; }
"+" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "PLUS", yytext); return PLUS; }
"-" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "MINUS", yytext); return MINUS; }
"*" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "STAR", yytext); return STAR; }
"/" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "DIV", yytext); return DIV; }
"&&" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "AND", yytext); return AND; }
"||" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "OR", yytext); return OR; }
"!" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "NOT", yytext); return NOT; }
"," { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "COMMA", yytext); return COMMA; }
"." { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "DOT", yytext); return DOT; }
";" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "SEMI", yytext); return SEMI; }

"=" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "ASSIGNOP", yytext); return ASSIGNOP; }

"(" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "LP", yytext); return LP; }
")" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "RP", yytext); return RP; }
"[" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "LB", yytext); return LB; }
"]" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "RB", yytext); return RB; }
"{" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "LC", yytext); return LC; }
"}" { yylval.node = newTokenNode(yylineno, TOKEN_OTHER, "RC", yytext); return RC; }

{ID} { yylval.node = newTokenNode(yylineno, TOKEN_ID, "ID", yytext); return ID;}

{COMMENT}       { yycolumn = 1; }
.               { printf("Error at line %d: Unrecognized character '%s'\n", yylineno, yytext); }
%%


/*int main(int argc, char **argv) {

    yyin = fopen("input.txt", "r");
    if (!yyin) {
        perror("Error opening input file");
        return 1;
    }

    yyout = fopen("output.txt", "w");
    if (!yyout) {
        perror("Error opening output file");
        fclose(yyin);
        return 1;
    }

    // 开始词法分析
    yylex();

    fclose(yyin);
    fclose(yyout);

    return 0;
}*/

