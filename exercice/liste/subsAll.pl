subsAll(_, _, [], []).
subsAll(E, X, [T|Q], L) :-
  T \= E,
  subsAll(E, X, Q, Ls),
  concat([T], Ls, L).
subsAll(E, X, [E|Q], L) :-
  subsAll(E, X, Q, Ls),
  concat([X], Ls, L).

testSubsAll :-
    % On utilise select/4 de la lib standard.
    select(X, L1, Y, L2),
    subsAll(X, Y, L1, L2),
    write(X), write(' => '), write(Y), write(' : '),
    write(L1), write(' => '), write(L2), write('\n').
