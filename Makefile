parser: lex.yy.c y.tab.c
	g++ -w y.tab.c lex.yy.c -ll -ly -o minicc
lex.yy.c: test.l y.tab.c
	lex test.l
y.tab.c: test.y
	yacc -v -d -Wno-error=yacc test.y
clean:
	rm -f minicc y.tab.c lex.yy.c y.tab.h y.output
