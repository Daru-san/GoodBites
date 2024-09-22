inherited frmAddFood: TfrmAddFood
  Caption = 'Add food to database'
  OnShow = FormShow
  TextHeight = 15
  inherited Bevel1: TBevel
    Top = 10
    ExplicitTop = 10
  end
  inherited OKBtn: TButton
    OnClick = OKBtnClick
  end
  object HelpBtn: TButton
    Left = 300
    Top = 68
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object edtName: TEdit
    Left = 24
    Top = 38
    Width = 121
    Height = 23
    TabOrder = 3
    TextHint = 'Food name'
  end
  object cbxItems: TComboBox
    Left = 24
    Top = 104
    Width = 145
    Height = 23
    Hint = 'Choose from a list of results'
    TabOrder = 4
    Text = 'Choose an Item'
  end
  object btnQuery: TButton
    Left = 192
    Top = 37
    Width = 75
    Height = 25
    Caption = 'Query'
    TabOrder = 5
    OnClick = btnQueryClick
  end
  object btnAccept: TButton
    Left = 192
    Top = 103
    Width = 75
    Height = 25
    Caption = 'Accept Item'
    TabOrder = 6
    OnClick = btnAcceptClick
  end
end
