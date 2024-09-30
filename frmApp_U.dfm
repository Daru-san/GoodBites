object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = 'Goodbites'
  ClientHeight = 323
  ClientWidth = 650
  Color = clBtnFace
  Constraints.MinHeight = 270
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 644
    Height = 317
    Align = alClient
    AutoSize = True
    TabOrder = 0
    object imgCenter: TImage
      Left = 1
      Top = 1
      Width = 642
      Height = 315
      Align = alClient
      ExplicitLeft = 4
      ExplicitTop = 7
    end
    object btnEnter: TButton
      AlignWithMargins = True
      Left = 296
      Top = 240
      Width = 75
      Height = 25
      Caption = 'Enter'
      Default = True
      TabOrder = 0
      OnClick = btnEnterClick
    end
  end
end
