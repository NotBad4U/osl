# Capabilities

Ownership capabilities derived C type qualifier. 

| Capabilities | C           | Rust     |
| ------------ | ----------- | -------- |
| OwnImm       | `const T`   | `T`      |
| OwnMut       | `T`         | `mut T`  |
| Refmut       | `T *`       | `&mut T` |
| RefImm       | `const T *` | `& T`    |


# Comparaison

## Variable declaration

### Declare a mutable variable

```c
int a = 1;
a = 2;
```
*Equivalent Rust code:*

```rust
let mut a = 1;
a = 2;
```


### Declare an immutable variable

```c
const int a = 2;
```

*Equivalent Rust code:*

```rust
let a = 1;
```

### Shared reference: &

```c
const int a = 2;
const int * b = &a;
const int * const c = &a;

int a2 = 2;
const int * b2 = &a2;
```

*Equivalent Rust code:*

```rust
let a = 1;
let b = &a;
let mut c = &a;


let mut a2 = 1;
let mut b2 = &a2;
```


### Mutable reference: &mut

```c
int a = 2;
int * const b = 2;
int * c = 2;
```

*Equivalent Rust code:*

```rust
let mut a = 1;
let b = &mut a;
let mut c = &mut a;
```

## Borrow

### ptr is a pointer to T

Declare ptr as pointer to const T

```c
int a = 1, b =2;
int * ptr = &a;    // pointer to int.

* ptr = 6;          // [ALLOW] the value of a can get changed through the pointer.

ptr = &b;           // [ALLOW] the pointer ptr can be changed.
```

Equivalent Rust code:

```rust
let mut a = 1;
let mut b = 2;
let mut ptr = &a;

ptr = &b;           // [ALLOW] the pointer ptr can be changed.

ptr = 5;            // [NOT ALLOW] the value of a can get changed through the pointer.
```

### ptr is constant pointer to const T

Declare x as const pointer to const T. Notice that `const int * const == int const * const`.

```c
const int a = 1, b =2;
const int * const ptr = &a;    // ptr is constant pointer to const T

* ptr = 6;          // [NOT ALLOW] the value of a can get changed through the pointer.

ptr = &b;           // [NOT ALLOW] the pointer ptr can be changed.
```

*Equivalent Rust code:*

```rust
let a = 1;
let b = 2;
let ptr = &a;

ptr = &b;           // [NOT ALLOW] the pointer ptr can be changed.

ptr = 5;            // [NOT ALLOW] the value of a can get changed through the pointer.
```




### ptr is a pointer to T constant (i.e const T)

Declare ptr as pointer to const T

```c
const int a = 1, b =2;
const int * ptr = &a;    // ptr is a pointer to int constant (i.e const T)

* ptr = 6;          // [NOT ALLOW] the value of a can get changed through the pointer.

ptr = &b;           // [ALLOW] the pointer ptr can be changed.
```

Equivalent Rust code:

```rust
let a = 1;
let b = 2;
let mut ptr = &a;

ptr = &b;           // [ALLOW] the pointer ptr can be changed.

ptr = 5;            // [NOT ALLOW] the value of a can get changed through the pointer.
```


### ptr is a pointer const T

:warning: same as the previous one because `const int * == int const *`

```c
const int a = 1, b =2;
int const  * ptr = &a;    // ptr is pointer to const int.

ptr = &b;           // [ALLOW] the pointer ptr can be changed.

* ptr = 6;          // [NOT ALLOW] the value of a can get changed through the pointer.

```

Equivalent Rust code:

```rust
let a = 1;
let b = 2;
let mut ptr = &a;

ptr = &b;           // [ALLOW] the pointer ptr can be changed.

ptr = 5;            // [NOT ALLOW] the value of a can get changed through the pointer.
```


### ptr is a const pointer to int

Declare x as const pointer to int.

```c
int a = 1, b =2;
int * const ptr = &a;    // ptr is a const pointer to int.

ptr = &b;           // [NOT ALLOW] the pointer ptr can be changed.

* ptr = 6;          // [ALLOW] the value of a can get changed through the pointer.
```

Equivalent Rust code:

