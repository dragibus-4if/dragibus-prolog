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

coef(Coef, (B, X), (B, Y)) :-
  Y is Coef * X.

applyIA(C, Player, N, PlayerNBets, CoupsPossibles, (Coef, IA), Estim) :-
  call(IA, Player, N, PlayerNBets, CoupsPossibles, Estim_),
  maplist(coef(C * Coef), Estim_, Estim).

plus_first((X, A), (X, B), (X, N)) :-
  N is A + B.

% IA combinant une liste d'IA pour combiner leurs estimations
iaCombine(LsIA, Player, N, PlayersNBets, CoupsPossibles, Estimations) :-
  length(LsIA, N),
  C is 1.0 / N,
  maplist(applyIA(C, Player, N, PlayersNBets, CoupsPossibles), LsIA, LsEstim),
  append([V0], LsEstim1, LsEstim),
  foldl(maplist(plus_first), LsEstim1, V0, Estimations).

% interface disponible
iaJoue(IA, Des, N, Coup, CoupsPossibles, Estimations) :-
  length(ListeEstimations, L),
  iaCombine(IA, Des, N, Coup, CoupsPossibles, [], ListeEstimations),
  sommeEstimations(ListeEstimations, EstimationsSommees),
  fail. % TODO diviser chaque deuxième élément par L

go :-
  iaJoue([iaIvre, iaStats], [3, 3, 4], 6, rulesBet(3, 3), [calza, dudo, rulesBet(4, 3), rulesBet(3, 4), rulesBet(3, 5), rulesBet(3, 6), rulesBet(2, 1)] , E),
  write(E).



% vim: ft=prolog et sw=2 sts=2
