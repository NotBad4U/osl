module C-SYNTAX 

imports DOMAINS

syntax Bool ::= isKResult(K) [symbol, function]

syntax TranslationUnit ::= ListExternalDeclaration

syntax ListExternalDeclaration ::= List{ExternalDeclaration,""}

syntax ExternalDeclaration ::= FunctionDefinition
                         | Declaration

syntax FunctionDefinition ::= ListDeclarationSpecifier Declarator ListDeclaration CompoundStatement

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
                   | StructOrFunionSpecifier
                   | EnumOfspecifier
                   | TypedefOfname

syntax StructOrFunionSpecifier ::= StructOrUnion Id "{" ListStructDeclaration ";" "}"
                              | StructOrUnion "{" ListStructDeclaration ";" "}"
                              | StructOrUnion Id
                              | StructOrUnion Id "{" "}" // NOTE: fix the problem of trailing semicolon

syntax ListStructDeclaration ::= List{StructDeclaration,";"}

syntax StructOrUnion ::= "struct"
                    | "union"

syntax StructDeclaration ::= ListSpecifierQualifier StructDeclaratorList

syntax ListSpecifierQualifier ::= List{SpecifierQualifier,""}


syntax SpecifierQualifier ::= TypeSpecifier
                        | TypeQualifier

// syntax StructDeclaratorList ::= StructDeclarator
//                            | StructDeclaratorList "," StructDeclarator

syntax StructDeclaratorList ::= NeList{StructDeclarator, ","}
                           //| StructDeclaratorList "," StructDeclarator


syntax StructDeclarator ::= Declarator
                      | Declarator ":" ConstantExpression
                      //| ":" ConstantExpression

syntax Declarator ::= DirectDeclarator
                    | Pointer DirectDeclarator

syntax Pointer ::= "*" ListTypeQualifier Pointer
                | "*" ListTypeQualifier

syntax ListTypeQualifier ::= List{TypeQualifier,""}


syntax TypeQualifier ::= "const"
                   | "volatile"

syntax DirectDeclarator ::= Id
                      | "(" Declarator ")"
                      | DirectDeclarator "[" ConstantExpression "]"
                      | DirectDeclarator "[" "]"
                      | DirectDeclarator "(" ParameterTypeList ")"      [prefer]
                      | DirectDeclarator "(" Ids ")"

syntax Ids ::= List{Id,""}

syntax ConstantExpression ::= ConditionalExpression

syntax ConditionalExpression ::= LogicalOforExpression
                           | LogicalOforExpression "?" Expression ":" ConditionalExpression

syntax LogicalOforExpression ::= LogicalOfandExpression
                          | LogicalOforExpression "||" LogicalOfandExpression

syntax LogicalOfandExpression ::= InclusiveOforExpression
                           | LogicalOfandExpression "&&" InclusiveOforExpression

syntax InclusiveOforExpression ::= ExclusiveOforExpression
                            | InclusiveOforExpression "|" ExclusiveOforExpression

syntax ExclusiveOforExpression ::= AndExpression
                            | ExclusiveOforExpression "^" AndExpression

syntax AndExpression ::= EqualityExpression
                   | AndExpression "&" EqualityExpression

syntax EqualityExpression ::= RelationalExpression
                        | EqualityExpression "==" RelationalExpression
                        | EqualityExpression "!=" RelationalExpression

syntax RelationalExpression ::= ShiftExpression
                          | RelationalExpression "<"  ShiftExpression
                          | RelationalExpression ">"  ShiftExpression
                          | RelationalExpression "<=" ShiftExpression
                          | RelationalExpression ">=" ShiftExpression

syntax ShiftExpression ::= AdditiveExpression
                     | ShiftExpression ">>" AdditiveExpression
                     | ShiftExpression "<<"  AdditiveExpression

syntax AdditiveExpression ::= MultiplicativeExpression
                        | AdditiveExpression "+" MultiplicativeExpression
                        | AdditiveExpression "-" MultiplicativeExpression

syntax MultiplicativeExpression ::= CastExpression
                              | MultiplicativeExpression "*" CastExpression
                              | MultiplicativeExpression "/" CastExpression
                              | MultiplicativeExpression "%" CastExpression

syntax CastExpression ::= UnaryExpression
                    | "(" TypeName ")" CastExpression

syntax UnaryExpression ::= PostfixExpression
                     | "++" UnaryExpression
                     | "--" UnaryExpression
                     | UnaryOperator CastExpression
                     | "sizeof" UnaryExpression
                     | "sizeof" TypeName

