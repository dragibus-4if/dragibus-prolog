use_module(library(random)).
use_module(library(lists)).
use_module(library(apply)).

:- [ia].

% Un dé est représenté par une valeur aléatoire entre 1 et 6.
de(N) :- random(1, 7, N).

% Un tirage est une liste de taille définie composée de dé.
tirage(0, []).
tirage(N, [T|Q]) :-
  de(T),
  N1 is N - 1,
  tirage(N1, Q),
  !.

% TODO données du jeu
% joueur(L) :- tirage(5, L).
joueur(N, L).
table(joueur(5, [1, 2, 3, 4, 0]), joueur(5, [0, 0, 0, 0, 0])).
%etat_jeu(, la_mise, ).

% TODO Initialisation du jeu.
% Doit créer dynamique des règles et des prédicats définissant l'état du jeu.
% init(mise(0, 0), joueur(N1, L1), joueur(N2, L2)) :-
%   tirage(N1, L1),
%   tirage(N2, L2).

% Indique le numéro du joueur qui a fini la partie
partie_finie(1) :- table(joueur(0, _), _), !.
partie_finie(2) :- table(_, joueur(0, _)), !.

% pas() :- perdu, .
% pas() :- ..., pas.
%
% jeu() :- init, pas

% Définition d'un mise et règle de validation.
% Une mise est un nombre N de dé d'un valeur V.
% Le nombre doit etre dans [1, NBR_DE]
% La valeur doit etre dans [1, 6]
mise(N, V) :-
  between(1, 10, N),
  between(1, 6, V).

% Définition d'un coup :
% Un coup est soit une mise, soit un dudo, soit un calza.
coup(mise(_, _)).
coup(dudo).
coup(calza).

% Un coup initial ne peut pas etre un paco.
% C'est donc une mise dont la valeur V est supérieur à 2
coupInit(mise(N, V)) :- mise(N, V), between(2, 6, V).

% Définie les coups possibles après une mise.
% Un dudo et un calza peuvent etre joués n'importe quand.
% On peut augmenter le nombre de dé misé en gardant la meme valeur de dé.
% En gardant le nombre de dé, on peut également augmenter la valeur.
% TODO règle des paco.
coupPossible(mise(_, _), dudo).
coupPossible(mise(_, _), calza).
coupPossible(mise(N1, V), mise(N2, V)) :-
  N is N1 + 1,
  between(N, 10, N2).
coupPossible(mise(N, V1), mise(N, V2)) :-
  V is V1 + 1,
  between(V, 6, V2).

% Génération des listes de coups initiaux et possible depuis une mise
lsCoupInit(L) :- setof(X, coupInit(X), L).
lsCoupPossible(M, L) :- setof(X, coupPossible(M, X), L).

% Mécanisme pour jouer un tour
jouer(Mout) :-
  lsCoupInit(L),
  iajoue(L, Index),
  nth1(Index, L, Mout).
jouer(Min, Mout) :-
  lsCoupPossible(Min, L),
  iajoue(L, Index),
  nth1(Index, L, Mout).

% Calcul le nombre de dé de valeur V sur la table
pred(V, 1).
pred(V, V).
nbrde(V, N) :-
  table(joueur(_, L1), joueur(_, L2)),
  append([L1, L2], L),
  include(pred(V), L, LF),
  length(LF, N).

% Vrai si il y a moins de dé
dudo(mise(N, V)) :-
  nbrde(V, N1),
  N1 < N.

% Vrai si le calza est bon
calza(mise(N, V)) :-
  nbrde(V, N1),
  N1 == N.

misajour(dudo).
misajour(calza).
misajour(M).

% vim: ft=prolog et sw=2 sts=2
