
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


syntax Stmts
       ::= #bindParams(K,K,K)     [function]


rule <k> call F:Id (Es:Exps) => { #bindParams(Ps, Es, SS) } ~> T  ... </k>
     <fname> F </fname>
     <fparams> Ps:Parameters  </fparams>
     <fbody> { SS:Stmts } </fbody>
     <fret> T:Type </fret>

rule V:Value ~> #void => #void

// Return statement
// We verify that the returned value
// as the same props than the returned type.
rule <k> #rs(PVal) ~> #own(PType) => #rs(PType) ... </k>
     requires PVal ==K PType

// When the function return a reference
// We got the location referenced and return a #ref(Loc)
// which should be use by the transfers rules: Transfer #ref X
rule <k> #loc(L:Int) ~> #ref(LF:Lifetime, T:Type) => #ref(L) ... </k>

rule #bindParams((P:Id : T:Type, Ps:Parameters), (E:Exp, Es:Exps), SS:Stmts) =>
     	    decl P; transfer E P ; #bindParams(Ps, Es, SS)

rule #bindParams(.Parameters, .Exps, SS:Stmts) => SS




endmodule