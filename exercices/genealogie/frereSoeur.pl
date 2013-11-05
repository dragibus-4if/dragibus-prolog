frereSoeur(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

% Test de la relation frere-soeur
testFrereSoeur :-
    frereSoeur(martha, marc),
    frereSoeur(marc, martha),
    \+ frereSoeur(marc, marc),
    \+ frereSoeur(rodrigo, marc),
    \+ frereSoeur(rodrigo, jean).
