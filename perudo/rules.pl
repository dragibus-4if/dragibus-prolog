use_module(library(lists)).
use_module(library(apply)).

:- [ia].
:- [player].

rulesBet(Nbr, Value) :-
  between(1, 6, Value),
  between(1, 30, Nbr).

rulesBet(Nbr, Value, NbrDice) :-
  between(1, 6, Value),
  between(1, NbrDice, Nbr).

rulesMove(dudo).
rulesMove(calza).
rulesMove(Bet) :-
  Bet = rulesBet(_, _),
  Bet.

rulesNbrDice_(Players, Value, Nbr) :-
  maplist(playerDices, Players, D),
  flatten(D, Dices),
  include(==(Value), Dices, R),
  length(R, Nbr).

rulesNbrDice(Players, 1, Nbr) :-
  rulesNbrDice_(Players, 1, Nbr), !.

rulesNbrDice(Players, Val, Nbr) :-
  rulesNbrDice_(Players, 1, N1),
  rulesNbrDice_(Players, Val, N2),
  Nbr is N1 + N2.

rulesNbrDicePalifico(Players, Val, Nbr) :-
  rulesNbrDice_(Players, Val, Nbr).

rulesPossibleMove(NbrDice, rulesBet(N, V)) :-
    between(2, 6, V),
    rulesBet(N, V, NbrDice).

rulesPossibleMove(rulesBet(_, _), _, dudo).
rulesPossibleMove(rulesBet(_, _), _, calza).

rulesPossibleMove(rulesBet(N, V1), NbrDice, rulesBet(N, V2)) :-
    V is V1 + 1,
    between(V, 6, V2),
    rulesBet(N, V2, NbrDice).

rulesPossibleMove(rulesBet(N1, V), NbrDice, rulesBet(N2, V)) :-
    N is N1 + 1,
    between(N, 30, N2),
    rulesBet(N2, V, NbrDice).

rulesPossibleMoves(Bet, NbrDice, Moves) :-
    setof(X, rulesPossibleMove(Bet, NbrDice, X), Moves).

rulesPossibleMoves(Moves, NbrDice) :-
    setof(X, rulesPossibleMove(NbrDice, X), Moves).

% Vrai si les deux listes sont les memes à l'exception que la tete de Game
% est le dernier élément de NGame.
% Représente la circulation du joueur en état de parler dans le jeu.
rulesNextPlayer(Players, NPlayers) :-
  nth1(1, Players, P),
  append([P], L, Players),
  append(L, [P], NPlayers).

rulesPreviousPlayer(Players, NPlayers) :-
  last(Players, P),
  append(L, [P], Players),
  append([P], L, NPlayers).

rulesCalza(rulesBet(N, V), Players) :-
    rulesNbrDice(Players, V, N1),
    N1 == N.

rulesCalza(Bet, Players, NewPlayers) :-
    rulesCalza(Bet, Players),
    rulesFirstWin(Players, NewPlayers).

rulesCalza(Bet, Players, NewPlayers) :-
    \+ rulesCalza(Bet, Players),
    rulesFirstLose(Players, NewPlayers).

rulesDudo(rulesBet(N, V), Players) :-
    rulesNbrDice(Players, V, N1),
    N1 >= N.

rulesDudo(Bet, Players, NewPlayers) :-
    rulesDudo(Bet, Players),
    rulesFirstLose(Players, NewPlayers).

rulesDudo(Bet, Players, NewPlayers) :-
    \+ rulesDudo(Bet, Players),
    rulesLastLose(Players, NPlayers),
    rulesPreviousPlayer(NPlayers, NewPlayers).

rulesFirstLose(Players, NewPlayers) :-
    append([P], L, Players),
    playerRemoveDice(P, NP),
    append([NP], L, NewPlayers).

rulesLastLose(Players, NewPlayers) :-
    append(L, [P], Players),
    playerRemoveDice(P, NP),
    append(L, [NP], NewPlayers).

rulesFirstWin(Players, NewPlayers) :-
    append([P], L, Players),
    playerAddDice(P, NP),
    append([NP], L, NewPlayers).

