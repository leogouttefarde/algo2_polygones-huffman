
EXEC=huffman
TEST=tests/test0.txt
OUT=$(TEST).huff


all:
	gnatmake $(EXEC)

clean:
	gnatclean $(EXEC)
	gnatclean test_file
	rm -f $(OUT)

run: all
	./$(EXEC) -c $(TEST) $(OUT)

test: all
	gnatmake test_file

frun: test
	./test_file


