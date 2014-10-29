%createDamier([T|_],0):-length(T,7).
%createDamier([T|_],N):-N1 is N-1, createDamier(T,N1), length(T,7).

:-dynamic damier/1.
:-dynamic jetonIA/1.
:-dynamic niveauIA/1.

%le premier élément du damier est une liste d'éléments corespondant aux éléments de la première colonne du plateau de jeu
damier([[],[],[],[],[],[],[]]).

jetonJoueur(o).

niveauIA(5).

chooseJeton(x):-jetonJoueur(Jeton),retract(jetonJoueur(Jeton)),assert(jetonJoueur(x)).
chooseJeton(o):-jetonJoueur(Jeton),retract(jetonJoueur(Jeton)),assert(jetonJoueur(o)).

chooseNiveauIA(NewNiveauIA):-niveauIA(NiveauIA),retract(niveauIA(NiveauIA)),assert(niveauIA(NewNiveauIA)).

%règle qui permet de connaitre les nombre de jetons dans une colonne d'un damier
%exemple d'utilsation: getNbJetons(2,NbJetons) permettera de connaitre le nombre de jetons présents dans la colonne 2.
getNbJetons(Colonne,NbJetons,Damier):-nth1(Colonne,Damier,[]), NbJetons is 0.
getNbJetons(Colonne,NbJetons,Damier):-nth1(Colonne,Damier,ListeColonne), length(ListeColonne, NbJetons).


%règle qui permet de créer un nouveau damier à partir d'un ancien damier en ajoutant un jeton en plus dans une colonne
%exemple d'utilisation: replace(2,Damier,o,NewDamier,1) avec Damier une variable non libre. NewDamier sera comme 
%Damier avec un jeton o en plus dans la colonne 2
replace(Colonne, [ListeColonne|X], Jeton, [NewListeColonne|L],N):- N==Colonne,!, append(ListeColonne,[Jeton],NewListeColonne), N1 is N+1, replace(Colonne,X,Jeton,L,N1).
replace(Colonne, [ListeColonne|X], Jeton, [ListeColonne|L],N):- N\=Colonne,!, N1 is N+1, replace(Colonne,X,Jeton,L,N1).
replace(_, [], _, [],_).

%règle qui permet d'ajouter réellement un pion dans une colonne dans le damier existant comme fait. La connaissance du nouveau damier ne disparait pas tant
%que l'interpréteur est en cours d'exécution.
%exemple d'utilisation: addReal(o,2,NewDamier,Ligne) va ajouter un jeton o dans la deuxième colonne du damier présent en tant que fait. Le nouveau damier est aussi retourné
%par la variable NewDamier et la ligne du pion joué est retourné par la variable Ligne
%Si la colonne est pleine, on écrit sur la console un message particulier et retourne faux comme résultat
addReal(Jeton, Colonne, NewDamier,Ligne):-damier(Damier),getNbJetons(Colonne,NbJetons,Damier),NbJetons<6,!,Ligne is NbJetons+1, replace(Colonne,Damier,Jeton,NewDamier,1), retract(damier(Damier)), assert(damier(NewDamier)).
addReal(_, Colonne, _,_):-damier(Damier),getNbJetons(Colonne,NbJetons,Damier),NbJetons>=6,!,write('column full'),fail.

%règle qui permet de modifier le damier présent en tant que fait par un damier vide.
resetDamier:-retract(damier(_)), assert(damier([[],[],[],[],[],[],[]])).

%règle qui permet de récupérer la liste des éléments d'une ligne d'un damier.
%exemple d'utilisation: getListeLigne(Damier,1,ListeLigne) permet de récupérer les éléments de la première ligne de la variable Damier.
%cas du vide: si il la première colonne possède un jeton et que les autres colonnes ne possède aucuns jetons, la listeLigne possèdera tout de même autant
%d'éléments qu'il y a de colonnes. Les colonnes sans éléments donneront dans la listeLigne des éléments v (v pour vide).'
getListeLigne([[]|T],Ligne,[v|L]):-!, getListeLigne(T,Ligne,L).
getListeLigne([ListeColonne|T],Ligne,[E|L]):-nth1(Ligne,ListeColonne,E),!,getListeLigne(T,Ligne,L).
getListeLigne([_|T],Ligne,[v|L]):-!, getListeLigne(T,Ligne,L).
getListeLigne([],_,[]).

