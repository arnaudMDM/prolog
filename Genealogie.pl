parent(robert,gaston).
parent(gaston,marc).
parent(marc, arnaud).
parent(annie, arnaud).
parent(marc, alexandre).
parent(annie,alexandre).
parent(marc,camille).
parent(annie,camille).
frereousoeur(arnaud, alexandre).
frereousoeur(camille, arnaud).
frereousoeur(marc, thibaut).
frereousoeur(gerda,annie).
homme(marc).
homme(alexandre).
homme(arnaud).
homme(thibaut).
femme(annie).
femme(camille).
femme(gerda).

grandParent(X,Y):-parent(X,Z),parent(Z,Y).

oncle(X,Y):-homme(X),(frereousoeur(X,Z);frereousoeur(Z,X)),parent(Z,Y).
tante(X,Y):-femme(X),(frereousoeur(X,Z);frereousoeur(Z,X)),parent(Z,Y).
%?-oncle(X,Y).
ancetres(X,Y):-parent(X,Y).
ancetres(X,Y):-parent(Z,Y),ancetres(X,Z).

dernierAncetres(X,Y):-parent(X,Y),not(parent(_,X)).
dernierAncetres(X,Y):-parent(H,Y),dernierAncetres(X,H).

arbregenea2(X,_,[X]):-not(parent(X,_)).
arbregenea2(X,Y,[X|L]):-parent(X,Y),arbregenea2(Y,_,L).
arbregenea(X,Z):-arbregenea2(X,_,Z).

longueur([],0).
longueur([_|Q],N) :- longueur(Q,N1), N is N1+1.
nbDesc(X,N) :- arbregenea(X,Z), longueur(Z,N).

nbDesc2(X,1):-not(parent(X,_)).
nbDesc2(X,N):-parent(X,Y),nbDesc2(Y,N1), N is N1+1.