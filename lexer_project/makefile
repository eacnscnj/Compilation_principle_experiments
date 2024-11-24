lex : lex.yy.c
	gcc -o lex lex.yy.c -lfl

lex.yy.c:lexer.l
	flex lexer.l

clean:
	rm lex.yy.c lex

build:
	./lex input.txt output.txt