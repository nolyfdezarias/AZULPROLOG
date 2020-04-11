

%%funciones de caracter general

%Dado un tablero y una posicon X y Y en base cero devuelve el elemento en dicha posicon
indexer(Tablero,X,Y,R):-
	nth0(X,Tablero,P),
	nth0(Y,P,R).

%devuelve una permutacion random de una lista
randomList(L,LL):-
	random_permutation(L,LL).

%elimina los primeros X elementos de una lista L
eraseFirstN(0,R,R).
eraseFirstN(X,L,R):-
	Y is X - 1,
	selectchk(_,L,LL),
	eraseFirstN(Y,LL,R).


%devuelve los primeros Y elementos de una lista L ,X veces
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

%devuelve los primeros X elementos de una lista L
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

%Dado un Tablero obtiene la X-esima columna en base 0
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

%remplaza la posicion X en una lista  L con el elemento E, X en  base 1
replaceX(L,X,E,R):-
	Y is X - 1,
	getFirst(Y,L,LL),
	append(LL,[E],NL),
	eraseFirstN(X,L,RL),
	append(NL,RL,R).

%addiciona todos los elementos de una Lista LL a una lista L
appendR1(R,_,0,R).
appendR1(L,LL,W,R):-
	NW is W - 1,
	selectchk(Z,LL,RLL),
	append(L,[Z],NL),
	appendR1(NL,RLL,NW,R).

appendR1(L,LL,R):-
	length(LL,W),
	appendR1(L,LL,W,R).

%remplaza la posicion X,Y en un Tablero con el elemento E ; X,Y  enbase 1
replaceXY(Tablero,X,Y,E,NTablero):-
	NX is X - 1,
	getFirst(NX,Tablero,L),
	eraseFirstN(NX,Tablero,NT),
	selectchk(Z,NT,RL),

	replaceX(Z,Y,E,R),

	append(L,[R],LL),

	appendR1(LL,RL,NTablero).


%casilla ocupada base 0
busyCell(Tablero,X,Y,R):-
	indexer(Tablero,X,Y,_:R).

%Devuelve 0  si 0  ,1 en cualquier otro caso
trueOrFalse(0,R):-R is 0.
trueOrFalse(_,R):-R is 1.

%retorna 0 si son iguales
%1 en otro cas0
equals(X,Y,R):-
	Z is X - Y ,
	trueOrFalse(Z,R).

%not binario
binaryNot(0,R):-R is 1.
binaryNot(1,R):-R is 0.

%a�ande el elemento E ,W veces a
%la lista L,los a�ade por alante
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


%imprime un Tablero
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
%%%%%%%%%%%%%
maxList(_,0,R,_,_,R).
maxList(L,LW,CW,P,CWP,R):-
	NLW is LW - 1,
	NP is P + 1,
	selectchk(Z,L,RL),
	( Z > CWP -> K is P ; K is CW   ),
	NCWP is max(Z,CWP),
	maxList(RL,NLW,K,NP,NCWP,R).


%devuelve el maximo de una lista
maxList(L,R):-
	length(L,LW),
	NLW is LW - 1,
	selectchk(Z,L,RL),
	maxList(RL,NLW,0,1,Z,R).




%%%
%crea una lista de de -1 de tamaño LI
makeList(0,R,R).
makeList(LI,RR,R):-
	NLI is LI - 1,
	append(RR,[-1],NRR),
	makeList(NLI,NRR,R).

%obitene una lista Lista de -1 de tamaño LI
getLine(R,_,0,R).
getLine(_,LI,_,R):-
	makeList(LI,[],R).
%%%%%%%%%%%


%%%%% metodos para sumar
%dado un tablero te la posicion de un color X en base 1
getColorPos(_,_,1,R,R).
getColorPos(L,X,_,Y,R):-
	NY is Y + 1,
	selectchk(Z:_,L,RL),

	equals(X,Z,RE),
	binaryNot(RE,RBN),
	getColorPos(RL,X,RBN,NY,R).


getColorPos(L,X,R):-
	getColorPos(L,X,0,0,R).

canPutElementInPattern1(_,_,_,0,R):-R is 0.
canPutElementInPattern1(Tablero,X,E,_,R):-
	nth0(X,Tablero,P),
	getColorPos(P,E,CP),

	NCP is CP - 1,
	busyCell(Tablero,X,NCP,BCR),binaryNot(BCR,R).




