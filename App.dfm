object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = 'Welcome to GoodBites'
  ClientHeight = 332
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 680
    Height = 326
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 749
    ExplicitHeight = 461
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 678
      Height = 41
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 747
      object lblHeading: TLabel
        Left = 1
        Top = 1
        Width = 676
        Height = 39
        Align = alClient
        Alignment = taCenter
        BiDiMode = bdLeftToRight
        Caption = 'Welcome to Goodbites'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitWidth = 121
        ExplicitHeight = 15
      end
    end
    object btnLogin: TButton
      Left = 280
      Top = 216
      Width = 81
      Height = 25
      Caption = 'Enter'
      TabOrder = 1
      OnClick = btnLoginClick
    end
  end
end
