unit Unit1;

{proverka za kalendara:
http://www.timeanddate.com/calendar/custom.html?year=1900&country=1&lang=en&moon=on&wno=2&hol=25}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    procedure ChangeMonth;
    { Private declarations }
  public
    { Public declarations }
  end;

type  TDay = record
              Week: 0..6; {1..6 Sedmica}  {nulata za ni6to}
              WeekDay: 0..7; {0..6 Denove:Ned,Pon,Vtor... semicata e za ni6to}
             end;
      TMonth = record
                Day: array[1..31] of TDay;
               end;
      TYear = record
               Month: array[1..12] of TMonth;
              end;
      TDate = array[0..200] of TYear;

var
  Form1: TForm1;
  Date: TDate;
  MonthPos: Byte;
  Godina: Integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var y,m,d,EndMonth,last: Integer;
begin
  MonthPos:=1;
  With StringGrid1 do
   begin
    Cells[0,0]:='Su'; Cells[1,0]:='Mo'; Cells[2,0]:='Tu';
    Cells[3,0]:='We';Cells[4,0]:='Th'; Cells[5,0]:='Fr';
    Cells[6,0]:='Sa';
   end;
  for y:=0 to 200 do
   for m:=1 to 12 do
    for d:=1 to 31 do
     begin
      Date[y].Month[m].Day[d].Week:=0;
      Date[y].Month[m].Day[d].WeekDay:=7;
     end;
  last:=0;
  for y:=0 to 200 do
   begin
    for m:=1 to 12 do
     begin
      if m in [4,6,9,11] then EndMonth:=30
       else if m=2 then
        if (((y+1900) mod 4)=0) and (y<>0) and (y<>200) then EndMonth:=29
         else EndMonth:=28
       else EndMonth:=31;
      for d:=1 to EndMonth do
       begin
        Date[y].Month[m].Day[d].Week:=((d+last) div 7)+1;
        Date[y].Month[m].Day[d].WeekDay:=(d+last) mod 7;
       end;
      last:=Date[y].Month[m].Day[EndMonth].WeekDay;
     end;
   end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 if (MonthPos>1) and (Edit1.text<>'') then
  begin
   Dec(MonthPos);
   Button1Click(self);
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 if (MonthPos<12) and (Edit1.text<>'') then
  begin
   Inc(MonthPos);
   Button1Click(self);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var d,x,y: Integer;
begin
  for x:=0 to 6 do
   for y:=1 to 6 do
    StringGrid1.Cells[x,y]:='';
  if (StrToInt(edit1.Text)<1900) or
   (StrToInt(edit1.text)>2100) then
     begin
      MessageBox(0,'Napishete ot 1900 .. 2100 godina !','Kalendar',0);
      Exit;
     end;
  Godina:=StrToInt(edit1.Text);
  ChangeMonth;
  if Date[Godina-1900].Month[MonthPos].Day[1].Week=2 then
   for d:=1 to 31 do
    with Date[Godina-1900].Month[MonthPos].Day[d] do
     Week:=Week-1;
  for d:=1 to 31 do
   with Date[Godina-1900].Month[MonthPos].Day[d] do
    if WeekDay<>7 then
     StringGrid1.Cells[WeekDay,Week]:=IntToStr(d);
end;

procedure TForm1.ChangeMonth;
begin
 case MonthPos of
  1: Label2.Caption:='January';
  2: Label2.Caption:='February';
  3: Label2.Caption:='March';
  4: Label2.Caption:='April';
  5: Label2.Caption:='May';
  6: Label2.Caption:='June';
  7: Label2.Caption:='July';
  8: Label2.Caption:='August';
  9: Label2.Caption:='September';
  10: Label2.Caption:='October';
  11: Label2.Caption:='November';
  12: Label2.Caption:='December';
 end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#8]) then key:=#0;
end;

end.
