% IA "ivre", retournant un coefficiant au hasard pour chaque coup possible
setRandom(X, (X, N)) :-
  N is random_float.

iaIvre(_, _, _, CoupsPossibles, Estimations) :-
  maplist(setRandom, CoupsPossibles, Estimations).

% vim: ft=prolog et sw=2 sts=2