%règle qui permet de récupérer la liste des éléments d'une diagonale descendante d'un damier.
%exemple d'utilisation: getListeDiagBas(Damier,2,1,ListeDiagBas,1) permetde récupérer la liste des diagonales descendantes du damier présent dans la varible
%Damier dont une des cases est la case de la deuxième ligne et la première colonne. On récupère la liste dans la variable ListeDiagBas
getListeDiagBas([],_,_,[],_):-!.
getListeDiagBas(Damier,Ligne,Colonne,ListeDiagBas,N):-D is Ligne+Colonne-N,D>0,D=<6,!,getListeDiagBas2(Damier,Ligne,Colonne,ListeDiagBas,N,D).
getListeDiagBas([_|T],Ligne,Colonne,ListeDiagBas,N):-D is Ligne+Colonne-N,D>6,!,N1 is N+1, getListeDiagBas(T,Ligne,Colonne,ListeDiagBas,N1).
getListeDiagBas2([ListeColonne|T],Ligne,Colonne,[E|L],N,D):- nth1(D,ListeColonne,E),E\=[],D>1,!,N1 is N+1, getListeDiagBas(T,Ligne,Colonne,L,N1).
getListeDiagBas2([ListeColonne|_],_,_,[E],_,D):- nth1(D,ListeColonne,E),E\=[],!.
getListeDiagBas2([_|T],Ligne,Colonne,[v|L],N,D):-D>1,!,N1 is N+1, getListeDiagBas(T,Ligne,Colonne,L,N1).
getListeDiagBas2([_|_],_,_,[v],_,_):-!.


%règle qui permet de récupérer la lsite des éléménts d'une diagonale ascendante
%exemple d'utilisation: similaire à getListeDiagBas
getListeDiagHaut([],_,_,[],_):-!.
getListeDiagHaut(Damier,Ligne,Colonne,ListeDiagHaut,N):-D is Ligne-Colonne+N,D>0,D=<6,!,getListeDiagHaut2(Damier,Ligne,Colonne,ListeDiagHaut,N,D).
getListeDiagHaut([_|T],Ligne,Colonne,ListeDiagHaut,N):-D is Ligne-Colonne+N,D=<0,!,N1 is N+1, getListeDiagHaut(T,Ligne,Colonne,ListeDiagHaut,N1).
getListeDiagHaut2([ListeColonne|T],Ligne,Colonne,[E|L],N,D):- nth1(D,ListeColonne,E),E\=[],D<6,!,N1 is N+1, getListeDiagHaut(T,Ligne,Colonne,L,N1).
getListeDiagHaut2([ListeColonne|_],_,_,[E],_,D):- nth1(D,ListeColonne,E),E\=[],!.
getListeDiagHaut2([_|T],Ligne,Colonne,[v|L],N,D):- D<6,!,N1 is N+1, getListeDiagHaut(T,Ligne,Colonne,L,N1).
getListeDiagHaut2(_,_,_,[v],_,_):-!.

%règle qui permet de compter le nombre maximum d'éléments succesifs présents dans une liste
%exemple d'utilisation: countElem(x,[x,x,o,x],Max) vaut Max=2
countElem(Jeton,Liste,Max):-countElem2(Jeton,Liste,_,Max).
countElem2(Jeton,[E|L],N,Max):-E==Jeton,!,countElem2(Jeton,L,N1,Max1),N is N1+1, Max is max(N,Max1).
countElem2(Jeton,[_|L],N,Max):-!,countElem2(Jeton,L,N1,Max1), Max is max(N1,Max1),N is 0.
countElem2(_,[],0,0).

%règle permettant d'afficher un élément d'une liste à partir d'un index
%exemple d'utilisation: afficheListe([x,x,x,o,x],4) affiche 'o' sur la console. NB: si la l'index voulu dépasse la taille de la liste, on affiche un espace.
afficheListe(ListeColonne,N):-afficheListe2(ListeColonne,N,1).
afficheListe2([],_,_):-!,write(' ').
afficheListe2([E|_],N1,N2):-N1 is N2,!,write(E).
afficheListe2([_|R],N1,N2):-!,N3 is N2+1,afficheListe2(R,N1,N3).

