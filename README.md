OSL: An Operational Semantics for Rust Language

## Introduction

OSL semantics is an operational semantics implemented by K-Framework,

which is a rewrite logic based formal modeling tool.

## Dependencies

In order to run the semantics, K-framework should be installed.

The project already contain a version of K-framework that you can use.

But if you want to use your own version, We suggest to install a release compatible with this one, which has been used for the development of OSL:

https://github.com/kframework/k/releases/tag/nightly-f5ea5c7

Other versions nmay arise some problems when compile and run OSL programs.

## Project structure

* `model`: source files of OSL semantic
* `document`: documentation
* `report`: Latex source of the OSL report
* `k`: The K release `nightly-f5ea5c7`

*Please ignore cfrontend folder for now*

## Run OSL semantic

**1. Compile the semantic**

The project provide a `Makefile`, so just run the following commands:
```sh
cd model
make 
```

The underlying command run is:

```sh
kompile -w none osl.k --backend llvm
```

**2. Run the example **

The project provide some demos.
You can try OSL by running this command in the `model` folder:

```sh
krun t4.rs
```
or

```sh
krun demo/demo.c
```

## Issues migrating from 3.5 to 5.1

The current aims to compile with the version `5.1`.
For now, the migration is encountering migration issue.

### Error 1


<u>Current code:</u> 

```
syntax Props
       ::= List{Prop, ","}			[klabel(#props)]

rule #inProps(P, #props(P, Ps)) => true
```

<u>Error:</u>

```sh
[Error] Inner Parser: Could not find any suitable production for label #props
	Source(/home/alessio/Project/osl/model/./osl.k)
	Location(79,18,79,24)
```

<u>Potential patch:</u>

I just unfolded the `#props`

```diff
-rule #inProps(P, #props(P, Ps)) => true
-rule #inProps(P1, #props(P, Ps)) => #inProps(P1, Ps)
+rule #inProps(P, (P:Prop, Ps:Props)) => true
+rule #inProps(P1, (P:Prop, Ps:Props)) => #inProps(P1, Ps)
```

### Error 2

<u>Current code:</u>

```
syntax Bool
       ::= #existRef(K,Set,Int)		[function]

rule #existRef(R:K, SetItem(#rs(_)) S:Set, C:Int) => #existRef(R, S, C)
rule #existRef(R:K, SetItem(#uninit) S:Set, C:Int) => #existRef(R, S, C)
rule #existRef(R:K, SetItem(#br(_,C1:Int,R)) S:Set, C:Int) => (C1 >=Int C) andBool true
rule #existRef(R:K, SetItem(#br(_,C1:Int,R1)) S:Set, C:Int) => #existRef(R,S,C)
     requires R =/=K R1
```

<u>Error:</u>

```sh
[Error] Inner Parser: Unexpected sort K for variable R. Expected: Exp
	Source(/home/alessio/Project/osl/model/./osl.k)
	Location(95,42,95,43)
```

<u>Potential patch:</u>
I removed the K sort restriction and let the type inference do his work.

```diff
 rule #existRef(R:K, SetItem(#rs(_)) S:Set, C:Int) => #existRef(R, S, C)
 rule #existRef(R:K, SetItem(#uninit) S:Set, C:Int) => #existRef(R, S, C)
-rule #existRef(R:K, SetItem(#br(_,C1:Int,R)) S:Set, C:Int) => (C1 >=Int C) andBool true
+rule #existRef(R, SetItem(#br(_,C1:Int,R)) S:Set, C:Int) => (C1 >=Int C) andBool true
 rule #existRef(R:K, SetItem(#br(_,C1:Int,R1)) S:Set, C:Int) => #existRef(R,S,C)
      requires R =/=K R1
```

### Error 3

<u>Current code:</u>

```
syntax Block
       ::= "{" Stmts "}"			[klabel(#block)]
       
rule <k> #block(Ss:Stmts) => Ss ~> #blockend ... </k>
     <env> ENV:Map </env>
     <stack> .List => ListItem(ENV) ... </stack>
```

<u>Error:</u>

```sh
[Error] Inner Parser: Could not find any suitable production for label #block
	Source(/home/alessio/Project/osl/model/block.k)
	Location(13,10,13,16)
```

<u>Potential patch:</u>

I forced the type in the rewriting rule.

```diff
-rule <k> #block(Ss:Stmts) => Ss ~> #blockend ... </k>
+rule <k> ({ Ss:Stmts }):Block => Ss ~> #blockend ... </k>
```

### Error 4

<u>Current code:</u>

```
syntax Stmt ::= 
     ...
	 | "@" Blocks  ";"			[klabel(#branch)]
...

rule #branch(B:Block, Bs:Blocks) => #secondBranch(Bs) ~> B
```

<u>Error:</u>

```
[Error] Inner Parser: Could not find any suitable production for label #branch
	Source(/home/alessio/Project/osl/model/control.k)
	Location(11,6,11,13)
```

<u>Potential patch:</u>

I unfolded the syntax rule of `#branch` in the rewriting rule.

```diff
-rule #branch(B:Block, Bs:Blocks) => #secondBranch(Bs) ~> B
+rule @ B:Block, Bs:Blocks ; => #secondBranch(Bs) ~> B
```

### Error 5

```
syntax Exp
       ::= #TransferIB(K,K)		[strict(1)]
         | #TransferMB(K,K)		[strict(1)]
	 	 | #uninitialize(Exp)
...

syntax OItem
       ::= #Read(K)		[strict]
```

<u>Error:</u>

```sh
[Error] Compiler: Cannot heat a nonterminal of sort K. Did you mean KItem?
	Source(/home/alessio/Project/osl/model/./osl.k)
	Location(130,12,130,51)
[Error] Compiler: Cannot heat a nonterminal of sort K. Did you mean KItem?
	Source(/home/alessio/Project/osl/model/./osl.k)
	Location(131,12,131,51)
[Error] Compiler: Cannot heat a nonterminal of sort K. Did you mean KItem?
	Source(/home/alessio/Project/osl/model/./osl.k)
	Location(167,12,167,40)
```

<u>Potential patch:</u>

I am not familiar with the distinction between `K`  and `KItem` sort. 

```diff
syntax OItem
-       ::= #Read(K)            [strict]
+       ::= #Read(KItem)                [strict]
 
```


### Error 6

```
rule <k> #Transfer(#rs(R:Props), #loc(L)) => . ... </k>
     <store> ... L |-> (_ => #rs(R)) ... </store>
```

<u>Potential patch:</u>

```diff
 rule <k> #Transfer(#rs(R:Props), #loc(L)) => . ... </k>
-     <store> ... L |-> (_ => #rs(R)) ... </store>
+     <store> Map => Map[L <- #rs(R)] </store>
```


### Development

You can find tests programs in the folder: `model/tests`.
Use them to control breaking changes and help in the development.