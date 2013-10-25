% On crééra une base de connaissances en spécifiant les relations "parent"
% directes. parent(X, Y) étant vrai si X est le parent de Y.

% Définition du lien grand-parent par une propagation de la relation parent sur 2
% niveaux.
% grandParent(X, Y) est vrai si X est le grand parent de Y.
grandParent(X, Y) :-
  parent(X, Z),
  parent(Z, Y).

% Définition du lien ancêtre par une propagation récursive sur plusieurs
% niveaux, jusqu'à satisfaction.
% ancetre(X, Y) est vrai si X est un ancetre de Y.
ancetre(X, Y) :-
  parent(X, Y).
ancetre(X, Y) :-
  parent(X, Z),
  ancetre(Z, Y).

% Définition de la liste des ancêtres à partir d'un élément de la famille.
% On utilise setof car cette partie n'est pas sur les listes, et son
% utilisation est pratique pour éliminer les doublons dans les candidats à la
% relation ancêtre.
% ancetres(X, L) est vrai si L est l'ensemble des ancetres de X
ancetres(X, L) :-
  setof(A, ancetre(A, X), L).

% Semblable à la relation ancetres, donne la liste des descendants d'un élément
% de la famille.
% descendants(X, L) est vrai si L est l'ensemble des descendants de X.
descendants(X, L) :-
  setof(A, ancetre(X, A), L).

% Pour ces deux dernières, X ne peut pas être déterminée à partir de L, et donc
% ne peut pas être une variable.
ancetres(X, _) :- var(X), fail.
descendants(X, _) :- var(X), fail.

% Définition de la relation frère-sœur complète en partant du constat que
% celle-ci correspond au partage des parents.
% Cette relation n'est pas réflexive, une personne ne pouvant pas être son
% propre frère-sœur.
% frereSoeur(X, Y) est vrai si X et Y ont le meme parent (donc sont frère-sœur).
frereSoeur(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

% Définition de la relation oncle-tante par une relation frère-sœur pour un
% parent.
% oncleTante(X, Y) est vrai si X est l'oncle (ou la tante) de Y.
oncleTante(X, Y) :-
  frereSoeur(X, Z),
  parent(Z, Y).

% Définition de la relation cousin par une relation frère-sœur entre deux parents.
% cousin(X, Y) est vrai si X et Y sont cousin (càd que leur parent sont freres).
cousin(X, Y) :-
  parent(A, X),
  parent(B, Y),
  frereSoeur(A, B).
