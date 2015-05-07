
EXEC=huffman
NOM=tests/test3
TEST=$(NOM).txt
ENC=$(NOM).huff
DEC=$(NOM)_dec.txt


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_file
	rm -f arbre.{png,dot} #$(ENC) $(DEC)

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
	mv arbre.dot $(NOM).dot
	mv arbre.png $(NOM).png


