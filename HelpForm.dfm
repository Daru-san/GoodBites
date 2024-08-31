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
    Height = 371
    ActivePage = tsExplain
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 412
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
  object pnlFoot: TPanel
    Left = 0
    Top = 432
    Width = 930
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 384
    ExplicitTop = 240
    ExplicitWidth = 185
    object btnExit: TButton
      Left = 826
      Top = 14
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Exit'
      TabOrder = 0
      OnClick = btnExitClick
    end
  end
end
