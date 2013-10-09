use_module(library(random)).
use_module(library(lists)).

:- [ia].

de(N) :- random(1, 7, N).

tirage(0, []).
tirage(N, [T|Q]) :- de(T), N1 is N - 1, tirage(N1, Q), !.

% joueur(L) :- tirage(5, L).
joueur(N, L).
mise(Nbr, Val).
table(joueur(5, _), joueur(5, _)).

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

% lsCoupPossible(mise(Nbr, Val)) :- setof(X, coupPossible(mise(Nbr, Val, X), ).

% vim: ft=prolog et sw=2 sts=2
