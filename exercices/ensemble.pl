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

% Vrai quand E correspond a l'ensemble des elements de L, sans doublon.
% L'ordre de la liste initiale est conserve
list2ens(L, E) :-
    list2ens(L, [], E1),
    inv(E1, E),
    !.

% Vrai quand L est un ensemble, et donc ne contient pas de doublons.
ensemble(L) :-
    list2ens(L, L).
