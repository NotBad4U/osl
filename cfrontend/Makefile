COMPILEDIR=cfrontend
BACKEND=ocaml
KBINPATH=../k/bin

all: cfrontend-kompiled

cfrontend-kompiled: *.k
	$(KBINPATH)/kompile c.k --backend $(BACKEND) -d $(COMPILEDIR)

test:
	$(KBINPATH)/krun --directory ./$(COMPILEDIR) test.c

ast:
	$(KBINPATH)/kast --directory ./$(COMPILEDIR) test.c


.PHONY: clean

clean:
	@rm -rf $(COMPILEDIR)