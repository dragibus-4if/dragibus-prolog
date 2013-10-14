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
gameNewTurn(Game) :-
  include(playerIsAlive, Game, L),
  maplist(playerShuffle, L, NGame),
  write('Nouveau tour de jeu\n'),
  gameShow(NGame),
  rulesPossibleMoves(Moves),
  iaJoue(Moves, B),
  rulesMove(B),
  gameTurn(NGame, B).

gameTurn(Game, dudo) :-
  write('Tu bluff gros porc\n'),
  % TODO: A Traiter
  gameNewTurn(Game),
  !.

gameTurn(Game, calza) :-
  write('J\'ai des boules moi\n'),
  % TODO: A Traiter
  gameNewTurn(Game),
  !.

% Un joueur parle à partir d'un état de jeu et d'une mise.
gameTurn(Game, Bet) :-
  gameNextPlayer(Game, NGame),
  write('Au prochain de jouer avec la mise : '),
  write(Bet),
  write('\n'),
  gameShow(Game),
  rulesPossibleMoves(Bet, Moves),
  iaJoue(Moves, B),
  rulesMove(B),
  gameTurn(NGame, B).

% Vrai si les deux listes sont les memes à l'exception que la tete de Game
% est le dernier élément de NGame.
% Représente la circulation du joueur en état de parler dans le jeu.
gameNextPlayer(Game, NGame) :-
  nth1(1, Game, P),
  append([P], L, Game),
  append(L, [P], NGame).

% Vrai s'il ne reste qu'un seul joueur dans le jeu.
gameIsOver(Game) :-
  length(Game, 1).

% vim: ft=prolog et sw=2 sts=2
