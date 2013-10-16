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

:- [ia/ivre].
:- [ia/debile].
:- [ia/stats].
:- [ia/autiste].

iaNbrDice(Dices, V, N) :-
    include(==(V), Dices, L),
    length(L, N).

% Fonction d'évaluation d'une mise par rapport au dé du joueur, du nombre total
% de dé, de la mise precedente.
iaEvalBet(Dices, NbrDice, _, Bet, Value) :-
    Bet = rulesBet(N, V),
    Bet,
    iaNbrDice(Dices, V, N1),
    iaNbrDice(Dices, 1, N2),
    ((V == 1) -> (NbrMe is N1, Div is 6) ; (NbrMe is N1 + N2, Div is 3)),
    length(Dices, N_),
    NbrOther is NbrDice - N_,
    write('Nombre eu = '), write(NbrMe), write('\n'),
    Lim is NbrOther / Div,
    write('Limite statistique = '), write(Lim), write('\n'),
    Value is Lim / (N - NbrMe).

iaJoue(Des, N, rulesBet(Nb, Val), CoupsPossibles, Coup) :-
  write('Des = '), write(Des), write('\n'),
  write('Nombre de dés au total = '), write(N), write('\n'),
  write('Mise :'), write(Nb), write(' '), write(Val), write('\n'),
  write('Liste des coups possibles : '), write(CoupsPossibles), write('\n'),
  write('Que voulez vous jouer ? '), read(Indice), nth1(Indice, CoupsPossibles, Coup).

% vim: ft=prolog et sw=2 sts=2
