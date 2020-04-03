
writeLine(_,_,0) :- !.
writeLine(Tablero,X,Y) :-
    Z is X - Y ,
    %print(Z),
   % writeln(''),
    nth0(Z,Tablero, P) ,
    print(P),
    writeln(''),
    %print(Y),
    %Y is Y - 1,print(Y),
    writeLine(Tablero,X,Y-1).

indexer(Tablero,X,Y,R):-
	nth0(X,Tablero,P),
	nth0(Y,P,R).
%	print(E),
%	writeln('').

%makeTilesIndexer(_,_,0,).
%makeTilesIndexer(Line,X,Y):-

factories(L,LL):-
	random_permutation(L,LL).

%erase the first n elements of a list
eraseFirstN(0,R,R).
eraseFirstN(X,L,R):-
	Y is X - 1,
	selectchk(_,L,LL),
	eraseFirstN(Y,LL,R).

%get the first n elements ,m times
getFirstNTimes(X,Y,L,R):-
	getFirstNTimes(X,Y,L,_,R).
getFirstNTimes(0,_,_,R,R).
getFirstNTimes(X,Y,L,RR,R):-
	Z is X - 1,
	length(L,XL),
	getFirst(Y,L,XL,_,NewR),
	append(RR,[NewR],NewRR),
	length(NewR,W),
	eraseFirstN(W,L,LL),
	getFirstNTimes(Z,Y,LL,NewRR,R).

%get the first n elements of a list
getFirst(X,L,R):-
	length(L,W),
	getFirst(X,L,W,[],R).
getFirst(_,_,0,R,R).
getFirst(0,_,_,R,R).
getFirst(X,L,W,RR,R):-
	Y is X - 1,
	NW is W - 1,
	selectchk(Z,L,LL),
	append(RR,[Z],NewR),
	getFirst(Y,LL,NW,NewR,R).

%esto es para los primeros n de una lista,no esta bien
test(0,_,R):-print(R).
test(X,L,R):-
	Y is X - 1,
	selectchk(Z,L,LL),
	append(R,[Z],RR),
	test(Y,LL,RR).


setFactories(L,R):-
	setFactories(4,L,R).
setFactories(0,_,L):-
	print(L).
setFactories(X,[H|T],L):-
	Y is X - 1,
	append(L, [H],R),
	setFactories(Y,T,R).
%%	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%lo mismo que factories....
makeTiles(0,L):-print(L).
makeTiles(X,L):-
	Y is random(5),
	append(L,[Y],LL),
	%print(5),
	M is X -1 ,
        makeTiles(M,LL).%,print(4).


%get the x- Column base 0
getColumn(Tablero,X,R):-
	length(Tablero,W),
	getColumn(W,W,Tablero,_,X,R).
getColumn(0,_,_,R,_,R).
getColumn(W,L,Tablero,RR,X,R):-
	I is L - W ,
	NW is W - 1,
	indexer(Tablero,I,X,E),
	append(RR,[E],NewR),
	getColumn(NW,L,Tablero,NewR,X,R).

%replace x in a Line base 1
replaceX(L,X,E,R):-
	Y is X - 1,
	getFirst(Y,L,LL),
	append(LL,[E],NL),
	eraseFirstN(X,L,RL),
	append(NL,RL,R).

appendR(R,_,0,R).
appendR(L,E,_,R):-
	append(L,[E],R).
appendR(L,E,R):-
	length(E,W),
	appendR(L,E,W,R).

%replace x,y in a board base 1
replaceXY(Tablero,X,Y,E,NTablero):-
	NX is X - 1,
	getFirst(NX,Tablero,L),
	eraseFirstN(NX,Tablero,NT),
	selectchk(Z,NT,RL),
	replaceX(Z,Y,E,R),
	append(L,[R],LL),
	appendR(LL,RL,NTablero).
%	append(LL,[RL],NTablero).

%casilla ocupada base 0
busyCell(Tablero,X,Y,R):-
	indexer(Tablero,X,Y,_:R).

%trueOrFalse(X,R):-
%	trueOrFalse(X,R).
trueOrFalse(0,R):-R is 0.
trueOrFalse(_,R):-R is 1.

%retorna 0 si son iguales
%1 en otro cas0
equals(X,Y,R):-
	Z is X-Y,
	trueOrFalse(Z,R).

binaryNot(0,R):-R is 1.
binaryNot(1,R):-R is 0.


