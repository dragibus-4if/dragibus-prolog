use_module(library(random)).
use_module(library(lists)).
use_module(library(apply)).

:- [ia].

de(N) :- random(1, 7, N).

tirage(0, []).
tirage(N, [T|Q]) :- de(T), N1 is N - 1, tirage(N1, Q), !.

% joueur(L) :- tirage(5, L).
joueur(N, L).
mise(Nbr, Val).
table(joueur(5, [1, 2, 3, 4, 0]), joueur(5, [0, 0, 0, 0, 0])).
%etat_jeu(, la_mise, ).

init(mise(0, 0), joueur(N1, L1), joueur(N2, L2)) :- tirage(N1, L1), tirage(N2, L2).

partie_finie(1) :- table(joueur(0, _), _), !.
partie_finie(2) :- table(_, joueur(0, _)), !.

% pas() :- perdu, .
% pas() :- ..., pas.
% 
% jeu() :- init, pas

coup(mise(_, _)).
coup(dudo).
coup(calza).

coupInit(mise(N, V)) :- between(2, 6, V), between(1, 10, N).
coupPossible(mise(_, _), dudo).
coupPossible(mise(_, _), calza).
coupPossible(mise(Nbr, Val), mise(N,Val)) :- N1 is Nbr + 1, Val > 0, N1 > 0, between(N1, 10, N).
coupPossible(mise(Nbr, Val), mise(Nbr, V)) :- V1 is Val + 1, Nbr > 0, V1 > 0, between(V1, 6, V).

lsCoupInit(L) :- setof(X, coupInit(X), L).
lsCoupPossible(M, L) :- setof(X, coupPossible(M, X), L).

jouer(Mout) :- lsCoupInit(L), iajoue(L, Index), nth1(Index, L, Mout).
jouer(Min, Mout) :- lsCoupPossible(Min, L), iajoue(L, Index), nth1(Index, L, Mout).

pred(V, 1).
pred(V, V).
nbrde(V, N) :- table(joueur(_, L1), joueur(_, L2)), append([L1, L2], L), include(pred(V), L, LF), length(LF, N).

dudo(mise(N, V)) :- nbrde(V, N1), N1 < N.
calza(mise(N, V)) :- nbrde(V, N1), N1 == N.

misajour(dudo).
misajour(calza).
misajour(M).

% lsCoupPossible(mise(Nbr, Val)) :- setof(X, coupPossible(mise(Nbr, Val, X), ).
