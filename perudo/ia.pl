% Informations nécessaires pour le fonctionnement d'une IA :
%   - l'état "joueur" de l'IA (liste de dés)
%   - la mise précédente
%   - le nombre total de dés
%   - la liste des coups possibles
%
% Signature d'une IA :
%   ia<NomIA>(Dés, NbrTotalDeDés, rulesBet(Nb, Val), CoupsPossibles, CoupChoisi)
%
% Description des paramètres :
%   1) Liste des dés de l'IA
%   2) Nombre TOTAL de dés (joueur IA compris)
%   3) Mise précédente
%   4) Liste des coups possibles
%   5) Coup choisi par l'IA

:- use_module(library(apply)).

:- [ia/ivre].
:- [ia/debile].
:- [ia/stats].
:- [ia/autiste].
:- [ia/eleve].

%iaCombineReele(IA, Des, N, Coup, CoupsPossibles, Estimations) :-

% Exposition de l'interface: le deuxième paramètre étant une closure de la
% liste d'IA (premier paramètre) appliquant toutes celles-ci
%iaCombine(L, IA) :- IA = \D^N^C^CP^E^(iaCombineReele(L, D, N, C, CP, E)).

% IA combinant une liste d'IA pour combiner leurs estimations
iaCombine([], _, _, _, _, []).
iaCombine([T|Q], Des, N, Coup, CoupsPossibles, ListeEstimations) :-
  call(T, Des, N, Coup, CoupsPossibles, ET),
  iaJoue(Q, Des, N, Coup, CoupsPossibles, EQ),
  append([ET], EQ, Estimations).
sommeEstimations([], L, L).
sommeEstimations([T|Q], L, R) :- fail. % TODO
sommeEstimations([T|Q], [], R) :-
  sommeEstimations(Q, T, R).
sommeEstimations(L, E) :-
  sommeEstimations(L, [], E),
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
