
EXEC=huffman
TEST=tests/test0.txt
ENC=$(TEST).huff
DEC=$(TEST)_dec.txt


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_file
	rm -f $(ENC) $(DEC) arbre.{png,dot}

run: all
	./$(EXEC) -c $(TEST) $(ENC)
	./$(EXEC) -d $(ENC) $(DEC)

test: all
	gnatmake test_file

frun: test
	./test_file

dot: run
	dot -Tpng arbre.dot > arbre.png
	gwenview arbre.png > /dev/null 2>&1


