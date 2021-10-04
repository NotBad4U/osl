

module OSL-SYNTAX

import DOMAINS-SYNTAX
import DOMAINS

//syntax OSL
//       ::= Stmts				[klabel(#osl)]

syntax Function
       ::= "fn" Id "(" Parameters ")" "->" Type Block		[klabel(#function)]

syntax Parameters
       ::= List{Parameter, ","}

syntax Parameter
       ::= Id ":" Type						[klabel(#parameter)]

syntax Type
       ::= #own(Props)
         | #ref(Lifetime, Type)
	 | "#voidTy"

syntax Lifetime
       ::= Int
         | "'" Id

syntax Block
       ::= "{" Stmts "}"			[klabel(#block)]

syntax Blocks
       ::= List{Block, ","}

syntax Stmts
       ::= List{Stmt,""}


syntax Stmt
       ::= "decl" Id   ";"			[klabel(#decl)]
       	 | "decl" Id ":" Type ";"		[klabel(#declTy)]
	 | Exp "borrow" Exp   ";"		[klabel(#borrow)]
	 | Exp "mborrow" Exp  ";"		[klabel(#mborrow)]
	 | "transfer" Exp Exp ";"		[klabel(#transfer)]
	 | "@" Blocks  ";"			[klabel(#branch)]
	 | "loop" Block ";"
	 | "deallocate" Exp ";"			[klabel(#deallocate)]
	 | "destruct" Exp ";"
	 | "!" Block ";"			[klabel(#repeat)]
	 | Block
	 | Exp ";"				[klabel(#expStmt),strict]
	 | val(Exp) 				[strict]
	 | Function ";"
        | "debug"
        | "unsafe" Block ";"              //[klabel(#unsafe)]

syntax Prop
       ::= "copy"
	 | "mut"

syntax Props
       ::= List{Prop, ","}			[klabel(#props)]

syntax Exp
       ::= Id
         | "newResource" "(" Props ")"
	 | "*" Exp
	 | Exp "." Int
	 | "read" "(" Exp ")"			[klabel(#read)]
	 | Value
	 | #lv( Exp )
	 | "call" Id "(" Exps ")"		[klabel(#FnCall)]

syntax Exps
       ::= List{Exp, ","}


syntax Value
       ::= #rs(Props)
         | #loc(Int)
         | #ref(Int)
	 | #Loc(Value,Int)
	 | "#void"

syntax Uninit
       ::= "#uninit"


syntax BranchTmp
       ::= #secondBranch(Blocks)

syntax Int
       ::= #cint(Int,Int)

syntax BorrowItem
       ::= #br(Int,Int, Exp)

syntax Value
       ::= #immRef(Int)
         | #mutRef(Int)


endmodule