%règle permettant d'afficher N points sur une ligne
%permet de donner l'illusion d'un damier d'un puissance 4
afficherPoint(N):-N>0,!,write(.),write(' '),N1 is N-1,afficherPoint(N1).
afficherPoint(N):-N is 0,!,write(.).
afficherPoint(_).

%règle permettant d'afficher la totalité du damier d'un puissance 4
%Il suffit de donner le damier en paramètre d'entrée
afficheTab(Damier):-afficherPoint(7),nl,afficheTab2(Damier,Damier,6).
afficheTab2(Damier,[],N):-N1 is N-1,write(.),nl,afficheTab2(Damier,Damier,N1),!.
afficheTab2(Damier,[E|R],N):-N>=1,write(.),afficheListe(E,N),afficheTab2(Damier,R,N),!.
afficheTab2(_,_,0):-nl.

%règle permettant de remplir une colonne dont la taille est inférieure à 6 de caractères 'v' jusqu'à obtenir 6 éléments
%exemple d'utilisation : addVToListeColonne([x,x,x],NewListeColonne) NewListeColonne renvoie [x,x,x,v,v,v]
addVToListeColonne(ListeColonne,NewListeColonne):-addVToListeColonne2(ListeColonne,NewListeColonne,1).
addVToListeColonne2([E|R1],[E|R2],N):-N<6,!,N1 is N+1, addVToListeColonne2(R1,R2,N1).
addVToListeColonne2([E],[E],_).
addVToListeColonne2([],[v|R2],N):-N<6,!,N1 is N+1,addVToListeColonne2([],R2,N1).
addVToListeColonne2([],[v],_).

%règle permettant de compter le nombre de combinaisons potentielles assurant la victoire par incrémentation
%exemple d'utilisation : testAndAddSuitesGagnantes(0,4,NewNbSuitePoss) NewNbSuitePoss vaut 1
testAndAddSuitesGagnantes(NbSuitePoss,N,NewNbSuitePoss):-N >= 4,!,NewNbSuitePoss is NbSuitePoss+1.
testAndAddSuitesGagnantes(NbSuitePoss,_,NewNbSuitePoss):-NewNbSuitePoss is NbSuitePoss.

%règle permettant de compter le nombre de combinaisons potentielles assurant la victoire sur une seule liste
%exemple d'utilisation : countSuitesGagnante(x,[x,x,o,x,x,v,v],NbSuitePoss) NbSuitePoss vaut 1
countSuitesGagnante(Jeton,[E|L],NbSuitePoss):-!,countSuitesGagnante2(Jeton,[E|L],NbSuitePoss,_).
countSuitesGagnante(_,[],0).
countSuitesGagnante2(Jeton,[E|L],NbSuitePoss,N):-(E==Jeton,!;E==v),!,countSuitesGagnante2(Jeton,L,NbSuitesPoss1,N1),N is N1+1,testAndAddSuitesGagnantes(NbSuitesPoss1,N,NbSuitePoss).
countSuitesGagnante2(Jeton,[_|L],NbSuitePoss,N):-!,countSuitesGagnante2(Jeton,L,NbSuitePoss,_),N is 0.
countSuitesGagnante2(_,[],0,0).

