inv([], []).
inv([X|Xs], L) :-
  inv(Xs, L2),
  concat(L2, [X], L).

testInv :-
    % On utilise reverse/2 de la lib standard pour tester
    reverse(L1, L2),
    inv(L1, L2),
    write(L1), write(' : '), write(L2), write('\n').