%poner un elemento en la columna x del patternLine
%base 0
canPutElementInPattern(Tablero,L,X,E,R):-
	nth0(X,L,P),
	canPutElement(P,E,RP),

	getFreeSpaces(P,RFS),
	(   RFS > 0 -> canPutElementInPattern1(Tablero,X,E,RP,R) ; R is 0).

%obtiene todos los espacios vacios ,donde vacio signifca -1
getFreeSpaces(L,R):-
	findall(X,(member(X,L),isEmpty(X)),W),
	length(W,R).

%cantidad de elementos consecuvitos no vacios en una linea
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
	getFirst(J,L,FL),
	reverse(FL,LF),
	consecutivos(LF,0,CL),
	X is J + 1,
	eraseFirstN(X,L,NL),
	consecutivos(NL,0,CR),
	R is CL + CR + 1.



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



%metodos para decir la cantidad de colores completos en un tablero
completeColors(L,R):-
	t1(L,1,A),
	t1(L,2,AM),
	t1(L,3,N),
	t1(L,4,RO),
	t1(L,5,RA),R is A + AM + RO + N + RA.

%determina si un color determinado esta completo en el tablero
t1(L,Q,R):-
	findall(Y,(member(X,L) , member(Y,X) , equalF(Y,Q) , busyF(Y) ),W),
	length(W,LW),equals(LW,5,RE),binaryNot(RE,R).






%obtener el color en una linea del PatternLine
getColor(E,0,R):-
	selectchk(R,E,_).
getColor(_,_,R):- R is -1.

%determinar si la cantidad de espacios vacios de una linea del PatterLine es igual a 0
procces(Z,R):-
	getFreeSpaces(Z,RFP),
	equals(RFP,0,RE),
	getColor(Z,RE,R).
%%%%%%%
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

%metodo auxiliar para la suma
toSum1(1,R,R).
toSum1(R,1,R).
toSum1(R1,R2,R):- R is R1 + R2.


%dada una posicion I,Z determina cuantos puntos se alcanzan
toSum(_,_,-1,R):-R is 0.
toSum(Tablero,I,Z,R):-
	nth0(I,Tablero,L),
	getColorPos(L,Z,J),
	NJ is J - 1,
	consecutiveLine(Tablero,I,NJ,RCL),

	consecutiveColumn(Tablero,NJ,I,RCC),

	toSum1(RCL,RCC,R).
	%R is RCL + RCC .


sumPointsOfMove(_,_,0,R,R).
sumPointsOfMove(Tablero,L,W,RR,R):-
	NW is W - 1,
	I is 5 - W,
	selectchk(Z,L,RL),
	toSum(Tablero,I,Z,RS),

	toUpdate(Tablero,I,Z,NTablero),
	NRR is RR + RS ,

	sumPointsOfMove(NTablero,RL,NW,NRR,R).


%calcula los puntos de un movimiento determinado
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
	%printT(Tablero),
	%writeln('tablero inicial'),
	%read(_),
	getFullLines(PL,FL),


        %printT(FL),
	%writeln('lineas completas en el PatterLine'),


	completeLines(Tablero,CL),
	%print([CL]),
	%writeln('lineas completas en el tablero inicial'),
	%read(_),
	completeColumns(Tablero,CC),
	%print([CC]),
	%writeln('columnas completas en el tablero inicial'),
	%read(_),
	completeColors(Tablero,CCl),
	%print([CCl]),
	%writeln('colores completos en el tablero inicial'),
	%read(_),
	sumPointsOfMove(Tablero,FL,RS),
	%print([RS]),
	%writeln('suma de los puntos de un movimiento'),
	%read(_),
	updateBoard(Tablero,FL,NTablero),
	%printT(NTablero),
	%writeln('nuevo Tablero'),
	%read(_),
	completeLines(NTablero,CL1),
	completeColumns(NTablero,CC1),

	completeColors(Tablero,CCl1),
	NCL is CL1 - CL,
	NCC is CC1 - CC,
	NCCl is CCl1 - CCl,
	length(NL,LNL),
	getNegativeSum(LNL,SNL),

       write(RS) , writeln('puntos del movimiento'),
       %print(NL),writeln(''),
       write(SNL) , writeln('puntos negativos del movimiento'),


       write(NCL) , writeln('cantidad de filas nuevas'),


       write(NCC) , writeln('cantidad de columnas nuevas'),


       write(NCCl) , writeln('cantidad de colores nuevos'),

       R1 is NCL * 2,
       R2 is NCC * 7,
       R3 is NCCl * 10,
       R4 is RS + SNL + R1 + R2 + R3,
       R is max(R4,0),
	%R is max(RS + (NCL * 2) + (NCC * 7) + SNL  + (NCCl * 10) , 0 ),
	write(R),writeln(' nueva suma').
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%funciones para generar movimientos aviables en un tablero para un jugador


