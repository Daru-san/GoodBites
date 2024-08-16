object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = #39
  ClientHeight = 323
  ClientWidth = 650
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
      TabOrder = 0
      object lblHeading: TLabel
        Left = 1
        Top = 1
        Width = 640
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
      AlignWithMargins = True
      Left = 4
      Top = 45
      Width = 636
      Height = 268
      Align = alClient
      Caption = 'Enter'
      TabOrder = 1
      OnClick = btnLoginClick
      ExplicitLeft = 6
      ExplicitTop = 47
    end
  end
end
