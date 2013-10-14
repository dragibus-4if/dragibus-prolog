createFoo(A, F, Res) :- Res = foo(A, F).

useFoo(Foo, Res) :- Foo = foo(_, F), call(F, Res).

funcA(X) :- between(1, 5, X).
