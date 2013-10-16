% Informations nécessaires pour le fonctionnement d'une IA :
%   - l'état "joueur" de l'IA (liste de dés)
%   - la mise précédente
%   - le nombre total de dés
%   - la liste des coups possibles
%
% Signature d'une IA :
%   ia<NomIA>(Dés, NbrTotalDeDés, rulesBet(Nb, Val), CoupsPossibles, CoupChoisi)
%
% Description des paramètres :
%   1) Liste des dés de l'IA
%   2) Nombre TOTAL de dés (joueur IA compris)
%   3) Mise précédente
%   4) Liste des coups possibles
%   5) Coup choisi par l'IA

:- [ia/ivre].
:- [ia/debile].
:- [ia/stats].
:- [ia/autiste].

iaNbrDice(Dices, V, N) :-
    include(==(V), Dices, L),
    length(L, N).

% Fonction d'évaluation d'une mise par rapport au dé du joueur, du nombre total
% de dé, de la mise precedente.
iaEvalBet(Dices, NbrDice, _, Bet, Value) :-
    Bet = rulesBet(N, V),
    Bet,
    iaNbrDice(Dices, V, N1),
    iaNbrDice(Dices, 1, N2),
    ((V == 1) -> (NbrMe is N1, Div is 6) ; (NbrMe is N1 + N2, Div is 3)),
    length(Dices, N_),
    NbrOther is NbrDice - N_,
    write('Nombre eu = '), write(NbrMe), write('\n'),
    Lim is NbrOther / Div,
    write('Limite statistique = '), write(Lim), write('\n'),
    Value is Lim / (N - NbrMe).

<<<<<<< HEAD
% Informations nécessaires pour le fonctionnement d'une IA :
%   - l'état "joueur" de l'IA (liste de dés)
%   - la mise précédente
%   - le nombre total de dés
%   - la liste des coups possibles
%
% Signature d'une IA :
%   ia<NomIA>(Dés, NbrTotalDeDés, rulesBet(Nbr, Val), CoupsPossibles, CoupChoisi)
%
% Description des paramètres :
%   1) Liste des dés de l'IA
%   2) Nombre TOTAL de dés (joueur IA compris)
%   3) Mise précédente
%   4) Liste des coups possibles
%   5) Coup choisi par l'IA

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

% IA "autiste", choisissant au hasard parmis la liste des coups possibles.
iaAutiste(_, _, _, CoupsPossibles, Coup) :-
  length(CoupsPossibles, NbCoupsPossibles),
  random(1, NbCoupsPossibles, N),
  nth1(N, CoupsPossibles, Coup).

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
% décider du coup à jouer. À partir d'une rulesBet(Nbr, Val),
% l'ia va regarder deux nombres :
%   1) Le nombre de dés dans sa main correspondant à "Val", c'est à dire le
%      nombre de dés "Val" et le nombre de pacos, seulement si Val != paco.
%      On appelle ce nombre "NbMesDesCorrespondant".
%   2) Le nombre de dés qu'on les autres joueurs ; puis statistiquement,
%      le nombre de dés correspondant à "Val" dans ces dés.
%      On divise ce nombre par un coefficient "Stat".
%      Si Val == paco, Stat == 6, sinon Stat == 3.
%      On appelle ce nombre divisé "NbAutresDesCorrespondant".
% L'ia décide du coup à jouer à partir de la somme de ces deux nombres :
%   - Nbr < Somme => monter
%   - Nbr > Somme => dudo
%   - Nbr = Somme => calza
iaStats(Des, N, rulesBet(Nbr, Val), CoupsPossibles, Coup) :-
  length(Des, NombreMesDes),
  NombreAutresDes is N - NombreMesDes,
  desTries(Des, DesTries),
  write('DesTries = '), write(DesTries), write('\n'),
  meilleurCoups(DesTries, MeilleurCoups),
  write('MeilleurCoups = '), write(MeilleurCoups), write('\n').

% Ceci est un commentaire
iaDebile(_, _, _, [_,_,X|_], X).
iaDebile(_, _, _, [_,X], X).

iaJoue(Des, N, rulesBet(Nbr, Val), CoupsPossibles, Coup) :-
=======
iaJoue(Des, N, rulesBet(Nb, Val), CoupsPossibles, Coup) :-
>>>>>>> 5039b92c8a7f2caa236a333497b6918f44fbea7f
  write('Des = '), write(Des), write('\n'),
  write('Nombre de dés au total = '), write(N), write('\n'),
  write('Mise :'), write(Nb), write(' '), write(Val), write('\n'),
  write('Liste des coups possibles : '), write(CoupsPossibles), write('\n'),
  write('Que voulez vous jouer ? '), read(Indice), nth1(Indice, CoupsPossibles, Coup).

% vim: ft=prolog et sw=2 sts=2
