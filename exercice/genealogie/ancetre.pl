ancetre(X, Y) :-
  parent(X, Y).
ancetre(X, Y) :-
  parent(X, Z),
  ancetre(Z, Y).

% Test de la relation ancetre
testAncetre :-
    ancetre(ivonne, martha),
    ancetre(rodrigo, marc),
    ancetre(john, martha),
    \+ ancetre(martha, martha).
