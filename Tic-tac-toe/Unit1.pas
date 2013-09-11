unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, TypInfo;

type
  TBoardStone = (bsNone, bsO, bsX);
  TForm1 = class(TForm)
    Button1: TButton;
    DrawGrid1: TDrawGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure DrawGrid1Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
     Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function Check5: boolean;
    procedure AddNode(S: string; Stone: TBoardStone; X, Y, Level: Integer; NodeList: TStrings);
    function DefensiveTrickCheck(NodeList: TStrings): Boolean;
    function HorizontallyCheck(Defensive: Boolean; Stone: TBoardStone; NodeList: TStrings): Boolean;
    function VerticallyCheck(Defensive: Boolean; Stone: TBoardStone; NodeList: TStrings): Boolean;
    function ObliqueCheck_TLBR(Defensive: Boolean; Stone: TBoardStone; NodeList: TStrings): Boolean;
    function ObliqueCheck_TRBL(Defensive: Boolean; Stone: TBoardStone; NodeList: TStrings): Boolean;
    procedure ComputerSequence;
    function MessageDialog(Text, Title: string; DlgType: TMsgDlgType;
     Buttons: TMsgDlgButtons; BtnCaptions: array of string): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

type
 TBrainNode = class(TObject)
  private
    FX, FY: Integer;
    FLevel: Integer;
    FStone: TBoardStone;
  public
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Level: Integer read FLevel write FLevel;
    property Stone: TBoardStone read FStone write FStone;
  end;

var
  Form1: TForm1;
  BoardStone: array[1..15, 1..15] of TBoardStone;
  FNodes: Integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var x,y: byte;
begin
 FNodes:=0;
 for y:=1 to 15 do
  for x:=1 to 15 do
   BoardStone[x,y]:=bsNone;
 if MessageDialog('Koi da byde prúv ?', 'The Game', mtInformation,
  [mbYes, mbNo], ['Az', 'Kompjuteryt'])=mrNo then
  begin
   ComputerSequence;
   DrawGrid1.Invalidate;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 OnCreate(self);
 DrawGrid1.Invalidate;
end;

procedure TForm1.DrawGrid1Click(Sender: TObject);
begin
 if (BoardStone[DrawGrid1.Col+1,drawgrid1.Row+1]=bsNone) and not Check5 then
  begin
   BoardStone[DrawGrid1.Col+1,drawgrid1.Row+1]:=bsO;
   drawgrid1.Invalidate;
   if Check5 then
    begin
     MessageBox(0,'POBEDIHTE ME!','Igrata',0);
     Exit;
    end;
   inc(FNodes);
   if FNodes >= 225 then Exit;
   ComputerSequence;
  end
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
 procedure CanvasOX(Ch: Char; Control: TCanvas; _Rect: TRect);
 begin
  with Control do
   begin
    Pen.Width:=3;
    case Ch of
     'X': begin
           Pen.Color:=clred;
           MoveTo(_Rect.Right,_Rect.Bottom);
           LineTo(_Rect.Left,_Rect.Top);
           MoveTo( _Rect.left , _Rect.bottom );
           LineTo(_Rect.Right,_Rect.Top);
          end;
     'O': begin
           Pen.Color:=clblue;
           Ellipse( _Rect );
          end;
    end;
   end;
 end;
begin
  case BoardStone[ACol+1,ARow+1] of
   bsO: CanvasOX('O',DrawGrid1.Canvas,Rect);
   bsX: CanvasOX('X',DrawGrid1.Canvas,Rect);
   bsNone: DrawGrid1.Canvas.FillRect(Rect);
  end;
end;

{----------------------------------------------------------}
{-------------------------Private--------------------------}
{----------------------------------------------------------}

function TForm1.Check5: boolean;
var x,y: byte;
    Stone: TBoardStone;
