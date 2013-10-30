:- use_module(library(lists)).

% Répéte un prédicat jusqu'à ce qu'il soit vrai
repeter.
repeter(P) :- P ; repeter(P).

% compter le nombre d'occurences d'un élément dans une liste
compter([], _, 0).
compter([X|T], X, Y):- compter(T, X, Z), Y is 1 + Z.
compter([X1|T], X, Z):- X1 \= X, compter(T, X, Z).

% Calcul du coefficient binomial C(n, p)
coefBinomial(_, 0, 1).
coefBinomial(N, N, 1).
coefBinomial(N, P, B) :-
  N1 is N-1,
  P1 is P-1,
  coefBinomial(N1, P1, B1),
  coefBinomial(N1, P, B2),
  B is B1 + B2.

% Répartition binomiale
repartitionBinomiale(N, Q, P, Stat) :-
  coefBinomial(N, Q, C),
  Stat is C * (P)**Q * (1-P)**(N-Q), !.

% Calcul de la probabilité d'un coup, en considérant ses dés
statCoup(Des, NbTotal, rulesBet(Nb, De), Stat) :-
  % calculer le nombre de dés "manquants"
  compter(Des, De, NbMesDesCorrespondant),
  NbDesManquants is max(0, Nb - NbMesDesCorrespondant),
  length(Des, NbMesDes),
  NbAutresDes is NbTotal - NbMesDes,

  % il peut manquer des dés ou non
  (NbDesManquants == 0
  ->
    Stat = 1
  ;
    % coefficient de division (6 si paco, 3 sinon)
    (De == 1 -> Div = 6 ; Div = 3),

    % calcul de la stat à partir des stats individuelles
    N = NbAutresDes,
    Q = NbDesManquants,
    P is 1/Div,
    findall(S, (between(Q, N, X), repartitionBinomiale(N, X, P, S)), ListStats),
    sumlist(ListStats, Stat)
  ), !.

% Calcul de la probabilité sur une enchêre: changement de dé
statEnchere(Des, N, rulesBet(Nb, _), rulesBet(Nb, DeChoisi), Stat) :-
  statCoup(Des, N, rulesBet(Nb, DeChoisi), Stat).

% Calcul de la probabilité sur une enchêre: augmentation du nombre
statEnchere(Des, N, rulesBet(_, De), rulesBet(NbChoisi, De), Stat) :-
  statCoup(Des, N, rulesBet(NbChoisi, De), Stat).
% TODO prendre en compte la mise précédente

% Calcul de la probabilité sur une enchêre: passage aux pacos
statEnchere(Des, N, rulesBet(_, De), rulesBet(NbChoisi, 1), Stat) :-
  De \= 1,
  statCoup(Des, N, rulesBet(NbChoisi, De), Stat).

% Calcul de la probabilité sur une enchêre: dudo
statEnchere(Des, N, rulesBet(Nb, De), dudo, Stat) :-
  statCoup(Des, N, rulesBet(Nb, De), Stat1),
  Stat is 1 - Stat1.

% Calcul de la probabilité sur une enchêre: calza
statEnchere(Des, NbTotal, rulesBet(Nb, De), calza, Stat) :-
  compter(Des, De, NbMesDesCorrespondant),
  NbDesManquants is max(0, Nb - NbMesDesCorrespondant),
  length(Des, NbMesDes),
  NbAutresDes is NbTotal - NbMesDes,

  (NbDesManquants > NbAutresDes -> Stat = 0 ;
  % Application de la formule:
  %   * nT: nombre de dés totaux (autres dés) -> NbAutresDes
  %   * nD: nombre de dés manquants -> NbDesManquants
  % => p(calza) = (nD parmi nT) / 6**nD
  NT = NbAutresDes,
  ND = NbDesManquants,
  coefBinomial(NT, ND, Coef),
  Stat is Coef / 6**ND).

% vim: ft=prolog et sw=2 sts=2
