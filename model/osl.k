
require "osl-syntax.k"
require "configuration.k"
require "control.k"
require "block.k"
require "call.k"


module OSL

import OSL-SYNTAX
import CONFIGURATION
import CONTROL
import BLOCK
import CALL


rule <k> newResource(Ps:Props) => #rs(Ps) ... </k>

rule S:Stmt Ss:Stmts => S ~> Ss
rule .Stmts => .


rule V:Value ~> .Stmts => V

rule V:Value ; => .

rule <k> decl X:Id ; => . ... </k>
     <env> Rho:Map => Rho[X <- N] </env>
     <store> .Map => N |-> #uninit ... </store>
     <stack> .List => ListItem( X ) ... </stack>
     <timer> TI:Int => TI +Int 1 </timer>
     <indexes> #indexes((N:Int => N +Int 1),_)  </indexes>

syntax Exp
       ::= #Transfer(Exp, Exp)  [strict]
	 | #TransferV(Exp,Exp)

rule #lv(newResource(Ps:Props)) => newResource(Ps)

// evaluate the expression: Transfer (call F) X
rule #lv( call F:Id (Es:Exps) ) => call F:Id (Es:Exps)

rule <k> #lv(X:Id) => #loc(I) ...  </k>
     <env> ... X |-> I:Int ...  </env>

