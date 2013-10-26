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

list2ens(L, E) :-
    list2ens(L, [], E1),
    inv(E1, E),
    !.

% Test de la conversion d'une liste en ensemble
testList2Ens :-
    list2ens([], []),
    list2ens([a, a], [a]),
    list2ens([a, b, a], [a, b]),
    \+ list2ens([a, b], [a]),
    \+ list2ens([a, b, c], [a, b]).
