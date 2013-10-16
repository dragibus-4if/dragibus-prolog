:- module(ivre, [iaIvre/5]).

% IA "ivre", choisissant au hasard parmis la liste des coups possibles.
iaIvre(_, _, _, CoupsPossibles, Coup) :-
  length(CoupsPossibles, NbCoupsPossibles),
  random(1, NbCoupsPossibles, N),
  nth1(N, CoupsPossibles, Coup).

% vim: ft=prolog et sw=2 sts=2
