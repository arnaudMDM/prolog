
lien(paris,lyon).
lien(lyon,marseille).
lien(nice,marseille).
lien(lyon,paris).

% ?-lien(X,marseille).		2 succes
% ?-lien(marseille,lyon).	echec
% ?-lien(X,Y), lien(Y,X). 	2 succes


lien1(paris,lyon).
lien1(lyon,marseille).
lien1(nice,marseille).
chemin1(X,Y) :- lien1(X,Y).   
 			
% ?-chemin1(X,marseille).	2 succes
% ?-chemin1(X,Y).			3 succes

chemin2(X,Y) :- lien1(X,Y).    	
chemin2(X,Y) :- lien1(X,Z), chemin2(Z,Y). 

% ?-chemin2(X,marseille).
% ?-chemin2(X,Y).			4 succes

relation(X,Y) :- lien(X,Y).
fermeture(X,Y) :- relation(X,Y).    			
fermeture(X,Y) :- relation(X,Z), fermeture(Z,Y). 

% ?-fermeture(X,Y).
% Attention, puisque le graphe qui correspond à lien 
% contient un cycle, ce programme peut boucler

fermeture1(X,Y) :- relation(X,Y).    			
fermeture1(X,Y) :- relation(X,Z), fermeture1(Z,Y). 	

fermeture2(X,Y) :- relation(X,Z), fermeture2(Z,Y). 
fermeture2(X,Y) :- relation(X,Y).    		

fermeture3(X,Y) :- relation(X,Y).    		
fermeture3(X,Y) :- fermeture3(Z,Y), relation(X,Z). 
		
fermeture4(X,Y) :- fermeture4(Z,Y), relation(X,Z).	
fermeture4(X,Y) :- relation(X,Y).    	

liaison(paris,marseille,date(12,5,2008)). 
liaison(paris,marseille,heure(13,15),[lundi,jeudi]).

avant(date(_,_,A1),date(_,_,A2)) :- A1 < A2.
avant(date(_,M1,A),date(_,M2,A)) :- M1 < M2.
avant(date(J1,M,A),date(J2,M,A)) :- J1 < J2.

% ?- liaison(D,A,date(_,5,_)).
% ?- liaison(paris,lyon,date(J1,M1,A)), liaison(lyon,X,date(J2,M2,A)),avant(date(J1,M1,A),date(J2,M2,A)).
% ?- liaison(paris,_,heure(H,_), L), H > 12, member(jeudi,L).		

membre(X,[X|_]).		   /* voir aussi element et member */
membre(X,[_|L]) :- membre(X,L).

% ?- membre(b,[a,b,c]).
% ?- membre(X,[a,b,c]).
% ?- membre(a,L).

append([ ], L1, L1).
append([A|L1],L2,[A|L3]) :- append(L1,L2,L3).

% ?- append([a,b],[c],[a,b,c]), append([a,b],[c,d],X).
% ?- append(X,Y, [a,b,c,d]).
% ?- append(X,[a,b],Y]).
% ?- L=[a,b,c], append(_,[X],L).