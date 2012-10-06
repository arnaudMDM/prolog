%createTable([T|_],0):-length(T,7).
%createTable([T|_],N):-N1 is N-1, createTable(T,N1), length(T,7).

:-dynamic table/1.
table([[],[],[],[],[],[],[]]).
%raisonnement par colonne

getNb(C,NB):-table(X), nth1(C,X,[]), NB is 0.
getNb(C,NB):-table(X), nth1(C,X,T), length(T, NB).


replace(C, [LIST|X], P, [RESULT|L],N):- N==C,!, append(LIST,[P],RESULT), N1 is N+1, replace(C,X,P,L,N1).
replace(C, [LIST|X], P, [LIST|L],N):- N\=C,!, N1 is N+1, replace(C,X,P,L,N1).
replace(_, [], _, [],_).

add(P, C, R):-getNb(C,NB),NB<6,!,table(X), replace(C,X,P,R,1), retract(table(X)), assert(table(R)).
add(_, C, _):-getNb(C,NB),NB>=6,!,write('column full').

resetTable:-retract(table(X)), assert(table([[],[],[],[],[],[],[]])).

getRow([C|T],R,[v|L]):-C==[],!,getRow(T,R,L).
getRow([C|T],R,[E|L]):-!,nth1(R,C,E), getRow(T,R,L).
getRow([],_,[]).

countElem(P,[A|L],N,M):-A==P,!,countElem(P,L,N1,M1),N is N1+1, M is max(N,M1).
countElem(P,[_|L],N,M):-!,countElem(P,L,N1,M1), M is max(N1,M1),N is 0.
countElem(_,[],0,0).


gagneHz(T,P,R):-getRow(T,R,L),countElem(P,L,NB,M),M is 4.

gagneVer(T,P,C):-nth1(C,T,L),countElem(P,L,NB,M),M is 4.

gagne(T,P,C,R):-gagneHz(T,P,R);gagneVer(T,P,C).


