:- module(ia, [iaJoue/5, iaAutiste/5, iaStats/5]).

% Informations nécessaires pour le fonctionnement d'une IA :
%   - l'état "joueur" de l'IA (liste de dés)
%   - la mise précédente
%   - le nombre total de dés
%
% Et optionnellement (ie: ça pourrait être utile) :
%   - la liste des coups possibles
%
% Signature d'une IA :
%   ia<NomIA>(Dés, NbrTotalDeDés, mise(Nbr, Val), CoupsPossibles, CoupChoisi)

% naive sort
%isSorted([], _).
%isSorted([_], _).
%isSorted([X, Y|T], Pred) :- call(Pred, X, Y), isSorted([Y|T], Pred).
%naiveSort(List, Sorted):- naiveSort(List, Sorted, =<).
%naiveSort(List, Sorted, Pred):- perm(List, Sorted), isSorted(Sorted, Pred).

% compter le nombre d'occurences d'un élément dans une liste
compter([], _, 0).
compter([X|T], X, Y):- compter(T, X, Z), Y is 1 + Z.
compter([X1|T], X, Z):- X1 \= X, compter(T, X, Z).
% compter le nombre d'occurences pour tous
compteTous(Liste, X, C) :-
    sort(Liste, L), member(X, L),
    compter(Liste, X, C).

% tri d'une liste de tuples selon le deuxième élément
compareSecond(Delta, [_, A], [_, B]):-
  %write('U = '), write(U), write('\n'),
  %write('V = '), write(V), write('\n'),
  %write('A = '), write(A), write('\n'),
  %write('B = '), write(B), write('\n'),
  compare(Delta, A, B).

% liste de dés -> set de dés
desTries(Des, DesTries) :-
  bagof([X, C], compteTous(Des, X, C), DesNonTries),
  predsort(compareSecond, DesNonTries, DesTries).
  %naiveSort(DesNonTries, DesTries, compareSecond).

% TODO faire ça mieux
meilleurCoups(DesTries, [MeilleurCoup]) :-
  last(DesTries, MeilleurCoup).

% IA "autiste", choisissant au hasard parmis la liste des coups possibles :
%   1) Liste des dés de l'IA
%   2) Nombre TOTAL de dés (joueur IA compris)
%   3) Mise précédente
%   4) Liste des coups possibles
%   5) Coup choisi par l'IA
iaAutiste(_, _, _, CoupsPossibles, Coup) :-
  length(CoupsPossibles, NbCoupsPossibles),
  random(1, NbCoupsPossibles, N),
  nth1(N, CoupsPossibles, Coup).

iaStats(Des, N, mise(Nbr, Val), CoupsPossibles, Coup) :-
  length(Des, NombreMesDes),
  NombreAutresDes is N - NombreMesDes,
  desTries(Des, DesTries),
  write('DesTries = '), write(DesTries), write('\n'),
  meilleurCoups(DesTries, MeilleurCoups),
  write('MeilleurCoups = '), write(MeilleurCoups), write('\n').

%iaJoue(L, X) :-
iaJoue(Des, N, mise(Nbr, Val), CoupsPossibles, Coup) :-
  write('Des = '), write(Des), write('\n'),
  write('Nombre de dés au total = '), write(N), write('\n'),
  write('Mise :'), write(Nbr), write(' '), write(Val), write('\n'),
  write('Liste des coups possibles : '), write(CoupsPossibles), write('\n'),
  write('Que voulez vous jouer ? '), read(Indice), nth1(Indice, CoupsPossibles, Coup).

% vim: ft=prolog et sw=2 sts=2