%para una distribucion de colores de una fabrica toma todas las piezas y las divide en las que se van ha seleccionar y el resto
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%funciones para actualizar


%actualiza eL patterLine
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


% metodo para actualizar el patternLine
%esta actualizacion es para despues de
%realizar el movimiento al tablero
updatePatternLine(PL,R):-
	updatePatterLine(PL,5,[],R1),printT(R1),
	getTeilsFromPatternLine(PL,R2),
	R = [ R1 ,R2].

%dada una lista de jugadores devuelve las piezas que se incorporaran al medio en la proxima ronda
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
%%%%%%%%%%%%%%%%%%%%%%%%%


%devuelve una lista con el elemento E de todos los players
getElementsOfPlayers(LP,E,R):-
	findall(Y , (member(X,LP) , nth0(E,X,Y) ) , R).

toUpdate(Tablero,_,-1,Tablero).
toUpdate(Tablero,I,Z,NTablero):-
	nth0(I,Tablero,L),

	NI is I + 1,
	getColorPos(L,Z,J),
	replaceXY(Tablero,NI,J,Z:1,NTablero).

updateBoard(Tablero,0,_,Tablero).
updateBoard(Tablero,W,L,NTablero):-
	I is 5 - W,
	selectchk(Z,L,RL),
	toUpdate(Tablero,I,Z,RTablero),
	%getColorPos(,Z,J)
	NW is W - 1,
	updateBoard(RTablero,NW,RL,NTablero).


%actualiza el tablero
%L es una lista de tama�o 5 que contiene un color c o -1 ,EJ : [1,2,-1,1,-1]
updateBoard(Tablero,L,NTablero):-
	updateBoard(Tablero,5,L,NTablero).%,printT(NTablero).

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


%dado un jugador lo actualiza
updatePlayer(P,R):-
	nth0(0,P,B),
	nth0(1,P,PL),
	nth0(2,P,NL),
	nth0(3,P,PO),
	nth0(4,P,PNU),



	%printT(B),
	%writeln('ggg'),
	%read(_),
	%printT(PL),
	%writeln('dd'),
	%read(_),
	%printT(NL),
	%writeln('iii'),
	%read(_),
	%printT([PO]),
	%writeln('aaa'),
	%read(_),




	sumPoints(B,PL,NL,SP),
	%write(SP),
	%writeln('lo devuelto por el metodo '),
	%read(_),
	NPO is PO + SP ,


	%printT([NPO]),

	%writeln('Nueva puntuacion'),
	%read(_),


	updatePatternLine(PL,UPL),

	nth0(0,UPL,NPL),
	nth0(1,UPL,NR),

	%printT(NPL),
	%writeln('ffffggg'),


	%printT(NR),
	%writeln('hhhhggg'),


	getFullLines(PL,FL),
	updateBoard(B,FL,NB),

	R = [ [NB , NPL , [] , NPO , PNU ] , NR ]%,
	 %print(R),	writeln('UPDATETTETETETETET')%, read(_)
	.




updatePlayers(_,0,RR,GR,R):- R = [RR , GR] .%, print(R),	writeln('players actualizados answer').%, read(_).
updatePlayers(LP,W,RR,GR,R):-



	%writeln('actualizado'),
	%writeln('lista de Players'),
	%print(LP),
	%read(_),
	%writeln('longitud lista de Players'),
	%write(W),
	%read(_),
	%writeln('lista de Nuevos Players'),
	%print(RR),
	%read(_),
	%writeln('lista suelos que van dejando los Players'),
	%print(GR),
	%read(_),


	NW is W - 1,
	selectchk(Z , LP,RLP),
	updatePlayer(Z,NZ),
	 %print(NZ),	writeln('players actualizado'),% read(_),
	nth0(0,NZ,NP),
	nth0(1,NZ,NR),
	append(GR,NR,NGR),
	append(RR,[NP],NRR),
	updatePlayers(RLP,NW,NRR,NGR,R).

%dada una lista de jugadores devuelve los jugadores actualizados
updatePlayers(LP,R):-
	length(LP,LLP),
		writeln('Actualizando  players'),
	updatePlayers(LP,LLP,[],[],R).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%predicados para el findall

twoFRowsF(0):- 1 is 1.
twoFRowsF(1):- 1 is 1.
twoFRowsF(_):- 0 is 1.

isEmptyf([]):- 1 is 1.
isEmptyf(_):- 0 is 1.

