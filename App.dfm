object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = 'Goodbites'
  ClientHeight = 323
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 644
    Height = 317
    Align = alClient
    TabOrder = 0
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 642
      Height = 41
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvSpace
      TabOrder = 0
      object lblHeading: TLabel
        Left = 1
        Top = 1
        Width = 636
        Height = 35
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
      AlignWithMargins = True
      Left = 4
      Top = 272
      Width = 636
      Height = 41
      Align = alBottom
      Caption = 'Enter'
      TabOrder = 1
      StyleName = 'Windows'
      OnClick = btnLoginClick
    end
    object btnHelp: TButton
      Left = 288
      Top = 136
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 2
      OnClick = btnHelpClick
    end
  end
end
