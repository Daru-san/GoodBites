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
    object btnLoad: TButton
      Left = 496
      Top = 329
      Width = 75
      Height = 25
      Caption = 'Load Data'
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object cbxNutrients: TComboBox
      Left = 328
      Top = 331
      Width = 145
      Height = 23
      TabOrder = 1
      Text = 'Nutrient'
    end
    object memInfo: TMemo
      Left = 16
      Top = 16
      Width = 569
      Height = 273
      Lines.Strings = (
        'memInfo')
      TabOrder = 2
    end
    object btnData: TButton
      Left = 496
      Top = 295
      Width = 75
      Height = 25
      Caption = 'Reload Data'
      TabOrder = 3
      OnClick = btnDataClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 628
    Height = 41
    Align = alTop
    TabOrder = 1
    object lblHeader: TLabel
      Left = 296
      Top = 16
      Width = 3
      Height = 15
      Alignment = taCenter
    end
  end
  object pnlFoot: TPanel
    Left = 0
    Top = 401
    Width = 628
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
end
