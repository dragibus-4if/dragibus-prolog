:- [utils].

% récupère le premier indice d'apparition d'un élément dans une liste
indiceElement([Element|_], Element, 0).
indiceElement([_|Q], Element, Indice) :-
  indiceElement(Q, Element, Indice1),
  Indice is Indice1 + 1.

% IA "statistique" (stats), se basant sur un calcul de probabilités pour
% décider du coup à jouer.
iaStats(Des, N, rulesBet(Nb, De), TousCoupsPossibles, Coup) :-
  % nombre de dés à moi
  length(Des, NbMesDes), NbAutresDes is N - NbMesDes,

  % comptage du nombre de dés dans la main correspondant à Val
  utils:compter(Des, De, NbMesDesCorrespondant),

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

% vim: ft=prolog et sw=2 sts=2
