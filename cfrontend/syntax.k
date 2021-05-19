module C-SYNTAX 

    imports DOMAINS

    /* Lexer *************************************/

    syntax StorageClassSpecifier ::= "auto"
                                    | "register"
                                    | "static"
                                    | "extern"
                                    | "typedef"

    syntax TypeSpecifier ::= "void"
                            | "char"
                            | "short"
                            | "int"
                            | "long"
                            | "float"
                            | "double"
                            | "signed"
                            | "unsigned"
                            | StructOrUnionSpecifier

    syntax TypeQualifier ::= "const"
                            | "volatile"

    syntax UnaryOperator ::= "&"
                            | "*"
                            | "+"
                            | "-"
                            | "~"
                            | "!"

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

    syntax ListTypeQualifier ::= List{TypeQualifier, " "}

    syntax StructOrUnion ::= "struct"
                            | "union"

    // NOTE verify the pointer work
    syntax Pointer ::= "*" ListTypeQualifier
                        | "*" ListTypeQualifier Pointer

    /* Struct and Union *************************************/

    syntax StructOrUnionSpecifier ::= StructOrUnion Id BodyStruct
                                | StructOrUnion Id

    syntax BodyStruct ::= "{" ListStructDeclaration "}" [bracket]

    syntax ListStructDeclaration ::= List{StructDeclaration, " "}

    syntax StructDeclaration ::= ListSpecifierQualifier Declarator ";"

    syntax ListSpecifierQualifier ::= List{SpecifierQualifier, " "} 

    syntax SpecifierQualifier ::= TypeSpecifier
                        | TypeQualifier


    syntax StructDeclarator ::= Declarator
                        //| Declarator : <constant-expression>
                        //| : <constant-expression>


    /* Declaration *************************************/

    syntax DeclarationSpecifier ::= StorageClassSpecifier
                                    | TypeSpecifier
                                    | TypeQualifier

    syntax ListDeclarationSpecifier ::= List{DeclarationSpecifier, " "}
 
    syntax Declaration ::= ListDeclarationSpecifier InitDeclarator ";"

    syntax Declarator ::= DirectDeclarator
                        | Pointer DirectDeclarator

    syntax DirectDeclarator ::= Id

    syntax Initializer ::= AssignmentExpression

    syntax InitDeclarator ::= Declarator
                            | Declarator "=" Initializer 

    /* Assignment *************************************/

    syntax AssignmentExpression ::=
                        UnaryExpression
                        | UnaryExpression AssignmentOperator AssignmentExpression  

    syntax UnaryExpression ::= 
                            PostfixExpression
                            | "++" UnaryExpression
                            | "--" UnaryExpression
                            | UnaryOperator UnaryExpression
                            | "sizeof" UnaryExpression
    
    syntax PostfixExpression ::= PrimaryExpression
                                //| PostfixExpression [ Expression ]
                                | PostfixExpression "(" AssignmentExpression ")"
                                | PostfixExpression "." Id
                                | PostfixExpression "->" Id
                                | PostfixExpression "++"
                                | PostfixExpression "--"
    
    syntax PrimaryExpression ::= Id
                                | Int
                                | Float
                                | String
    
    /* Expression  ******************************** */

    // TODO finish and/or/etc-expression

    syntax Expression ::= AssignmentExpression
               | Expression "," AssignmentExpression

    /* Statement **********************************************/
    syntax Stmt ::= SelectionStmt
                    | ExpressionStmt
                    //| <compound-statement> // TODO
                    | IterationStmt
                    | JumpStmt

    syntax ExpressionStmt ::= "{" Expression "}" [bracket]
    
    syntax SelectionStmt ::= "#if" "(" Expression ")" Stmt  
                            | "#if" "(" Expression ")" Stmt "#else" Stmt
                            | "#switch" "(" Expression ")" Stmt

    syntax IterationStmt ::= "#while" "(" Expression ")" Stmt
                            | "#do" Stmt "#while" "(" Expression ")" ";"
                            | "#for" "(" Expression ";" Expression ";" Expression ")" Stmt

    syntax JumpStmt ::= "#goto" Id ";"
                        | "#continue" ";"
                        | "#break" ";"
                        | "#return" Expression ";"
                        | "#return" ";"             // TODO improve this case with an optional



    /* Function **************************************** */
endmodule