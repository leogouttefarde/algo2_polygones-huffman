
EXEC=huffman
TEST=tests/test1.txt
ENC=$(TEST).huff
DEC=$(TEST)_dec.txt


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_file
	rm -f $(ENC) $(DEC)

run: all
	./$(EXEC) -c $(TEST) $(ENC)
	./$(EXEC) -d $(ENC) $(DEC)

test: all
	gnatmake test_file

frun: test
	./test_file

dot: run
	dot -Tpng arbre.dot > arbre.png


