COMPILEDIR=cfrontend
BACKEND=llvm
KBINPATH=../k/bin

all: cfrontend-kompiled

cfrontend-kompiled: *.k
	kompile c.k --backend $(BACKEND) -d $(COMPILEDIR)

test:
	krun --directory ./$(COMPILEDIR) test.c

ast:
	kast --directory ./$(COMPILEDIR) test.c


.PHONY: clean

clean:
	@rm -rf $(COMPILEDIR)