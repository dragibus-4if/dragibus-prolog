iaJoue(L, X) :-
  write('Liste des coups possibles : '),
  write(L),
  write('\n'),
  write('Que voulez vous jouer : '),
  read(N),
  nth1(N, L, X).

% compter le nombre d'occurences d'un élément dans une liste
compter([], _, 0).
compter([X|T], X, Y):- compter(T, X, Z), Y is 1 + Z.
compter([X1|T], X, Z):- X1 \= X, compter(T, X, Z).
% compter le nombre d'occurences pour tous
compteTous(List, X, C) :-
    sort(List, L), member(X, L),
    compter(List, X, C).

desVersTirage(Des, Tirage) :-
  bagof([X, C], compteTous(Des, X, C), Tirage).

%iaAutiste(joueur(N, Des), mise(Nbr, Val), Coup) :- % N est le nombre TOTAL de dés (joueur IA compris)
%  length(Des, NombreMesDes),
%  NombreAutresDes is N - NombreMesDes.

second([_, Y], Y).

% vim: ft=prolog et sw=2 sts=2
