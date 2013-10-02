parent(jacques, mireille).
parent(jean, mireille).
parent(jacques, marc).
parent(jean, marc).
parent(mireille, herve).
parent(marc, louis).

fils(X, Y) :- parent(Y, X).
gdparent(X,Y) :- parent(X, Z), parent(Z, Y).
frere(X, Y) :- parent(X, Z), parent(Y, Z).
oncle(X, Y) :- parent(X, Z), frere(Z, Y).

ancetre(X, Y) :- parent(X, Y).
ancetre(X, Y) :- parent(X, Z), ancetre(Z, Y).

ascendance(X) :- setof(X, ancetre(X, _), T).
descendance(X) :- setof(X, ancetre(_, X), T).

% ?- setof(X, ancetre(jean, X), T).
% ?- setof(X, ancetre(X, herve), T).

len([], 0).
len([_|Q], N) :- len(Q, N1), N is N1 + 1.

element(_, [], []).
element(T, [T|Q], [H|L]) :- T \== H, element(T, Q, [H|L]).
element(X, [T|Q], [T|L]) :- X \== T, element(X, Q, L).
