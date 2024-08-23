object frmHelp: TfrmHelp
  Left = 0
  Top = 0
  Caption = 'Goodbites: Help'
  ClientHeight = 473
  ClientWidth = 930
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pcHelp: TPageControl
    Left = 0
    Top = 61
    Width = 930
    Height = 412
    ActivePage = tsExplain
    Align = alClient
    TabOrder = 0
    object tsExplain: TTabSheet
      Caption = 'What is this app?'
      OnShow = tsExplainShow
      object memPurpose: TMemo
        Left = 24
        Top = 16
        Width = 873
        Height = 345
        Lines.Strings = (
          'memPurpose')
        TabOrder = 0
      end
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 930
    Height = 61
    Align = alTop
    TabOrder = 1
    object lblHeader: TLabel
      Left = 448
      Top = 16
      Width = 3
      Height = 15
    end
  end
end
