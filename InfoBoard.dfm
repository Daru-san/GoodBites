object frmInfo: TfrmInfo
  Left = 0
  Top = 0
  Caption = 'Goodbites: Info'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object pnlCenter: TPanel
    Left = 0
    Top = 41
    Width = 628
    Height = 360
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 144
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object redText: TRichEdit
      Left = 16
      Top = 6
      Width = 577
      Height = 309
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'redText')
      ParentFont = False
      TabOrder = 0
    end
    object btnLoad: TButton
      Left = 496
      Top = 329
      Width = 75
      Height = 25
      Caption = 'Load Data'
      TabOrder = 1
      OnClick = btnLoadClick
    end
    object cbxNutrients: TComboBox
      Left = 328
      Top = 331
      Width = 145
      Height = 23
      TabOrder = 2
      Text = 'Nutrient'
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 232
    ExplicitTop = 224
    ExplicitWidth = 185
    object lblHeader: TLabel
      Left = 296
      Top = 16
      Width = 3
      Height = 15
    end
  end
  object pnlFoot: TPanel
    Left = 0
    Top = 401
    Width = 628
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 232
    ExplicitTop = 224
    ExplicitWidth = 185
  end
end
