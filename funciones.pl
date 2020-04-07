
indexer(Tablero,X,Y,R):-
	nth0(X,Tablero,P),
	nth0(Y,P,R).

%devuelve una permutacion random de una lista
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


appendR1(R,_,0,R).
appendR1(L,LL,W,R):-
	NW is W - 1,
	selectchk(Z,LL,RLL),
	append(L,[Z],NL),
	appendR1(NL,RLL,NW,R).

appendR1(L,LL,R):-
	length(LL,W),
	appendR1(L,LL,W,R).

%replace x,y in a board base 1
replaceXY(Tablero,X,Y,E,NTablero):-
	NX is X - 1,
	getFirst(NX,Tablero,L),
	eraseFirstN(NX,Tablero,NT),
	selectchk(Z,NT,RL),
%	print(RL),
	%writeln(''),
	replaceX(Z,Y,E,R),
	%print(R),
	%writeln(''),
	append(L,[R],LL),
	%print(LL),
	%writeln(''),
	appendR1(LL,RL,NTablero).
%	append(LL,[RL],NTablero).

%casilla ocupada base 0
busyCell(Tablero,X,Y,R):-
	indexer(Tablero,X,Y,_:R).

trueOrFalse(0,R):-R is 0.
trueOrFalse(_,R):-R is 1.

%retorna 0 si son iguales
%1 en otro cas0
equals(X,Y,R):-
	Z is X - Y ,
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
	%print(RP),
	%writeln(''),
	getFreeSpaces(P,RFS),
	(   RFS > 0 -> canPutElementInPattern1(Tablero,X,E,RP,R) ; R is 0).

isEmpty(X):- -1 is X.
getFreeSpaces(L,R):-
	findall(X,(member(X,L),isEmpty(X)),W),
	length(W,R).


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

%consecutivos en la columna i del Tablero,junto a la posicionJ
%base 0
consecutiveColumn(Tablero,I,J,R):-
	getColumn(Tablero,I,L),
	%print(L),
	%writeln(''),
	getFirst(J,L,FL),
	reverse(FL,LF),
	consecutivos(LF,0,CL),
	X is J + 1,
	eraseFirstN(X,L,NL),
	consecutivos(NL,0,CR),
	R is CL + CR + 1.

equalF(X:_,C):-
	C is X.

myAdd(0,R,R).
myAdd(1,RR,R):- R is RR + 1.

allColor(_,_,0,R,R).
allColor(Tablero,C,W,RR,R):-
	nth1(W,Tablero,L),
	findall(X,(member(X,L),equalF(X,C)),[_:B]),
	equals(B,0,RE),
	myAdd(RE,RR,RA),
	NW is W - 1,
	allColor(Tablero,C,NW,RA,R).

%decir si las casillas del color C estan ocupadas en Tablero
allColor(Tablero,C,R):-
	length(Tablero,W),
	writeln('asdjkashdkjashd'),
	allColor(Tablero,C,W,0,NR),
	writeln('asdjkashdkjashdxxxxxxxxxxxxxxxxxxxx'),

	equals(W,NR,RE),
	binaryNot(RE,R).

busyF(_:X):- 1 is X.

completeLines(_,0,R,R).
completeLines(Tablero,W,RR,R):-
	NW is W - 1,
	%consecutiveLine(Tablero,NW,0,RCL),
	nth0(NW,Tablero,L),
	findall(X,(member(X,L),busyF(X)),B),
	length(B,RCL),
	equals(RCL,5,RE),
	binaryNot(RE,RN),
	NRR is RR + RN,
	completeLines(Tablero,NW,NRR,R).

%dado un tablero da la cantidad de filas completas
completeLines(Tablero,R):-
	length(Tablero,W),
       	completeLines(Tablero,W,0,R).

completeColumns(_,0,R,R).
completeColumns(Tablero,W,RR,R):-
	NW is W - 1,
	%consecutiveColumn(Tablero,NW,0,RCC),
	%nth0(NW,Tablero,L),
	getColumn(Tablero,NW,L),
	findall(X,(member(X,L),busyF(X)),B),
	length(B,RCC),
	equals(RCC,5,RE),
	binaryNot(RE,RN),
	NRR is RR + RN,
	completeColumns(Tablero,NW,NRR,R).

%dado un tablero da la cantidad de columnas completadas
completeColumns(Tablero,R):-
	length(Tablero,W),
	completeColumns(Tablero,W,0,R).

completeColors(_,0,R,R):- print(R), writeln('Resultado final') ,read(_) .
completeColors(Tablero,W,RR,R):-

		writeln('Tablero para contar los colores'),
	print(Tablero),
		writeln('W'),
	print([W]),
	%read(_),
	NW is W - 1,
	allColor(Tablero,W,RA),
	writeln('cantidad de colores completos en el Tablero'),
	print([RA]),

	%read(_),
	NRR is RR + RA,
	writeln('NW'),
	print(NW),
	read(_),
	completeColors(Tablero,NW,NRR,R).

t2(L,R):-
	t1(L,1,A),
	t1(L,2,AM),
	t1(L,3,N),
	t1(L,4,RO),
	t1(L,5,RA),R is A + AM + RO + N + RA.

