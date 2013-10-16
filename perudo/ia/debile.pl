:- module(debile, [iaDebile/5]).

% IA "débile", choisissant le coup le plus faible à chaque fois
iaDebile(_, _, _, [_,_,X|_], X).
iaDebile(_, _, _, [_,X], X).

% vim: ft=prolog et sw=2 sts=2
