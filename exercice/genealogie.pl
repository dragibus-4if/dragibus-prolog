% parent(X, Y) vrai si X est le parent de Y
parent(john, martha).
parent(john, marc).
parent(rodrigo, john).
parent(jean, leo).
parent(louis, jean).
parent(louis, george).
parent(rodrigo, louis).
parent(ivonne, rodrigo).

% Vrai siX est le grand parent de Y
grandParent(X, Y) :-
  parent(X, Z),
  parent(Z, Y).

% Vrai si X est un ancetre de Y
ancetre(X, Y) :-
  parent(X, Y).

ancetre(X, Y) :-
  parent(X, Z),
  ancetre(Z, Y).

% Vrai si L est l'ensemble des ancetres de X
ancetres(X, L) :-
  setof(A, ancetre(A, X), L).

descendant(X, L) :-
  setof(A, ancetre(X, A), L).

% Vrai si X et Y ont le meme parent
frereSoeur(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

% Vrai si X est l'oncle (ou la tante) de Y
oncleTante(X, Y) :-
  frereSoeur(X, Z),
  parent(Z, Y).

% Vrai si X et Y sont cousin (cad que leur parent sont freres).
cousin(X, Y) :-
  parent(A, X),
  parent(B, Y),
  frereSoeur(A, B).

% vim: ft=prolog et sw=2 sts=2