t1(L,Q,R):-
	findall(Y,(member(X,L) , member(Y,X) , equalF(Y,Q) , busyF(Y) ),W),
	length(W,LW),equals(LW,5,RE),binaryNot(RE,R).



completeColor(Tablero,X,R):-
	nth0(0,Tablero,L0),
	nth0(1,Tablero,L1),
	nth0(2,Tablero,L2),
	nth0(3,Tablero,L3),
	nth0(4,Tablero,L4),

	getColorPos(L0,X,P0),
	NP0 is P0 - 1,
	getColorPos(L1,X,P1),
	NP1 is P1 - 1,

	getColorPos(L2,X,P2),
NP2 is P2 - 1,

	getColorPos(L3,X,P3),
NP3 is P3 - 1,

	getColorPos(L4,X,P4),
NP4 is P4 - 1,

	%isBusy(Tablero,)
	busyCell(Tablero,0,NP0,B0),
	busyCell(Tablero,1,NP1,B1),
	busyCell(Tablero,2,NP2,B2),
busyCell(Tablero,3,NP3,B3),
busyCell(Tablero,4,NP4,B4),
	S is B0 + B1 + B2 + B3 + B4,
	equals(S,5,RE),binaryNot(RE,R)
	.

completeColors1(Tablero,R):-
	completeColor(Tablero,1,A),
	completeColor(Tablero,2,AM),
	completeColor(Tablero,3,RO),
	completeColor(Tablero,4,N),
	completeColor(Tablero,5,RA),
	R is A + AM + RO + N + RA.

%dado un tablero da la cantidad de colores completos
completeColors(Tablero,R):-
		writeln('Tablero para contar asdjkhaskjdhaksjdhaskjdhkasjdhasjkd'),
		print(Tablero),
	%allColor(Tablero,1,A),

	nth1(1,Tablero,L0),
	nth1(2,Tablero,L1),
	nth1(3,Tablero,L2),
	nth1(4,Tablero,L3),
	nth1(5,Tablero,L4),


	writeln('Coji las lineas'),
	%	print(Tablero),

	findall(X,(member(X,L0),equalF(X,1)),[_:BA0]),
	findall(X,(member(X,L1),equalF(X,1)),[_:BA1]),
	findall(X,(member(X,L2),equalF(X,1)),[_:BA2]),
	findall(X,(member(X,L3),equalF(X,1)),[_:BA3]),
	findall(X,(member(X,L4),equalF(X,1)),[_:BA4]),

	writeln('coji los elementos 1'),
		print(BA0),

	equals(BA0,0,RE0),
	writeln('coji los elementos 1-1'),
		print(RE0),
	equals(BA1,0,RE1),
	equals(BA2,0,RE2),
	equals(BA3,0,RE3),
	equals(BA4,0,RE4),
	RBA is RE0 + RE1 + RE2 + RE3 + RE4,
	equals(RBA,5,A),

	writeln('coji los elementos 1-as,dmaksd'),

	findall(X,(member(X,L0),equalF(X,2)),[_:BAM0]),
	findall(X,(member(X,L1),equalF(X,2)),[_:BAM1]),
	findall(X,(member(X,L2),equalF(X,2)),[_:BAM2]),
	findall(X,(member(X,L3),equalF(X,2)),[_:BAM3]),
	findall(X,(member(X,L4),equalF(X,2)),[_:BAM4]),

	writeln('coji los elementos 2'),
	%	print(Tablero),

	equals(BAM0,0,RE00),
	equals(BAM1,0,RE11),
	equals(BAM2,0,RE22),
	equals(BAM3,0,RE33),
	equals(BAM4,0,RE44),
	RBAM is RE00 + RE11 + RE22 + RE33 + RE44,
	equals(RBAM,5,AM),

	findall(X,(member(X,L0),equalF(X,1)),[_:BRO0]),
	findall(X,(member(X,L1),equalF(X,1)),[_:BRO1]),
	findall(X,(member(X,L2),equalF(X,1)),[_:BRO2]),
	findall(X,(member(X,L3),equalF(X,1)),[_:BRO3]),
	findall(X,(member(X,L4),equalF(X,1)),[_:BRO4]),

	equals(BRO0,0,RE000),
	equals(BRO1,0,RE111),
	equals(BRO2,0,RE222),
	equals(BRO3,0,RE333),
	equals(BRO4,0,RE444),
	RBRO is RE000 + RE111 + RE222 + RE333 + RE444,
	equals(RBRO,5,RO),

	findall(X,(member(X,L0),equalF(X,1)),[_:BN0]),
	findall(X,(member(X,L1),equalF(X,1)),[_:BN1]),
	findall(X,(member(X,L2),equalF(X,1)),[_:BN2]),
	findall(X,(member(X,L3),equalF(X,1)),[_:BN3]),
	findall(X,(member(X,L4),equalF(X,1)),[_:BN4]),

	equals(BN0,0,RE0000),
	equals(BN1,0,RE1111),
	equals(BN2,0,RE2222),
	equals(BN3,0,RE3333),
	equals(BN4,0,RE4444),
	RBN is RE0000 + RE1111 + RE2222 + RE3333 + RE4444,
	equals(RBN,5,N),

	findall(X,(member(X,L0),equalF(X,1)),[_:BRA0]),
	findall(X,(member(X,L1),equalF(X,1)),[_:BRA1]),
	findall(X,(member(X,L2),equalF(X,1)),[_:BRA2]),
	findall(X,(member(X,L3),equalF(X,1)),[_:BRA3]),
	findall(X,(member(X,L4),equalF(X,1)),[_:BRA4]),

	equals(BRA0,0,RE00000),
	equals(BRA1,0,RE11111),
	equals(BRA2,0,RE22222),
	equals(BRA3,0,RE33333),
	equals(BRA4,0,RE44444),
	RBRA is RE00000 + RE11111 + RE22222 + RE33333 + RE44444,
	equals(RBRA,5,RA),



	R is A + AM + RO + N + RA,
	writeln('Cantidad de colores completos'),
	writeln(R),
	read(_)


	%completeColors(Tablero,5,0,R).
	.

