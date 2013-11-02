go :-
  current_prolog_flag(argv, Arguments),
  append(_SystemArgs, [--|Args], Arguments), !,
  go(Args).

go(Args) :-
  writeln(Args).
