% IA "débile", retournant un coefficient en e**-d où d est
% la distance entre l'élément courant et l'élément le plus "faible",
% c'est à dire le troisième dans le cas d'une liste de taille > 3,
% sinon le deuxième.
pair_set_second(V, E, (E, V)).

iaDebile(_, _, _, [A, B], [(A, Ac), (B, Bc)]) :-
  Ac is exp(-1), Bc is 1.
iaDebile(_, _, _, [A, B, C | L], Res) :-
  Ac is exp(-2), Bc is exp(-1), Cc is 1,
  maplist(pair_set_second(0), L, L_),
  append([(A, Ac), (B, Bc), (C, Cc)], L_, Res).

% vim: ft=prolog et sw=2 sts=2
