% element(_, [], []).
element(X, [X|Xs], Xs).
element(X, [T|As], [T|Bs]) :-
  element(X, As, Bs),
  X \== T.

extract(_, []).
extract(L, [X|Xs]) :-
  element(X, L, L2),
  extract(L2, Xs).

concat([], L2, L2).
concat([X|Xs], L2, [X|L]) :-
  concat(Xs, L2, L).

inv([], []).
inv([X|Xs], L) :-
  inv(Xs, L2),
  concat(L2, [X], L).

% substitution
subsAll(_, _, [], []).
subsAll(E, X, [T|Q], L) :-
  T \= E,
  subsAll(E, X, Q, Ls),
  concat([T], Ls, L),
  !.
subsAll(E, X, [E|Q], L) :-
  subsAll(E, X, Q, Ls),
  concat([X], Ls, L),
  !.

% vim: ft=prolog et sw=2 sts=2
