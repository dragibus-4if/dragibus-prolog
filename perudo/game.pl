use_module(library(lists)).
use_module(library(apply)).

:- [player].
:- [rules].
:- [ia].
:- [botMaster].

% Idée d'IA : (TODO)
% Point de confiance pour chaque joueur.
% A la fin d'un tour, on dévoile les dés de chaque joueur.
% Les IA qui apprennent peuvent alors voir qui sont ceux qui ont bluffé.
% On peut ainsi déterminer au cours de la partie un coefficiant de confiance.
%
% Apprentissage des derniers coups joués.
% Quand une IA joue, les autres doivent etre mis au courant.
% Les IA qui apprennent vont donc pouvoir se faire plaisir.
% A coupler avec le coefficient de confiance.

go :-
  gameCreate([('John', iaAutiste),
    ('Marc', iaAutiste),
    ('Luke', iaDebile),
    ('Lisa', iaAutiste),
    ('Jule', iaAutiste)]).

% Toujours vrai, affiche les informations sur le jeu Game.
gameShow(Game) :-
  write('Game : '),
  write(Game),
  write('\n').

% Crée un jeu et le lance en créant les joueurs données dans la liste Names.
% Faux et arrete si la liste des noms comporte des doublons.
% Faux si la liste est vide
gameCreate([]) :- !, fail.
gameCreate(Names) :-
  is_set(Names),
  maplist(playerCreate, Names, Game),
  write('Creation de la partie\n'),
  gameShow(Game),
  gameNewTurn(Game).

% Débute un nouveau tour à partir de l'état Game puis continue le jeu.
gameInitNewTurn(Game) :-
  include(playerIsAlive, Game, L),
  maplist(playerShuffle, L, NGame),
  gameNewTurn(NGame).

gameNewTurn([P]) :-
  playerId(P, X),
  write(X),
  write(' dit : Game over motherfucker\n'),
  write(X),
  write('\n'),
  !.

gameNewTurn(Game) :-
  write('Nouveau tour de jeu\n'),
  gameShow(Game),
  gameNbrDice(Game, NbrDice),
  rulesPossibleMoves(Moves, NbrDice),
  nth1(1, Game, P),
  playerPlay(P, NbrDice, [], Moves, B),
  rulesMove(B),
  gameTurn(Game, [B]).

gameTurn(Game, [dudo, Bet|_]) :-
  write('Tu bluff gros porc\n'),
  rulesDudo(Bet, Game, NGame),
  gameInitNewTurn(NGame),
  !.

gameTurn(Game, [calza, Bet|_]) :-
  write('J\'ai des boules moi\n'),
  rulesCalza(Bet, Game, NGame),
  gameInitNewTurn(NGame),
  !.

% Un joueur parle à partir d'un état de jeu et d'une mise.
gameTurn(Game, [Bet|Bets]) :-
  rulesNextPlayer(Game, NGame),
  write('Au prochain de jouer avec la mise : '),
  write(Bet),
  write('\n'),
  gameShow(NGame),
  gameNbrDice(NGame, NbrDice),
  rulesPossibleMoves(Bet, NbrDice, Moves),
  nth1(1, NGame, P),
  playerPlay(P, NbrDice, [Bet|Bets], Moves, B),
  rulesMove(B),
  gameTurn(NGame, [B,Bet|Bets]).

% Vrai s'il ne reste qu'un seul joueur dans le jeu.
gameIsOver(Game) :-
  length(Game, 1).

gameNbrDice(Game, Nbr) :-
  maplist(playerDices, Game, D),
  flatten(D, R),
  length(R, Nbr).

% vim: ft=prolog et sw=2 sts=2
