% On creera une base de connaissances en specifiant les relations "parent"
% directes. parent(X, Y) etant vrai si X est le parent de Y.

% Definition du lien grand-parent par une propagation de la relation parent sur 2
% niveaux.
% grandParent(X, Y) est vrai si X est le grand parent de Y.
grandParent(X, Y) :-
  parent(X, Z),
  parent(Z, Y).

% Definition du lien ancetre par une propagation recursive sur plusieurs
% niveaux, jusqu'a satisfaction.
% ancetre(X, Y) est vrai si X est un ancetre de Y.
ancetre(X, Y) :-
  parent(X, Y).
ancetre(X, Y) :-
  parent(X, Z),
  ancetre(Z, Y).

% Definition de la liste des ancetres a partir d'un element de la famille.
% On utilise setof car cette partie n'est pas sur les listes, et son
% utilisation est pratique pour eliminer les doublons dans les candidats a la
% relation ancetre.
% ancetres(X, L) est vrai si L est l'ensemble des ancetres de X
ancetres(X, L) :-
  setof(A, ancetre(A, X), L).

% Semblable a la relation ancetres, donne la liste des descendants d'un element
% de la famille.
% descendants(X, L) est vrai si L est l'ensemble des descendants de X.
descendants(X, L) :-
  setof(A, ancetre(X, A), L).

% Pour ces deux dernieres, X ne peut pas etre determinee a partir de L, et donc
% ne peut pas etre une variable.
ancetres(X, _) :- var(X), fail.
descendants(X, _) :- var(X), fail.

% Definition de la relation frere-soeur complete en partant du constat que
% celle-ci correspond au partage des parents.
% Cette relation n'est pas reflexive, une personne ne pouvant pas etre son
% propre frere-soeur.
% frereSoeur(X, Y) est vrai si X et Y ont le meme parent (donc sont frere-soeur).
frereSoeur(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

% Definition de la relation oncle-tante par une relation frere-soeur pour un
% parent.
% oncleTante(X, Y) est vrai si X est l'oncle (ou la tante) de Y.
oncleTante(X, Y) :-
  frereSoeur(X, Z),
  parent(Z, Y).

% Definition de la relation cousin par une relation frere-soeur entre deux parents.
% cousin(X, Y) est vrai si X et Y sont cousin (cad que leur parent sont freres).
cousin(X, Y) :-
  parent(A, X),
  parent(B, Y),
  frereSoeur(A, B).
