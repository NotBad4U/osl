
decl x;

!{
	transfer newResource() x; 
	decl y;
	@ {transfer newResource() y;}, {transfer x y;} ;
} ;