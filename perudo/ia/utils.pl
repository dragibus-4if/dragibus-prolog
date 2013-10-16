% Utile pour les paires [X, Y]
first([X, _], X).
second([_, Y], Y).

% compter le nombre d'occurences d'un élément dans une liste
compter([], _, 0).
compter([X|T], X, Y):- compter(T, X, Z), Y is 1 + Z.
compter([X1|T], X, Z):- X1 \= X, compter(T, X, Z).

% vim: ft=prolog et sw=2 sts=2
