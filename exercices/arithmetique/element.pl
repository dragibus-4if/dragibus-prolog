element(Idx, X, L) :-
  element(Idx, 0, X, L).
element(Idx, _, _, _) :-
      Idx < 1, !, fail.
element(Idx, Count, H, [H|_]) :-
  Idx is Count + 1.
element(Idx, Count, Item, [_|T]) :-
  Count1 is Count + 1,
  element(Idx, Count1, Item, T).

testElement :-
    \+ element(0, _, _),
    element(1, X, [X]),
    element(1, X, [X, _, _, _, _]),
    \+ (X \= Y, element(2, X, [_, Y, _, _, _])),
    element(1, a, [a, b, a]),
    \+ element(2, a, [a, b, a]),
    element(3, a, [a, b, a]),
    % Identique a nth1/3. On l'utilise alors pour prouver le code.
    nth1(Idx, L, E),
    element(Idx, E, L).
