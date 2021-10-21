
require "osl-syntax.k"
require "configuration.k"

module CONTROL

import OSL-SYNTAX
import CONFIGURATION
import BLOCK


rule #branch(B:Block, Bs:Blocks) => #secondBranch(Bs) ~> B

rule <k> @ B:Block, Bs:Blocks ; => #secondBranch(Bs) ... </k>
     <tmp> .List => ListItem(B) ... </tmp>


rule <k> #secondBranch(.Blocks) => B ... </k>
     <tmp> ListItem(B) => .List ... </tmp>

rule <k> #secondBranch(B:Block, Bs:Blocks) ~> Rest:K => #secondBranch(Bs) ~> Rest </k>
     <env> ENV:Map </env>
     <store> STORE:Map </store>
     <stack> STACK:List </stack>
     <indexes> #indexes(A:Int,C:Int) </indexes>
     <timer> TIMER:Int </timer>
     <unsafe-mode> UNSAFE </unsafe-mode>
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
	     </state>
     )

// Remove a state that has been correctly executed.
rule <nstate> NS:Int => NS -Int 1 </nstate>
     <states>
     ...
     (<state>
          <k>.</k> // sound execution
          ...
     </state> => .Bag)
     ...
     </states>
     requires NS =/=Int 1

syntax Separator
       ::= #loopSep(Int) // The Ints represent the Id of the two states to compare
          | #loopEnd(Int)
          | #evaluate(Block)


// Proposition: All owners keep the own of their resource after a loop iteration.
// If a resource is moved(transfered)/deallocate in previous iteration of loop, it become not available
// for the next iteration. This Rust example illustrate the error:
//
// ```
// let x = P(4);
// loop {
//   let y = x;
//       ^^^^^^^ Value moved here, in previous iteration of loop
// }
// ```
// Compiler Error: The value is use of moved value: `x`
//
//
// For checking this property, we proceed like this:
// First, we evaluate the loop in another <State>.
// Then we verify that each owner in the main <Store>
// are still the owner of their resource by comparing the Value.
//
// NOTE: If the resource has the prop Copy, then the transfer is possible.
rule <k> ! B:Block ; ~> Rest:K => #loopSep(NS) ~> B ~> Rest </k>
     <env> ENV:Map </env>
     <store> STORE:Map </store>
     <stack> STACK:List </stack>
     <timer> TIMER:Int </timer>
     <write> WRITE:Set  </write>
     <unsafe-mode> UNSAFE_BLOCK:Bool </unsafe-mode>
     <indexes> #indexes(A:Int,C:Int) </indexes>
     // Create a new state with a copy of the current context
     // for evaluating the block of the loop without
     // without polluting the main context.
     <nstate> NS:Int => NS +Int 1 </nstate>
     (.Bag =>
          <state>
	          <index> NS </index>
               <k> #evaluate(B) ~> #loopEnd(NS) </k>
	          <env> ENV </env>
	          <store> STORE </store>
	          <stack> STACK </stack>
	          <timer> TIMER </timer>
               <unsafe-mode> UNSAFE_BLOCK </unsafe-mode>
               <write> WRITE  </write>
               <indexes> #indexes(A,C) </indexes>
          </state>
     )

// evaluate the block of the loop
rule #evaluate(#block(Ss:Stmts)) => Ss

// The block of the loop has been evaluated.
// We can now compare the two Store and verify the property above.
syntax Bool ::=
     #IsMoveOccurred(Map,Map) [function]
     | #IsMoved(Int, K, K) [function]

// We have to compare the I:Int tag in requires
// because using the <index> raise a compiler error.
rule
     <state>
          <k> #loopSep(I:Int) ~> Rest:K => Rest </k>
          <store> STORE </store>
          ...
     </state>
     <nstate> NS:Int => NS -Int 1 </nstate>
     (<state>
          <k> #loopEnd(I2) </k>
          <store> STORE2 </store>
          ...
     </state>  => .Bag)
     requires (#IsMoveOccurred(STORE, STORE2) ==Bool true) andBool (I ==Int I2)

// Case of return in the loop.
// TODO: maybe a better way to deal with this problem.
rule V:Value ~> Rest:Stmts ~> #loopEnd(I) => #loopEnd(I)

// Check if the owner has still the owner of his resource after the evaluation of the loop
rule #IsMoveOccurred((Key:Int |-> #rs(Props)) M, M2:Map) => #IsMoved(Key, #rs(Props), M2[Key]) andBool #IsMoveOccurred(M,M2)

// skip this check if the resource is uninit or a reference
rule #IsMoveOccurred((Key:Int |-> #uninit) M, M2:Map) => true andBool #IsMoveOccurred(M,M2)
rule #IsMoveOccurred((Key:Int |-> #br(_,_,_)) M, M2:Map) => true andBool #IsMoveOccurred(M,M2)
rule #IsMoveOccurred(.Map, M2) => true

rule #IsMoved(Key, #rs(P1), #rs(P2)) => true
     requires P1 ==K P2
// A variable has been moved and will be use in the next loop iteration.
rule #IsMoved(Key, #rs(P), #uninit) => false
rule #IsMoved(Key, #rs(P), #br(_,_,_)) => false

endmodule