syntax PostfixExpression ::= PrimaryExpression
                       | PostfixExpression "[" Expression "]"
                       | PostfixExpression "(" ListAssignmentExpression ")"
                       | PostfixExpression "." Id
                       | PostfixExpression "->" Id
                       | PostfixExpression "++"
                       | PostfixExpression "--"

syntax ListAssignmentExpression ::= List{AssignmentExpression,","}

syntax PrimaryExpression ::= Id
                        | String
                        | Constant
                        | "(" Expression ")"

syntax Constant ::= Int
             | Float
             | EnumerationConstant

syntax EnumerationConstant ::= Id

syntax Expression ::= AssignmentExpression
               | Expression "," AssignmentExpression

syntax AssignmentExpression ::= ConditionalExpression
                          | UnaryExpression AssignmentOperator AssignmentExpression

syntax AssignmentOperator ::= "="
                        | "*="
                        | "/="
                        | "%="
                        | "+="
                        | "Of="
                        | "="
                        | "="
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

syntax ListSpecifierQualifier ::= List{SpecifierQualifier,""}

syntax ParameterTypeList ::= ParameterList
                        | ParameterList "," "..."

syntax ParameterList ::= ParameterDeclaration
                   | ParameterList "," ParameterDeclaration

syntax ParameterDeclaration ::= ListDeclarationSpecifier Declarator        [prefer]
                            | ListDeclarationSpecifier
                            | ListDeclarationSpecifier AbstractDeclarator

syntax ListDeclarationSpecifier ::= NeList{DeclarationSpecifier,""}

syntax AbstractDeclarator ::= Pointer
                        | Pointer DirectAbstractDeclarator
                        | DirectAbstractDeclarator

syntax DirectAbstractDeclarator ::=  "(" AbstractDeclarator ")"
                               | DirectAbstractDeclarator "[" ConstantExpression "]"
                               | DirectAbstractDeclarator "[" "]"
                               | "[" ConstantExpression "]"
                               | "[" "]"
                               | DirectAbstractDeclarator "(" ParameterTypeList ")"
                               | DirectAbstractDeclarator "(" ")"
                               | "(" ParameterTypeList ")"
                               | "(" ")"

syntax EnumOfspecifier ::= "enum" Id "{" EnumeratorList "}"
                   | "enum" "{" EnumeratorList "}"
                   | "enum" Id

/*syntax EnumeratorList ::= Enumerator
                    | EnumeratorList "," Enumerator*/

syntax EnumeratorList ::= List{Enumerator, ","}

syntax Enumerator ::= Id
                    |  Id "=" Int

syntax TypedefOfname ::= Id

syntax Declaration ::= ListDeclarationSpecifier ListInitDeclarator ";"
                    | ListDeclarationSpecifier Id ";"   [prefer]

syntax ListInitDeclarator ::= List{Initdeclarator, ","}

syntax Initdeclarator ::= Declarator
                    | Declarator "=" Initializer

syntax Initializer ::= AssignmentExpression
                | "{" InitializerList "}"
                | "{" InitializerList "," "}"

syntax InitializerList ::= Initializer
                     | InitializerList "," Initializer

syntax CompoundStatement ::= "{" ListDeclaration ListStatement "}"

syntax ListStatement ::= List{Statement,""}

syntax Statement ::= LabeledStatement
              | ExpressionStatement
              | CompoundStatement
              | SelectionStatement
              | IterationStatement
              | JumpStatement

syntax LabeledStatement ::= Id ":" Statement
                      | "case" ConstantExpression ":" Statement
                      | "default" ":" Statement

syntax ExpressionStatement ::= Expression ";"
                                | ";"

syntax SelectionStatement ::= "if" "(" Expression ")" Statement
                        | "if" "(" Expression ")" Statement "else" Statement
                        | "switch" "(" Expression ")" Statement

syntax IterationStatement ::= "while" "(" Expression ")" Statement
                        | "do" Statement "while" "(" Expression ")" ";"
                        | "for" "(" ForInitClause ";" OptionalExpression ";" OptionalExpression ")" Statement

syntax ForInitClause ::= Expression
                | Declaration
                | ListDeclarationSpecifier ListInitDeclarator
                | ListDeclarationSpecifier Id
                | "" [klabel(none)]

syntax JumpStatement ::= "goto" Id ";"
                   | "continue" ";"
                   | "break" ";"
                   | "return" OptionalExpression ";"

syntax OptionalExpression ::= "" [klabel(none)] | Expression [klabel(some)]

endmodule