%règle permettant de choisir la colonne à jouer pour l'IA en fonction d'une évaluation minimum ou maximale (algo alpha/beta (optimisation de min/max))
%exemple d'utilisation : chooseEval(x,5,7,ResultatTemp,1,2,ColonneToPlayTemp1) ResultatTemp vaut 5 et ColonneToPLayTemp1 vaut 1 à condition que x est le jeton du joueur.
chooseEval(Jeton,ResultatTemp1,ResultatTemp2,ResultatTemp,ColonneToPlayTemp1,_,ColonneToPlayTemp1):-jetonJoueur(Jeton),ResultatTemp is min(ResultatTemp1,ResultatTemp2),ResultatTemp is ResultatTemp1,!.
chooseEval(Jeton,ResultatTemp1,ResultatTemp2,ResultatTemp,_,ColonneToPlayTemp2,ColonneToPlayTemp2):-jetonJoueur(Jeton),ResultatTemp is min(ResultatTemp1,ResultatTemp2),ResultatTemp is ResultatTemp2,!.
chooseEval(Jeton,ResultatTemp1,ResultatTemp2,ResultatTemp,ColonneToPlayTemp1,_,ColonneToPlayTemp1):-jetonJoueur(JetonTemp),changeJeton(JetonTemp,Jeton),ResultatTemp is max(ResultatTemp1,ResultatTemp2),ResultatTemp is ResultatTemp1,!.
chooseEval(Jeton,ResultatTemp1,ResultatTemp2,ResultatTemp,_,ColonneToPlayTemp2,ColonneToPlayTemp2):-jetonJoueur(JetonTemp),changeJeton(JetonTemp,Jeton),ResultatTemp is max(ResultatTemp1,ResultatTemp2),ResultatTemp is ResultatTemp2,!.

%règle permettant d'éviter de prendre en compte des chemins inutiles que min/max aurait évalué/
%exemple d'utilisation : alphaBeta(x,5,1,8,ResultatTemp): ResultatTemp vaut 8 en supposant que x soit la couleur du joueur
alphaBeta(Jeton,ResultatHaut,1,ResultatTemp,ResultatTemp):-jetonJoueur(JetonJoueur),Jeton\=JetonJoueur,!,ResultatHaut=<ResultatTemp,!.
alphaBeta(Jeton,ResultatHaut,1,ResultatTemp,ResultatTemp):-!,jetonJoueur(JetonJoueur),Jeton==JetonJoueur,ResultatHaut>=ResultatTemp.

%règle permettant d'ajouter de manière non permanente un jeton au damier afin que l'IA puisse évaluer une configuration potentielle future.
%exemple d'utilisation : addVirtual(o, 3, [[x,o,x,o],[x,o,x,o],[x,o,x],[],[],[],[]],NewDamier,Ligne) NewDamier vaut [[x,o,x,o],[x,o,x,o],[x,o,x,o],[],[],[],[]] et ligne vaut 4
addVirtual(Jeton, Colonne, Damier,NewDamier,Ligne):-getNbJetons(Colonne,NbJetons,Damier),NbJetons<6,!,Ligne is NbJetons+1, replace(Colonne,Damier,Jeton,NewDamier,1).

%règle permettant de donner un poids "infini" à une configuration gagnante ou perdante
%exemple d'utilisation : addGagne(x, N) N vaut -100 si x est un joueur.
addGagne(Jeton,N):-jetonJoueur(JetonJoueur),Jeton==JetonJoueur,!,N is -100.
addGagne(_,N):-N is 100.

%règle permettant d'évaluer une configuration gagnante sur une dimension
%exemple d'utilisation : gagneHor([[x,o,x,o],[x,o,x,o],[x,o,x,o],[x],[],[],[]],x,1) la règle retournerait vrai.
gagneHor(Damier,Jeton,Ligne):-getListeLigne(Damier,Ligne,ListeLigne),countElem(Jeton,ListeLigne,Max),Max >= 4.
gagneVer(Damier,Jeton,Colonne):-nth1(Colonne,Damier,ListeColonne),countElem(Jeton,ListeColonne,Max),Max >= 4.
gagneDiagBas(Damier,Jeton,Ligne,Colonne):-getListeDiagBas(Damier,Ligne,Colonne,ListeDiagBas,1),countElem(Jeton,ListeDiagBas,Max),Max >= 4.
gagneDiagHaut(Damier,Jeton,Ligne,Colonne):-getListeDiagHaut(Damier,Ligne,Colonne,ListeDiagHaut,1),countElem(Jeton,ListeDiagHaut,Max),Max >= 4.

%règle permettant d'évaluer une configuration gagnante sur tout le damier
%exemple d'utilisation : gagne([[x,o,x,o],[x,o,x,o],[x,o,x,o],[x],[],[],[]],x,1,1) la règle retournerait vrai.
gagne(Damier,Jeton,Ligne,Colonne):-gagneHor(Damier,Jeton,Ligne),!;gagneVer(Damier,Jeton,Colonne),!;gagneDiagBas(Damier,Jeton,Ligne,Colonne),!;gagneDiagHaut(Damier,Jeton,Ligne,Colonne).

