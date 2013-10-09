use_module(library(random)).

de(N) :- random(1, 6, N).

tirage(0, []).
tirage(N, [T|Q]) :- de(T), N1 is N - 1, tirage(N1, Q), !.

% joueur(L) :- tirage(5, L).
joueur(N, L).
mise(Nbr, Val).
table(joueur(5, _), joueur(5, _)).

perdu(tirage(N, _)) :- N == 0.

init(mise(0, 0), joueur(N1, L1), joueur(N2, L2)) :- tirage(N1, L1), tirage(N2, L2).

partie_finie(1) :- table(joueur(0, _), _), !.
partie_finie(2) :- table(_, joueur(0, _)), !.

% pas() :- perdu, .
% pas() :- ..., pas.
% 
% jeu() :- init, pas
