object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = 'Welcome to GoodBites'
  ClientHeight = 470
  ClientWidth = 767
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
    Width = 761
    Height = 464
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 187
    ExplicitTop = 235
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 759
      Height = 41
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 777
      object lblHeading: TLabel
        Left = 1
        Top = 1
        Width = 757
        Height = 39
        Align = alClient
        Alignment = taCenter
        BiDiMode = bdLeftToRight
        Caption = 'Welcome to Goodbites'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitLeft = -519
        ExplicitTop = 33
      end
    end
    object btnLogin: TButton
      Left = 304
      Top = 352
      Width = 81
      Height = 25
      Caption = 'Enter'
      TabOrder = 1
      OnClick = btnLoginClick
    end
  end
end
