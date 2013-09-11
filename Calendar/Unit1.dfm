object Form1: TForm1
  Left = 266
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Calendar'
  ClientHeight = 409
  ClientWidth = 366
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
    Left = 112
    Top = 320
    Width = 60
    Height = 20
    Caption = 'YEAR: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 35
    Top = 135
    Width = 31
    Height = 97
    Caption = '<'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 300
    Top = 135
    Width = 31
    Height = 97
    Caption = '>'
    OnClick = SpeedButton2Click
  end
  object Label2: TLabel
    Left = 80
    Top = 40
    Width = 201
    Height = 25
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 136
    Top = 352
    Width = 89
    Height = 25
    Caption = 'Find'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 184
    Top = 320
    Width = 65
    Height = 21
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object StringGrid1: TStringGrid
    Left = 72
    Top = 80
    Width = 220
    Height = 220
    ColCount = 7
    DefaultColWidth = 30
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 7
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 2
  end
end
