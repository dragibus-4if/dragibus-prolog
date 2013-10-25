concat([], L2, L2).
concat([X|Xs], L2, [X|L]) :-
  concat(Xs, L2, L).

testConcat :-
    % On utilise append/3 de la lib standard pour tester
    append(L1, L2, L1nL2),
    concat(L1, L2, L1nL2),
    write(L1), write(' + '), write(L2), write(' = '), write(L1nL2), write('\n').
