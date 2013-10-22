:- [liste].

element(_, []) :- fail.
element(X, [T|Q]) :-
  X == T ; element(X, Q).

list2ens([], _).
list2ens([T|Q], E) :-
  (var(E) -> Es = [] ; Es = E),
  (element(T, Es) ; concat([T], Es, E)),
  list2ens(Q, E).

% vim: ft=prolog et sw=2 sts=2
