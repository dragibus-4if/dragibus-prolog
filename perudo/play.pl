:- [game].

readline(L) :-
  read_line_to_codes(user_input, Input),
  string_to_atom(Input, L).

tuple_zero(E, (E, 0)).
enumFold(Elem, Old, [(Idx, Elem)|Old]) :-
  Old = [(OldIdx, _)|_],
  Idx is OldIdx + 1.
playFunc(Player, N, [], CoupsPossibles, Eval) :-
  playerDices(Player, Dice),
  write('Il y a '), write(N), write(' dés\n'),
  write('Vos des : '), write(Dice), write('\n'),
  write('Appuyez sur entrée pour continuer'),
  readline(_),

  writeln('Coups possibles :'),
  append([P], L_, CoupsPossibles),
  foldl(enumFold, L_, [(1, P)], CoupsPossibles_),
  maplist(writeln, CoupsPossibles_),

  write('Coup ? '),
  readline(StrCoup),
  atom_number(StrCoup, ICoup),
  maplist(tuple_zero, CoupsPossibles, Eval_),
  nth1(ICoup, CoupsPossibles, Coup),
  select((Coup, 0), Eval_, (Coup, 1), Eval).

playFunc(Player, N, [(_, Mise)|_], CoupsPossibles, Estimations) :-
  write('La mise est de '), write(Mise), write('\n'),
  playFunc(Player, N, [], CoupsPossibles, Estimations).

play :-
  write('Nom ? '), readline(Nom),
  P1 = (Nom, playFunc),
  P2 = ('John', iaCombine([(0.5, iaDebile), (0, iaEleve), (0.5, iaStats), (0, iaIvre)])),
  %P3 = ('Mike', iaCombine([(D2, iaDebile), (E2, iaEleve), (S2, iaStats), (I2, iaIvre)])),
  LsP = [P1, P2],
  gameCreate(LsP, W),
  write(W).

% vim: ft=prolog et sw=2 sts=2