toUpdate(Tablero,_,-1,Tablero).
toUpdate(Tablero,I,Z,NTablero):-
	nth0(I,Tablero,L),
%	print(L),
	%writeln(''),
	NI is I + 1,
	getColorPos(L,Z,J),
	replaceXY(Tablero,NI,J,Z:1,NTablero).%,print(NTablero),writeln('').

updateBoard(Tablero,0,_,Tablero).
updateBoard(Tablero,W,L,NTablero):-
	I is 5 - W,
	selectchk(Z,L,RL),
	toUpdate(Tablero,I,Z,RTablero),
	%getColorPos(,Z,J)
	NW is W - 1,
	updateBoard(RTablero,NW,RL,NTablero).


printT(_,0).
printT(L,W):-
	NW is W - 1,
	selectchk(Z,L,RL),
	print(Z),
	writeln(''),
	printT(RL,NW).

printT(L):-
	length(L,W),
	printT(L,W).

%actualiza el tablero

%L es una lista de tamaño 5 que contiene un color c o -1 ,EJ : [1,2,-1,1,-1]
updateBoard(Tablero,L,NTablero):-
	updateBoard(Tablero,5,L,NTablero),printT(NTablero).




getColor(E,0,R):-
	selectchk(R,E,_).
getColor(_,_,R):- R is -1.


procces(Z,R):-
	getFreeSpaces(Z,RFP),
	equals(RFP,0,RE),
	getColor(Z,RE,R).

getFullLines(_,0,R,R).
getFullLines(PL,W,RR,R):-
	NW is W - 1,
	selectchk(Z , PL , RPL),
	procces(Z,NR),
	append(RR,[NR],NRR),
	getFullLines(RPL,NW,NRR,R).

%dado el patterLine devuelve una lista de las lozas q estan listas para
%ubicar en el tablero,L = [1,2,-1,1,-1]
getFullLines(Pl,L):-
	getFullLines(Pl,5,[],L).


toSum1(1,R,R).
toSum1(R,1,R).
toSum1(R1,R2,R):- R is R1 + R2.

toSum(_,_,-1,R):-R is 0.
toSum(Tablero,I,Z,R):-
	nth0(I,Tablero,L),
	getColorPos(L,Z,J),
	NJ is J - 1,
	consecutiveLine(Tablero,I,NJ,RCL),
	%print(RCL),
	consecutiveColumn(Tablero,NJ,I,RCC),
%	print(RCC),
	toSum1(RCL,RCC,R).
	%R is RCL + RCC .


sumPointsOfMove(_,_,0,R,R).
sumPointsOfMove(Tablero,L,W,RR,R):-
%	print(Tablero),
	%writeln(''),
	NW is W - 1,
	I is 5 - W,
	selectchk(Z,L,RL),
	toSum(Tablero,I,Z,RS),
	%print(RS),
	%writeln(''),
	%NI is I + 1,
	%toReplace(Tablero,NI,Z,NTablero),
	toUpdate(Tablero,I,Z,NTablero),
	NRR is RR + RS ,
	%print(NRR),
	%writeln(''),
	sumPointsOfMove(NTablero,RL,NW,NRR,R).



sumPointsOfMove(Tablero,L,R):-
	length(L,W),
	sumPointsOfMove(Tablero,L,W,0,R).

%metodo para dada una lista dar el valor de los negativos
getNegativeSum(0,R):- R is 0.
getNegativeSum(1,R):- R is -1.
getNegativeSum(2,R):- R is -2.
getNegativeSum(3,R):- R is -4.
getNegativeSum(4,R):- R is -6.
getNegativeSum(5,R):- R is -8.
getNegativeSum(6,R):- R is -11.
getNegativeSum(_,R):- R is -14.



%suma los puntos al finalizar una ronda