%poner un elemento en una lista
%asumiendo que la lista esta formada por tuplas 1, 2 ,...,
%donde 1 es azul ,2 es rojo .....
%-1 representa una casilla vacia
canPutElement(L,X,R):-
	selectchk(Z,L,_),
	canPutElement(_,Z,X,R).
canPutElement(_,-1,_,R):- R is 1.
canPutElement(_,Z,X,R):-
	equals(X,Z,RR),binaryNot(RR,R).

getColorPos(_,_,1,R,R).
getColorPos(L,X,_,Y,R):-
	NY is Y + 1,
	selectchk(Z:_,L,RL),
	%print(Z),
	equals(X,Z,RE),
	binaryNot(RE,RBN),
	getColorPos(RL,X,RBN,NY,R).

%base 1
getColorPos(L,X,R):-
%	Y is 0,
	getColorPos(L,X,0,0,R).

canPutElementInPattern1(_,_,_,0,R):-R is 0.
canPutElementInPattern1(Tablero,X,E,_,R):-
	nth0(X,Tablero,P),
	getColorPos(P,E,CP),
	%print(CP),
	NCP is CP - 1,
	busyCell(Tablero,X,NCP,BCR),binaryNot(BCR,R).




%poner un elemento en la columna x del patternLine
%base 0
canPutElementInPattern(Tablero,L,X,E,R):-
	nth0(X,L,P),
	canPutElement(P,E,RP),
%	print(RP),
	canPutElementInPattern1(Tablero,X,E,RP,R).

isEmpty(X):- -1 is X.
getFreeSpaces(L,R):-
	findall(X,(member(X,L),isEmpty(X)),W),
	length(W,R).

%lineIndexer(L,I,R):-
%	nth0(I,L,R).
%busyPos(L,I,R):-
%	lineIndexer(L,I,_:R).

%consecutiveLeft(_,_,0,RR,R):- R is RR -1.
%consecutiveLeft(_,-1,_,R,R).

%consecutiveLeft(L,J,1,RR,R):-
	%print(L),
	%writeln(''),
%	NJ is J - 1,
%	busyPos(L,J,RbP),
	%print(RbP),
	%writeln(''),
%	NRR is RR + 1,
%	consecutiveLeft(L,NJ,RbP,NRR,R).


%consecutiveLeft(L,J,R):-
%	consecutiveLeft(L,J,1,0,R).

%consecutiveRigth(_,_,0,_,R,R).
%consecutiveRigth(_,_,_,0,RR,R):- R is RR - 1.
%consecutiveRigth(L,J,W,1,RR,R):-
	%NJ is J + 1,
	%NW is W - 1,
	%busyPos(L,J,RbP),
	%NRR is RR + 1,
	%consecutiveRigth(L,NJ,NW,RbP,NRR,R).


%consecutiveRigth(L,W,J,R):-
 %       NW is W - J,
	%print(NW),
	%writeln(''),
	%print(L),
	%	writeln(''),
	%consecutiveRigth(L,J,NW,1,0,R).

%consecutivos en la linea i del Tablero,junto a la posicionX
%base 0
%consecutiveLine(Tablero,I,X,R):-
%	Y is X - 1,
%	nth0(I,Tablero,L),
%	getFirst(X,L,FL),
%	print(FL),
%	writeln(''),
%	reverse(FL,LF),
%	print(LF),
%	writeln(''),
%	consecutiveLeft(LF,Y,CL),
%	print(CL),
%		writeln(''),
%	Z is X + 1,
%	length(L,W),
%	eraseFirstN(Z,L,NL),
	%print(NL),
	%	writeln(''),
	%consecutiveRigth(NL,W,Z,RL),
	%print(RL),
		%writeln(''),
	%R is CL + RL + 1.

consecutivos([],R,R).
consecutivos([_:0|_],R,R).
consecutivos([_|Y],RR,R):-
	NRR is RR + 1,
	consecutivos(Y,NRR,R).

%consecutivos en la linea i del Tablero,junto a la posicionJ
%base 0
consecutiveLine(Tablero,I,J,R):-
	nth0(I,Tablero,L),
	getFirst(J,L,FL),
	reverse(FL,LF),
	consecutivos(LF,0,CL),
	X is J + 1,
	eraseFirstN(X,L,NL),
	consecutivos(NL,0,CR),
	R is CL + CR + 1.


printT(Tablero):-
    length(Tablero, X),
    %print(X),
    %writeln(''),
    writeLine(Tablero,X,X).



init :- Tablero = [[1,2],[3,4]],
%	length(Tablero,X),
%	print(X),
        printT(Tablero).










