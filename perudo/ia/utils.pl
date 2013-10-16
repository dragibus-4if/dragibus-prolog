:- use_module(library(lists)).

% Utile pour les paires [X, Y]
premier([X, _], X).
second([_, Y], Y).

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

% Calcul à partir de la forme binomiale
%     N : nombre autres dés
%     N : nombre de dés manquants
statCoup(Des, NbTotal, rulesBet(Nb, De), Stat) :-
  % calculer le nombre de dés "manquants"
  compter(Des, De, NbMesDesCorrespondant),
  NbDesManquants is max(0, Nb - NbMesDesCorrespondant),
  length(Des, NbMesDes),
  NbAutresDes is NbTotal - NbMesDes,

  % debug
  %write('Il y a '), write(NbTotal), write(' dés au total\n'),
  %write('J\'ai '), write(NbMesDes), write(' dés\n'),
  %write('Il y a '), write(NbAutresDes), write(' autre dés\n'),
  %write('J\'ai '), write(NbMesDesCorrespondant), write(' '), write(De), write('\n'),
  %write('Il manque '), write(NbDesManquants), write(' '), write(De), write('\n'),

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
    between(Q, N, X), % FIXME doit sortir plusieurs résultats
    bagof(S, repartitionBinomiale(N, X, P, S), ListStats),
    write('ListStats = '), write(ListStats), write('\n'),
    sumlist(ListStats, Stat)
  ), !.

%statCoup(Des, N, rulesBet(Nb, De), calza, Stat)
%statCoup(Des, N, rulesBet(Nb, De), dudo, Stat)
%statCoup(Des, N, rulesBet(Nb, De), rulesBet(Nb1, De1), Stat)

% vim: ft=prolog et sw=2 sts=2
