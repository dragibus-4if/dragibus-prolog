:- use_module(library(random)).
:- use_module(library(lists)).

% Vrai si Res et un player(Id, L) avec L une liste de taille 5 de nombres
% aléatoires entre 1 et 6 compris.
playerCreate((Id, PlayFunc), Res) :-
  playerCreate(Id, PlayFunc, 5, Res).

% Vrai si Res et un player(Id, L) avec L une liste de taille NbDice de nombres
% aléatoires entre 1 et 6 compris.
playerCreate(Id, PlayFunc, NbDice, Res) :-
  maplist(random(1, 7), L),
  length(L, NbDice),
  Res = player(Id, PlayFunc, L), !.

playerId(P, Id) :-
  P = player(Id, _, _).

% Vrai si Res est un player(Id, L2) avec L2 une liste de la meme taille que
% L et remplie de nombres aléatoires entre 1 et 6 compris.
playerShuffle(player(Id, PlayerFunc, L), Res) :-
  length(L, NbDice),
  playerCreate(Id, PlayerFunc, NbDice, Res).

% Vrai si le player est composé d'une liste vide.
playerIsDead(player(_, _, [])).

% Négation de playerIsDead
playerIsAlive(P) :-
    not(playerIsDead(P)).

% Vrai si le joueur P a les dés Dices
playerDices(P, Dices) :-
  P = player(_, _, Dices).

% Vrai si le joueur NP est le meme que P avec le premier dé en moins.
playerRemoveDice(P, NP) :-
  P = player(Id, PF, D),
  append([_], Dices, D),
  NP = player(Id, PF, Dices).

% Vrai si le joueur P à 5 dé.
playerAddDice(P, P) :-
  P = player(_, _, D),
  length(D, 5),
  !.

% Vrai si le joueur NP est le joueur P avec un dé en plus de valeur 0 comme
% premier dé. Un joueur ne peux avoir plus de 5 dés.
playerAddDice(P, NP) :-
  P = player(Id, PF, D),
  append([0], D, Dices),
  NP = player(Id, PF, Dices).

playerPlay(Player, NbrTotalDice, OldBet, PossibleMoves, Move) :-
  Player = player(_, PlayerFunc, Dice),
  call(PlayerFunc, Dice, NbrTotalDice, OldBet, PossibleMoves, Move).

% vim: ft=prolog et sw=2 sts=2
