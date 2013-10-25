% Element(Idx, X, L) est vrai si X est a la position Idx dans L (en commencant a compter a partir de 1).
% On doit passer par une fonction element/4 pour integrer un accumulateur en parametre.
element(Idx, X, L) :-
  element(Idx, 0, X, L).
element(Idx, _, _, _) :-
      Idx < 1, !, fail.
element(Idx, Count, H, [H|_]) :-
  Idx is Count + 1.
element(Idx, Count, Item, [_|T]) :-
  Count1 is Count + 1,
  element(Idx, Count1, Item, T).

