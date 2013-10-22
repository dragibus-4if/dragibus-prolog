% permet de vérifier si un élément fait partie d'une liste
element(_, []) :- fail.
element(X, [X|_]).
element(X, [_|Q]) :- element(X, Q).

% permet de construire un ensemble à partir d'une liste
list2ens([], V, V).
list2ens([T|Q], V, E) :-
  element(T, V),
  list2ens(Q, V, E).
list2ens([T|Q], V, E) :-
  \+element(T, V),
  concat([T], V, V1),
  list2ens(Q, V1, E).
list2ens(L, E) :-
    list2ens(L, [], E), !.

% renvoie si une liste est un ensemble
ensemble(L) :-
    list2ens(L, L1),
    inv(L1, L2),
    L = L2.
