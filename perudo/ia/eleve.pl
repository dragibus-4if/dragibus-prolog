dist(dudo, Player, NbrPlayer, Dist) :-
  % TODO
  Dist = 1.

dist(calza, Player, NbrPlayer, Dist) :-
  % TODO
  Dist = 1.

dist(rulesBet(N, V), Player, NbrPlayer, Dist) :-
  rulesNbrDice([Player], V, NbrDice),
  N2 is N / NbrPlayer,
  Dist is N2 - NbrDice.

dConfiance(Param, D, Res) :-
  Res is Param * D / 10.0.

:- dynamic confiance/3.

majConfiance(Player, OtherPlayer, Bet, NbPlayer, Param) :-
  playerId(Player, IdP),
  playerId(OtherPlayer, IdOP),
  ((\+ confiance(IdP, IdOP, _)) -> assert(confiance(IdP, IdOP, 0.5)) ; true),
  confiance(IdP, IdOP, C),
  dist(Bet, OtherPlayer, NbPlayer, D),
  Res_ is C - Param * D / 10.0,
  ((Res_ < 0) -> Res__ = 0 ; Res__ = Res_),
  ((Res__ > 1) -> Res = 1 ; Res = Res__),
  retractall(confiance(IdP, IdOP, _)),
  assert(confiance(IdP, IdOP, Res)).

majConfiance(Player, NbPlayer, Param, (OtherPlayer, Bet)) :-
  % Player \= OtherPlayer,
  majConfiance(Player, OtherPlayer, Bet, NbPlayer, Param).

majConfiances(PlayersNBets, NbrPlayer, Param, Player) :-
  maplist(majConfiance(Player, NbrPlayer, Param), PlayersNBets).

zip((A, B), A, B).
majConfiances(PlayersNBets, Param) :-
  maplist(zip, PlayersNBets, Players, _),
  list_to_set(Players, SetPlayers),
  length(SetPlayers, NbrPlayer),
  maplist(majConfiances(PlayersNBets, NbrPlayer, Param), SetPlayers).

nbrDeAttenduPar(Player, V, (OtherPlayer, rulesBet(N, V1)), Res) :-
  playerId(Player, IdP),
  playerId(OtherPlayer, IdOP),
  (confiance(IdP, IdOP, _) -> confiance(IdP, IdOP, C) ; C is 0),
  ((V = V1) -> Res is C * N ; Res is 0).

nbrDeAttendu(Player, V, PlayersNBets, Res) :-
  maplist(nbrDeAttenduPar(Player, V), PlayersNBets, L),
  max_list(L, Res).

eleveBet2Estimation(_, _, dudo, (dudo, 0)) :- !.
eleveBet2Estimation(_, _, calza, (calza, 0)) :- !.
eleveBet2Estimation(Player, PlayerNBets, rulesBet(N, V), Estimation) :-
  (nbrDeAttendu(Player, V, PlayerNBets, Res) -> true ; Res = 0),
  Est is 1.0 - (N - Res) / (30.0 - Res),
  Estimation = (rulesBet(N, V), Est).

iaEleve(Player, _, PlayersNBets, CoupsPossibles, Estimations) :-
  maplist(eleveBet2Estimation(Player, PlayersNBets), CoupsPossibles, Estimations).

% vim: ft=prolog et sw=2 sts=2
