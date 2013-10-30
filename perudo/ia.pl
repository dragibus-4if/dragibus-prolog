% Informations nécessaires pour le fonctionnement d'une IA :
%   - l'état "joueur" de l'IA (liste de dés)
%   - la mise précédente
%   - le nombre total de dés
%   - la liste des coups possibles
%
% Signature d'une IA :
%   ia<NomIA>(Player, NbrTotalDeDés, [(Player, rulesBet(Nb, Val))], CoupsPossibles, [(Coups, Estimation)])
%
% Description des paramètres :
%   1) Joueur de l'IA
%   2) Nombre TOTAL de dés (joueur IA compris)
%   3) Liste des mises précédentes associés à son joueur
%   4) Liste des coups possibles
%   5) Liste des coups avec une estimation entre 0 et 1 de l'importance du coup.

:- use_module(library(apply)).

:- [ia/ivre].
:- [ia/debile].
:- [ia/stats].
:- [ia/autiste].
:- [ia/eleve].

premier((X, _), X).
second((_, Y), Y).

coef_premier(Coef, (X, B), (Y, B)) :-
  Y is Coef * X.
coef_second(Coef, (B, X), (B, Y)) :-
  Y is Coef * X.

applyIA(Player, N, PlayerNBets, CoupsPossibles, (Coef, IA), Estim) :-
  call(IA, Player, N, PlayerNBets, CoupsPossibles, Estim_),
  maplist(coef_second(Coef), Estim_, Estim).

plus_second((X, A), (X, B), (X, N)) :-
  N is A + B.

% IA combinant une liste d'IA pour combiner leurs estimations
iaCombine([], _, _, _, _, _) :- fail.
iaCombine(LsIA, Player, N, PlayersNBets, CoupsPossibles, Estimations) :-
  maplist(premier, LsIA, LsCoef),
  sum_list(LsCoef, SumCoef),
  GlobalCoef is 1.0 / SumCoef,
  maplist(coef_premier(GlobalCoef), LsIA, LsIA_),
  maplist(applyIA(Player, N, PlayersNBets, CoupsPossibles), LsIA_, LsEstim),
  append([V0], LsEstim1, LsEstim),
  foldl(maplist(plus_second), LsEstim1, V0, Estimations).

cmpEstimation((=), (_, V), (_, V)).
cmpEstimation((<), (_, V1), (_, V2)) :- V1 @< V2.
cmpEstimation((>), (_, V1), (_, V2)) :- V1 @> V2.

iaJoue(IA, Player, N, PlayersNBets, CoupsPossibles, Coup) :-
  call(IA, Player, N, PlayersNBets, CoupsPossibles, E),
  predsort(cmpEstimation, E, E2),
  write(E2), write('\n'),
  last(E2, C),
  C = (Coup, _), !.

goIA :-
  playerCreate(('John', _), P1),
  playerCreate(('Marc', _), P2),
  PnB = [(P1, rulesBet(3, 6))],
  PnB = [(_, Bet)|_],
  Game = [P1, P2],
  gameNbrDice(Game, NbrDice),
  rulesPossibleMoves(Bet, NbrDice, CoupsPossibles),
  % CoupsPossibles = [rulesBet(10, 3), rulesBet(10, 4), dudo, calza],
  IA = iaCombine([(0.0, iaEleve), (9.0, iaStats)]),
  write('GO!!!!\n'),
  iaJoue(IA, P2, 10, PnB, CoupsPossibles, Coup),
  write(Coup),
  write('\n').

% vim: ft=prolog et sw=2 sts=2