%règle permettant de compter le nombre de configuration potentielles gagnantes quelles que soient les lignes et les colonnes.
%exemple d'utilisation : calcJeu([[x,o],[x,o],[x,o],[]],N) N vaut -3
calcJeu(Damier,N):-calcJeuLignes(Damier,N1,1),calcJeuColonnes(Damier,N2,1),calcJeuDiagBas(Damier,N3,1,1),calcJeuDiagHaut(Damier,N4,6,1),N is N1+N2+N3+N4.
calcJeuLignes(Damier,N,Ligne):-Ligne<7,!,NewLigne is Ligne+1, calcJeuLignes(Damier,N1,NewLigne),getListeLigne(Damier,Ligne,ListeLigne),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,ListeLigne,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,ListeLigne,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuLignes(_,0,_).
calcJeuColonnes(Damier,N,Colonne):-Colonne<8,!,NewColonne is Colonne+1, calcJeuColonnes(Damier,N1,NewColonne),nth1(Colonne,Damier,ListeColonne),addVToListeColonne(ListeColonne,NewListeColonne),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,NewListeColonne,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,NewListeColonne,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuColonnes(_,0,_).
calcJeuDiagBas(Damier,N,Ligne,Colonne):-Colonne<7,!,NewColonne is Colonne+1, calcJeuDiagBas(Damier,N1,Ligne,NewColonne),getListeDiagBas(Damier,Ligne,Colonne,ListeDiagBas,1),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,ListeDiagBas,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,ListeDiagBas,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuDiagBas(Damier,N,Ligne,Colonne):-Ligne<7,!,NewLigne is Ligne+1, calcJeuDiagBas(Damier,N1,NewLigne,Colonne),getListeDiagBas(Damier,Ligne,Colonne,ListeDiagBas,1),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,ListeDiagBas,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,ListeDiagBas,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuDiagBas(_,0,_,_).
calcJeuDiagHaut(Damier,N,Ligne,Colonne):-Ligne>1,!,NewLigne is Ligne-1, calcJeuDiagHaut(Damier,N1,NewLigne,Colonne),getListeDiagHaut(Damier,Ligne,Colonne,ListeDiagHaut,1),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,ListeDiagHaut,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,ListeDiagHaut,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuDiagHaut(Damier,N,Ligne,Colonne):-Colonne<8,!,NewColonne is Colonne+1, calcJeuDiagHaut(Damier,N1,Ligne,NewColonne),getListeDiagHaut(Damier,Ligne,Colonne,ListeDiagHaut,1),jetonJoueur(JetonJoueur),changeJeton(JetonJoueur,JetonIA),countSuitesGagnante(JetonIA,ListeDiagHaut,NbSuitesPoss1),countSuitesGagnante(JetonJoueur,ListeDiagHaut,NbSuitesPoss2),N is N1+NbSuitesPoss1-NbSuitesPoss2.
calcJeuDiagHaut(_,0,_,_).

