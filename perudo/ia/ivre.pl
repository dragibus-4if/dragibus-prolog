% IA "ivre", retournant un coefficiant au hasard pour chaque coup possible
iaIvre(_, _, _, [], []).
iaIvre(_, _, _, [T1|Q1], [T2|Q2]) :-
    random(0, 100, X), Stat is X / 100,
    T2 =[T1, Stat],
    iaIvre(_, _, _, Q1, Q2),
    !.

% vim: ft=prolog et sw=2 sts=2