sumPoints(Tablero,PL,NL,R):-
	printT(Tablero),
	writeln('tablero inicial'),
	%read(_),
	getFullLines(PL,FL),


        printT(FL),
	writeln('lineas completas en el PatterLine'),
	%read(_),

	completeLines(Tablero,CL),
	print([CL]),
	writeln('lineas completas en el tablero inicial'),
	%read(_),
	completeColumns(Tablero,CC),
	print([CC]),
	writeln('columnas completas en el tablero inicial'),
	%read(_),
	%completeColors1(Tablero,CCl),
	t2(Tablero,CCl),
	print([CCl]),
	writeln('colores completos en el tablero inicial'),
	%read(_),
	sumPointsOfMove(Tablero,FL,RS),
	print([RS]),
	writeln('suma de los puntos de un movimiento'),
	%read(_),
	updateBoard(Tablero,FL,NTablero),
	printT(NTablero),
	writeln('nuevo Tablero'),
	%read(_),
	completeLines(NTablero,CL1),
	completeColumns(NTablero,CC1),
	%completeColors1(NTablero,CCl1),
	t2(Tablero,CCl1),
	NCL is CL1 - CL,
	NCC is CC1 - CC,
	NCCl is CCl1 - CCl,
	length(NL,LNL),
	getNegativeSum(LNL,SNL),
	R is max(RS + (NCL * 2) + (NCC * 7) + SNL  + (NCCl * 10) , 0 ), %(NCCl * 10) + SNL,0),
	write(R),writeln(' nueva suma')%,
	%read(_)
	.


isM1f(X):- -1 is X.

makeList(0,R,R).
makeList(LI,RR,R):-
	NLI is LI - 1,
	append(RR,[-1],NRR),
	makeList(NLI,NRR,R).

getLine(R,_,0,R).
getLine(_,LI,_,R):-
	makeList(LI,[],R).

updatePatterLine(_,0,R,R).
updatePatterLine(PL,W,RR,R):-
	I is 5 - W,
	nth0(I,PL,L),
	length(L,LI),
	%print(L),
	findall(X,(member(X,L),isM1f(X)),RW),
	%print(RW),
	length(RW,LW),
	equals(LW,0,RE),
	binaryNot(RE,RBN),
	getLine(L,LI,RBN,NL),
	append(RR,[NL],NRR),
	NW is W - 1,
	updatePatterLine(PL,NW,NRR,R).
	%fillM1Line()

% metodo para actualizar el patternLine
%esta actualizacion es para despues de
%realizar el movimiento al tablero
updatePatternLine(PL,R):-
	updatePatterLine(PL,5,[],R1),printT(R1),
	getTeilsFromPatternLine(PL,R2),
	R = [ R1 ,R2].

getTeilsFromPatternLine(_,0,R,R).
getTeilsFromPatternLine(PL,W,RR,R):-
	selectchk(Z,PL,L),
	NW is W - 1,
	length(Z , LL ),
	nth0(0,Z,E),
	NL is LL - 1,
	findall(X,(member(X,Z),isM1f(X)),RW),
	length(RW,LW),
	equals(LW,0,RE),
	binaryNot(RE,RBN),
	(   RBN > 0 -> addElements(RR,NL,E,NR) ; NR = RR ),
	getTeilsFromPatternLine(L,NW,NR,R).

getTeilsFromPatternLine([_|PL],R):-
	getTeilsFromPatternLine(PL,4,[],R).

winner(_,0,R,_,_,R).
winner(L,LW,CW,P,CWP,R):-
	NLW is LW - 1,
	NP is P + 1,
	selectchk(Z,L,RL),
	( Z > CWP -> K is P ; K is CW   ),
	NCWP is max(Z,CWP),
	winner(RL,NLW,K,NP,NCWP,R).

%ganador
%pero se puede ver como el maximo de una lista
winner(L,R):-
	length(L,LW),
	NLW is LW - 1,
	selectchk(Z,L,RL),
	winner(RL,NLW,0,1,Z,R).

isEnd(_,_,0,R,R).
isEnd(L,LWO,LW,RR,R):-
	I is LWO - LW ,
	NW is LW - 1,
	nth0(I , L , RL),
	completeLines(RL,CL),
	%print(CL),
	(   CL > 0 -> K is 1,NRR is 1,K1 is 0 ; K is 0,K1 is NW,NRR is RR),
%	print(K1),
	isEnd(L,LWO,K1,NRR,R).


%dada una lista de tableros de jugadores decir si se acabo el juego
isEnd(L,X):-
	length(L,LW),
	isEnd(L,LW,LW,0,X).

board(X):- X = [[1:0,2:0,3:0,4:0,5:0],
		[5:0,1:0,2:0,3:0,2:0],
		[4:0,5:0,1:0,2:0,3:0],
		[3:0,4:0,5:0,1:0,2:0],
		[2:0,3:0,4:0,5:0,1:0]].

patterLine(X):- X =[[-1],
		    [-1,-1],
		    [-1,-1,-1],
		    [-1,-1,-1,-1],
		    [-1,-1,-1,-1,-1]].

bug(X):- X = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
	      3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
	      4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
	      5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5].

init(2,R):-
	board(BJ0),
	board(BJ1),
	patterLine(PLJ0),
	patterLine(PLJ1),
	bug(B),factories(B,RB),
	printT(BJ0),
	writeln(''),
	printT(BJ1),
	writeln(''),
	printT(PLJ0),
	writeln(''),
	printT(PLJ1),
	writeln(''),
	play([[BJ0,PLJ0,[],0],[BJ1,PLJ1,[],0]],RB,5,[-1],[],R).

