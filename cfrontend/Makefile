BACKEND=llvm
KBINPATH=../k/bin

all: cfrontend-kompiled

cfrontend-kompiled: *.k
	kompile c.k --backend $(BACKEND)

test:
	krun test.c	

tests:
	./test/run.sh	

ast:
	kast test.c


.PHONY: all test tests clean

clean:
	@rm -rf $(COMPILEDIR)