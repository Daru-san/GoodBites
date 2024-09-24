inherited frmAddFood: TfrmAddFood
  Caption = 'Add food to database'
  ClientHeight = 338
  ClientWidth = 668
  OnShow = FormShow
  ExplicitWidth = 684
  ExplicitHeight = 377
  TextHeight = 15
  inherited Bevel1: TBevel
    Width = 574
    Height = 313
    ExplicitWidth = 574
    ExplicitHeight = 313
  end
  inherited OKBtn: TButton
    Left = 588
    ExplicitLeft = 588
  end
  inherited CancelBtn: TButton
    Left = 588
    Top = 63
    ExplicitLeft = 588
    ExplicitTop = 63
  end
  object HelpBtn: TButton
    Left = 588
    Top = 116
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object edtName: TEdit
    Left = 40
    Top = 38
    Width = 121
    Height = 23
    TabOrder = 3
    TextHint = 'Food name'
  end
  object cbxItems: TComboBox
    Left = 304
    Top = 38
    Width = 145
    Height = 23
    Hint = 'Choose from a list of results'
    TabOrder = 4
    Text = 'Choose an Item'
    OnChange = cbxItemsChange
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
    Left = 374
    Top = 77
    Width = 75
    Height = 25
    Caption = 'Accept Item'
    TabOrder = 6
    OnClick = btnAcceptClick
  end
  object cbxBranded: TCheckBox
    Left = 48
    Top = 71
    Width = 97
    Height = 17
    Caption = 'Branded'
    TabOrder = 7
  end
  object redItems: TRichEdit
    Left = 24
    Top = 108
    Width = 545
    Height = 185
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'redItems')
    ParentFont = False
    TabOrder = 8
  end
end
