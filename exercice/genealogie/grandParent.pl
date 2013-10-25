grandParent(X, Y) :-
  parent(X, Z),
  parent(Z, Y).

% Test de la relation grand-parent
testGrandParent :-
    grandParent(rodrigo, martha),
    grandParent(rodrigo, marc),
    grandParent(rodrigo, jean),
    grandParent(ivonne, john),
    grandParent(rodrigo, marc),
    \+ grandParent(jean, george),
    \+ grandParent(ivonne, martha),
    \+ grandParent(john, martha),
    \+ grandParent(martha, martha),
    grandParent(louis, leo),
    !.
