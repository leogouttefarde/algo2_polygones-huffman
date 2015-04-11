
EXEC=main
TEST=args


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	rm -f trash.o

run: all
	./$(EXEC) $(TEST)