begin
 Result:=False;
 for y:=1 to 15 do
  for x:=1 to 15 do
   begin
    Stone:=BoardStone[x,y];
    if Stone=bsNone then Continue;
    if (X in [1..11]) then
     if (BoardStone[x+1,y] = Stone) and
        (BoardStone[x+2,y] = Stone) and
        (BoardStone[x+3,y] = Stone) and
        (BoardStone[x+4,y] = Stone) then
      begin
       Result:=True;
       Exit;
      end;
    if (Y in [1..11]) then
     if (BoardStone[x,y+1] = Stone) and
        (BoardStone[x,y+2] = Stone) and
        (BoardStone[x,y+3] = Stone) and
        (BoardStone[x,y+4] = Stone) then
      begin
       Result:=True;
       Exit;
      end;
    if (X in [1..11]) and (Y in [1..11]) then
     if (BoardStone[x+1,y+1] = Stone) and
        (BoardStone[x+2,y+2] = Stone) and
        (BoardStone[x+3,y+3] = Stone) and
        (BoardStone[x+4,y+4] = Stone) then
      begin
       Result:=True;
       Exit;
      end;
    if (x in [5..15]) and (Y in [1..15]) then
     if (BoardStone[x-1,y+1] = Stone) and
        (BoardStone[x-2,y+2] = Stone) and
        (BoardStone[x-3,y+3] = Stone) and
        (BoardStone[x-4,y+4] = Stone) then
      begin
       Result:=True;
       Exit;
      end;
   end;
end;

procedure TForm1.AddNode(S: string; Stone: TBoardStone; X, Y, Level: Integer;
 NodeList: TStrings);
var
  Node: TBrainNode;
begin
  if (Level = 0) or not (X in [1..15]) or not(Y in [1..15]) or (S = '') or
   (NodeList = nil) then Exit;
  Node := TBrainNode.Create;
  Node.X := X;
  Node.Y := Y;
  Node.Level:=Level;
  Node.Stone := Stone;
  NodeList.AddObject(S, Node);
end;

procedure TForm1.ComputerSequence;    {Comp Brain}
var
  I, X, Y: Integer;
  NodeList: TStrings;
  DefensiveNode, OfensiveNode, Node: TBrainNode;
begin
  if FNodes >= 225 then Exit;
  NodeList := TStringList.Create;
  if FNodes>0 then
   begin
    { Defensive }
    DefensiveTrickCheck(NodeList);
    HorizontallyCheck(True, bsO, NodeList);
    VerticallyCheck(True, bsO, NodeList);
    ObliqueCheck_TLBR(True, bsO, NodeList);
    ObliqueCheck_TRBL(True, bsO, NodeList);
    { Offensive }
    HorizontallyCheck(False, bsX, NodeList);
    VerticallyCheck(False, bsX, NodeList);
    ObliqueCheck_TLBR(False, bsX, NodeList);
    ObliqueCheck_TRBL(False, bsX, NodeList);
   end;
  DefensiveNode := nil;
  OfensiveNode := nil;
  for I := 0 to pred(NodeList.Count) do
   if NodeList.Objects[I] <> nil then
    begin
     Node := TBrainNode(NodeList.Objects[I]);
     if NodeList[I] = 'Defensive' then
      begin
       if DefensiveNode <> nil then
        begin
         if Node.Level > DefensiveNode.Level then
          DefensiveNode := Node;
        end
       else
        DefensiveNode := Node;
      end
     else
      begin
       if OfensiveNode <> nil then
        begin
         if Node.Level > OfensiveNode.Level then
          OfensiveNode := Node;
        end
       else
        OfensiveNode := Node;
      end;
    end;

  if (OfensiveNode <> nil) and (DefensiveNode <> nil) then
   begin
    if (OfensiveNode.Level = 5) and (DefensiveNode.Level = 5) then
     BoardStone[OfensiveNode.X,OfensiveNode.y]:=bsX
    else if (OfensiveNode.Level > DefensiveNode.Level) then
     BoardStone[OfensiveNode.X,OfensiveNode.y]:=bsX
    else if (OfensiveNode.Level <= DefensiveNode.Level) then
     BoardStone[DefensiveNode.X,DefensiveNode.y]:=bsX
   end
  else if (OfensiveNode = nil) and (DefensiveNode <> nil) then
   BoardStone[DefensiveNode.X,DefensiveNode.y]:=bsX
  else if (OfensiveNode <> nil) and (DefensiveNode = nil) then
   BoardStone[OfensiveNode.X,OfensiveNode.y]:=bsX
  else
   begin
    Randomize;
    X := Random(14) + 1;
    Y := Random(14) + 1;
    while BoardStone[X, Y] <> bsNone do
     begin
      X := Random(14) + 1;
      Y := Random(14) + 1;
     end;
    BoardStone[x,y]:=bsX;
   end;
  I := pred(NodeList.Count);
  while I > -1 do
   begin
    if NodeList.Objects[I] <> nil then
     begin
      Node := TBrainNode(NodeList.Objects[I]);
      Node.Free;
     end;
    NodeList.Delete(I);
    I := pred(NodeList.Count);
  end;
  NodeList.Free;
  inc(FNodes);
  if Check5 then
   begin
    MessageBox(0,'Az sym pobeditel.','Igrata',0);
    Exit;
   end;