equalF1(X,Y):- X is Y.

isColorF(C,X):- C is X.

isM1f(X):- -1 is X.

equalF(X:_,C):-C is X.

busyF(_:X):- 1 is X.

isEmpty(X):- -1 is X.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Estrategias para realizar una jugada


%clasifica si un movimiento pertenece a la diagonal superior o inferior
myUpDown(X,P,R):-
	nth0(0,X,M),
	nth0(1,X,I),



        nth0(3,M,C:_),
        nth0(0,P,B),
        nth0(I,B,L),
        getColorPos(L,C,CP),

	(   CP > I -> R is 1 ; R is 0).


getTwoList(_,_,0,R1,R2,R):- R  = [R1,R2].
getTwoList(L,P,LL,R1,R2,R):-
	NLL is LL - 1,
	selectchk(Z,L,RL),
	myUpDown(Z,P,UD),
	(   UD > 0 -> append(R1,[Z],NR1) , NR2 = R2 ; append(R2,[Z],NR2), NR1 = R1 ),
	getTwoList(RL,P,NLL,NR1,NR2,R).


%dada una Lista  L separa en dos listas L1 y L2 donde en L1 estan todos los movimientos aviables de la diagonal superior
%y en L2 el resto
getTwoList(L,P,R):-
	length(L,LL),
	getTwoList(L,P,LL,[],[],R).


%metodo de otro movimiento
%genera todos los movimientos pisbles en dos listas , L1 los movimientos q se encuentran en la diagonal superior
%L2 los elementos que se encuentran en la diagonal inferior
%siempre tata de tomar uno random de L1 en caso de no existir uno random de L2
makeMove1(P,F,G,R):-
        aviableFactories(F,LF),
	lengthOfGround(G,LG),

	nth0(4,P,NI),

	SL is LF + LG ,

	write(' Turno del Player '),write(NI),writeln(''),
	(   SL > 0 -> write("Hay lozas "),
	    writeln(''),
	    getColorList(F,0,CL),
	    getColorList([G],1,CL1),
	    append(CL,CL1,CL2),
	    nth0(1,P,PTL),
	    nth0(0,P,PB),
	    getAviableLines(PB,PTL,CL2,AM),
	    %writeln('Movimientos Aviables'),


	    getTwoList(AM,P,TLR),


	    %print(AM),



	    nth0(0,TLR,UPAM),
	    nth0(1,TLR,DWAM),



	    length(UPAM,LUPAM),
	    length(DWAM,LDWAM),

	    (	LUPAM > 0 ->
	        randomList(UPAM,RUPAM),
		nth0(0,RUPAM , CM),
		move(P,CM,MoR),
		nth0(0,MoR , NP),
		nth0(1,MoR , FG),
		nth0(2,MoR , MorI),
		nth0(3,MoR , MorRL),
		(	FG > 0 -> NF = F , NG = MorRL ;
		        updateLineInPatterLine(F,MorI,[],NF),
		        append(G , MorRL ,NG)
	        ),

	        R = [ NP , NF , NG ]


	       ;
	       (   LDWAM  > 0 ->

	           randomList(DWAM,RDWAM),

		   nth0(0,RDWAM , CM1),
		   move(P,CM1,MoR1),
		   nth0(0,MoR1 , NP1),
		   nth0(1,MoR1 , FG1),
		   nth0(2,MoR1 , MorI1),
		   nth0(3,MoR1 , MorRL1),
		   (	FG1 > 0 -> NF1 = F , NG1 = MorRL1 ;
		        updateLineInPatterLine(F,MorI1,[],NF1),
		        append(G , MorRL1 ,NG1)
		   ),

		   R = [ NP1 , NF1 , NG1 ]

	           ;

		   selectchk(FCL2,CL2,_),

		   %directToGround(P,FCLM),
		   nth0(3,FCL2,CCL2:CACL2),

		   nth0(0,P,CL2P),
		   nth0(1,P,CL2PL),
		   nth0(2,P,CL2NL),
		   nth0(3,P,CL2PO),
		   nth0(4,P,CL2PNU),

		   addElements(CL2NL,CACL2,CCL2,NCL2NL),
		   NP1 = [ CL2P , CL2PL, NCL2NL  , CL2PO , CL2PNU ],


		   nth0(1,FCL2,PFCL2),
		   nth0(2,FCL2,IFCL2),
		   nth0(4,FCL2,FCL2G),
		   %es decir que tome del suelo si PFCL" > 0
		   (  PFCL2 > 0 ->  NF1 = F , NG1 = FCL2G;
		      updateLineInPatterLine(F,IFCL2,[],NF1),
		      append(G , FCL2G ,NG1)
		   ),

		   R = [ NP1 , NF1 ,NG1 ]

	       ))

	    ;
	     %  print(G),
	    %writeln('Last Ground'),

	    %print(F),
	    %writeln('Last Factories'),

	    %read(_),
	    R = [ P , F ,  G ]
	)

	.





