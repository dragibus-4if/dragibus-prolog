testElement :-
    \+ element(_, [], []),
    element(b, [a, b, c], [a, c]),
    element(a, [a, b, c], [b, c]),
    element(c, [a, b, c], [a, b]),
    \+ element(d, [a, b, c], _),
    \+ element(a, [a, b], [a, b]),
    \+ element(a, [c, b], [c, b]),
    \+ element(b, [a, b, c], [a, b]),
    % Il faut rajouter une coupure pour prouver les prédicats
    % suivants pour limiter l'espace des solutions :
    % element(X, [X | L], L),
    % element(X, [A, X | L], [A | L]),
    % ...
    true.

testExtract :-
    extract([], []),
    extract([a], []),
    extract([a], [a]),
    extract([a, b], []),
    extract([a, b], [a]),
    extract([a, b], [b]),
    extract([a, b], [a, b]),
    extract([a, b], [b, a]),
    extract([a, b, c], []),
    extract([a, b, c], [a]),
    extract([a, b, c], [b]),
    extract([a, b, c], [c]),
    extract([a, b, c], [a, b]),
    extract([a, b, c], [a, c]),
    extract([a, b, c], [b, a]),
    extract([a, b, c], [b, c]),
    extract([a, b, c], [c, a]),
    extract([a, b, c], [c, b]),
    extract([a, b, c], [a, b, c]),
    extract([a, b, c], [a, c, b]),
    extract([a, b, c], [b, a, c]),
    extract([a, b, c], [b, c, a]),
    extract([a, b, c], [c, a, b]),
    extract([a, b, c], [c, b, a]),
    \+ extract([], [_]),
    \+ extract([a], [b]),
    \+ extract([a, b, c], [a, b, d]),
    % Toutes les permutations de L1 sont des sous ensembles de L2 :
    permutation(L1, L2),
    extract(L1, L2),
    write(L1), write(' '), write(L2), write('\n').

testConcat :-
    % On utilise append/3 de la lib standard pour tester
    append(L1, L2, L1nL2),
    concat(L1, L2, L1nL2),
    write(L1), write(' + '), write(L2), write(' = '), write(L1nL2), write('\n').

testInv :-
    % On utilise reverse/2 de la lib standard pour tester
    reverse(L1, L2),
    inv(L1, L2),
    write(L1), write(' : '), write(L2), write('\n').

testSubsAll :-
    % On utilise select/4 de la lib standard.
    select(X, L1, Y, L2),
    subsAll(X, Y, L1, L2),
    write(X), write(' => '), write(Y), write(' : '),
    write(L1), write(' => '), write(L2), write('\n').

