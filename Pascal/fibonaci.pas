{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
program Dime2;
uses crt;

var num, k: integer;
    f, a: array[0..100] of longint;

procedure Fibonacci(n: longint);
var a, a1, a2: longint;
    i: integer;
begin
	a1 := 1; a2 := 1; a := 1;
	f[0] := 1; f[1] := 1; i := 2;
	while (a <= n) do
	begin
		a := a1 + a2;
		a1 := a2;
		a2 := a;
		f[i] := a;
		inc(i);
		write(a, ' ');
	end;
	num := i - 1;
end;

function solve(n: longint): integer;
var i: integer;
begin
	k := 0;
	i := num;
	while n > 0 do
	begin
		while f[i] > n do dec(i);
		n := n - f[i];
		inc(k);
		a[k] := f[i];
	end;
	solve := k;
end;

var n,i: integer;

begin
	ClrScr;
	Writeln('Help: ');
	Fibonacci(1000001);
	Writeln;
	repeat
		Write('Pi6ete nomera [0 za izhod]: ');
		Readln(n);
		Writeln('Ima ', solve(n), ' sumi: ');
		for i := 1 to k - 1 do Write(a[i], ' + ');
		Writeln(a[k]);
	until n = 0;
end.