init(3,R):-
	board(BJ0),
	board(BJ1),
	board(BJ2),
	patterLine(PLJ0),
	patterLine(PLJ1),
	patterLine(PLJ2),
	bug(B),factories(B,RB),
	printT(BJ0),
	writeln(''),
	printT(BJ1),
	writeln(''),
	printT(BJ2),
	writeln(''),
	printT(PLJ0),
	writeln(''),
	printT(PLJ1),
	writeln(''),
	printT(PLJ2),
	writeln(''),
	play([[BJ0,PLJ0,[],0],[BJ1,PLJ1,[],0],[BJ2,PLJ2,[],0]],RB,7,[-1],[],R).

init(4,R):-
	board(BJ0),
	board(BJ1),
	board(BJ2),
	board(BJ3),
	patterLine(PLJ0),
	patterLine(PLJ1),
	patterLine(PLJ2),
	patterLine(PLJ3),
	bug(B),factories(B,RB),
	printT(BJ0),
	writeln(''),
	printT(BJ1),
	writeln(''),
	printT(BJ2),
	writeln(''),
	printT(BJ3),
	writeln(''),
	printT(PLJ0),
	writeln(''),
	printT(PLJ1),
	writeln(''),
	printT(PLJ2),
	writeln(''),
	printT(PLJ3),
	writeln(''),
	play([[BJ0,PLJ0,[],0],[BJ1,PLJ1,[],0],[BJ2,PLJ2,[],0],[BJ3,PLJ3,[],0]],RB,9,[-1],[],R).



isColorF(C,X):- C is X.

colorAndRest(L,C,W,I,S,RR,R):-
	findall(X ,(member(X,L),isColorF(C,X)),T),
	length(T,LT),
	(   LT > 0 ->
	    findall(X ,(member(X,L),not(isColorF(C,X)) , not(isM1f(X)) ),RT),

	    append(RR,[[S,W,I,C:LT,RT]],R)

	; R = RR

	).




%dada un factoria o el ground genera una lista de elementos
%%[S,F/G , I , C : X , R]
getColorsOfFact(L,I,W,R):-
	findall(X ,(member(X,L), isM1f(X)),T),
	length(T,LT),
	(   LT > 0 -> S is 1 ; S is 0),
	colorAndRest(L,1,W,I,S ,[],AR),
	colorAndRest(L,2,W,I,S ,AR,AMR),
	colorAndRest(L,3,W,I,S ,AMR,RR),
	colorAndRest(L,4,W,I,S ,RR,NR),
	colorAndRest(L,5,W,I,S ,NR,R).

getColorList(_,_,0,_,R,R).

getColorList(L,LL,I,W,RR,R):-
	RI is LL - I,
	nth0(RI,L,RL),
	getColorsOfFact(RL,RI,W,CFL),
	append(RR,CFL,NRR),
	NI is I - 1,
	getColorList(L,LL,NI,W,NRR,R).

%generara por cada lista una series de elementos
%[S,F/G , I , C : X , R]
%S si la lista contiene -1
%F/G 1 si es de F , 0 si es de G
%I indice en F
%C color
%X cantidad del color
%R es todos los demas lozas q no son de ese color en ese elemento
getColorList(L , W , R):-
	length(L,LL),
	getColorList(L,LL,LL,W,[],R).


%dado un elemento [S,F/G , I , C : X , R]
 %genera [[[S,F/G , I , C : X , R],I1],[[S,F/G , I , C : X , R],I2],[[S,F/G , I , C : X , R],IN]]
%para todos los I del patterLine donde se pueda poner dicho elemento
%I esta en base 0
getAviableLinesForAElement(_,_,_,0,R,R).
getAviableLinesForAElement(B,E,PTL,W,RR,R):-
	        NW is W - 1,
		I is 5 - W,
		%nht0(I,PTL,L)
		%aqui va la parte de verificar

		nth0(3,E,C:_),

		%poner un elemento en la columna x del patternLine
		%base 0
		canPutElementInPattern(B,PTL,I, C ,CPER),
		(   CPER > 0  ->  H = [E , I] ,
		    append(RR,[H],NRR),
		    getAviableLinesForAElement(B,E,PTL,NW,NRR,R);
		    getAviableLinesForAElement(B,E,PTL,NW,RR,R) )

		.


getAviableLines(_,_,0,_,R,R).
getAviableLines(B,L,LL,PTL,RR,R):-
	NLL is LL - 1,
	selectchk(Z,L,RL),
	getAviableLinesForAElement(B,Z,PTL,5,[],AVE),
	append(RR , AVE , NRR),
	getAviableLines(B,RL,NLL,PTL,NRR,R).

%Dada una lista de las combinaciones de de colores extraidas de
%las fabricas y el suelo
%devuelve todas las resalmente posibles
getAviableLines(B,PTL,L ,R):-
	length(L,LL),
	getAviableLines(B,L,LL,PTL,[],R).

