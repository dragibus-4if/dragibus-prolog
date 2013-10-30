:- [utils].

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
statCouple(Des, N, Coup, Mise, Estimation) :-
  statEnchere(Des, N, Coup, Mise, Estim),
  Estimation = (Mise, Estim).

iaStats(Player, N, PlayersNBets, CoupsPossibles, Estimations) :-
  playerDices(Player, Des),
  PlayersNBets = [(_, Coup)|_],
  maplist(statCouple(Des, N, Coup), CoupsPossibles, Estimations), !.

% vim: ft=prolog et sw=2 sts=2
