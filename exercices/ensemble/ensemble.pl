ensemble(L) :-
    list2ens(L, L).

% Test de la verification d'un ensemble
testEnsemble :-
    ensemble([]),
    ensemble([a]),
    ensemble([a, b]),
    ensemble([a, b, c]),
    \+ ensemble([a, a]),
    \+ ensemble([a, b, a]),
    \+ ensemble([a, b, b]),
    \+ ensemble([c, c, b]).
