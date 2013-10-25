% Test de la vérification d'un ensemble
testEnsemble :-
    ensemble([]),
    ensemble([a]),
    ensemble([a, b]),
    ensemble([a, b, c]),
    \+ ensemble([a, a]),
    \+ ensemble([a, b, a]),
    \+ ensemble([a, b, b]),
    \+ ensemble([c, c, b]).

% Test de la conversion d'une liste en ensemble
testList2Ens :-
    list2ens([], []),
    list2ens([a, a], [a]),
    list2ens([a, b, a], [a, b]),
    \+ list2ens([a, b], [a]),
    \+ list2ens([a, b, c], [a, b]).
