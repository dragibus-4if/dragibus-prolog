% lit une ligne depuis l'entrée standard
lireLigne(X) :-
  read_line_to_codes(user_input, X),
  X \= end_of_line, X \= end_of_file.

% procedure pour répéter un prédicat
repeter.
repeter(P) :- P ; repeter(P).

lireNombre(X) :-
  write('Entrez en nombre: '), lireLigne(Ligne),
  catch(number_chars(X, Ligne), _, fail).

main :-
  repeter(lireNombre(X)),
  write('Vous avez entré: '), write(X).

% vim: ft=prolog et sw=2 sts=2
