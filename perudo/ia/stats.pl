:- [utils].

% récupère le premier indice d'apparition d'un élément dans une liste
indiceElement([Element|_], Element, 0).
indiceElement([_|Q], Element, Indice) :-
  indiceElement(Q, Element, Indice1),
  Indice is Indice1 + 1.

% Calcul à partir de la forme binomiale
%     N : nombre autres dés
%     N : nombre de dés manquants
statCoup(Des, NbTotal, rulesBet(Nb, De), Stat) :-
  % calculer le nombre de dés "manquants"
  compter(Des, De, NbMesDesCorrespondant),
  NbDesManquants is max(0, Nb - NbMesDesCorrespondant),
  length(Des, NbMesDes), NbAutresDes is NbTotal - NbMesDes,

  % Debug
  %write('Il y a '), write(NbTotal), write(' dés au total\n'),
  %write('J\'ai '), write(NbMesDes), write(' dés\n'),
  %write('Il y a '), write(NbAutresDes), write(' autre dés\n'),
  %write('Il manque '), write(NbDesManquants), write(' '), write(De), write('\n'),
  %write('J\'ai '), write(NbMesDesCorrespondant), write(' '), write(De), write('\n'),

  % coefficient de division (6 si paco, 3 sinon)
  (De = 1 -> Div is 6 ; Div is 3),

  %% stat en fonction de la distance entre les deux nombres (minimisée à 0)
  %NbAutresDesCorrespondants is NbAutresDes / Div,
  %Distance is max(0, NbDesManquants - NbAutresDesCorrespondants),
  %Stat is exp(-Distance).

  % calcul du coefficient binomial
  N = NbAutresDes,
  Q = NbDesManquants,
  coefBinomial(N, Q, C),
  Stat is C * (1/Div)**Q * (1-1/Div)**(N-Q),
  !.

%statCoup(Des, N, rulesBet(Nb, De), calza, Stat)
%statCoup(Des, N, rulesBet(Nb, De), dudo, Stat)
%statCoup(Des, N, rulesBet(Nb, De), rulesBet(Nb1, De1), Stat)

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
% décider du coup à jouer.
iaStats(Des, N, rulesBet(Nb, De), TousCoupsPossibles, Coup) :-
  % nombre de dés à moi
  length(Des, NbMesDes), NbAutresDes is N - NbMesDes,

  % comptage du nombre de dés dans la main correspondant à Val
  compter(Des, De, NbMesDesCorrespondant),

  % estimation du nombre d'autre dés correspondant à Val
  (De = 1 -> Stat is 6 ; Stat is 3),
  NbAutresDesCorrespondants is NbAutresDes / Stat,

  % choix en fonction de la proba
  Somme is NbMesDesCorrespondant + NbAutresDesCorrespondants,
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

% vim: ft=prolog et sw=2 sts=2
