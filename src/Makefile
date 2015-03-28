

EXEC=main

all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_avl

run: all
	./$(EXEC) tests/1.in

test_avl:
	gnatmake test_avl