%añande el elemento E ,W veces a
%la lista L,los añade por alante
addElements(R,0,_,R).
addElements(L,W,E,R):-
	NW is W - 1,
	Y = [E],
	append(Y,L,NL),
	addElements(NL,NW,E,R).


%actualiza una lista de listas PL
%cambiando su Iesima fila por NL
updateLineInPatterLine(PL,I,NL,R):-
	getFirst(I,PL,FPL),
	NI is I + 1,
	eraseFirstN(NI,PL ,RPL),
	append(FPL,[NL],FPL1),
	append(FPL1,RPL,R).


%actualiza el patternLine
%notifica los cambios a realizar en
%las factories o ground
move(P,CM,R):-
	nth0(0,P,B),
	nth0(1,P,PL),
	nth0(2,P,NL),
	nth0(3,P,PO),
	nth0(0,CM,CM1),
	nth0(1,CM,IND),

	nth0(0,CM1,S),
	nth0(1,CM1,FG),
	nth0(2,CM1,I),
	nth0(3,CM1,C:X),
	nth0(4,CM1,RL),

	nth0(IND,PL,L),
	getFreeSpaces(L,FREE),
	addElements(NL,S,-1,NNL),
	(   FREE > X -> reverse(L,ReL),eraseFirstN(X,ReL,LL),reverse(LL,ReL1) ,addElements(ReL1,X,C,NPL),NNL1 = NNL ;
	    TNL is X - FREE ,
	    addElements(NNL,TNL,C,NNL1),
	    reverse(L,ReL),eraseFirstN(FREE,ReL,LL),reverse(LL,ReL1),
	    addElements(ReL1,FREE,C,NPL)

	),


	%putElementsInPatternLine(L,TNL,C,NLP),
	updateLineInPatterLine(PL,IND,NPL,NPL1),
	R = [ [B , NPL1 , NNL1 , PO] , FG , I , RL ]
	.


%directToGRound(P,M,R).

%metodo del movimiento de un player
%R = [ NP , F ,G]
%NP es el player actualizado
%F las factories actualizadas
%G ground actualizado
makeMove(P,I,F,G,R):-
	%length(F,LF),
	%length(G,LG),

	aviableFactories(F,LF),
	lengthOfGround(G,LG),


	SL is LF + LG ,
	%print("Turno del player "),
	%print(I),

	write(' Turno del Player '),write(I),writeln(''),

	(   SL > 0 -> print("Hay lozas "),
	    writeln(''),
	    getColorList(F,0,CL),
	    getColorList([G],1,CL1),
	    append(CL,CL1,CL2),
	    nth0(1,P,PTL),
	    nth0(0,P,PB),
	    getAviableLines(PB,PTL,CL2,AM),
	    writeln('Movimientos Aviables'),
	    factories(AM,RAM),
	    print(RAM),
	    writeln(''),
	    print(CL2),
	    writeln(''),
	   % read(_),

	    length(RAM,LRAM),
	    (	LRAM > 0 ->

	    nth0(0,RAM , CM),
	    move(P,CM,MoR),
	    nth0(0,MoR , NP),
	    nth0(1,MoR , FG),
	    nth0(2,MoR , MorI),
	    nth0(3,MoR , MorRL),
	    (	FG > 0 -> NF = F , NG = MorRL ;
	        updateLineInPatterLine(F,MorI,[],NF),
		append(G , MorRL ,NG)
	    ),

	    R = [ NP , NF , NG ]%,
	     %writeln('Result of Move'),
	    %print(R)%,
	    %read(_)
	    ;
	     selectchk(FCL2,CL2,_),
	     %append(FCL2,[-1],FCLM),
	     %directToGround(P,FCLM),
		nth0(3,FCL2,CCL2:CACL2),

		nth0(0,P,CL2P),
		nth0(1,P,CL2PL),
		nth0(2,P,CL2NL),
		nth0(3,P,CL2PO),

		addElements(CL2NL,CACL2,CCL2,NCL2NL),
		NP1 = [ CL2P , CL2PL, NCL2NL  , CL2PO ],


		nth0(1,FCL2,PFCL2),
		nth0(2,FCL2,IFCL2),
		nth0(4,FCL2,FCL2G),
		%es decir que tome del suelo si PFCL" > 0
		(  PFCL2 > 0 ->  NF1 = F , NG1 = FCL2G;
		   updateLineInPatterLine(F,IFCL2,[],NF1),
		   append(G , FCL2G ,NG1)
		),

		R = [ NP1 , NF1 ,NG1 ]
	    )
	    % actualizar F y G segun sea CM
	    % R = [ NP , F , G ]


	;
	   % print("No hay Lozas"),
	   writeln('LLegue akiiiiiiiiiiiiiiiiiiiiiiiiii'),
	    print(G),
	    writeln('Last Ground'),

	    print(F),
	    writeln('Last Factories'),

	    %read(_),
	    R = [ P , F ,  G ]
	)


	.

makeMoves(_,_,0,F,G,RML,R):-

	 writeln('LLegue 8888888888'),
	    print(G),
	    writeln('Current Ground'),

	    print(F),
	    writeln('Current Factories'),

	    print(RML),
	    writeln('Current Players'),

	   % read(_),

	R = [RML , F , G ].

