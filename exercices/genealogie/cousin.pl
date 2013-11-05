cousin(X, Y) :-
  parent(A, X),
  parent(B, Y),
  frereSoeur(A, B).

% Test de la relation cousin
testCousin :-
    cousin(jean, martha),
    cousin(marc, jean),
    \+ cousin(marc, martha),
    \+ cousin(rodrigo, martha).
