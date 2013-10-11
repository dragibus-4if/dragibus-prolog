use_module(library(random)).
use_module(library(lists)).

% Vrai si Res et un player(Id, L) avec L une liste de taille 5 de nombres
% aléatoires entre 1 et 6 compris.
playerCreate(Id, Res) :-
  playerCreate(Id, 5, Res).

% Vrai si Res et un player(Id, L) avec L une liste de taille NbDice de nombres
% aléatoires entre 1 et 6 compris.
playerCreate(Id, NbDice, Res) :-
  maplist(random(1, 7), L),
  length(L, NbDice),
  Res = player(Id, L), !.

% Vrai si Res est un player(Id, L2) avec L2 une liste de la meme taille que
% L et remplie de nombres aléatoires entre 1 et 6 compris.
playerShuffle(player(Id, L), Res) :-
  length(L, NbDice),
  playerCreate(Id, NbDice, Res).

% Vrai si le player est composé d'une liste vide.
playerIsDead(player(_, [])).

% Négation de playerIsDead
playerIsAlive(P) :-
    not(playerIsDead(P)).

% vim: ft=prolog et sw=2 sts=2