%makeMoves(_,_,0,_,_,R,R).


makeMoves(LP,LLP,W,F,G,RML,R):-
	I is LLP - W,
	NW is W - 1,
%	print("here making Moves"),
	%writeln(''),
	nth0(I,LP,P),

	writeln('HERE MAKKING MOVES'),
	writeln('ground1111'),
	print(G),
	%HERE MAKKING MOVES
	writeln(''),
	writeln('factoires1111'),
	print(F),
	%HERE MAKKING MOVES
	writeln(''),



	makeMove(P,I,F,G,PMR),
	nth0(0,PMR,NP),
	nth0(1,PMR,NF),
	nth0(2,PMR,NG),
	append(RML,[NP],NRML),
	%print(NRML),
	%read(_),
	makeMoves(LP,LLP,NW,NF,NG,NRML,R)
	.
%metodo de realizar jugadas hasta que las factories esten vacias

%cada player Realiza una jugada
makeMoves(LP,F,G,ML):-
	length(LP,LLP),

	write(' Realizando una ronda de movimientos '),
		write(LLP),	writeln(' cantidad de juagores'),

	makeMoves(LP,LLP,LLP,F,G,[],ML).

aviableFactories(_,0,R,R).
aviableFactories(L,W,RR,R):-
	selectchk(Z,L,RL),
	NW is W - 1,
	length(Z,LZ),
	(   LZ > 0 -> NRR is RR + 1 ; NRR is RR),
	aviableFactories(RL,NW,NRR,R).



aviableFactories(X,R):-
	length(X,XL),
	aviableFactories(X,XL,0,R).

lengthOfGround([],R):-R is 0.
lengthOfGround(_,R):-R is 1.


makeRound(LP,F,G,ML):-
	aviableFactories(F,LF),
	%length(F,LF),
	%length(G,LG),
	lengthOfGround(G,LG),

	write('RONDADADADADADADAAD'),
	    writeln(''),
	   %read(_),
	   print(LP),
	   %read(_),
	   %writeln(''),
	   %print()

	S is LG + LF ,
	       write(LG),
		write(' ,eso anterior fue LG ,Estoy en la Ronda hay '),
		write(LF),	writeln(' factories'),
		print(G),
		writeln(' GROUNDDDDDDDD'),


	(  S > 0 -> makeMoves(LP,F,G,RML),
	   nth0(0,RML,LP1),
	   nth0(1,RML,F1),
	   nth0(2,RML,G1),
	   makeRound(LP1,F1,G1,ML) ;
	    write('Se acabo la ronda'),
	    writeln(''),
	  % read(_),
	   ML = [ LP , F , G ],
	   print(ML)%,
	  % read(_)

	).


%metodo que devuelve el ganador del juego
endGame(LP1,R):-
	%length(LP1,LLP1),
	%getPointsList(LP1,LLP1,LLP1,[],LPo),
	getElementsOfPlayers(LP1,3,LPo),
	winner(LPo,R).


%devuelve los tableros de los jugadores
%este metodo se puede factorizar con el getPointList
%añadiendole un indice que seria donde buscar en el jugardor
%getBoards(LP,R):-
%	length(LP,LLP),
%	getBoards(LP,LLP,LLP,[],R).

getElementsOfPlayers(_,_,0,_,R,R).
getElementsOfPlayers(LP,LLP,W,E,RR,R):-
	I is LLP - W,
	NW is W - 1,
	nth0(I,LP,Z),
	%print(Z),
	nth0(E,Z,B),
	append(RR,[B],NRR),
	getElementsOfPlayers(LP,LLP,NW,E,NRR,R).

%devuelve una lista con el elemento E de todos los players
getElementsOfPlayers(LP,E,R):-
%	print(LP),
	%print(E),
	writeln('Consultando elementos'),
	length(LP,LLP),
	getElementsOfPlayers(LP,LLP,LLP,E,[],R),writeln('tERMINE DE CONSULTAR').


updateNBug(R,_,0,R).
updateNBug(NB,GS,W,R):-
	NW is W - 1,
	selectchk(Z,GS,RGS),
	findall(X ,(member(X,Z) , not(isM1f(X))) , L),
	append(NB,L,NNB),
	updateNBug(NNB,RGS,NW,R).

%actualiza la tapa de la caja,fichas que
%se introduciran a la bolsa una vez que esta
%no tenga mas
updateNBug(NB,GS,R):-
	length(GS,LGS),
	updateNBug(NB,GS,LGS,R).

updatePlayer(P,R):-
	nth0(0,P,B),
	nth0(1,P,PL),
	nth0(2,P,NL),
	nth0(3,P,PO),



        printT(B),
	writeln('ggg'),
	%read(_),
	printT(PL),
	writeln('dd'),
	%read(_),
	printT(NL),
	writeln('iii'),
	%read(_),
	printT([PO]),
	writeln('aaa'),
	%read(_),


	sumPoints(B,PL,NL,SP),
	NPO is PO + SP ,

	%	writeln('aaa123123'),
	printT([NPO]),
%
	writeln('Nueva puntuacion'),
	%read(_),
