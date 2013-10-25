% element(Idx, X, L) est vrai si X est à la position Idx dans L (en commençant à compter à partir de 1).
% On doit passer par une fonction element/4 pour intégrer un accumulateur en paramètre.
element(Idx, X, L) :-
  element(Idx, 0, X, L).
element(Idx, _, _, _) :-
      Idx < 1, !, fail.
element(Idx, Count, H, [H|_]) :-
  Idx is Count + 1.
element(Idx, Count, Item, [_|T]) :-
  Count1 is Count + 1,
  element(Idx, Count1, Item, T).