%règle permettant de permettre à l'IA de choisir la bonne colonne à jouer, de la jouer et de vérifier s'il y a une configuration gagnante ou d'égalité
%exemple d'utilisation : playIA(o) joue un o et indique s'il y a égalité ou gagne.
playIA(Jeton):-damier(Damier),niveauIA(NiveauIA),playIA2(NiveauIA,1,Damier,Jeton,ColonneToPlay,_,Egalite,_,0),(Egalite is 0,write('EGALITE'),!;addReal(Jeton,ColonneToPlay,NewDamier,Ligne),afficheTab(NewDamier),testGagneIA(NewDamier,Jeton,Ligne,ColonneToPlay)).
playIA2(Profondeur,Colonne,Damier,Jeton,ColonneToPlay,Resultat,BPossible,ResultatHaut,BCompare):-Colonne<8,!,playIA4(Profondeur,Colonne,Damier,Jeton,ColonneToPlay1,Resultat1,BPossible,_,0),Colonne1 is Colonne+1,(BPossible is 0,!;alphaBeta(Jeton,ResultatHaut,BCompare,Resultat1,Resultat),!;playIA3(Profondeur,Colonne1,Damier,Jeton,ColonneToPlay,ColonneToPlay1,Resultat,Resultat1,ResultatHaut,BCompare)).
playIA3(Profondeur,Colonne,Damier,Jeton,ColonneToPlay,ColonneToPlayTemp1,Resultat,ResultatTemp1,ResultatHaut,BCompare):-Colonne<8,!,playIA4(Profondeur,Colonne,Damier,Jeton,ColonneToPlayTemp2,ResultatTemp2,BPossible,ResultatTemp1,1),(BPossible is 0,!;alphaBeta(Jeton,ResultatHaut,BCompare,ResultatTemp2,Resultat),!;chooseEval(Jeton,ResultatTemp1,ResultatTemp2,ResultatTemp,ColonneToPlayTemp1,ColonneToPlayTemp2,ColonneToPlayTemp),Colonne1 is Colonne+1,playIA3(Profondeur,Colonne1,Damier,Jeton,ColonneToPlay,ColonneToPlayTemp,Resultat,ResultatTemp,ResultatHaut,BCompare)),!.
playIA3(_,_,_,_,ColonneToPlay,ColonneToPlay,Resultat,Resultat,_,_).
playIA4(Profondeur,Colonne,Damier,Jeton,Colonne,ResultatTemp,1,ResultatHaut,BCompare):-addVirtual(Jeton,Colonne,Damier,NewDamier,Ligne),!,playIA5(Profondeur,Colonne,Ligne,NewDamier,Jeton,ResultatTemp,ResultatHaut,BCompare).
playIA4(Profondeur,Colonne,Damier,Jeton,ColonneToPlay,ResultatTemp,BPossible,ResultatHaut,BCompare):-Colonne<7,!,Colonne1 is Colonne+1,playIA4(Profondeur,Colonne1,Damier,Jeton,ColonneToPlay,ResultatTemp,BPossible,ResultatHaut,BCompare).
playIA4(_,_,_,_,_,_,0,_,_).
playIA5(_,Colonne,Ligne,Damier,Jeton,ResultatTemp,_,_):-gagne(Damier,Jeton,Ligne,Colonne),!,addGagne(Jeton,ResultatTemp).
playIA5(Profondeur,_,_,Damier,Jeton,ResultatTemp,ResultatHaut,BCompare):-Profondeur > 1,!,Profondeur1 is Profondeur-1,changeJeton(Jeton,NewJeton),playIA2(Profondeur1,1,Damier,NewJeton,_,ResultatTemp,_,ResultatHaut,BCompare).
playIA5(_,_,_,Damier,_,ResultatTemp,_,_):-calcJeu(Damier,ResultatTemp).

%règle permettant de changer le jeton à jouer à chaque tour (méthode pour l'IA afin de lui permettre de rechercher la configuration optimale)
%exemple d'utilisation : changeJeton(o,X) X vaut x
changeJeton(Jeton,o):-Jeton==x,!.
changeJeton(Jeton,x):-!,Jeton==o.

%règle permettant d'indiquer une configuration gagnante de l'IA et dans ce cas précis de faire un reset du damier
%exemple d'utilisation : testGagneIA([[x,o,x,o],[x,o,x,o],[x,o,x,o],[o,o],[],[],[]],o,Ligne,Colonne) Ligne vaut 2 et Colonne vaut 4.
testGagneIA(Damier,Jeton,Ligne,Colonne):-gagne(Damier,Jeton,Ligne,Colonne),!,write('PERDU'),resetDamier.
testGagneIA(_,_,_,_).

%règle permettant au joueur de jouer une colonne précise
%exemple d'utilisation : play(2) ajoute un jeton de la couleur du joueur dans la colonne 2 de façon permanente.
play(Colonne):-jetonJoueur(Jeton),addReal(Jeton,Colonne,NewDamier,Ligne),afficheTab(NewDamier),(play2(NewDamier,Jeton,Ligne,Colonne),!;changeJeton(Jeton,NewJeton),playIA(NewJeton)).
play2(Damier,Jeton,Ligne,Colonne):-gagne(Damier,Jeton,Ligne,Colonne),!,write('GAGNE'),resetDamier.