%

	updatePatternLine(PL,UPL),
	%	writeln('aaa55555'),
	nth0(0,UPL,NPL),
	nth0(1,UPL,NR),

	printT(NPL),
	writeln('ffffggg'),
	%read(_),

	printT(NR),
	writeln('hhhhggg'),
	%read(_),


	getFullLines(PL,FL),
	updateBoard(B,FL,NB),
%		writeln('aaa444'),
	R = [ [NB , NPL , [] , NPO ] , NR ],
	 print(R),	writeln('UPDATETTETETETETET')%, read(_)
	.




updatePlayers(_,0,RR,GR,R):- R = [RR , GR] , print(R),	writeln('players actualizados answer').%, read(_).
updatePlayers(LP,W,RR,GR,R):-



	writeln('actualizado'),
	writeln('lista de Players'),
	print(LP),
	%read(_),
	writeln('longitud lista de Players'),
	write(W),
	%read(_),
	writeln('lista de Nuevos Players'),
	print(RR),
	%read(_),
	writeln('lista suelos que van dejando los Players'),
	print(GR),
	%read(_),


	NW is W - 1,
	selectchk(Z , LP,RLP),
	updatePlayer(Z,NZ),
	 print(NZ),	writeln('players actualizado'),% read(_),
	nth0(0,NZ,NP),
	nth0(1,NZ,NR),
	append(GR,NR,NGR),
	append(RR,[NP],NRR),
	updatePlayers(RLP,NW,NRR,NGR,R).

updatePlayers(LP,R):-
	length(LP,LLP),
		writeln('actualizando  players'),
	updatePlayers(LP,LLP,[],[],R).

%LP lista de jugadores
%B bolsa
%LF cantidad de factorias
%G piso
%NB lozas acumuladas para rellenar la bolsa
play(LP,B,LF,G,NB,R):-
	length(LP,LLP),
	write('Partida con '),
        print(LLP),
	write(' jugadores y con '),
        print(LF),
	write(' fabricas!!!!'),
	writeln(''),
	getFirstNTimes(LF,4,B,F),
	print(F),
	writeln('ESTas fueron las fabricas'),
	eraseFirstN(LF,B,RB),

	writeln('Elimine Las lozas puestas en las fabrizas de la bolsa'),

	makeRound(LP,F,G,MR),

	print(MR),
	writeln('Hice una Ronda'),
	%read(_),

	%makeMoves(LP,F,G ,ML),
	%nth0(1,ML,NG),
	nth0(0,MR,LP1),

	print(LP1),
	writeln('lo que devolvio la ronda'),
	%read(_),

	%sumar los puntos
	%actualizar lista

	%en verdad lo q se añade a la nueva bolsa es lo que esta en el suelo de cada jugador
	%seria getElementsOfPlayers(LP1,2,Grounds)
	%luego de esto queda actualizar los suelos de todos los players a []

	getElementsOfPlayers(LP1,2,Grounds),

	print(Grounds),
	writeln('los suelos de la ronda anterior'),
	%read(_),

	%updatesGrounds(LP1,LP2),
	length(LP1,QQ),
	print([QQ]),
	writeln('len de LP1'),
	%read(_),
	updatePlayers(LP1,UP),
	nth0(0,UP,LP2),

	length(LP2,QQ1),
	print([QQ1]),
	writeln('len de LP2'),
	%read(_),


	print(LP2),
	writeln('players actualizados'),
	%read(_),

	nth0(1,UP,MoreGrounds),

	append(Grounds,[MoreGrounds],NGrounds),

	print(NGrounds),
	writeln('suelos actualiazos'),
	%read(_),

	updateNBug(NB,NGrounds,NB1),

	print(NB1),
	writeln('nueva tapa de la caja'),
	%read(_),

	writeln('Obteniendo Tableros'),
	%getElementsOfPlayers(LP2,0,Boards),

	%findall(X,(member(X,LP2) ) , Boards),

	f(LP2,Boards),

	%write('asdasdasd'),
	print(Boards),
	%write('ñññadlasñdlsa'),
	writeln('tableros de los jugadores tras la ronda'),
	%read(_),

	isEnd(Boards,End),
	(   End > 0 -> endGame(LP2,R);
	    length(RB,LRB),
	    equals(LRB,0,RE),
	    binaryNot(RE,RBN),
	   ( RBN > 0 ->
	     length(NB1,LNB),
	     equals(LNB,0,RE1),
	     binaryNot(RE1,RBN1),
	     (	 RBN1 > 0 -> endGame(LP2,R) ;
		 %findall(X ,(member(X , NG ), not(isM1f(X)) ) , W  ) ,
		 %append(NB,W,NNB),
	         factories(NB1,RNB), play(LP2,RNB , LF , [-1],[],R) )

	   ;
	   %findall(X ,(member(X , NG ), not(isM1f(X)) ) , W1  ) ,
	   %append(NB,W1,NB1),

	   writeln('no se ha acabado el juego aun'),
	   read(_),
	   play(LP2,RB,LF,[-1],NB1,R)

	   	   )

	)



	.


f(L,W):-
	findall(Y , (member(X,L) , nth0(0,X,Y) ) , W).

game(N,R):-
	init(N,R).














