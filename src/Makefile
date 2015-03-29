

EXEC=main
TEST=tests/7.in
SVG=out.svg

all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_avl
	gnatclean test_comp
	rm -f out.png

run: all
	./$(EXEC) $(TEST)

tests: all
	./$(EXEC) tests/1.in > tests/1.svg
	./$(EXEC) tests/2.in > tests/2.svg
	./$(EXEC) tests/3.in > tests/3.svg
	./$(EXEC) tests/4.in > tests/4.svg
	./$(EXEC) tests/5.in > tests/5.svg
	./$(EXEC) tests/6.in > tests/6.svg
	./$(EXEC) tests/7.in > tests/7.svg
	./$(EXEC) tests/8.in > tests/8.svg

svg: all
	./$(EXEC) $(TEST) > $(SVG)
	inkscape $(SVG)

test_avl:
	gnatmake $@

test_comp: all
	gnatmake $@

dot:
	dot -Tpng test.dot > out.png


