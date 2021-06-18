module C-SYNTAX

import DOMAINS

syntax Constant ::= Int
            | Float

// TODO: support struct/union and typedef
syntax TypeSpecifier ::= "void"
                   | "char"
                   | "short"
                   | "int"
                   | "long"
                   | "float"
                   | "double"
                   | "signed"
                   | "unsigned"

syntax Pointer ::= "*" OptionalTypeQualifier OptionalPointer

syntax OptionalPointer ::= ""       [klabel(none)]
                        | Pointer   [klabel(#somePointer), symbol]

syntax TypeQualifier ::= "const"

syntax OptionalTypeQualifier ::= ""             [klabel(none)]
                            | TypeQualifier     [klabel(#typequalifier), symbol]

syntax DeclarationSpecifier ::= TypeQualifier
            | TypeSpecifier

syntax NeListDeclarationSpecifier ::= NeList{DeclarationSpecifier,""}


syntax CStmt ::= Declaration
                | DeclarationDesugar
                | Stmt

syntax CStmts ::= List{CStmt,""}

// A declaration is a C language construct that introduces one or more
// identifiers into the program and specifies their meaning and properties.
// TODO: support more than one identifier
syntax Declaration ::=  NeListDeclarationSpecifier OptionalPointer Declarator ";"

syntax DeclarationDesugar ::= RefCapability Declarator ";"

syntax Declarator ::=  Id

syntax   RefCapability ::=  "#Imm"      [klabel(#imm), symbol]
                        |   "#Mut"      [klabel(#mut), symbol]
                        |   "#RefImm"   [symbol]
                        |   "#RefMut"   [symbol]


syntax Stmt ::= ExpressionStmt

syntax ExpressionStmt ::= Expression ";"


syntax Expression ::= AssignmentExpression
                    | PrimaryExpression
                    | UnaryExpression

syntax UnaryExpression ::= UnaryOperator PrimaryExpression

syntax PrimaryExpression ::= Id
                            | Constant
                            | String
                            | "(" PrimaryExpression ")" [bracket]

// TODO: Add support of conditionnal assignment (ternary operator)
syntax AssignmentExpression ::= Id AssignmentOperator Expression

syntax AssignmentOperator ::= "="
                        | "*="
                        | "/="
                        | "%="
                        | "+="
                        | "-="
                        | "<<="
                        | ">>="
                        | "&="
                        | "^="
                        | "|="

syntax UnaryOperator ::= "&"
                        | "*"
                        | "+"
                        | "-"
                        | "~"
                        | "!"

endmodule