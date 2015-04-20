
EXEC=huffman
TEST=fichier.txt
OUT=$(TEST).huff


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	rm -f $(OUT)

run: all
	./$(EXEC) -c $(TEST) $(OUT)


