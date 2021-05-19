
require "osl-syntax.k"

module CONFIGURATION

import OSL-SYNTAX

syntax KResult
       ::= Value

syntax Indexes
       ::= #indexes(Int,Int)

configuration

<T>
    <states>
     <state multiplicity="*" type="Map">
     	<index> 0:Int </index>
	<k> $PGM:Stmts </k>
     	<env> .Map </env>
     	<store> .Map </store>
	<stack> .List  </stack>
	<write> .Set </write>
	<timer> 0:Int </timer>
     	<indexes> #indexes(0,0) </indexes>
     </state>
    </states>     
     <nstate> 1:Int </nstate>
     <tmp> .List </tmp>     
     <funDefs>    
       <funDef multiplicity="*" type="Map">
	<fname> .K </fname>
	<fparams> .Parameters </fparams>
	<fret> .K </fret>
	<fbody> .K </fbody> 
       </funDef>
     </funDefs>
</T>


endmodule