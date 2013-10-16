% IA "débile", choisissant le coup le plus faible à chaque fois
iaDebile(_, _, _, [_, _|[_|_]], 2).
iaDebile(_, _, _, [_, _], 1).

% vim: ft=prolog et sw=2 sts=2
