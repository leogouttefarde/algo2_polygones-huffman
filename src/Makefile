

EXEC=main

all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)

run: all
	./$(EXEC) tests/1.in > test.svg
	inkscape test.svg
	rm test.svg


