
require "osl-syntax.k"
require "configuration.k"

module CALL

import OSL-SYNTAX
import CONFIGURATION


rule <k> fn F:Id (Ps:Parameters) -> T:Type B:Block ; => . ... </k>
     (.Bag =>
     <funDef>
	<fname> F </fname>
	<fparams> Ps </fparams>
	<fret> T </fret>
	<fbody> B </fbody>
     </funDef> )


syntax Bool ::= #inProps2(Prop, Props) [function]
rule #inProps2(P, #props(P, Ps)) => true
rule #inProps2(P1, #props(P, Ps)) => #inProps2(P1, Ps)
     requires P1 =/=K P
rule #inProps2(P, .Props) => false

syntax Bool
       ::= #checkType(K,Type)     [function]

syntax Set ::= #props2Set(Props)              [function]
rule #props2Set(.Props) => .Set
rule #props2Set((P:Prop,L:Props)) => SetItem(P) #props2Set(L)

rule #checkType(#rs(Ps1:Props), #own(Ps2:Props)) => true
     requires #props2Set(Ps2) <=Set #props2Set(Ps1)

rule #checkType(#br(_,_,#immRef(_)), #ref (_, #own(Ps:Props))) => true
     requires #inProps2(mut, Ps) ==Bool false

rule #checkType(#br(_,_,#mutRef(_)), #ref (_, #own(Ps:Props))) => true
     requires #inProps2(mut, Ps)

rule #checkType(& X, #ref (_, #own(Ps:Props))) => true
     requires #inProps2(mut, Ps) ==Bool false

rule #checkType(&mut X, #ref (_, #own(Ps:Props))) => true
     requires #inProps2(mut, Ps)

syntax Stmts
       ::= #bindParams(K,K,K,Map,Map)     [function]

rule <k> call F:Id (Es:Exps) => { #bindParams(Ps, Es, SS, ST, ENV) } ~> T  ... </k>
     <env> ENV:Map </env>
     <store> ST:Map </store>
     <fname> F </fname>
     <fparams> Ps:Parameters  </fparams>
     <fbody> { SS:Stmts } </fbody>
     <fret> T:Type </fret>

rule V:Value ~> #void => #void

rule <k> #voidTy => #void ... </k>

// Return statement
// We verify that the returned value
// as the same props than the returned type.
rule <k> #rs(PVal) ~> #own(PType) => #rs(PType) ... </k>
     requires PVal ==K PType

syntax K
     ::= #getValue(K, Map, Map)   [function]
rule #getValue(X ,S:Map, E:Map) => S[E[X]]

// When the function return a reference
// We got the location referenced and return a #ref(Loc)
// which should be use by the transfers rules: Transfer #ref X
rule <k> #loc(L:Int) ~> #ref(LF:Lifetime, T:Type) => #ref(L) ... </k>

rule #bindParams((P:Id : T:Type, Ps:Parameters), (#immBorrow(E:Exp), Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
     decl P; P borrow E; #bindParams(Ps, Es, SS, Store, Env)
     requires #checkType(#immBorrow(E), T)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (#mutBorrow(E:Exp), Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
     decl P; P mborrow E; #bindParams(Ps, Es, SS, Store, Env)
     requires #checkType(#mutBorrow(E), T)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (E:Id, Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
      decl P; transfer E P ; #bindParams(Ps, Es, SS, Store, Env)
     requires #checkType(#getValue(E, Store, Env), T)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (newResource(PROPS:Props), Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
      decl P; transfer newResource(PROPS) P ; #bindParams(Ps, Es, SS, Store, Env)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (call F:Id (Es2:Exps) , Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
      decl P; transfer call F (Es2) P ; #bindParams(Ps, Es, SS, Store, Env)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (* E:Exp , Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
      decl P; transfer * E P ; #bindParams(Ps, Es, SS, Store, Env)

rule #bindParams((P:Id : T:Type, Ps:Parameters), (rd(E), Es:Exps), SS:Stmts, Store:Map, Env:Map) =>
      decl P; transfer rd(E) P ; #bindParams(Ps, Es, SS, Store, Env)

//rule #bindParams((P:Id : T:Type, Ps:Parameters), (E:Exp, Es:Exps), SS:Stmts) =>
//     decl P; transfer E P ; #bindParams(Ps, Es, SS, Store, Env)

rule #bindParams(.Parameters, .Exps, SS:Stmts, ST:Map, Env:Map) => SS


endmodule