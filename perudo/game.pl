:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(assoc)).

:- [player].
:- [rules].
:- [ia].

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

init_assoc_id(Id, Assoc, NewAssoc) :-
  put_assoc(Id, Assoc, 0, NewAssoc).

add_win(Winner, Assoc, NewAssoc) :-
  playerId(Winner, ID),
  get_assoc(ID, Assoc, NbrWin),
  NbrWin_ is NbrWin + 1,
  get_assoc(ID, Assoc, NbrWin, NewAssoc, NbrWin_).

go :-
  current_prolog_flag(argv, Arguments),
  append(_SytemArgs, [--|Args], Arguments), !,
  go(Args),
  halt.

go([D1_, E1_, S1_, I1_, D2_, E2_, S2_, I2_, N_]) :-
  atom_number(D1_, D1),
  atom_number(E1_, E1),
  atom_number(S1_, S1),
  atom_number(I1_, I1),
  atom_number(D2_, D2),
  atom_number(E2_, E2),
  atom_number(S2_, S2),
  atom_number(I2_, I2),
  atom_number(N_, N),
  P1 = ('John', iaCombine([(D1, iaDebile), (E1, iaEleve), (S1, iaStats), (I1, iaIvre)])),
  P2 = ('Mike', iaCombine([(D2, iaDebile), (E2, iaEleve), (S2, iaStats), (I2, iaIvre)])),
  LsP = [P1, P2],

  empty_assoc(Assoc_),
  maplist(premier, LsP, LsID),
  foldl(init_assoc_id, LsID, Assoc_, Assoc),

  findall(W, (between(1, N, _), gameCreate(LsP, W)), Bag),
  foldl(add_win, Bag, Assoc, NAssoc),
  assoc_to_list(NAssoc, L),
  % maplist(writeln, L),
  true.
  % gameCreate([('John', iaDebile),
  %   ('Luke', iaDebile),
  %   ('Marc', iaEleve),
  %   ('Lisa', iaDebile),
  %   ('Jule', iaDebile),
  %   ('Mike', iaStats)]).

% Toujours vrai, affiche les informations sur le jeu gagnant.
gameShowWinner(Winner) :-
  playerId(Winner, Name),
  write(Name), write('\n').

% Toujours vrai, affiche les informations sur le jeu Game.
gameShow(_).
% gameShow(Game) :-
%   write('Game : '),
%   write(Game),
%   write('\n').

% Crée un jeu et le lance en créant les joueurs données dans la liste Names.
% Faux et arrete si la liste des noms comporte des doublons.
% Faux si la liste est vide
gameCreate([], _) :- !, fail.
gameCreate(Names, Winner) :-
  is_set(Names),
  maplist(playerCreate, Names, Game),
  % write('Creation de la partie\n'),
  gameShow(Game),
  gameNewTurn(Game, Winner), !.

% Débute un nouveau tour à partir de l'état Game puis continue le jeu.
gameInitNewTurn(Game, Winner) :-
  include(playerIsAlive, Game, L),
  maplist(playerShuffle, L, NGame),
  gameNewTurn(NGame, Winner).

gameNewTurn([P], P) :-
  gameShowWinner(P), !.

gameNewTurn(Game, Winner) :-
  % write('Nouveau tour de jeu\n'),
  gameShow(Game),
  gameNbrDice(Game, NbrDice),
  rulesPossibleMoves(Moves, NbrDice),
  nth1(1, Game, P),
  playerPlay(P, NbrDice, [], Moves, B),
  rulesMove(B),
  gameTurn(Game, [(P, B)], Winner).

gameEndTurn(OldBets) :-
  majConfiances(OldBets, 0.01).

gameTurn(Game, OldBets, Winner) :-
  OldBets = [(_, dudo), (_, Bet) | _],
  % write('Tu bluff gros porc\n'),
  rulesDudo(Bet, Game, NGame),
  gameEndTurn(OldBets),
  gameInitNewTurn(NGame, Winner),
  !.

gameTurn(Game, OldBets, Winner) :-
  OldBets = [(_, calza), (_, Bet) | _],
  % write('J\'ai des boules moi\n'),
  rulesCalza(Bet, Game, NGame),
  gameEndTurn(OldBets),
  gameInitNewTurn(NGame, Winner),
  !.

% Un joueur parle à partir d'un état de jeu et d'une mise.
gameTurn(Game, OldBets, Winner) :-
  OldBets = [(_, Bet) | _],
  rulesNextPlayer(Game, NGame),
  % write('Au prochain de jouer avec la mise : '),
  % write(Bet),
  % write('\n'),
  gameShow(NGame),
  gameNbrDice(NGame, NbrDice),
  rulesPossibleMoves(Bet, NbrDice, Moves),
  nth1(1, NGame, P),
  playerPlay(P, NbrDice, OldBets, Moves, B),
  rulesMove(B),
  gameTurn(NGame, [(P, B)|OldBets], Winner).

% Vrai s'il ne reste qu'un seul joueur dans le jeu.
gameIsOver(Game) :-
  length(Game, 1).

gameNbrDice(Game, Nbr) :-
  maplist(playerDices, Game, D),
  flatten(D, R),
  length(R, Nbr).

% vim: ft=prolog et sw=2 sts=2
