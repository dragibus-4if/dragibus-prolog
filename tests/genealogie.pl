% Base de connaissances
parent(john, martha).
parent(john, marc).
parent(rodrigo, john).
parent(jean, leo).
parent(louis, jean).
parent(louis, george).
parent(rodrigo, louis).
parent(ivonne, rodrigo).

% Test de la relation grand-parent
testGrandParent :-
    grandParent(rodrigo, martha),
    grandParent(rodrigo, marc),
    grandParent(rodrigo, jean),
    grandParent(ivonne, john),
    grandParent(rodrigo, marc),
    \+grandParent(jean, george),
    \+grandParent(ivonne, martha),
    \+grandParent(john, martha),
    \+grandParent(martha, martha),
    grandParent(louis, leo),
    !.

% Test de la relation ancetre
testAncetre :-
    ancetre(ivonne, martha),
    ancetre(rodrigo, marc),
    ancetre(john, martha),
    \+ancetre(martha, martha).

% Test de la relation frère-sœur
testFrereSoeur :-
    frereSoeur(martha, marc),
    frereSoeur(marc, martha),
    \+frereSoeur(marc, marc),
    \+frereSoeur(rodrigo, marc),
    \+frereSoeur(rodrigo, jean).

% Test de la relation oncle-tante
testOncleTante :-
    oncleTante(louis, marc),
    oncleTante(louis, martha),
    \+oncleTante(rodrigo, martha),
    \+oncleTante(marc, martha).

% Test de la relation cousin
testCousin :-
    cousin(jean, martha),
    cousin(marc, jean),
    \+cousin(marc, martha),
    \+cousin(rodrigo, martha).

% Tester tout le module
testTout :-
    testGrandParent,
    testAncetre,
    testFrereSoeur,
    testOncleTante.
