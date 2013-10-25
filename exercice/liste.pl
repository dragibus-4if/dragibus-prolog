% element(X, L, L\X) est vrai si L/X est une liste compose des
% elements de L. L'ordre doit etre preserve.  prive une fois de X.
% Si X n'est pas dans L, alors le predicat est faux.
% Les trois parametres peuvent etre des variables.
element(X, [X|Xs], Xs).
element(X, [T|As], [T|Bs]) :-
  element(X, As, Bs),
  X \== T.

% extract(L1, L2) est vrai si L2 est un sous ensemble de L1.
% Les deux parametres peuvent etre des variables
extract(_, []).
extract(L, [X|Xs]) :-
  element(X, L, L2),
  extract(L2, Xs).

% concat(L1, L2, L1nL2) est vrai si L1nL2 est la concatenation de L1 et L2.
concat([], L2, L2).
concat([X|Xs], L2, [X|L]) :-
  concat(Xs, L2, L).

% inv(L1, L2) est vrai si L1 est l'inverse de L2
% On remarque que si L1 n'est pas une variable et que L2 en est une, le
% predicat ne se termine pas.
inv([], []).
inv([X|Xs], L) :-
  inv(Xs, L2),
  concat(L2, [X], L).

% subsall(E, X, L1, L2) est vrai si L2 est la liste L1 avec les elements E
% remplaces par des X.
% Dans le cas ou E est une variable, il prend la premiere valeur de L1
subsAll(_, _, [], []).
subsAll(E, X, [T|Q], L) :-
  T \= E,
  subsAll(E, X, Q, Ls),
  concat([T], Ls, L).
subsAll(E, X, [E|Q], L) :-
  subsAll(E, X, Q, Ls),
  concat([X], Ls, L).
