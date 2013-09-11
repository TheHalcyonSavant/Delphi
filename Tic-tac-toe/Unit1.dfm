object Form1: TForm1
  Left = 192
  Top = 107
  BorderStyle = bsSingle
  Caption = 'The Game'
  ClientHeight = 410
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 568
    Top = 62
    Width = 25
    Height = 33
    AutoSize = False
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 565
    Top = 18
    Width = 25
    Height = 33
    AutoSize = False
    Caption = 'O'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 432
    Top = 24
    Width = 89
    Height = 25
    AutoSize = False
    Caption = 'YOU'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 432
    Top = 64
    Width = 121
    Height = 25
    AutoSize = False
    Caption = 'Computer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 424
    Top = 360
    Width = 177
    Height = 33
    Caption = 'Start New Game'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DrawGrid1: TDrawGrid
    Left = 8
    Top = 8
    Width = 389
    Height = 389
    BorderStyle = bsNone
    ColCount = 15
    DefaultColWidth = 25
    DefaultRowHeight = 25
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 15
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 1
    OnClick = DrawGrid1Click
    OnDrawCell = DrawGrid1DrawCell
  end
end
