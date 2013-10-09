use_module(library(random)).

de(N) :- random(1, 6, N).

tirage(0, []).
tirage(N, [T|Q]) :- de(T), N1 is N - 1, tirage(N1, Q), !.

joueur(N, L) :- tirage(N, L).

joueur1(5, L) :- joueur(5, L).
joueur2(5, L) :- joueur(5, L).

perdu(joueur(N, _)) :- N == 0.
