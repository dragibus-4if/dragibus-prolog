ancetres(X, L) :-
  setof(A, ancetre(A, X), L).

descendants(X, L) :-
  setof(A, ancetre(X, A), L).

ancetres(X, _) :- var(X), fail.
descendants(X, _) :- var(X), fail.
