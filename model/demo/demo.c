
/*
int * p_global ;
int cmp () { return * p_global >= MIN && * p_global <= MAX ; }
void index_user ( int * p ) {
int * p_global_save ;
p_global_save = p_global ;
p_global = p ;
if ( cmp () <=0)
{
printf ( " The secret is greater than 50\ n " ) ;
return ; }
printf ( " The secret is less than 50 \ n " ) ;
p_global = p_global_save ; return ;
}
int main ( int argc , char * argv []) {
int * p_index ,* p_pass ;
if ( argc !=2) {
printf ( " ./ uaf MODE \ nMODE EASY =1\ nMODE HARD !=1\ n " )
;
return 0; }
p_global =( int *) malloc ( sizeof ( int ) ) ;
* p_global = SECRET_PASS ;
if ( atoi ( argv [1]) == MODE_EASY ) {
p_index =( int *) malloc ( sizeof ( int ) ) ;
printf ( " Give a number between 0 and 100\ n " ) ;
scanf ( " % d " , p_index ) ;
index_user ( p_index ) ;
free ( p_index ) ; }
else { printf ( " Good luck ! \ n " ) ; }
p_pass =( int *) malloc ( sizeof ( int ) ) ;
printf ( " Give the secret \ n " ) ;
scanf ( " % d " , p_pass ) ;
if (* p_pass ==* p_global ) {
printf ( " Congrats ! \ n " ) ; }
else { printf ( " Sorry ...\ n " ) ; }
return 0; }
*/

decl p_global ;

fn cmp() -> #own(copy) {
   p_global;
   val(newResource(copy))
     };

fn index_user(p:#own()) -> #voidTy {

  decl p_global_save ;
  transfer p_global p_global_save;
  transfer p p_global;
  call cmp () ;
  @ {
    
  }, {
    transfer p_global_save p_global;
  };
  
} ;

fn main(arg:#own(copy), argv:#own()) -> #own(copy){

  decl p_index;
  decl p_pass;
  transfer newResource() p_global;
  argv;
  @ {
   transfer newResource() p_index;
   call index_user(p_index);
   deallocate p_index ;
  }, {
  
  } ;


  transfer newResource() p_pass;

  p_pass ;
  p_global ;

  @{}, {} ;

  val(newResource(copy))
  
    } ;

decl arg1;
decl argv1;

transfer newResource(copy) arg1;
transfer newResource() argv1;

call main(arg1, argv1) ;





























