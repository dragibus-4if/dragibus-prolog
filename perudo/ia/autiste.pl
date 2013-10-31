% compter le nombre d'occurences pour tous
compteTous(Liste, X, C) :-
  sort(Liste, L),
  member(X, L),
  compter(Liste, X, C).

% tri d'une liste de tuples selon le deuxième élément
compareSecond(Delta, (_, A), (_, B)):-
  A == B; compare(Delta, A, B).

bet2dice(calza) :- fail.
bet2dice(dudo) :- fail.
bet2dice(rulesBet(_, X), X).

% IA "autiste", juge quel est le meilleur coup à jouer en se basant sur seulement
% sur ses propre dés.
iaAutiste(Player, N, [(_, rulesBet(Nb, De))|_], TousCoupsPossibles, Estimations) :-
  playerDices(Player, Des),
  length(Des, NbMesDes),
  NbAutresDes is N - NbMesDes,

  % récupération des coups numériques sans dudo/calza
  TousCoupsPossibles = [_, _|CoupsPossibles],
  write('CoupsPossibles = '), write(CoupsPossibles), write('\n'),

  % intersection entre nos dés et les dés possibles à jouer
  %   - CoupsPossibles est sous la forme [[Nb, Dé], ...]
  maplist(bet2dice, CoupsPossibles, X),
  list_to_set(X, Y),
  intersection(Des, Y, DesPossibles),
  write('DesPossibles = '), write(DesPossibles), write('\n'),

  % tri des dés possibles sous la forme [[D1, Nb1], [D2, Nb2], ...]
  bagof((D, C), compteTous(DesPossibles, D, C), DesNonTries),
  write('DesNonTries = '), write(DesNonTries), write('\n'),
  predsort(compareSecond, DesNonTries, DesTries),
  write('DesTries = '), write(DesTries), write('\n'),

  % TODO
  write('Estimations = ', Estimations).

go1 :-
  P1 = player('Un quelconque', _, [1, 2, 2]),
  P2 = player('Un autiste', _, [2, 3, 2, 2]),
  PnB = [(P1, rulesBet(2, 2))],
  PnB = [(_, Bet)|_],
  Game = [P1, P2],
  gameNbrDice(Game, NbrDice),
  rulesPossibleMoves(Bet, NbrDice, CoupsPossibles),
  iaAutiste(P2, NbrDice, [(_, Enchere)|_], CoupsPossibles, E).

% vim: ft=prolog et sw=2 sts=2
