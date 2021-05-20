module C-SYNTAX 

    imports DOMAINS

    /* Lexer *************************************/

    syntax TranslationUnit ::= List{ExternalDeclaration,""}

    syntax ExternalDeclaration ::= FunctionDefinition
                                | Declaration

    syntax FunctionDefinition ::=  ListDeclarationSpecifier Declarator ListDeclaration CompoundStmt

    syntax ListDeclarationSpecifier ::= List{DeclarationSpecifier, ""}

    syntax ListDeclaration ::= List{Declaration,""} 

    syntax DeclarationSpecifier ::= StorageClassSpecifier
                                | TypeSpecifier
                                | TypeQualifier

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
                            | "volatile"

    syntax StructOrUnionSpecifier ::= StructOrUnion Id "{" ListStructDeclaration "}"
                            | StructOrUnion "{" ListStructDeclaration "}"
                            | StructOrUnion Id
    
    syntax ListStructDeclaration ::= List{StructDeclaration,""}

    syntax StructOrUnion ::= "struct"
                            | "union"

    syntax StructDeclaration ::= ListSpecifierQualifier StructDeclaratorList

    syntax ListSpecifierQualifier ::= List{SpecifierQualifier,""} 

    syntax SpecifierQualifier ::= TypeSpecifier
                                | TypeQualifier

    syntax StructDeclaratorList ::= StructDeclarator
                                    | StructDeclaratorList "," StructDeclarator

    syntax StructDeclarator ::= Declarator
                                | Declarator ":" ConstantExpression
                                | ":" ConstantExpression

   syntax Declarator ::= DirectDeclarator
                        | Pointer DirectDeclarator


    syntax Pointer ::= "*" ListTypeQualifier
                        | "*" ListTypeQualifier Pointer

    syntax ListTypeQualifier ::= List{TypeQualifier,""}

    syntax TypeQualifier ::= "const"
                            | "volatile"
    
    syntax DirectDeclarator ::= Id
                                | "(" Declarator ")"
                                | DirectDeclarator "[" ConstantExpression "]"
                                | DirectDeclarator "[" "]"
                                | DirectDeclarator "(" ParameterTypeList  ")"
                                | DirectDeclarator "(" Ids ")"

    syntax Ids ::= List{Id,""}

    syntax ConstantExpression ::= ConditionalExpression

    syntax ConditionalExpression ::= LogicalOrExpression
                                    | LogicalOrExpression "?" Expression ":" ConditionalExpression

    syntax LogicalOrExpression ::= LogicalAndExpression
                                | LogicalOrExpression "||" LogicalAndExpression

    syntax LogicalAndExpression ::= InclusiveOrExpression
                                | LogicalAndExpression "&&" InclusiveOrExpression

    syntax InclusiveOrExpression ::= ExclusiveOrExpression
                                | InclusiveOrExpression "|" ExclusiveOrExpression

    syntax ExclusiveOrExpression ::= AndExpression
                                | ExclusiveOrExpression "^" AndExpression

    syntax AndExpression ::= EqualityExpression
                            | AndExpression "&" EqualityExpression

    syntax EqualityExpression ::= RelationalExpression
                                | EqualityExpression "==" RelationalExpression
                                | EqualityExpression "!=" RelationalExpression

    syntax RelationalExpression ::= ShiftExpression
                                | RelationalExpression "<" ShiftExpression
                                | RelationalExpression ">" ShiftExpression
                                | RelationalExpression "<=" ShiftExpression
                                | RelationalExpression ">=" ShiftExpression

    syntax ShiftExpression ::= AdditiveExpression
                            | ShiftExpression "<<" AdditiveExpression
                            | ShiftExpression ">>" AdditiveExpression

    syntax AdditiveExpression ::= MultiplicativeExpression
                                | AdditiveExpression "+" MultiplicativeExpression
                                | AdditiveExpression "-" MultiplicativeExpression

    syntax MultiplicativeExpression ::= CastExpression
                                    MultiplicativeExpression "*" CastExpression 
                                    | MultiplicativeExpression "/" CastExpression
                                    | MultiplicativeExpression "%" CastExpression

    syntax CastExpression ::= UnaryExpression
                    | "(" TypeName ")" CastExpression

    syntax UnaryExpression ::= 
                            PostfixExpression
                            | "++" UnaryExpression
                            | "--" UnaryExpression
                            | UnaryOperator CastExpression
                            | "sizeof" UnaryExpression
                            | "sizeof" TypeName

    syntax PostfixExpression ::= PrimaryExpression
                                | PostfixExpression "[" Expression "]"
                                | PostfixExpression "(" AssignmentExpression ")"
                                | PostfixExpression "." Id
                                | PostfixExpression "->" Id
                                | PostfixExpression "++"
                                | PostfixExpression "--"
    
    syntax PrimaryExpression ::= Id
                                | Int
                                | Float
                                | "(" Expression ")"

    syntax Expression ::= AssignmentExpression
                        | Expression "," AssignmentExpression

    syntax AssignmentExpression ::= ConditionalExpression
                        | UnaryExpression AssignmentOperator AssignmentExpression

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

    syntax TypeName ::= ListSpecifierQualifier AbstractDeclarator
                        | ListSpecifierQualifier

    syntax ParameterTypeList ::= ParameterList
                        | ParameterList "," "..."

    syntax ParameterList ::= ParameterDeclaration
                        | ParameterList "," ParameterDeclaration

    syntax ParameterDeclaration ::= ListDeclarationSpecifier Declarator
                                | ListDeclarationSpecifier AbstractDeclarator
                                | ListDeclarationSpecifier

    syntax AbstractDeclarator ::= Pointer
                            | Pointer DirectAbstractDeclarator
                            | DirectAbstractDeclarator

    syntax DirectAbstractDeclarator ::=  "(" AbstractDeclarator ")"
                               | DirectAbstractDeclarator "[" ConstantExpression "]"
                               | DirectAbstractDeclarator "[" "]"
                               | DirectAbstractDeclarator "(" ParameterTypeList ")"
                               | DirectAbstractDeclarator "(" ")"

    syntax TypedefName ::= Id
    
    syntax Declaration ::= ListDeclarationSpecifier ListInitDeclarator ";"

    syntax ListInitDeclarator ::= List{InitDeclarator,""}

    syntax ListDeclarationSpecifier ::= List{DeclarationSpecifier,""}

    syntax InitDeclarator ::= Declarator
                            | Declarator "=" Initializer 

    syntax Initializer ::= AssignmentExpression
                        | "{" InitializerList "}"
                        | "{" InitializerList "," "}"

    syntax InitializerList ::= Initializer
                     | InitializerList "," Initializer

    syntax CompoundStmt ::= "{" ListDeclaration Stmts "}"

    syntax ListDeclaration ::= List{Declaration,""}

    syntax Stmts ::= List{Stmt,""}

    syntax Stmt ::= LabeledStmt
                    | ExpressionStmt
                    | CompoundStmt
                    | SelectionStmt
                    | IterationStmt
                    | JumpStmt

    syntax LabeledStmt ::= Id ":" Stmt
                        | "case" ConstantExpression ":" Stmt
                        | "default :" Stmt

    syntax ExpressionStmt ::= Expression ";"

    
    syntax SelectionStmt ::= "if" "(" Expression ")" Stmt
                            | "if" "(" Expression ")" Stmt "else" Stmt
                            | "switch" "(" Expression ")" Stmt

    syntax IterationStmt ::= "while" "(" Expression ")" Stmt
                            | "do" Stmt "while"  "(" Expression ")" ";"
                            | "for" "(" Expression ";" Expression ";" Expression ")" Stmt

    syntax JumpStmt ::= "goto" Id ";"
                        | "continue" ";"
                        | "break" ";"
                        | "return" Expression ";"
                        | "return" ";" // TODO improve this case with an optional

endmodule