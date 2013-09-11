Program Ivelin_Grapha;

uses crt;

const maxvyz = 200;
      maxklon = 200;

var i, j, vyzli, kloni, v: byte;
    c: char;
    M: array[1..maxvyz, 1..maxklon] of shortint;

procedure Polustepen(v: byte);
var i, vhod, izhod: byte;
begin
	vhod := 0; izhod := 0;
	for i := 1 to kloni do
	case M[v,i] of
		1: inc(izhod);
		-1: inc(vhod);
	end;
	Writeln('Izhodnata polustepen za vyzel ',v,' e: ', izhod);
	Writeln('Vhodnata polustepen za vyzel ',v,' e: ', vhod);
end;

begin
	ClrScr;
	repeat
		Write('Vyvedete broq na vyzlite na grafa(max ', maxvyz, '): ');
		{$I-} Readln(vyzli); {$I+}
	until (IOResult = 0) and (vyzli in [1..maxvyz]);
	repeat
		Write('Vyvedete broq na klonite na grafa(max ', maxklon, '): ');
		{$I-} Readln(kloni); {$I+}
	until (IOResult = 0) and (kloni in [1..maxklon]);
	Writeln;
	Writeln(' --------- MATRICA NA INCIDENTNOS M[i,j] --------- ');
	Writeln('        i = vyzlite;         j = klonite;');
	Writeln(' ako M = 0 -> nqma syotno6enie mejdu klona i vyzela');
	Writeln(' ako M = 1 -> klona (j) izliza ot vyzela (i)');
	Writeln(' ako M = -1 -> klona (j) vliza vyv vyzela (i)');
	Writeln;
	for i := 1 to vyzli do
	for j := 1 to kloni do
	repeat
		Write('M[', i, ',', j, ']= ');
		{$I-} Readln(M[i, j]); {$I+}
	until ((IOResult = 0) and ((M[i,j] = -1) or (M[i,j] = 0) or (M[i,j] = 1)));
	Writeln;
	repeat
		Writeln('Vyvedte vyzela: ');
		repeat
			{$I-} Readln(v); {$I+}
		until ((IOResult = 0) and (v in [1..vyzli]));
		Polustepen(v);
		Write('Iskate li povtorno tyrsene?[ESC za ne]: ');
		c := readkey;
		Writeln;
	until c = #27;
end.