% The Lannister family
parent(tywin, tyrion).
parent(tywin, cersei).
parent(tywin, kingslayer).
parent(cersei, joeffrey).
parent(cersei, mircella).
parent(kingslayer, joeffrey).

ancestor(X, Y) :-
  parent(X, Y);
  (
    parent(X, Z),
    ancestor(Z, Y)
  ).

sibling(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

uncle(X, Y) :-
  parent(Y, A),
  sibling(A, X).

cousin(X, Y) :-
  parent(X, A),
  parent(Y, B),
  sibling(A, B).

% vim: ft=prolog et sw=2 sts=2
