BACKEND=llvm
KBINPATH=../k/bin

all: cfrontend-kompiled

cfrontend-kompiled: *.k
	kompile c.k --backend $(BACKEND)

tests:
	./test/run.sh


test:
	krun test.c

ast:
	kast test.c


.PHONY: all test tests clean

clean:
	@rm -rf $(COMPILEDIR)