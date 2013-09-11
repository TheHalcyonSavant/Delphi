{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
program Rumi_Graph;

{ ----- Matrica na sysedstvo -------
  kvadraticna s razmer ot broq na vyzlite
  M[i,j] = 0 ako vyzlite ne sa svyrzani
  M[i,j] = 1 ako vyzlite sa svyrzani
  po glavnata diqgonala sa nuli
  ----- Dopylnitelen Grapf ---------
  inversna matrica na matricata na
  sysetstvo, po glavnata diqgonala
  ostavat nuli
}

uses crt;

const Vmax = 25; {ispolzvai do 25 za po-dobre pretstavqne }

type matrica = array[1..Vmax, 1..Vmax] of byte;

procedure Izvejdane(var M:matrica; v:byte; a:char);
var i, j, l: byte;
    Nacalo: boolean;
begin
	Writeln;
	Write('    ');
	for i := 1 to v do
	Write(i:3);
	Writeln;
	Write('   ');
	for i := 1 to (v * 3 + 1) do
	Write('-');
	Writeln; Nacalo := True; l := 1;
	for i := 1 to v do
	for j := 1 to v do
	begin
		if Nacalo then {"Nacalo" i "l" za po-dobre izvejdane}
		begin
			Write(l:2, '| ');
			Nacalo := False;
			inc(l);
		end;
		if a = 'W' then {'W' za 'Write' na M, ako ne e 'W' to samo izvejda M}
		if i = j then M[i,j] := 0 else M[i,j] := random(2);
		Write(M[i,j]:3);
		if j = v then
		begin
			Nacalo := True;
			Writeln;
		end;
	end;
	Writeln;
end;

var v, i, j: byte;
    M: matrica;

begin
	clrscr;
	TextColor(7);
	repeat
		Write('Vyvedete broi na vyzli na grafa [1..', Vmax, ']: ');
		{$I-} Readln(v); {$I+}
	until (IOResult = 0) and (v > 0) and (v <= Vmax);
	Writeln('Proizvolen graf ot ', v, ' vyzli: ');
	Randomize;
	Izvejdane(M, v, 'W');
	Readln;
	Writeln('Dopylnitelen graf za proizvolniq graf e: ');
	for i := 1 to v do
	for j := 1 to v do
	if i <> j then
	if M[i,j] = 0 then M[i,j] := 1
	else M[i,j] := 0;
	TextColor(Red);
	Izvejdane(M, v, 'R');
	Readln;
end.