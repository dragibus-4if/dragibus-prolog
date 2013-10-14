use_module(library(lists)).
use_module(library(apply)).

:- [player].
:- [rules].
:- [ia].

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
  % Names \= [],
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
  !.

gameNewTurn(Game) :-
  write('Nouveau tour de jeu\n'),
  gameShow(Game),
  gameNbrDice(NGame, NbrDice),
  rulesPossibleMoves(Moves, NbrDice),
  nth1(1, NGame, P),
  playerDices(P, PDices),
  iaAutiste(PDices, NbrDice, _, Moves, B),
  rulesMove(B),
  gameTurn(Game, _, B).

gameTurn(Game, Bet, dudo) :-
  write('Tu bluff gros porc\n'),
  rulesDudo(Bet, Game, NGame),
  gameInitNewTurn(NGame),
  !.

gameTurn(Game, Bet, calza) :-
  write('J\'ai des boules moi\n'),
  rulesCalza(Bet, Game, NGame),
  gameInitNewTurn(NGame),
  !.

% Un joueur parle à partir d'un état de jeu et d'une mise.
gameTurn(Game, OldBet, Bet) :-
  rulesNextPlayer(Game, NGame),
  write('Au prochain de jouer avec la mise : '),
  write(Bet),
  write('\n'),
  gameShow(NGame),
  gameNbrDice(NGame, NbrDice),
  rulesPossibleMoves(Bet, NbrDice, Moves),
  nth1(1, NGame, P),
  playerDices(P, PDices),
  iaAutiste(PDices, NbrDice, OldBet, Moves, B),
  rulesMove(B),
  gameTurn(NGame, Bet, B).

% Vrai s'il ne reste qu'un seul joueur dans le jeu.
gameIsOver(Game) :-
  length(Game, 1).

gameNbrDice(Game, Nbr) :-
  maplist(playerDices, Game, D),
  flatten(D, R),
  length(R, Nbr).

% vim: ft=prolog et sw=2 sts=2
