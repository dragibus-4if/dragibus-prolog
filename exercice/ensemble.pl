:- [liste].

element(_, []) :- fail.
element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

list2ens([], V, V).
list2ens([T|Q], V, E) :-
  element(T, V),
  list2ens(Q, V, E).
list2ens([T|Q], V, E) :-
  \+element(T, V),
  concat([T], V, V1),
  list2ens(Q, V1, E).

list2ens(L, E) :- list2ens(L, [], E), !.

% vim: ft=prolog et sw=2 sts=2
