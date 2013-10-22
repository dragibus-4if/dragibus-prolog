element(Idx, X, L) :-
  element_(Idx, 0, X, L).
element_(Idx, Count, H, [H|_]) :-
  Idx is Count + 1.
element_(Idx, Count, Item, [_|T]) :-
  Count1 is Count + 1,
  element_(Idx, Count1, Item, T).
