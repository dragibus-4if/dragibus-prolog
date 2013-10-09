% lit une ligne depuis l'entrée standard
lire_ligne(X) :-
  read_line_to_codes(user_input, X),
  X \= end_of_line, X \= end_of_file.

% procedure pour répéter un prédicat
repeter.
repeter(P) :- P ; repeter(P).

lire_nombre(X) :-
  write('Entrez en nombre: '), lire_ligne(Ligne),
  catch(number_chars(X, Ligne), _, fail).

main :-
  repeter(lire_nombre(X)),
  write('Vous avez entré: '), write(X).

% vim: ft=prolog et sw=2 sts=2
