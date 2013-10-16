% Utile pour les paires [X, Y]
first([X, _], X).
second([_, Y], Y).

% compter le nombre d'occurences d'un élément dans une liste
compter([], _, 0).
compter([X|T], X, Y):- compter(T, X, Z), Y is 1 + Z.
compter([X1|T], X, Z):- X1 \= X, compter(T, X, Z).

% coefficient binomial
coefBinomial(_, 0, 1).
coefBinomial(N, N, 1).
coefBinomial(N, P, B) :-
  N1 is N-1, P1 is P-1,
  coefBinomial(N1, P1, B1),
  coefBinomial(N1, P, B2),
  B is B1 + B2.

% vim: ft=prolog et sw=2 sts=2