%% Un tirage est une liste de taille définie composée de dé.
%tirage(0, []) :- !.
%tirage(N, [T|Q]) :-
%  random(1, 7, T),
%  N1 is N - 1,
%  tirage(N1, Q).
%
%% Données du jeu
%%  - table -> liste des joueurs
%%  - état de jeu -> mise, table
%% joueur(L) :- tirage(5, L).
%% joueur(N, L).
%% table(joueur(5, [1, 2, 3, 4, 0]), joueur(5, [0, 0, 0, 0, 0])).
%%etat_jeu(, la_mise, ).
%
%% Initialisation du jeu.
%% Doit créer dynamique des règles et des prédicats définissant l'état du jeu.
%% init(mise(0, 0), joueur(N1, L1), joueur(N2, L2)) :-
%%   tirage(N1, L1),
%%   tirage(N2, L2).
%
%
%currentPlayer(P) :-
%  stateGame(L),
%  nth1(1, L, P).
%
%playerPlay(_, LsCoup, Coup) :-
%  iajoue(LsCoup, N),
%  nth1(N, LsCoup, Bet),
%  Coup = coup(Bet).
%
%game :-
%  L = ['John', 'Roger', 'Marc'],
%  initialiseGame(L),
%  playTurn(init).
%
%% playTurn(_) :- endOfGame, !.
%playTurn(init) :-
%  initialiseTurn,
%  currentPlayer(P),
%  lsCoupInit(L),
%  playerPlay(P, L, Coup),
%  %nextPlayer,
%  Coup = coup(B),
%  write('Bet = '), write(B), write('\n'),
%  playTurn(B).
%
%playTurn(Bet) :-
%  write('Tour suivant\n'),
%  currentPlayer(P),
%  lsCoupPossible(Bet, L),
%  playerPlay(P, L, Coup),
%  %traiter le coup
%  %nextPlayer,
%  Coup = coup(B),
%  write('Bet = '), write(B), write('\n'),
%  playTurn(B).
%
%% pas() :- perdu, .
%% pas() :- ..., pas.
%%
%% jeu() :- init, pas
%
%% Définition d'un mise et règle de validation.
%%  - une mise est un nombre N de dés d'un valeur V.
%%  - le nombre doit être dans [1, NBR_DE]
%%  - la valeur doit être dans [1, 6]
%mise(N, V) :-
%  between(1, 10, N),
%  between(1, 6, V).
%
%% Définition d'un coup :
%% Un coup est soit une mise, soit un dudo, soit un calza.
%coup(mise(_, _)).
%coup(dudo).
%coup(calza).
%
%% Un coup initial ne peut pas etre un paco.
%% C'est donc une mise dont la valeur V est supérieur à 2
%coupInit(mise(N, V)) :- mise(N, V), between(2, 6, V).
%
%% Définie les coups possibles après une mise.
%% Un dudo et un calza peuvent etre joués n'importe quand.
%% On peut augmenter le nombre de dé misé en gardant la meme valeur de dé.
%% En gardant le nombre de dé, on peut également augmenter la valeur.
%% TODO règle des paco.
%coupPossible(mise(_, _), dudo).
%coupPossible(mise(_, _), calza).
%coupPossible(mise(N1, V), mise(N2, V)) :-
%  N is N1 + 1,
%  between(N, 10, N2). % TODO modifier 10 -> nombre de dés
%coupPossible(mise(N, V1), mise(N, V2)) :-
%  V is V1 + 1,
%  between(V, 6, V2).
%
%% Génération des listes de coups initiaux et possible depuis une mise
%lsCoupInit(L) :- setof(X, coupInit(X), L).
%lsCoupPossible(M, L) :- setof(X, coupPossible(M, X), L).
%
%% Mécanisme pour jouer un tour
%jouer(Mout) :-
%  lsCoupInit(L),
%  iajoue(L, Index),
%  nth1(Index, L, Mout).
%jouer(Min, Mout) :-
%  lsCoupPossible(Min, L),
%  iajoue(L, Index),
%  nth1(Index, L, Mout).
%
%% Calcul le nombre de dé de valeur V sur la table
%pred(_, 1).
%pred(V, V).
%nbrde(V, N) :-
%  table(joueur(_, L1), joueur(_, L2)),
%  append([L1, L2], L),
%  include(pred(V), L, LF),
%  length(LF, N).
%
%% Vrai si il y a moins de dé
%dudo(mise(N, V)) :-
%  nbrde(V, N1),
%  N1 < N.
%
%% Vrai si le calza est bon
%calza(mise(N, V)) :-
%  nbrde(V, N1),
%  N1 == N.
%
%% misajour(dudo).
%% misajour(calza).
%% misajour(_).
%
%% vim: ft=prolog et sw=2 sts=2