```rust
let mut a = 1;
let mut b = 2;
let ptr = &mut a;

ptr = &mut b;       // [NOT ALLOW] the pointer ptr can be changed.

ptr = 5;            // [ALLOW] the value of a can get changed through the pointer.
```

## Derivate a reference from another one


### A pointer to pointer to T

Declare ptr as pointer to pointer to T

```c
int a = 1;
int * b = &a;
int * * ptr = &b; 

*b = 3;             // [ALLOW] the value of a can get changed through the pointer.
**c = 4;            // [ALLOW] the value of a can get changed through the pointer.
```

❗ No equivalent Rust code because multiple mutable borrow value

```rust
let mut a = 1;
let mut b: &mut i32 = &mut a;

let mut c: &mut &mut i32 = &mut b;

*b = 5;
**c = 10;
```

This program crash with the following error:

```zsh
error[E0506]: cannot assign to `*b` because it is borrowed
 --> src/main.rs:8:5
  |
6 |     let mut c: &mut &mut i32 = &mut b;
  |                                ------ borrow of `*b` occurs here
7 |     
8 |     *b = 5;
  |     ^^^^^^ assignment to borrowed `*b` occurs here
9 |     **c = 10;
  |     -------- borrow later used here
```

### A const pointer to a pointer to an T

declare ptr as const pointer to pointer to int

```c
int a = 1, e = 2;
int * b = &a;
int * b2 = &a;
int * * const ptr = &b;

*b = 2;                 // [ALLOW] the value of a can get changed through the pointer.
**ptr = 10;               // [ALLOW] the value of a can get changed through the pointer.

ptr = &b2;                // [NOT ALLOW] the pointer ptr can be changed
```


```rust
let mut a = 1;
let mut b: &mut **i32** = &mut a;
let c: &(&mut i32) = &b;           // [NOT ALLOW] the pointer ptr can be changed

*c = &mut 4;                        // [NOT ALLOW] the value of a can get changed through the pointer.

*b = 4;
```


### a pointer to a const pointer to an T

declare ptr as pointer to const pointer to int

```c
int a = 1, e = 2;
int * const b = &a;
int * const b2 = &a;
int * const * ptr = &b;
```
❗ No equivalent Rust code because multiple mutable borrow value

```rust
let mut a = 1;
let b = &mut a;
let c = &mut b;
```

The Rust program crash with this following error:

```zsh
cannot borrow `b` as mutable, as it is not declared as mutable
```

##  A pointer to a pointer to a const int

Declare ptr as pointer to pointer to const int

```c
int a = 1, b = 2;
int const * c = &a; 
int const * d = &a; 
int const * * ptr = &c;

** ptr = 5;     // [NOT ALLOW] the value of a can get changed through the pointer.
ptr = &d;       // [ALLOW] the pointer ptr can be changed
```

❗ No equivalent Rust code because cannot borrow `a` as mutable, as it is not declared as mutable.

```rust
let a = 1;
let mut b = &mut a;
let mut c = &mut b;
```

We get the error:
```zsh
error[E0596]: cannot borrow `a` as mutable, as it is not declared as mutable
 --> src/main.rs:4:17
  |
3 |     let a = 1;
  |         - help: consider changing this to be mutable: `mut a`
4 |     let mut b = &mut a;
  |                 ^^^^^^ cannot borrow as mutable
```


###  A const pointer to a const pointer to an T

Declare a as const pointer to const pointer to int.

```c
int a = 1, b = 2;
int * const * const ptr;
```

❗ No equivalent Rust code because cannot borrow `b` as mutable, as it is not declared as mutable

```rust 
let mut a = 1;
let b = &mut a;
let c = &mut b;
```

We get the error:

```zsh
5 |     let c = &mut b;
  |             ^^^^^^
  |             |
  |             cannot borrow as mutable
  |             try removing `&mut` here
```



## Derivation from Immutable and Mutable reference

We allow:
* Get an immutable reference from an immutable one: `&T -> &T`
* Get an immutable reference from an mutable one: `&mut T -> &T`
* Get an mutable reference from an mutable one: `&mut T -> &mut T`
* Get an mutable reference from an mutable owner: `mut T -> &mut T`


We don't allow
* Get an mutable reference from an immutable one:  `&T -> &mut T`
* Get an mutable reference from an immutable owner: `T -> &mut T`
