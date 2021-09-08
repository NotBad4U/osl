
require "osl-syntax.k"
require "configuration.k"

module BLOCK

import OSL-SYNTAX
import CONFIGURATION

syntax BlockItem
       ::= "#blockend"
       | "#unsafeBlockend"

rule <k> #block(Ss:Stmts) => Ss ~> #blockend ... </k>
     <env> ENV:Map </env>
     <stack> .List => ListItem(ENV) ... </stack>

rule V:Value ~> #blockend => #blockend ~> V

rule <k> #blockend => #blockend ... </k>
     <env> ... X |-> L:Int ... </env>
     <store> ... ((L |-> _) => .Map ) ...  </store>
     <stack> (ListItem(X:Id) => .List) ... </stack>

rule <k> #blockend => . ... </k>
     <env> _ => ENV </env>
     <stack> (ListItem(ENV:Map) => .List) ... </stack>


rule <k> unsafe B:Block ; => B ~> #unsafeBlockend ... </k>
     <unsafe-mode> FLAG:Bool => true </unsafe-mode>

rule <k> #unsafeBlockend => . ... </k>
     <unsafe-mode> FLAG:Bool => false </unsafe-mode>

endmodule