%dada una Lista  L separa en dos listas L1 y L2 donde en L1 estan todos los movimientos aviables de las primeras 2 filas
%y en L2 el resto
getTwoList1(L,R):-
	findall( X  , (member(X,L) ,nth0(1,X,Y) ,twoFRowsF(Y)) , W),
	findall( X  , (member(X,L) ,nth0(1,X,Y) , not(twoFRowsF(Y))) , W1),
	R = [ W ,W1].

%metodo de otro movimiento
%genera todos los movimientos pisbles en dos listas , L1 los movimientos q se encuentran en las primeras dos filas
%L2 los elementos que se encuentran en el resto de la matriz
%siempre tata de tomar uno random de L1 en caso de no existir uno random de L2
makeMove2(P,F,G,R):-
        aviableFactories(F,LF),
	lengthOfGround(G,LG),

	nth0(4,P,NI),

	SL is LF + LG ,

	write(' Turno del Player '),write(NI),writeln(''),
	(   SL > 0 -> write("Hay lozas "),
	    writeln(''),
	    getColorList(F,0,CL),
	    getColorList([G],1,CL1),
	    append(CL,CL1,CL2),
	    nth0(1,P,PTL),
	    nth0(0,P,PB),
	    getAviableLines(PB,PTL,CL2,AM),
	    %writeln('Movimientos Aviables'),


	    getTwoList1(AM,TLR),


	    %print(AM),



	    nth0(0,TLR,UPAM),
	    nth0(1,TLR,DWAM),



	    length(UPAM,LUPAM),
	    length(DWAM,LDWAM),

	    (	LUPAM > 0 ->
	        randomList(UPAM,RUPAM),
		nth0(0,RUPAM , CM),
		move(P,CM,MoR),
		nth0(0,MoR , NP),
		nth0(1,MoR , FG),
		nth0(2,MoR , MorI),
		nth0(3,MoR , MorRL),
		(	FG > 0 -> NF = F , NG = MorRL ;
		        updateLineInPatterLine(F,MorI,[],NF),
		        append(G , MorRL ,NG)
	        ),

	        R = [ NP , NF , NG ]


	       ;
	       (   LDWAM  > 0 ->

	           randomList(DWAM,RDWAM),

		   nth0(0,RDWAM , CM1),
		   move(P,CM1,MoR1),
		   nth0(0,MoR1 , NP1),
		   nth0(1,MoR1 , FG1),
		   nth0(2,MoR1 , MorI1),
		   nth0(3,MoR1 , MorRL1),
		   (	FG1 > 0 -> NF1 = F , NG1 = MorRL1 ;
		        updateLineInPatterLine(F,MorI1,[],NF1),
		        append(G , MorRL1 ,NG1)
		   ),

		   R = [ NP1 , NF1 , NG1 ]

	           ;

		   selectchk(FCL2,CL2,_),

		   %directToGround(P,FCLM),
		   nth0(3,FCL2,CCL2:CACL2),

		   nth0(0,P,CL2P),
		   nth0(1,P,CL2PL),
		   nth0(2,P,CL2NL),
		   nth0(3,P,CL2PO),
		   nth0(4,P,CL2PNU),

		   addElements(CL2NL,CACL2,CCL2,NCL2NL),
		   NP1 = [ CL2P , CL2PL, NCL2NL  , CL2PO , CL2PNU ],


		   nth0(1,FCL2,PFCL2),
		   nth0(2,FCL2,IFCL2),
		   nth0(4,FCL2,FCL2G),
		   %es decir que tome del suelo si PFCL" > 0
		   (  PFCL2 > 0 ->  NF1 = F , NG1 = FCL2G;
		      updateLineInPatterLine(F,IFCL2,[],NF1),
		      append(G , FCL2G ,NG1)
		   ),

		   R = [ NP1 , NF1 ,NG1 ]

	       ))

	    ;
	       %print(G),
	    %writeln('Last Ground'),

	    %print(F),
	    %writeln('Last Factories'),

	    %read(_),
	    R = [ P , F ,  G ]
	)


	.

