:- use_module(library(lists)).

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
  between(2, 30, N),
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

% vim: ft=prolog et sw=2 sts=2
