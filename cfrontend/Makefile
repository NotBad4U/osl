COMPILEDIR=cfrontend
BACKEND=llvm
KBINPATH=../k/bin

all: cfrontend-kompiled

cfrontend-kompiled: *.k
	kompile c.k --backend $(BACKEND)

test:
	krun test.c

ast:
	kast test.c


.PHONY: clean

clean:
	@rm -rf $(COMPILEDIR)