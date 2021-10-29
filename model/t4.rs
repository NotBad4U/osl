fn abs(x:#own(copy,mut)) -> #own(copy) {
   val(newResource(copy,mut))
};

fn atof(ptr:#ref('a,#own())) -> #own(copy) {
   val(newResource(copy,mut))
};

fn atoi(ptr:#ref('a,#own())) -> #own(copy) {
   val(newResource(copy,mut))
};

fn atol(ptr:#ref('a,#own())) -> #own(copy) {
   val(newResource(copy,mut))
};

fn bind(__sockfd:#own(copy,mut),__addr:#ref('a,#own())) -> #voidTy {
   read(__sockfd);
   read(__addr);
};

fn accept(__sockfd:#own(copy,mut),__addr:#ref('a,#own()),__addrlen:#ref('b,#own())) -> #own(copy,mut)  {
   read(__sockfd);
   read(__addr);
   read(__addrlen);
   val(newResource(copy,mut))
};

fn exit(status:#own(copy,mut)) -> #voidTy {
   read(status);
};

//FIXME
fn close(__fd:#own(copy,mut)) -> #voidTy {
   read(__fd);
};

fn fmod(fmodx:#own(copy,mut),fmody:#own(copy,mut)) -> #own(copy,mut) {
   val(newResource(copy,mut))
};

fn fprintf1(stream:#ref('s,#own(copy,mut)),format:#own()) -> #voidTy {
   // transpiler built-in
};

fn fprintf2(stream:#ref('s,#own(copy,mut)),format:#own(),_a:#ref('a,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
};

fn fprintf3(stream:#ref('s,#own(copy,mut)),format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
};

fn fprintf4(stream:#ref('s,#own(copy,mut)),format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own()),_c:#ref('c,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
   read(_c);
};

fn fprintf5(stream:#ref('s,#own(copy,mut)),format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own()),_c:#ref('c,#own()),_d:#ref('d,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
   read(_c);
   read(_d);
};

fn htons(__hostlong:#own(copy,mut)) -> #own(copy,mut) {
   read(__hostlong);
   val(newResource(copy,mut))
};


fn memset(__s:#ref('a,#own(mut)),__c:#own(),__n:#own(copy,mut)) -> #voidTy {
   read(__n);
   transfer __c __s;
};

fn perror(__msg:#own()) -> #voidTy {
   read(__msg);
};

fn pow(powx:#own(copy,mut),powy:#own(copy,mut)) -> #own(copy,mut) {
   val(newResource(copy,mut))
};

fn printf1(format:#own()) -> #voidTy {
   // transpiler built-in
};

fn printf2(format:#own(),_a:#ref('a,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
};

fn printf3(format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
};

fn printf4(format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own()),_c:#ref('c,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
   read(_c);
};

fn printf5(format:#own(),_a:#ref('a,#own()),_b:#ref('b,#own()),_c:#ref('c,#own()),_d:#ref('d,#own())) -> #voidTy {
   // transpiler built-in
   read(_a);
   read(_b);
   read(_c);
   read(_d);
};

fn rand() -> #own(copy) {
   val(newResource(copy,mut))
};

fn scanf1(format:#own()) -> #voidTy {
   // transpiler built-in
};

fn scanf2(format:#own(),_a:#ref('a,#own(mut))) -> #voidTy {
   // transpiler built-in
};

fn scanf3(format:#own(),_a:#ref('a,#own(mut)),_b:#ref('b,#own(mut))) -> #voidTy {
   // transpiler built-in
};

fn scanf4(format:#own(),_a:#ref('a,#own(mut)),_b:#ref('b,#own(mut)),_c:#ref('c,#own(mut))) -> #voidTy {
   // transpiler built-in
};

fn scanf5(format:#own(),_a:#ref('a,#own(mut)),_b:#ref('b,#own(mut)),_c:#ref('c,#own(mut)),_d:#ref('d,#own(mut))) -> #voidTy {
   // transpiler built-in
};

fn socket(__type:#own(copy,mut)) -> #own(copy,mut) {
   read(__type);
   val(newResource(copy,mut))
};

decl stdin;
decl stdout;
decl stderr;
decl sys_nerr;
decl sys_errlist;
fn __bswap_16(__bsx:#own(mut)) -> #own(copy,mut) {
   val(call __builtin_bswap16(__bsx))
};

fn __bswap_32(__bsx:#own(mut)) -> #own(copy,mut) {
   val(call __builtin_bswap32(__bsx))
};

fn __bswap_64(__bsx:#own(mut)) -> #own(copy,mut) {
   val(call __builtin_bswap64(__bsx))
};

fn __uint16_identity(__x:#own(mut)) -> #own(copy,mut) {
   val(__x)
};

fn __uint32_identity(__x:#own(mut)) -> #own(copy,mut) {
   val(__x)
};

fn __uint64_identity(__x:#own(mut)) -> #own(copy,mut) {
   val(__x)
};

decl __environ;
decl optarg;
decl optind;
decl opterr;
decl optopt;
decl in6addr_any;
decl in6addr_loopback;
fn main() -> #own(copy,mut) {
   decl server_fd;
   decl new_socket;
   decl value_read;
   decl address;
   decl addrlen;
   //FIXME
   transfer newResource(copy,mut) addrlen;
   decl hello;
   transfer newResource() hello;
   transfer call socket(newResource(copy, mut)) server_fd;
   read(server_fd);
   
   @
   {
       call perror(newResource());
       call exit(newResource(copy,mut));
   };
   transfer newResource(copy,mut) address;
   transfer newResource(copy,mut) address;
   transfer call htons(newResource(copy,mut)) address;
   call memset(&mut address,newResource(),newResource(copy,mut));
   call bind(server_fd, &address);
   
   @
   {
       call perror(newResource());
       call exit(newResource(copy,mut));
   };
   //call listen(server_fd);
   
   @
   {
       call perror(newResource());
       call exit(newResource(copy,mut));
   };
   
   !{
      //FIXME:
       transfer call accept(server_fd, &address, &addrlen) new_socket;
       call printf1(newResource());
       read(new_socket);
       
       @
       {
           call perror(newResource());
           call exit(newResource(copy,mut));
       };
       decl buffer;
       transfer newResource(mut) buffer;
       //transfer call read(new_socket,buffer) value_read;
       call printf2(newResource(),&buffer);
       //call write(new_socket,hello,call strlen(hello));
       call printf1(newResource());
       call close(new_socket);
       
   };
   val(newResource(copy,mut))
};

call main();