end;

function TForm1.DefensiveTrickCheck(NodeList: TStrings): Boolean;
var
  X, Y: Integer;
begin
  Result:=False;
  if NodeList = nil then Exit;
  for Y := 1 to 15 do
   for X := 1 to 15 do
    begin
     if (X in [1..11]) and (Y in [1..11]) then
        {
          ???_?
          _OO__
          ???O?
          ???O?
          ???_?
        }
        if (BoardStone[X + 3, Y] = bsNone) and
           (BoardStone[X, Y + 1] = bsNone) and
           (BoardStone[X + 1, Y + 1] = bsO) and
           (BoardStone[X + 2, Y + 1] = bsO) and
           (BoardStone[X + 3, Y + 1] = bsNone) and
           (BoardStone[X + 4, Y + 1] = bsNone) and
           (BoardStone[X + 3, Y + 2] = bsO) and
           (BoardStone[X + 3, Y + 3] = bsO) and
           (BoardStone[X + 3, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 3, Y + 1, 5, NodeList);
          Result := True;
        end;

      if (X in [1..11]) and (Y in [1..11]) then
        {
          ?_???
          __OO_
          ?O???
          ?O???
          ?_???
        }
        if (BoardStone[X + 1, Y] = bsNone) and
           (BoardStone[X, Y + 1] = bsNone) and
           (BoardStone[X + 1, Y + 1] = bsNone) and
           (BoardStone[X + 2, Y + 1] = bsO) and
           (BoardStone[X + 3, Y + 1] = bsO) and
           (BoardStone[X + 4, Y + 1] = bsNone) and
           (BoardStone[X + 1, Y + 2] = bsO) and
           (BoardStone[X + 1, Y + 3] = bsO) and
           (BoardStone[X + 1, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 1, Y + 1, 5, NodeList);
          Result := True;
        end;

      if (X in [1..11]) and (Y in [1..11]) then
        {
          ?_???
          ?O???
          ?O???
          __OO_
          ?_???
        }
        if (BoardStone[X + 1, Y] = bsNone) and
           (BoardStone[X + 1, Y + 1] = bsO) and
           (BoardStone[X + 1, Y + 2] = bsO) and
           (BoardStone[X, Y + 3] = bsNone) and
           (BoardStone[X + 1, Y + 3] = bsNone) and
           (BoardStone[X + 2, Y + 3] = bsO) and
           (BoardStone[X + 3, Y + 3] = bsO) and
           (BoardStone[X + 4, Y + 3] = bsNone) and
           (BoardStone[X + 1, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 1, Y + 3, 5, NodeList);
          Result := True;
        end;

      if (X in [1..11]) and (Y in [1..11]) then
        {
          ???_?
          ???O?
          ???O?
          _OO__
          ???_?
        }
        if (BoardStone[X + 3, Y] = bsNone) and
           (BoardStone[X + 3, Y + 1] = bsO) and
           (BoardStone[X + 3, Y + 2] = bsO) and
           (BoardStone[X, Y + 3] = bsNone) and
           (BoardStone[X + 1, Y + 3] = bsO) and
           (BoardStone[X + 2, Y + 3] = bsO) and
           (BoardStone[X + 3, Y + 3] = bsNone) and
           (BoardStone[X + 4, Y + 3] = bsNone) and
           (BoardStone[X + 3, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 3, Y + 3, 5, NodeList);
          Result := True;
        end;

      if (X in [1..11]) and (Y in [1..11]) then
        {
          ??_??
          ??O??
          _O_O_
          ??O??
          ??_??
        }
        if (BoardStone[X + 2, Y] = bsNone) and
           (BoardStone[X + 2, Y + 1] = bsO) and
           (BoardStone[X, Y + 2] = bsNone) and
           (BoardStone[X + 1, Y + 2] = bsO) and
           (BoardStone[X + 2, Y + 2] = bsNone) and
           (BoardStone[X + 3, Y + 2] = bsO) and
           (BoardStone[X + 4, Y + 2] = bsNone) and
           (BoardStone[X + 2, Y + 3] = bsO) and
           (BoardStone[X + 2, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 2, Y + 2, 5, NodeList);
          Result := True;
        end;

      if (X in [1..11]) and (Y in [1..11]) then
        {
          _???_
          ?O?O?
          ??_??
          ?O?O?
          _???_
        }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 4, Y] = bsNone) and
           (BoardStone[X + 1, Y + 1] = bsO) and
           (BoardStone[X + 3, Y + 1] = bsO) and
           (BoardStone[X + 2, Y + 2] = bsNone) and
           (BoardStone[X + 1, Y + 3] = bsO) and
           (BoardStone[X + 3, Y + 3] = bsO) and
           (BoardStone[X, Y + 4] = bsNone) and
           (BoardStone[X + 4, Y + 4] = bsNone) then
        begin
          AddNode('Defensive', bsX, X + 2, Y + 2, 5, NodeList);
          Result := True;
        end;

    end;
end;

function TForm1.HorizontallyCheck(Defensive: Boolean; Stone: TBoardStone;
  NodeList: TStrings): Boolean;
var
  X, Y: Integer;
  NodeStone, OppStone: TBoardStone;
  ItemStr: string;
begin
  Result := False;
  if (Stone = bsNone) or (NodeList = nil) then Exit;
  if Defensive then
  begin
    ItemStr := 'Defensive';
    if Stone = bsO then
    begin
      NodeStone := bsX;
      OppStone := bsO;
    end else
    begin
      NodeStone := bsO;
      OppStone := bsX;
    end;
  end else
  begin
    ItemStr := 'Ofensive';
    NodeStone := Stone;
    if Stone = bsO then
      OppStone := bsX
    else
      OppStone := bsO;
  end;

  for Y := 1 to 15 do
   for X := 1 to 15 do
    begin
      if X <= 10 then
       begin
        { _XX_X_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = bsNone) and
           (BoardStone[X + 4, Y] = Stone) and
           (BoardStone[X + 5, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 3, Y, 4, NodeList);
          Result := True;
         end;
        { _X_XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = bsNone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = Stone) and
           (BoardStone[X + 5, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 2, Y, 4, NodeList);
          Result := True;
         end;
       end;

      if X <= 11 then
       begin
        { XXXX_ }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 4, Y, 5, NodeList);
          Result := True;
         end;
        { XXX_X }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = bsNone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X + 3, Y, 5, NodeList);
          Result := True;
         end;
        { XX_XX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = bsNone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X + 2, Y, 5, NodeList);
          Result := True;
         end;
        { X_XXX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y] = bsNone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X + 1, Y, 5, NodeList);
          Result := True;
         end;
        { _XXXX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 5, NodeList);
          Result := True;
         end;
        { _XXX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 4, Y, 3, NodeList);
          Result := True;
         end;
        { _XX_X }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = bsNone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 3, Y, 3, NodeList);
          Result := True;
         end;
        { _X_XX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = bsNone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = Stone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 2, Y, 3, NodeList);
          Result := True;
         end;
        { _XXXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = OppStone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          Result := True;
         end;
        { OXXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = Stone) and
           (BoardStone[X + 4, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 4, Y, 2, NodeList);
          Result := True;
         end;
       end;

      if X <= 12 then
       begin
        { _XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          AddNode(ItemStr, NodeStone, X + 3, Y, 2, NodeList);
          Result := True;
         end;
        { _XXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = OppStone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
         end;
        { OXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X + 1, Y] = Stone) and
           (BoardStone[X + 2, Y] = Stone) and
           (BoardStone[X + 3, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 3, Y, 1, NodeList);
          Result := True;
         end;
       end;

      if not Defensive and (X <= 14) then
       begin
        { _O }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y] <> bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
         end;
        { O_ }
        if (BoardStone[X, Y] <> bsNone) and
           (BoardStone[X + 1, Y] = bsNone) then
         begin
          AddNode(ItemStr, NodeStone, X + 1, Y, 1, NodeList);
          Result := True;
         end;
       end;

    end;
end;

function TForm1.VerticallyCheck(Defensive: Boolean; Stone: TBoardStone;
  NodeList: TStrings): Boolean;
var
  X, Y: Integer;
  NodeStone, OppStone: TBoardStone;
  ItemStr: string;
begin
  Result := False;
  if (Stone = bsNone) or (NodeList = nil) then Exit;

  if Defensive then
  begin
    ItemStr := 'Defensive';
    if Stone = bsO then
    begin
      NodeStone := bsX;
      OppStone := bsO;
    end else
    begin
      NodeStone := bsO;
      OppStone := bsX;
    end;
  end else
  begin
    ItemStr := 'Ofensive';
    NodeStone := Stone;
    if Stone = bsO then
      OppStone := bsX
    else
      OppStone := bsO;
  end;

  for X := 1 to 15 do
  begin
    for Y := 1 to 15 do
    begin
      if Y <= 10 then
      begin
        { _XX_X_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = bsNone) and
           (BoardStone[X, Y + 4] = Stone) and
           (BoardStone[X, Y + 5] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 3, 4, NodeList);
          Result := True;
        end;
        { _X_XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = bsNone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = Stone) and
           (BoardStone[X, Y + 5] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 2, 4, NodeList);
          Result := True;
        end;
      end;

      if Y <= 11 then
      begin
        { XXXX_ }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 4, 5, NodeList);
          Result := True;
        end;
        { XXX_X }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = bsNone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 3, 5, NodeList);
          Result := True;
        end;
        { XX_XX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = bsNone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 2, 5, NodeList);
          Result := True;
        end;
        { X_XXX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X, Y + 1] = bsNone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 1, 5, NodeList);
          Result := True;
        end;
        { _XXXX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 5, NodeList);
          Result := True;
        end;
        { _XXX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X, Y + 4, 3, NodeList);
          Result := True;
        end;
        { _XX_X }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = bsNone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X, Y + 3, 3, NodeList);
          Result := True;
        end;
        { _X_XX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = bsNone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X, Y + 2, 3, NodeList);
          Result := True;
        end;
        { _XXXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          Result := True;
        end;
        { OXXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = Stone) and
           (BoardStone[X, Y + 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 4, 2, NodeList);
          Result := True;
        end;
      end;

      if Y <= 12 then
      begin
        { _XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          AddNode(ItemStr, NodeStone, X, Y + 3, 2, NodeList);
          Result := True;
        end;
        { _XXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { OXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X, Y + 1] = Stone) and
           (BoardStone[X, Y + 2] = Stone) and
           (BoardStone[X, Y + 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 3, 1, NodeList);
          Result := True;
        end;
      end;

      if not Defensive and (X <= 14) then
      begin
        { _O }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X, Y + 1] <> bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { O_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X, Y + 1] <> bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y + 1, 1, NodeList);
          Result := True;
        end;
      end;

    end;
  end;
end;

function TForm1.ObliqueCheck_TLBR(Defensive: Boolean; Stone: TBoardStone;
  NodeList: TStrings): Boolean;
var
  X, Y: Integer;
  NodeStone, OppStone: TBoardStone;
  ItemStr: string;
begin
  Result := False;
  if (Stone = bsNone) or (NodeList = nil) then Exit;

  if Defensive then
  begin
    ItemStr := 'Defensive';
    if Stone = bsO then
    begin
      NodeStone := bsX;
      OppStone := bsO;
    end else
    begin
      NodeStone := bsO;
      OppStone := bsX;
    end;
  end else
  begin
    ItemStr := 'Ofensive';
    NodeStone := Stone;
    if Stone = bsO then
      OppStone := bsX
    else
      OppStone := bsO;
  end;

  for Y := 1 to 15 do
  begin
    for X := 1 to 15 do
    begin

      if (X in [6..15]) and (Y in [6..15]) then
      begin
        { _XX_X_ }
        if (BoardStone[X - 5, Y - 5] = bsNone) and
           (BoardStone[X - 4, Y - 4] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 2, Y - 2] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X, Y] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 2, Y - 2, 4, NodeList);
          Result := True;
        end;
        { _X_XX_ }
        if (BoardStone[X - 5, Y - 5] = bsNone) and
           (BoardStone[X - 4, Y - 4] = Stone) and
           (BoardStone[X - 3, Y - 3] = bsNone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X, Y] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 3, Y - 3, 4, NodeList);
          Result := True;
        end;
      end;

      if (X in [5..15]) and (Y in [5..15]) then
      begin
        { XXXX_ }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 4, Y - 4, 5, NodeList);
          Result := True;
        end;
        { XXX_X }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = bsNone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X - 3, Y - 3, 5, NodeList);
          Result := True;
        end;
        { XX_XX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = bsNone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X - 2, Y - 2, 5, NodeList);
          Result := True;
        end;
        { X_XXX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X - 1, Y - 1] = bsNone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X - 1, Y - 1, 5, NodeList);
          Result := True;
        end;
        { _XXXX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 5, NodeList);
          Result := True;
        end;
        { _XXX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X - 4, Y - 4, 3, NodeList);
          Result := True;
        end;
        { _XX_X }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = bsNone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X - 3, Y - 3, 3, NodeList);
          Result := True;
        end;
        { _X_XX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = bsNone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X - 2, Y - 2, 3, NodeList);
          Result := True;
        end;
        { _XXXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 1, Y - 2] = Stone) and
           (BoardStone[X - 1, Y - 3] = Stone) and
           (BoardStone[X - 1, Y - 4] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          Result := True;
        end;
        { OXXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = Stone) and
           (BoardStone[X - 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 4, Y - 4, 2, NodeList);
          Result := True;
        end;
      end;

      if (X in [4..15]) and (Y in [4..15]) then
      begin
        { _XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          AddNode(ItemStr, NodeStone, X - 3, Y - 3, 2, NodeList);
          Result := True;
        end;
        { _XXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { OXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X - 1, Y - 1] = Stone) and
           (BoardStone[X - 2, Y - 2] = Stone) and
           (BoardStone[X - 3, Y - 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 3, Y - 3, 1, NodeList);
          Result := True;
        end;
      end;

      if not Defensive and (X <= 14) then
      begin
        { _O }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X - 1, Y - 1] <> bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { O_ }
        if (BoardStone[X, Y] <> bsNone) and
           (BoardStone[X - 1, Y - 1] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X - 1, Y - 1, 1, NodeList);
          Result := True;
        end;
      end;

    end;
  end;
end;

function TForm1.ObliqueCheck_TRBL(Defensive: Boolean; Stone: TBoardStone;
  NodeList: TStrings): Boolean;
var
  X, Y: Integer;
  NodeStone, OppStone: TBoardStone;
  ItemStr: string;
begin
  Result := False;
  if (Stone = bsNone) or (NodeList = nil) then Exit;

  if Defensive then
  begin
    ItemStr := 'Defensive';
    if Stone = bsO then
    begin
      NodeStone := bsX;
      OppStone := bsO;
    end else
    begin
      NodeStone := bsO;
      OppStone := bsX;
    end;
  end else
  begin
    ItemStr := 'Ofensive';
    NodeStone := Stone;
    if Stone = bsO then
      OppStone := bsX
    else
      OppStone := bsO;
  end;

  for Y := 1 to 15 do
  begin
    for X := 1 to 15 do
    begin

      if (X in [1..10]) and (Y in [6..15]) then
      begin
        { _XX_X_ }
        if (BoardStone[X + 5, Y - 5] = bsNone) and
           (BoardStone[X + 4, Y - 4] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 2, Y - 2] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X, Y] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 2, Y - 2, 4, NodeList);
          Result := True;
        end;
        { _X_XX_ }
        if (BoardStone[X + 5, Y - 5] = bsNone) and
           (BoardStone[X + 4, Y - 4] = Stone) and
           (BoardStone[X + 3, Y - 3] = bsNone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X, Y] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 3, Y - 3, 4, NodeList);
          Result := True;
        end;
      end;

      if (X in [1..11]) and (Y in [5..15]) then
      begin
        { XXXX_ }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 4, Y - 4, 5, NodeList);
          Result := True;
        end;
        { XXX_X }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = bsNone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X + 3, Y - 3, 5, NodeList);
          Result := True;
        end;
        { XX_XX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = bsNone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X + 2, Y - 2, 5, NodeList);
          Result := True;
        end;
        { X_XXX }
        if (BoardStone[X, Y] = Stone) and
           (BoardStone[X + 1, Y - 1] = bsNone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X + 1, Y - 1, 5, NodeList);
          Result := True;
        end;
        { _XXXX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 5, NodeList);
          Result := True;
        end;
        { _XXX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 4, Y - 4, 3, NodeList);
          Result := True;
        end;
        { _XX_X }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = bsNone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 3, Y - 3, 3, NodeList);
          Result := True;
        end;
        { _X_XX }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = bsNone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = Stone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 3, NodeList);
          AddNode(ItemStr, NodeStone, X + 2, Y - 2, 3, NodeList);
          Result := True;
        end;
        { _XXXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 1, Y - 2] = Stone) and
           (BoardStone[X + 1, Y - 3] = Stone) and
           (BoardStone[X + 1, Y - 4] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          Result := True;
        end;
        { OXXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = Stone) and
           (BoardStone[X + 4, Y - 4] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 4, Y - 4, 2, NodeList);
          Result := True;
        end;
      end;

      if (X in [1..12]) and (Y in [4..15]) then
      begin
        { _XX_ }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 2, NodeList);
          AddNode(ItemStr, NodeStone, X + 3, Y - 3, 2, NodeList);
          Result := True;
        end;
        { _XXO }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = OppStone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { OXX_ }
        if (BoardStone[X, Y] = OppStone) and
           (BoardStone[X + 1, Y - 1] = Stone) and
           (BoardStone[X + 2, Y - 2] = Stone) and
           (BoardStone[X + 3, Y - 3] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 3, Y - 3, 1, NodeList);
          Result := True;
        end;
      end;

      if not Defensive and (X <= 14) then
      begin
        { _O }
        if (BoardStone[X, Y] = bsNone) and
           (BoardStone[X + 1, Y - 1] <> bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X, Y, 1, NodeList);
          Result := True;
        end;
        { O_ }
        if (BoardStone[X, Y] <> bsNone) and
           (BoardStone[X + 1, Y - 1] = bsNone) then
        begin
          AddNode(ItemStr, NodeStone, X + 1, Y - 1, 1, NodeList);
          Result := True;
        end;
      end;

    end;
  end;
end;

function TForm1.MessageDialog(Text, Title: string; DlgType: TMsgDlgType;
 Buttons: TMsgDlgButtons; BtnCaptions: array of string): Integer;
var dlgButton: TButton;
    i, BtnIndex: Integer;
begin
 with CreateMessageDialog(Text, DlgType, Buttons) do
  begin
   BtnIndex := 0;
   Caption := Title;
   for i := 0 to ComponentCount - 1 do
    if (Components[i] is TButton) then
     begin
      dlgButton := TButton(Components[i]);
      if BtnIndex > High(BtnCaptions) then Break;
      dlgButton.Caption := BtnCaptions[BtnIndex];
      Inc(BtnIndex);
     end;
  Result := ShowModal;
 end;
end;

end.
