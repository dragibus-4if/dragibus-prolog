oncleTante(X, Y) :-
  frereSoeur(X, Z),
  parent(Z, Y).

% Test de la relation oncle-tante
testOncleTante :-
    oncleTante(louis, marc),
    oncleTante(louis, martha),
    \+ oncleTante(rodrigo, martha),
    \+ oncleTante(marc, martha).
