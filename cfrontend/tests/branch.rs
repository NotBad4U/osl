mod common;
use common::assert_equal_program;

#[test]
fn it_should_transpile_if_else_statement() {
    let c_program = r###"
    void main() {
        int age = 23;
        int limit = 30;
        int ok;

        if (age >= limit) {
            ok = 0;
        }
        else {
            ok = 1;
        }
    }
    "###;

    let expected_osl_program = r###"
        fn main() ->  #voidTy {
            decl age;
            transfer newResource(copy,mut) age;
            decl limit;
            transfer newResource(copy,mut) limit;
            decl ok;
            rd(age);
            rd(limit);
            @
            {
                transfer newResource(copy,mut) ok;
            },
            {
                transfer newResource(copy,mut) ok;
            };
        };
        call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_if_statement_and_ignore_constant() {
    let c_program = r###"
    void main() {
        int age = 23;
        int ok;

        if (age >= 30) {
            ok = 0;
        }
        else {
            ok = 1;
        }
    }
    "###;

    let expected_osl_program = r###"
        fn main() ->  #voidTy {
            decl age;
            transfer newResource(copy,mut) age;
            decl ok;
            rd(age);
            @
            {
                transfer newResource(copy,mut) ok;
            },
            {
                transfer newResource(copy,mut) ok;
            };
        };
        call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}

#[test]
fn it_should_transpile_nested_if_else_statements() {
    let c_program = r###"
    void main() {
        int x;

        if (x) {
            if (x) {} else {}
        }
        else {
            if (x) {} else {}
        }
    }
    "###;

    // Note that the transpiler ignore empty else condition
    let expected_osl_program = r###"
    fn main() -> #voidTy {
        decl x;
        rd(x);
        @{
            rd(x);
            @{
            };
        },{
            rd(x);
            @{
            };
        };
    };
    call main();
    "###;

    assert_equal_program(c_program, expected_osl_program);
}

fn it_should_transpile_switch_statement() {
    let c_program = r###"
    int main () {

        /* local variable definition */
        char grade = 'B';
     
        switch(grade) {
           case 'A' :
              printf("Excellent!\n" );
              break;
           case 'B' :
           case 'C' :
              printf("Well done\n" );
              break;
           case 'D' :
              printf("You passed\n" );
              break;
           case 'F' :
              printf("Better try again\n" );
              break;
           default :
              printf("Invalid grade\n" );
        }

        printf("Your grade is  %c\n", grade );

        return 0;
    }
    "###;

    let expected_osl_program = r###"
fn main() -> #voidTy {
    decl grade;
    transfer newResource(mut) grade;
    rd(grade);
    @
    {
        call printf();
    },
    {
        call printf();
    },
    {
        call printf();
    },
    {
        call printf();
    };
    call printf(grade);
    val(newResource(copy))
};

call main();
"###;

    assert_equal_program(c_program, expected_osl_program);
}
