:- [utils].

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
% décider du coup à jouer.
iaStats(_, _, _, [], L, L).
iaStats(Des, N, Coup, [T|Q], V, L) :-
  statEnchere(Des, N, Coup, T, Tc),
  append([[T, Tc]], V, V1),
  iaStats(Des, N, Coup, Q, V1, L).
iaStats(Player, N, PlayersNBets, CoupsPossibles, Estimations) :-
  playerDices(Player, Des),
  PlayersNBets = [(_, Coup)|_],
  maplist(statEnchere(Des, N, Coup), CoupsPossibles, Estimations), !.
  % iaStats(Des, N, Coup, CoupsPossibles, [], Estimations), !.

% vim: ft=prolog et sw=2 sts=2
