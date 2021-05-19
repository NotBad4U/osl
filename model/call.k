
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
       	

rule <k> call F:Id (Es:Exps) => { #bindParams(Ps, Es, SS) } ~> #void  ... </k>
     <fname> F </fname>
     <fparams> Ps:Parameters  </fparams>
     <fbody> { SS:Stmts } </fbody>

rule V:Value ~> #void => #void


rule #bindParams((P:Id : T:Type, Ps:Parameters), (E:Exp, Es:Exps), SS:Stmts) =>
     	    decl P; transfer E P ; #bindParams(Ps, Es, SS)

rule #bindParams(.Parameters, .Exps, SS:Stmts) => SS




endmodule