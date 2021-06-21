

all: *.k
	kompile -w none osl.k --backend llvm

test: *.k
	krun test.rs

.PHONY: all test tests clean

clean: *~
	rm *~
