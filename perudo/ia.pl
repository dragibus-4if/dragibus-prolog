:- module(ia, [iaJoue/5, iaIvre/5, iaDebile/5, iaStats/5, iaAutiste/5]).

use_module(library(lists)).

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
  compare(Delta, A, B).

% liste de dés -> set de paires [dé, nb]
% TODO vérifier que doublons gardés
desTries(Des, DesTries) :-
  bagof([X, C], compteTous(Des, X, C), DesNonTries),
  predsort(compareSecond, DesNonTries, DesTries).

% TODO faire ça mieux
meilleurCoups(DesTries, [MeilleurCoup]) :-
  last(DesTries, MeilleurCoup).

% IA "ivre", choisissant au hasard parmis la liste des coups possibles.
iaIvre(_, _, _, CoupsPossibles, Coup) :-
  length(CoupsPossibles, NbCoupsPossibles),
  random(1, NbCoupsPossibles, N),
  nth1(N, CoupsPossibles, Coup).

% Utile pour les paires [X, Y]
first([X, _], X).
second([_, Y], Y).

% récupère le premier indice d'apparition d'un élément dans une liste
indiceElement([Element|_], Element, 0).
indiceElement([_|Q], Element, Indice) :-
  indiceElement(Q, Element, Indice1),
  Indice is Indice1 + 1.

% permet d'unzipper une liste de paires en liste de second
unzip2Second([], []).
unzip2Second([T|Q], [R|L]) :-
  second(T, R),
  unzip2Second(Q, L).

% Intersection entre nos dés et les dés possibles à jouer
%   - CoupsPossibles est sous la forme [[Nb, Dé], ...]
choixDesPossibles(Des, CoupsPossibles, MesDesPossibles) :-
  unzip2Second(CoupsPossibles, DesPossibles),
  intersection(Des, DesPossibles, MesDesPossibles).

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
% décider du coup à jouer.
iaStats(Des, N, rulesBet(Nb, De), TousCoupsPossibles, Coup) :-
  % nombre de dés à moi
  length(Des, NbMesDes), NbAutresDes is N - NbMesDes,

  % comptage du nombre de dés dans la main correspondant à Val
  compter(Des, De, NbMesDesCorrespondant),

  % estimation du nombre d'autre dés correspondant à Val
  (De = 1 -> Stat is 6 ; Stat is 3),
  NbAutresDesCorrespondant is NbAutresDes / Stat,

  % choix en fonction de la proba
  Somme is NbMesDesCorrespondant + NbAutresDesCorrespondant,
  (Nb < Somme
    -> NbDesChoisis is Nb + 1, CoupChoisi = [NbDesChoisis, De]
    ; (Nb > Somme
        -> CoupChoisi = dudo
        ; CoupChoisi = calza
      )
  ),

  % TODO vérifier si le coup choisi est dans la liste des coups possibles

  % renvoi de l'indice du coup
  indiceElement(TousCoupsPossibles, CoupChoisi, Coup).

% IA "autiste", juge quel est le meilleur coup à jouer en se basant sur seulement
% sur ses propre dés.
iaAutiste(Des, N, rulesBet(Nb, De), TousCoupsPossibles, Coup) :-
  % nombre de dés à moi
  length(Des, NbMesDes), NbAutresDes is N - NbMesDes,

  % récupération des coups numériques sans dudo/calza
  TousCoupsPossibles = [_, _|CoupsPossibles],

  % choix des dés possibles à jouer parmi nos dés
  choixDesPossibles(Des, CoupsPossibles, DesPossibles),

  % tri des dés possibles sous la forme [[D1, Nb1], [D2, Nb2], ...]
  desTries(DesPossibles, DesTries),

  % choix des meilleurs coups équiprobables
  meilleurCoups(DesTries, MeilleurCoups),
  intersection(MeilleurCoups, CoupsPossibles, MeilleurCoupsPossibles),

  % tuple (dés, nb) à choisir, correspondant au coup le
  % plus avantageux pour l'IA
  length(MeilleurCoupsPossibles, NbMeilleurCoupsPossibles),
  random(1, NbMeilleurCoupsPossibles, ChoixMeilleurCoup),
  nth1(ChoixMeilleurCoup, MeilleurCoupsPossibles, CoupChoisi).

% Ceci est un commentaire
iaDebile(_, _, _, [_,_,X|_], X).
iaDebile(_, _, _, [_,X], X).

iaJoue(Des, N, rulesBet(Nb, Val), CoupsPossibles, Coup) :-
  write('Des = '), write(Des), write('\n'),
  write('Nombre de dés au total = '), write(N), write('\n'),
  write('Mise :'), write(Nb), write(' '), write(Val), write('\n'),
  write('Liste des coups possibles : '), write(CoupsPossibles), write('\n'),
  write('Que voulez vous jouer ? '), read(Indice), nth1(Indice, CoupsPossibles, Coup).

% vim: ft=prolog et sw=2 sts=2
