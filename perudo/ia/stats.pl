:- [utils].

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
statCouple(Des, N, Coup, Mise, Estimation) :-
  statEnchere(Des, N, Coup, Mise, Estim),
  Estimation = (Mise, Estim).

iaStats(_, _, [], CoupsPossibles, Estimations) :-
  maplist(pair_set_second(0), CoupsPossibles, Estimations).
iaStats(Player, N, [(_, Coup) | _], CoupsPossibles, Estimations) :-
  playerDices(Player, Des),
  maplist(statCouple(Des, N, Coup), CoupsPossibles, Estimations), !.

% vim: ft=prolog et sw=2 sts=2