%Para cada movimiento devuelve un numero Y q es la cantidad de nuevos elemntos aportados a los negativos
moveFuture(_,_,0,_,R,R).
moveFuture(P,L,LL,LNL,W,R):-
	selectchk(Z,L,RL),
	NLL is LL - 1 ,
	move(P,Z,MR),
	nth0(0,MR,NP),
	nth0(2,NP,MNL),
	length(MNL,LMNL),
	Y is LMNL - LNL ,
	Y1 is Y * (-1),
	append(W,[Y1],NW),
	moveFuture(P,RL,NLL,LNL,NW,R).

%realiza todos los movimientos y se queda con el que menos aporte a la lista de negativos
moveAll(P,L,R):-
	nth0(2,P,NL),
	length(NL,LNL),
	length(L,LL),
	moveFuture(P,L,LL,LNL,[],W),


	maxList(W,MP),

	nth0(MP,L,R).




%metodo de otro movimiento
%dada una lista de movimientos viables toma el movimiento que menos elementos suma a los negativos
makeMove3(P,F,G,R):-
	aviableFactories(F,LF),
	lengthOfGround(G,LG),

	nth0(4,P,NI),

	SL is LF + LG ,

	write(' Turno del Player '),write(NI),writeln(''),
	(   SL > 0 -> write('Hay lozas'),
		writeln(''),
		getColorList(F,0,CL),
		getColorList([G],1,CL1),
		append(CL,CL1,CL2),
		nth0(1,P,PTL),
		nth0(0,P,PB),
		getAviableLines(PB,PTL,CL2,AM),







		length(AM,LAM),


		(	LAM > 0 ->


			moveAll(P,AM,CM),
			%nth0(0,AM , CM),
			move(P,CM,MoR),
			nth0(0,MoR , NP),
			nth0(1,MoR , FG),
			nth0(2,MoR , MorI),
			nth0(3,MoR , MorRL),
			(	FG > 0 -> NF = F , NG = MorRL ;
				updateLineInPatterLine(F,MorI,[],NF),
				append(G , MorRL ,NG)
			),

			R = [ NP , NF , NG ]


		;


		selectchk(FCL2,CL2,_),

		%directToGround(P,FCLM),
		nth0(3,FCL2,CCL2:CACL2),

		nth0(0,P,CL2P),
		nth0(1,P,CL2PL),
		nth0(2,P,CL2NL),
		nth0(3,P,CL2PO),
		nth0(4,P,CL2PNU),

		addElements(CL2NL,CACL2,CCL2,NCL2NL),
		NP1 = [ CL2P , CL2PL, NCL2NL  , CL2PO , CL2PNU ],


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

		;

		R = [ P , F ,  G ]
	).



%metodo del movimiento de un player
%R = [ NP , F ,G]
%NP es el player actualizado
%F las factories actualizadas
%G ground actualizado
%Genera todos los movimientos posibles y toma uno random
makeMove(P,F,G,R):-
	aviableFactories(F,LF),
	lengthOfGround(G,LG),

	nth0(4,P,NI),

	SL is LF + LG ,

	write(' Turno del Player '),write(NI),writeln(''),

	(   SL > 0 -> write("Hay lozas "),
	    writeln(''),
	    getColorList(F,0,CL),
	    getColorList([G],1,CL1),
	    append(CL,CL1,CL2),
	    nth0(1,P,PTL),
	    nth0(0,P,PB),
	    getAviableLines(PB,PTL,CL2,AM),
	    %writeln('Movimientos Aviables'),
	    randomList(AM,RAM),
	    %print(RAM),
	    %writeln(''),
	    %print(CL2),
	    %writeln(''),
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

	    ;
	     selectchk(FCL2,CL2,_),

	     %directToGround(P,FCLM),
		nth0(3,FCL2,CCL2:CACL2),

		nth0(0,P,CL2P),
		nth0(1,P,CL2PL),
		nth0(2,P,CL2NL),
		nth0(3,P,CL2PO),
		nth0(4,P,CL2PNU),

		addElements(CL2NL,CACL2,CCL2,NCL2NL),
		NP1 = [ CL2P , CL2PL, NCL2NL  , CL2PO , CL2PNU ],


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



	;
	   % print("No hay Lozas"),

	    %print(G),
	    %writeln('Last Ground'),

	    %print(F),
	    %writeln('Last Factories'),

	    %read(_),
	    R = [ P , F ,  G ]
	)


	.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Objetos


board(X):- X = [[1:0,2:0,3:0,4:0,5:0],
		[5:0,1:0,2:0,3:0,4:0],
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%funciones del juego



isEnd(_,_,0,R,R).
isEnd(L,LWO,LW,RR,R):-
	I is LWO - LW ,
	NW is LW - 1,
	nth0(I , L , RL),
	completeLines(RL,CL),

	(   CL > 0 -> K is 1,NRR is 1,K1 is 0 ; K is 0,K1 is NW,NRR is RR),

	isEnd(L,LWO,K1,NRR,R).


%dada una lista de tableros de jugadores decir si se acabo el juego
isEnd(L,X):-
	length(L,LW),
	isEnd(L,LW,LW,0,X).

%actualiza el patternLine
%notifica los cambios a realizar en
%las factories o ground
move(P,CM,R):-
	nth0(0,P,B),
	nth0(1,P,PL),
	nth0(2,P,NL),
	nth0(3,P,PO),
	nth0(4,P,PNU),
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
	R = [ [B , NPL1 , NNL1 , PO , PNU] , FG , I , RL ]
	.

makeMoves(_,_,0,F,G,RML,R):-

	%print(G),
	%writeln('Current Ground'),

	%print(F),
	%writeln('Current Factories'),

	%print(RML),
	%writeln('Current Players'),


	R = [RML , F , G ].

makeMoves(LP,LLP,W,F,G,RML,R):-
	I is LLP - W,
	NW is W - 1,
	nth0(I,LP,P),

	writeln('HERE MAKING MOVES'),

	writeln('Estado de las Fabricas'),
	print(F),writeln(''),
	writeln('Estado de los azulejos del medio'),
	print(G),writeln(''),


	%makeMove(P,F,G,PMR),

	%makeMove1(P,F,G,PMR),

	%makeMove2(P,F,G,PMR),

	makeMove3(P,F,G,PMR),

	nth0(0,PMR,NP),
	nth0(1,PMR,NF),
	nth0(2,PMR,NG),
	append(RML,[NP],NRML),
	makeMoves(LP,LLP,NW,NF,NG,NRML,R).

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


%devuelve las fabricas disponibles
aviableFactories(X,R):-
	length(X,XL),
	aviableFactories(X,XL,0,R).
%devuelve la cantidad de fichas que hay en el medio
lengthOfGround([],R):-R is 0.
lengthOfGround(_,R):-R is 1.

%realiza una ronda de movimientos para cada jugador
makeRound(LP,F,G,ML):-
	aviableFactories(F,LF),
	lengthOfGround(G,LG),



	S is LG + LF ,



	(  S > 0 -> makeMoves(LP,F,G,RML),
   		nth0(0,RML,LP1),
   		nth0(1,RML,F1),
   		nth0(2,RML,G1),
   		makeRound(LP1,F1,G1,ML) ;

		writeln(''),
		ML = [ LP , F , G ]

	).

%rota una lista L dejando al elemento de la posicion PI como primer Elemento
remakeList(R,_,0,R).
remakeList([H|LP],PI,_,R):-
	nth0(4,H,HI),
	equals(HI,PI,RE),
	(   RE < 1 -> remakeList([H|LP],PI,0,R) ; append(LP , [H] ,NLP) , remakeList(NLP,PI,1,R) )
	.
%dada una lista de jugadores devuelve una lista ordenada para el orden en la proxima ronda
whoFirst(LP,R):-
	findall( X , ( member( X , LP) , nth0(2,X,Y) , findall(Z , ( member(Z , Y) , isM1f(Z) ) ,W1 ) , not(isEmptyf(W1)) ) , W),
	nth0(0,W,P),nth0(4,P,PI),
	remakeList(LP,PI,1,R).

%dado una lista de jugadores determina el ganador
getWinner(LP,_,_,0,WP,_,R):-
	nth0(WP,LP,R).
getWinner(LP,LPB,LL,P,WP,WCL,R):-
	NLL is LL - 1,
	selectchk(Z,LPB,RLPB),
	completeLines(Z,CL),
	(   CL > WCL ->
	    NWP is P,
	    NWCL is CL
	;
	    NWP is WP,
	    NWCL is WCL
	),
	NP is P + 1,
	getWinner(LP,RLPB,NLL,NP,NWP,NWCL,R).




%dado una lista de jugadores determina el ganador
winner1([X],X).
winner1(LP,R):-
	getElementsOfPlayers(LP,0,LPB),
	length(LPB,LL),
	NLL is LL - 1,
	selectchk(Z,LPB,RLPB ),
	completeLines(Z,CL),
	getWinner(LP,RLPB,NLL,1,0,CL ,R).


%metodo que devuelve el ganador del juego
endGame(LP1,R):-
	getElementsOfPlayers(LP1,3,LPo),

	%en WP esta la posicion del ganador lo que no es precisamente el jugador
	maxList(LPo,WP),

	nth0(WP,LP1,PPW),
	nth0(3,PPW,WPo),

	%dame todos los jugadores que tengan Puntuacion maxima
	findall(X , ( member( X,LP1) , nth0(3,X,Z) , equalF1(Z,WPo)  ) , W ),

	winner1(W,R).

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

	%print(MR),
	writeln('Hice una Ronda'),
	%read(_),


	nth0(0,MR,LP1),

	%print(LP1),
	%writeln('lo que devolvio la ronda'),
	%read(_),

	whoFirst(LP1,NLP1),

	%read(_),

	getElementsOfPlayers(LP1,2,Grounds),

	print(Grounds),
	writeln('los suelos de la ronda anterior'),
	%read(_),


	updatePlayers(NLP1,UP),
	nth0(0,UP,LP2),


	writeln('players actualizados'),
	printPlayers(LP2),
	writeln(''),


	nth0(1,UP,MoreGrounds),

	append(Grounds,[MoreGrounds],NGrounds),

	%writeln('suelos actualiazos'),
	%print(NGrounds),
	%writeln(''),


	updateNBug(NB,NGrounds,NB1),

	writeln('nueva tapa de la caja'),
	print(NB1),
	writeln(''),

	writeln('Bolsa actual '),
	print(RB),
	writeln(''),

	%writeln('Obteniendo Tableros'),

	getElementsOfPlayers(LP2,0,Boards),

	%	print(Boards),

	%writeln('tableros de los jugadores tras la ronda'),


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

	         randomList(NB1,RNB),

		 play(LP2,RNB , LF , [-1],[],R) )

	   ;


	   writeln('no se ha acabado el juego aun'),
	   %read(_),

	   play(LP2,RB,LF,[-1],NB1,R)

	   	   )

	)

	.


