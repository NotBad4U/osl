
require "osl-syntax.k"
require "configuration.k"

module CONTROL

import OSL-SYNTAX
import CONFIGURATION


rule #branch(B:Block, Bs:Blocks) => #secondBranch(Bs) ~> B

rule <k> @ B:Block, Bs:Blocks ; => #secondBranch(Bs) ... </k>
     <tmp> .List => ListItem(B) ... </tmp>


rule <k> #secondBranch(.Blocks) => B ... </k>
     <tmp> ListItem(B) => .List ... </tmp>

rule <k> #secondBranch(B:Block, Bs:Blocks) ~> Rest:K => #secondBranch(Bs) ~> Rest  </k>
     <env> ENV:Map </env>
     <store> STORE:Map </store>
     <stack> STACK:List </stack>
     <indexes> #indexes(A:Int,C:Int) </indexes>
     <timer> TIMER:Int </timer>
     <write> WRITE:Set  </write>
     <nstate> NS:Int => NS +Int 1 </nstate>
     (.Bag =>
        <state>
	 <index> NS </index>
     	 <k> B ~> Rest </k>
	 <env> ENV </env>
	 <store> STORE </store>
	 <stack> STACK </stack>
         <timer> TIMER </timer>
         <unsafe-mode> UNSAFE </unsafe-mode>
         <write> WRITE  </write>
     	 <indexes> #indexes(A,C) </indexes>
	</state> )


rule <k> #repeat(B:Block) => B ... </k>

// syntax Separator
//        ::= #loopSep(Int)

// rule <k> ! B:Block ; ~> Rest:K => B ~> #loopSep(0)  ~> ! B ; ~> Rest </k>
//      <env> ENV:Map </env>
//      <store> STORE:Map </store>
//      <stack> STACK:List </stack>
//      <timer> TIMER:Int </timer>
//      <write> WRITE:Set  </write>
//      <indexes> #indexes(A:Int,C:Int) </indexes>     
//      <nstate> NS:Int => NS +Int 2 </nstate>
//      (.Bag =>
//         <state>
// 	 <index> NS </index>
//      	 <k> #compare(! B ; ~> Rest) </k>
// 	 <env> ENV </env>
// 	 <store> STORE </store>
// 	 <stack> STACK </stack>
// 	 <timer> TIMER </timer>
//          <write> WRITE  </write>
//      	 <indexes> #indexes(A,C) </indexes>
//  	</state> )
//       (.Bag =>
//         <state>
// 	 <index> NS +Int 1 </index>
//      	 <k> Rest </k>
// 	 <env> ENV </env>
// 	 <store> STORE </store>
// 	 <stack> STACK </stack>
// 	 <timer> TIMER </timer>
//          <write> WRITE  </write>
//      	 <indexes> #indexes(A,C) </indexes>
//  	</state> ) 



// rule <k> #loopSep(N:Int) ~> Rest:K => Rest  </k> 
//      <nstate> NS:Int </nstate>
//      requires N >=Int NS

// rule <k> #loopSep(N:Int) ~> Rest:K => #loopSep(N +Int 1) ~> Rest  </k> 
     

// syntax LoopItem
//        ::= #decompose(K)

// rule #decompose(! B:Block ; ~> Rest:K) => Rest

// rule <state>
//       <k> #loopSep(N:Int) ~> Rest:K => #removeState </k>
//       <env> ENV:Map </env>
//       <store> STORE:Map </store>
//       <stack> STACK:List </stack>
//       ...
//      </state>
//      <state> 
//      	 <index> N </index>
// 	 <k> Pro:K </k>
// 	 <env> ENV1:Map </env>
// 	 <store> STORE1:Map </store>
// 	 <stack> STACK1:List </stack>
// 	 ...
//      </state>
//      requires (Pro ==K #compare(Rest)) andBool #compareS(STORE, STORE1)

// syntax RItem
//        ::= "#removeState"

// rule   (<state>
// 	   <k> #removeState  </k>
// 	   ...
//        </state>) => .Bag


// rule <k> #loopSep(N:Int) ~> Rest:K => #loopSep(N +Int 1) ~> Rest </k>
//      <env> ENV:Map </env>
//      <store> STORE:Map </store>
//      <stack> STACK </stack>
//      <state> 
//      	 <index> N </index>
// 	 <k> Pro:K </k>
// 	 <env> ENV1:Map </env>
// 	 <store> STORE1:Map </store>
// 	 <stack> STACK1 </stack>
// 	 ...
//      </state>
//      requires (Pro =/=K #compare(Rest)) orBool (#compareS(STORE, STORE1)  ==Bool false)


// syntax Bool
//        ::= #compareS(Map,Map)   [function]
//        	 | #compareE(Map,Map)  	[function]
// 	 | #compareA(K,K)      [function]


// rule #compareS(M1:Map, M2:Map) => (size(M1) ==Int size(M2)) andBool #compareE(M1,M2)

// rule #compareE((Key:Int |-> Val) M, M2:Map) => #compareA(Val, M2[Key]) andBool #compareE(M,M2)

// rule #compareE(.Map, M2) => true

// rule #compareA(#uninit, #uninit) => true
// rule #compareA(#uninit, #rs(_)) => false
// rule #compareA(#rs(_), #uninit) => false
// rule #compareA(#rs(P), #rs(P)) => true
// rule #compareA(#uninit, #br(_,_,_)) => false
// rule #compareA(#br(_,_,_), #uninit) => false

// rule #compareA(#rs(_), #br(_,_,_)) => false
// rule #compareA(#br(_,_,_), #rs(_)) => false


// rule #compareA(#rs(P), #rs(P1)) => false
//      requires P =/=K P1

// rule #compareA(#br(_,_,R1), #br(_,_,R1)) => true

// rule #compareA(#br(_,_,R1), #br(_,_,R2)) => false
//      requires R1 =/=K R2






endmodule
















