require "syntax.k"
require "osl-syntax.k"

module C
    imports DOMAINS

    imports C-SYNTAX
    imports OSL-SYNTAX

    syntax KResult ::= Constant

    configuration
        <T>
            <k> $PGM:CStmts </k>
            <caps> .Map </caps>
            <stack> .K </stack>
            <osl> .List </osl>
        </T>

    syntax TransItems ::= #pushTerm(K)
                        | #pushTerms(K,K)


    // Stmts
    rule .CStmts => .                   [structural]
    rule S:CStmt Ss:CStmts => S ~> Ss   [structural]

    rule <stack> #pushTerm(T:KItem) => . ... </stack>
        <osl> .List => ListItem(T) ...  </osl>

    rule <stack> #pushTerms(T1:K,T2:K) => #pushTerm(T1) ~> #pushTerm(T2) </stack>

    // Declare an immutable owner: const T x => Imm x
    rule  <k> const _:NeListDeclarationSpecifier X:Id ; => #Imm X ; ... </k>    [anywhere]

    rule <k> #Imm X:Id ; => . ... </k>
        <caps> Map => Map[X <- #Imm] </caps>
        <stack> . => #pushTerms(decl X ; ,  transfer newResource ( copy ) X ;  )  </stack>


    // Declare a mutable owner: T x => Mut x
    rule  <k> _:NeListDeclarationSpecifier X:Id ; => #Mut X ; ... </k>

    rule <k> #Mut X:Id ; => . ... </k>
        <caps> Map => Map[X <- #Mut] </caps>
        <stack> . => #pushTerms(decl X ; ,  transfer newResource ( copy ) X ;  )  </stack>

    // Declare reference to an immutable owner: const T * x => RefImm x
    rule  <k> const _:NeListDeclarationSpecifier * X:Id ; => #RefImm X ; ... </k> [anywhere]

    rule <k> #RefImm X:Id ; => . ... </k>
        <caps> Map => Map[X <- #RefImm] </caps>

    // Declare reference to an mutable owner: const T * x => Refmut x
    rule  <k> _:NeListDeclarationSpecifier * X:Id ; => #RefMut X ; ... </k>

    rule <k> #RefMut X:Id ; => . ... </k>
        <caps> Map => Map[X <- #RefMut] </caps>

endmodule