rule <k> transfer EF:Exp TX:Exp ; => #Transfer(#lv(EF),#lv(TX))
     	 	  	 	~> #increaseIndex ~> #increaseTimer ... </k>
     <timer> TR:Int  </timer>
     <env> ENV:Map </env>
     <write> .Set => SetItem(#writev(#wv(TX,ENV), TR)) ... </write>

syntax WItem
       ::= #writev(Int,Int)

syntax Int
       ::= #wv(Exp,Map)		[function]

syntax Int
       ::= #unwrapVal(K)	[function]

rule #unwrapVal(V:Int) => V

rule #wv(X:Id, ENV:Map) => #unwrapVal(ENV[X])
rule #wv(* E:Exp, ENV:Map) => #wv(E,ENV)
//rule #wv(E:Exp . I:Int, ENV:Map) => #wv(E, ENV) . I

syntax IndexItem
       ::= "#increaseIndex"
         | "#increaseTimer"

rule <k> #increaseIndex => . ... </k>
     <indexes> #indexes((C:Int => C +Int 1), _:Int) </indexes>

rule <k> #increaseTimer => . ... </k>
     <timer> TIMER:Int => TIMER +Int 1 </timer>

syntax Bool
       ::= #inProps(Prop, Props)			[function]


rule #inProps(P, #props(P, Ps)) => true
rule #inProps(P1, #props(P, Ps)) => #inProps(P1, Ps)
     requires P1 =/=K P
rule #inProps(P, .Props) => false


syntax Set
       ::= #list2Set(List)              [function]
rule #list2Set(.List) => .Set
rule #list2Set(ListItem(E) L:List) => SetItem(E) #list2Set(L)

syntax Bool
       ::= #existRef(K,Set,Int)		[function]

rule #existRef(R:K, SetItem(#rs(_)) S:Set, C:Int) => #existRef(R, S, C)
rule #existRef(R:K, SetItem(#uninit) S:Set, C:Int) => #existRef(R, S, C)
rule #existRef(R:K, SetItem(#br(_,C1:Int,R)) S:Set, C:Int) => (C1 >=Int C) andBool true
rule #existRef(R:K, SetItem(#br(_,C1:Int,R1)) S:Set, C:Int) => #existRef(R,S,C)
     requires R =/=K R1
     
rule #existRef(_, .Set, _) => false


rule <k> #Transfer(#loc(F:Int), #loc(L:Int)) => #TransferV(#loc(F), #loc(L)) ... </k>
     <store> STORE:Map </store>
     <indexes> #indexes(C:Int, _:Int) </indexes>
     requires (notBool #existRef(#immRef(F), #list2Set(values(STORE)),C)) andBool
	      (notBool #existRef(#mutRef(F), #list2Set(values(STORE)),C))

rule <k> #Transfer(#rs(R:Props), #loc(L)) => . ... </k>
     <store> ... L |-> (_ => #rs(R)) ... </store>

// return of a function
// Transfer an immutable reference into L.
// Can be see like borrow a borrowed L.
rule <k> #Transfer(#ref(F), #loc(L)) => #TransferIB(#loc(F), #loc(L)) ... </k>
     <store> ... F |-> #rs(PS:Props) ... </store>
     requires notBool #inProps(mut, PS)

// return of a function
// Transfer a mutable reference into L
// Can be see like mborrow an mborrowed L.
rule <k> #Transfer(#ref(F), #loc(L)) => #TransferMB(#loc(F), #loc(L)) ... </k>
     <store> ... F |-> #rs(PS:Props) ... </store>
     requires #inProps(mut, PS)

rule <k> #TransferV(#loc(F), #loc(L)) => #Transfer(#rs(PS), #loc(L)) ... </k>
     <store> ... (F |-> #rs(PS)) => (F |-> #uninit)  ... </store>
     requires notBool #inProps(copy, PS)


rule <k> #TransferV(#loc(F), #loc(L)) => #Transfer(#rs(PS), #loc(L)) ... </k>
     <store> ... F |-> #rs(PS:Props) ... </store>
     requires #inProps(copy, PS)

syntax Exp
       ::= #TransferIB(K,K)		[strict(1)]
         | #TransferMB(K,K)		[strict(1)]
	 | #uninitialize(Exp)

rule <k> #TransferV(#loc(F), #loc(L)) => #TransferIB(read(#loc(F)), #loc(L)) ... </k>
     <store> ... F |-> #br(BEG,END,#immRef(L1)) ... </store>

rule <k> #TransferV(#loc(F), #loc(L)) =>
     	 		     	#TransferMB(read(#loc(F)), #loc(L)) ~>
				#uninitialize(#loc(F)) ... </k>
     <store> ... F |-> #br(BEG,END,#mutRef(L1)) ... </store>

rule <k> #TransferIB(#loc(F), #loc(L)) => . ... </k>
     <store> ... L |-> (_ => #br(C,C,#immRef(F))) ... </store>
     <indexes> #indexes(C:Int, _:Int) </indexes>


rule <k> #TransferMB(#loc(F), #loc(L)) => . ... </k>
     <store> Rho:Map => Rho[L <- #br(C,C,#mutRef(F))] </store>
     <indexes> #indexes(C:Int, _:Int) </indexes>

rule <k> #uninitialize(#loc(F:Int)) => . ... </k>
     <store> ... F |-> (_ => #uninit) ... </store>

rule X:Id => read(X)


rule <k> read(X:Id) => read(#loc(L)) ... </k>
     <env> ... X |-> L:Int ...  </env>

rule <k> read(#loc(L:Int)) => #rs(N) ...  </k>
     <store> ... L |-> #rs(N:Props) ... </store>

rule <k> read(#loc(L:Int)) => #Read(#borrowImmCK(L,BEG,END,L1)) ~> #loc(L1) ...  </k>
     <store> ... L |-> #br(BEG:Int, END:Int, #immRef(L1:Int)) ... </store>

syntax OItem
       ::= #Read(K)		[strict]

rule #Read(#loc(L:Int)) => #Read(read(#loc(L)))

rule #Read(#rs(R:Props)) => .

rule <k> read(#loc(L:Int)) => #Read(#borrowMutCK(L,BEG,END,L1)) ~> #loc(L1) ...  </k>
     <store> ... L |-> #br(BEG:Int, END:Int, #mutRef(L1:Int)) ... </store>

syntax Bool
       ::= #writeCK(Int, Int, Int, Set)		[function]

rule #writeCK(L:Int, B:Int, E:Int, SetItem(#writev(L, T:Int)) RestS:Set) => false
     requires (B <=Int T) andBool ( T <=Int E)

rule #writeCK(L:Int, B:Int, E:Int, SetItem(#writev(L1, T:Int)) RestS:Set) => #writeCK(L,B,E, RestS)
     requires L =/=Int L1


rule #writeCK(L:Int, B:Int, E:Int, SetItem(#writev(L, T:Int)) RestS:Set) => #writeCK(L,B,E, RestS)
     requires notBool((B <=Int T) andBool ( T <=Int E))

rule #writeCK(_,_,_,.Set) => true



rule <k> #borrowImmCK(L:Int, BEG:Int, END:Int, L1:Int) => #loc(L1) ... </k>
     <store> Rho:Map => Rho[L <- #br(BEG, TIMER, #immRef(L1))] </store>
     <indexes> #indexes(C:Int,_) </indexes>
     <timer> TIMER:Int </timer>
     <write> WRITE:Set </write>
     <unsafe-mode> UNSAFE_BLOCK:Bool </unsafe-mode>
     requires ( UNSAFE_BLOCK ==Bool true )
               orBool
               ((#borrowimmck(L, Rho, BEG, TIMER , L1) ==Bool false) andBool
     	      (#writeCK(L1, BEG, TIMER,WRITE)))

rule <k> #borrowMutCK(L:Int,BEG:Int, END:Int,L1:Int) => #loc(L1) ... </k>
     <store> Rho:Map => Rho[L <- #br(BEG, TIMER, #mutRef(L1))] </store>
     <indexes> #indexes(C:Int, _) </indexes>
     <timer> TIMER:Int </timer>
     <write> WRITE:Set </write>
     <unsafe-mode> UNSAFE_BLOCK:Bool </unsafe-mode>
     requires  ( UNSAFE_BLOCK ==Bool true )
               orBool
               ((#borrowmutck(L, Rho, BEG, TIMER , L1) ==Bool false) andBool
     	      (#writeCK(L1, BEG, TIMER,WRITE)))
     	           

syntax Bool
       ::= #lc(Int,Int,Int,Int)				[function]
         | #borrowimmck(Int, Map, Int, Int, Int)	[function]
         | #borrowmutck(Int, Map, Int, Int, Int)	[function]

syntax OItem
       ::= #borrowImmCK(Int,Int,Int,Int)
         | #borrowMutCK(Int,Int,Int,Int)

/************************* lvalue *******************************/


rule <k> #lv(X) => #loc(L)  ... </k>
     <env> ... X |-> L:Int ... </env>

rule #lv(#loc(L:Int)) => #loc(L)

syntax Exp
       ::= #lvDref( Exp )	[strict]

rule #lv( * E:Exp ) => #lvDref(#lv(E))

rule <k> #lvDref(#loc(L:Int)) => #borrowImmCK(L, BEG, END, L1) ... </k>
     <store> ... L |-> #br(BEG:Int, END:Int, #immRef(L1:Int)) ... </store>


rule <k> #lvDref(#loc(L:Int)) => #borrowMutCK(L, BEG, END, L1) ... </k>
     <store> ... L |-> #br(BEG:Int, END:Int, #immRef(L1:Int)) ... </store>






/*****************************************************************/


rule #lc(L1:Int,L2:Int,L3:Int,L4:Int) => ((L1 <Int L3) andBool (L3 <=Int L2)) orBool
     				         ((L1 <Int L4) andBool (L4 <=Int L2))

rule #borrowimmck(L4:Int, L |-> #rs(_) M:Map, L1:Int, L2:Int, L3:Int) => #borrowimmck(L4, M, L1, L2, L3)
rule #borrowimmck(L4:Int, L |-> #br(_,_,#immRef(_)) M:Map, L1:Int, L2:Int, L3:Int) => #borrowimmck(L4, M, L1, L2, L3)
rule #borrowimmck(L4:Int, L |-> #uninit M:Map, L1:Int, L2:Int, L3:Int) => #borrowimmck(L4, M, L1, L2, L3)

rule #borrowimmck(L5:Int, L:Int |-> #br(_,_, #mutRef(L3:Int))  M:Map, L1:Int, L2:Int, L4:Int)
     		     => #borrowimmck(L5, M, L1, L2, L4)
     requires L3 =/=Int L4

rule #borrowimmck(L5:Int, L:Int |-> #br(BEG:Int, END:Int, #mutRef(L3:Int))  M:Map, L1:Int, L2:Int, L3:Int)
     		     =>  #borrowimmck(L5, M, L1, L2, L3)
     requires (L5 =/=Int L) andBool (#lc(L1, L2 , BEG , END) ==Bool false)

rule #borrowimmck(L5:Int, L:Int |-> #br(BEG:Int, END:Int, #mutRef(L3:Int))  M:Map, L1:Int, L2:Int, L3:Int)
     		     =>  true
     requires (L5 =/=Int L) andBool (#lc(L1, L2 , BEG , END) ==Bool true)


rule #borrowimmck(L:Int, L |-> #br(BEG:Int, END:Int, #mutRef(L3:Int))  M:Map, L1:Int, L2:Int, L3:Int)
     		     =>  #borrowimmck(L, M, L1, L2, L3)



rule #borrowimmck(_,.Map, _,_,_) => false


/**********************************************************/

rule #borrowmutck(L4:Int, L |-> #rs(_) M:Map, L1:Int, L2:Int, L3:Int)
     			  => #borrowmutck(L4, M, L1, L2, L3)

rule #borrowmutck(L4:Int, L |-> #br(_,_,#immRef(L5:Int)) M:Map, L1:Int, L2:Int, L3:Int)
     			  => #borrowmutck(L4, M, L1, L2, L3)
     requires L5 =/=Int L3


rule #borrowmutck(L5:Int, L |-> #br(BEG,END,#immRef(L3:Int)) M:Map, L1:Int, L2:Int, L3)
     			  => #borrowmutck(L5, M, L1, L2, L3)
     requires (L5 =/=Int L) andBool (#lc(L1,L2,BEG,END) ==Bool false)

rule #borrowmutck(L5:Int, L |-> #br(BEG,END,#immRef(L3:Int)) M:Map, L1:Int, L2:Int, L3)
     			  => true
     requires (L5 =/=Int L) andBool (#lc(L1,L2,BEG,END) ==Bool true)


rule #borrowmutck(L4:Int, (L:Int |-> #uninit) M:Map, L1:Int, L2:Int, L3:Int)
     			  => #borrowmutck(L4, M, L1, L2, L3)

rule #borrowmutck(L5:Int, L:Int |-> #br(_,_, #mutRef(L3:Int))  M:Map, L1:Int, L2:Int, L4:Int)
     		     => #borrowmutck(L5, M, L1, L2, L4)
     requires L3 =/=Int L4

rule #borrowmutck(L5:Int, L:Int |-> #br(BEG:Int, END:Int, #mutRef(L3:Int))
     			  	    		 M:Map, L1:Int, L2:Int, L3:Int)
     			  =>  #borrowmutck(L5, M, L1, L2, L3)
     requires (L5 =/=Int L) andBool (#lc(L1, L2 , BEG , END) ==Bool false)

rule #borrowmutck(L5:Int, L:Int |-> #br(BEG:Int, END:Int, #mutRef(L3:Int))
     			  	    		 M:Map, L1:Int, L2:Int, L3:Int)
     		     =>  true
     requires (L5 =/=Int L) andBool (#lc(L1, L2 , BEG , END) ==Bool true)


rule #borrowmutck(L:Int, (L |-> #br(_,_,_)) M:Map, L1:Int, L2:Int, L3:Int)
     		     =>  #borrowmutck(L, M, L1, L2, L3)

rule #borrowmutck(_,.Map, _,_,_) => false


/**********************************************************/

syntax Bool
       ::= #checkInit(Id, Map, Map)	[function]

rule #checkInit(X,E:Map, S:Map) => S[E[X]] =/=K #uninit



rule <k> X:Id borrow Y:Id ; => . ... </k>
     <env>  ENV:Map  </env>
     <store> ST:Map =>
     	     ST[#unwrapInt(ENV[X]) <-
	       #br(C,C, #immRef(#unwrapInt(ENV[Y])))] </store>
     <timer> TIMER:Int => TIMER +Int 1 </timer>
     <indexes> #indexes((C:Int => C +Int 1),_) </indexes>
     requires #checkInit(Y,ENV,ST)

     

rule <k> X:Id mborrow Y:Id ; => . ... </k>
     <env>  ENV:Map  </env>
     <store> ST:Map => ST[#unwrapInt(ENV[X]) <- #br(C, C, #mutRef(#unwrapInt(ENV[Y])))] </store>
     <indexes> #indexes((C:Int => C +Int 1),_) </indexes>
     <timer> TIMER:Int => TIMER +Int 1 </timer>
     requires #checkInit(Y,ENV,ST)


syntax Int
       ::= #unwrapInt(K)	[function]

rule #unwrapInt(I:Int) => I


rule val(V:Value) => V

syntax DItem
       ::= #Deallocate(Exp)		[strict]
     
rule deallocate E:Exp ; => #Deallocate(#lv(E))

rule #Deallocate(#rs(Ps:Props)) => .

endmodule