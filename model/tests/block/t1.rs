
decl a ;

{
	decl x;
	transfer newResource() x;
	a borrow x;
}

read(a);