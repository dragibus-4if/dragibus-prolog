:- [utils].

% permet d'unzipper une liste de paires en liste de second
unzip2Second([], []).
unzip2Second([T|Q], [R|L]) :-
  second(T, R),
  unzip2Second(Q, L).

% compter le nombre d'occurences pour tous
compteTous(Liste, X, C) :-
    sort(Liste, L), member(X, L),
    compter(Liste, X, C).

% tri d'une liste de tuples selon le deuxième élément
compareSecond(Delta,[_, A], [_, B]):-
  A == B; compare(Delta, A, B).

% liste de dés -> set de paires [dé, nb]
desTries(Des, DesTries) :-
  bagof([X, C], compteTous(Des, X, C), DesNonTries),
  predsort(compareSecond, DesNonTries, DesTries).

% TODO faire ça mieux
meilleurCoups(DesTries, [MeilleurCoup]) :-
  last(DesTries, MeilleurCoup).

% Intersection entre nos dés et les dés possibles à jouer
%   - CoupsPossibles est sous la forme [[Nb, Dé], ...]
choixDesPossibles(Des, CoupsPossibles, MesDesPossibles) :-
  unzip2Second(CoupsPossibles, DesPossibles),
  intersection(Des, DesPossibles, MesDesPossibles).

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

% vim: ft=prolog et sw=2 sts=2
