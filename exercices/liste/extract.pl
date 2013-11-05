extract(_, []).
extract(L, [X|Xs]) :-
  element(X, L, L2),
  extract(L2, Xs).

testExtract :-
    extract([], []),
    extract([a], []),
    extract([a], [a]),
    extract([a, b], []),
    extract([a, b], [a]),
    extract([a, b], [b]),
    extract([a, b], [b, a]),
    extract([a, b, c], []),
    extract([a, b, c], [b]),
    extract([a, b, c], [c]),
    extract([a, b, c], [a, b]),
    extract([a, b, c], [a, c]),
    extract([a, b, c], [b, a]),
    extract([a, b, c], [a, b, c]),
    extract([a, b, c], [a, c, b]),
    extract([a, b, c], [b, a, c]),
    \+ extract([], [_]),
    \+ extract([a], [b]),
    \+ extract([a, b, c], [a, b, d]),
    % Toutes les permutations de L1 sont des sous ensembles de L2 :
    permutation(L1, L2),
    extract(L1, L2),
    write(L1), write(' '), write(L2), write('\n').
