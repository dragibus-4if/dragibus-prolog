% IA "débile", retournant un coefficient en e**-d où d est
% la distance entre l'élément courant et l'élément le plus "faible",
% c'est à dire le troisième dans le cas d'une liste de taille > 3,
% sinon le deuxième.
iaDebile(_, _, _, [A, B], [[A, Ac], [B, Bc]]) :-
  Ac is exp(-1), Bc is 1.
iaDebile(_, _, _, [A, B, C], [[A, Ac], [B, Bc], [C, Cc]]) :-
  Ac is exp(-2), Bc is exp(-1), Cc is 1.
%iaDebile(_, _, _, [T|Q]) :- TODO

% vim: ft=prolog et sw=2 sts=2