%inicializa un juego para 2 jugadores
init(2,R):-
	board(BJ0),
	board(BJ1),
	patterLine(PLJ0),
	patterLine(PLJ1),
	bug(B),randomList(B,RB),
	printT(BJ0),
	writeln(''),
	printT(BJ1),
	writeln(''),
	printT(PLJ0),
	writeln(''),
	printT(PLJ1),
	writeln(''),
	play([[BJ0,PLJ0,[],0,0],[BJ1,PLJ1,[],0,1]],RB,5,[-1],[],R).

%inicializa un juego para 3 jugadores
init(3,R):-
	board(BJ0),
	board(BJ1),
	board(BJ2),
	patterLine(PLJ0),
	patterLine(PLJ1),
	patterLine(PLJ2),
	bug(B),randomList(B,RB),
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
	play([[BJ0,PLJ0,[],0,0],[BJ1,PLJ1,[],0,1],[BJ2,PLJ2,[],0,2]],RB,7,[-1],[],R).


%inicializa un juego para 4 jugadores
init(4,R):-
	board(BJ0),
	board(BJ1),
	board(BJ2),
	board(BJ3),
	patterLine(PLJ0),
	patterLine(PLJ1),
	patterLine(PLJ2),
	patterLine(PLJ3),
	bug(B),randomList(B,RB),
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
	play([[BJ0,PLJ0,[],0,0],[BJ1,PLJ1,[],0,1],[BJ2,PLJ2,[],0,2],[BJ3,PLJ3,[],0,3]],RB,9,[-1],[],R).






%imprime un jugador
printPlayer(P):-
	nth0(0,P,B),
	nth0(1,P,PL),
	nth0(2,P,NL),
	nth0(3,P,PO),
	nth0(4,P,I),
	write('player '),writeln(I),
	writeln('El tablero'),
	printT(B),writeln(''),
	writeln('El PatterLine'),
	printT(PL),writeln(''),
	writeln('Su lista de negatigos'),
	print(NL),writeln(''),

	write('Su puntuacion es de '),writeln(PO).


printPlayers(_,0).
printPlayers(LP,L):-
	NL is L - 1,
	selectchk(Z,LP,RLP),
	printPlayer(Z),
	printPlayers(RLP,NL).
%imprime el estado de una lista de jugadores
printPlayers(LP):-
	length(LP,L),
	printPlayers(LP,L).





%crea un juego y devuelve el ganador
game(N,R):-
	init(N,R),nth0(4,R,Z),write('gano el player '),writeln(Z),writeln(''),printPlayer(R).








