%{
#include <stdio.h>
#include <string.h>

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

void print_token(const char *token, const char *value) {
	fprintf(yyout,"%-12s %-12s\n", token, value);
}
%}
%option noyywrap
%option yylineno

digit [0-9]
letter [a-zA-Z]
ID [a-zA-Z][0-9a-zA-Z]*
NUM  0|([1-9][0-9]*)
IF if
ELSE else
FOR for
WHILE while
DO do
INT int
WRITE write
READ read
RETURN return
COMMENT "/*"([^*]|\*+[^*/])*\*+"/"

%%

"+"            { print_token("PLUS", "+"); }
"-"            { print_token("MINUS", "-"); }
"*"            { print_token("STAR", "*"); }
"/"            { print_token("DIV", "/"); }
"&&"           { print_token("AND", "&&"); }
"||"           { print_token("OR", "||"); }
"!"            { print_token("NOT", "!"); }
">"            { print_token("GREATER", ">"); }
"<"            { print_token("LESS", "<"); }
"."            { print_token("DOT", "."); }
";"            { print_token("SEMI", ";"); }
"="            { print_token("ASSIGN", "="); }
"("            { print_token("LP", "("); }
")"            { print_token("RP", ")"); }
"["            { print_token("LB", "["); }
"]"            { print_token("RB", "]"); }
"{"            { print_token("LC", "{"); }
"}"            { print_token("RC", "}"); }
">="           { print_token("GREATER_EQUAL", ">="); }
"<="           { print_token("LESS_EQUAL", "<="); }
"=="           { print_token("EQUAL", "=="); }
"\""           { print_token("DOUBLE_QUOTE", "\""); }
"'"            { print_token("SINGLE_QUOTE", "'"); }

[ \t]           {  } 
[\n]            {  }
{digit}         { print_token("digit", yytext); }
{COMMENT}       {  }
{NUM}        	{ print_token("NUM", yytext); }
{ID}        	{ 
                	if (is_keyword(yytext)) {
                	fprintf(yyout,"KEYWORD: %s\n", yytext); // 输出保留字
                	} else {
                	fprintf(yyout,"ID: %s\n", yytext); // 输出标识符
                }; 
            	}

.               { fprintf(yyout,"Error at line %d: Unrecognized character '%s'\n", yylineno, yytext); }
%%


int main(int argc, char **argv) {

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
}

