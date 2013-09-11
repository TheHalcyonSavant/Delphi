PROGRAM Dime1;

{
  at the beginning of the line in a text file write the abbreviation,
  and after the 15th char write the whole answer, exp:
   DMA    >     Direct Memory Access
          ^     ^
          9th   15th
  avoid tabs (\t), use write spaces instead;
  If the sentence starts with a big char (DMA), then
  it'll be stronger than the lower chars (dma)
}

USES Crt;

CONST
	Max = 200;

TYPE
	Sort_Var = STRING[120];
	Ary = ARRAY[1..Max] OF Sort_Var;

PROCEDURE QSort(VAR X: Ary; M, N: Integer);

	procedure Swap(var m,n: Sort_Var);
	var temp: Sort_Var;
	begin
		temp := m;
		m := n;
		n := temp;
	end;
	
	procedure Partit(var A: Ary; var I, J: Integer; Left, Right: Integer);
	var Pivot: Sort_Var;
	begin
		Pivot := A[(Left + Right) DIV 2];
		I := Left;
		J := Right;
		while I <= J do
		begin
			while A[I] < Pivot do
				I := I + 1;
			while Pivot < A[J] do
				J := J - 1;
			if I <= J then
			begin
				Swap(A[I], A[J]);
				I := I + 1;
				J := J - 1
			end
		end
	end;

VAR I, J: integer;

BEGIN
  IF M < N THEN
    BEGIN
      Partit(X, I, J, M, N);
      Qsort(X, M, J);
      Qsort(X, I, N)
    END
END;

VAR
  X: Ary;
  N, M, I, J, L: Integer;
  Filename, Abbr: STRING[14];
  WholeSent: Sort_Var;
  Filvar: Text;
  C, Confirm, AddConfirm: Char;
  Sentence, Answer: string;

BEGIN
	ClrScr;
	REPEAT
		Write(' File to sort ( ',max,' lines allowed): ');
		Readln(Filename);
		Assign(Filvar, Filename);
		{$I-}
		Reset(Filvar);
		{$I+}
	UNTIL IOResult = 0;
	N := 0;
	REPEAT
		Inc(N);
		ReadLn(Filvar,X[N])
	UNTIL Eof(Filvar);
	Writeln('Option: ');
	Writeln(' 1 for finding abbreviation;');
	Writeln(' 2 for Exit;');
	REPEAT
		c := readkey;
	UNTIL (c = '1') or (c = '2');
	IF c = '1' THEN
	REPEAT
		Write('Write the abbreviation: ');
		Readln(Abbr);
		Answer := '';
		FOR I := 1 TO N DO
		BEGIN
			L := 0; Sentence := '';
			FOR J := 1 TO 8 DO
			BEGIN
				Sentence := X[I];
				IF UpCase(Abbr[J]) = UpCase(Sentence[J]) THEN
					Inc(L);
			END;
			IF (L = Length(Abbr)) AND (Sentence <> '') AND (L <> 0) THEN
			BEGIN
				FOR M := 15 TO Length(Sentence) DO
					Answer := Answer + Sentence[M];
				Break;
			END;
		END;
		IF Answer <> '' THEN
			Writeln(Abbr,'  =  ',Answer)
		ELSE
		BEGIN
			Writeln('Abbreviation not found');
			Write('Do you like to add to the list? ["Y" for Yes]');
			AddConfirm := readkey; Writeln(AddConfirm);
			IF UpCase(AddConfirm) = 'Y' THEN
			BEGIN
				Writeln('Write the whole sentece ( from the 15th char write the answer of the abbreviation ):');
				Readln(WholeSent);
				Inc(N);
				X[N] := WholeSent;
			END;
		END;
		Write('Do you like to search again? ["N" for No]');
		Confirm := readkey; Writeln(Confirm);
	UNTIL UpCase(Confirm)='N';
	IF c = '2' THEN Halt;
	Close(FilVar);
	Rewrite(FilVar);
	QSort(X, 1, N);
	FOR I := 1 TO N DO
		WriteLn(Filvar,X[I]);
	Close(FilVar);
END.