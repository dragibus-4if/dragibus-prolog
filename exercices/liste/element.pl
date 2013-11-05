element(X, [X|Xs], Xs).
element(X, [T|As], [T|Bs]) :-
  element(X, As, Bs),
  X \== T.

testElement :-
    \+ element(_, [], []),
    element(b, [a, b, c], [a, c]),
    element(a, [a, b, c], [b, c]),
    element(c, [a, b, c], [a, b]),
    \+ element(d, [a, b, c], _),
    \+ element(a, [a, b], [a, b]),
    \+ element(a, [c, b], [c, b]),
    \+ element(b, [a, b, c], [a, b]),
    % Il faut rajouter une coupure pour prouver les predicats
    % suivants pour limiter l'espace des solutions :
    % element(X, [X | L], L),
    % element(X, [A, X | L], [A | L]),
    % ...
    true.
