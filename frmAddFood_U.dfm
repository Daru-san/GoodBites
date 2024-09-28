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
    Height = 322
    ExplicitWidth = 574
    ExplicitHeight = 322
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
  object cbxItems: TComboBox
    Left = 368
    Top = 52
    Width = 145
    Height = 23
    Hint = 'Choose from a list of results'
    Enabled = False
    TabOrder = 3
    Text = 'Choose an Item'
    OnChange = cbxItemsChange
  end
  object btnQuery: TButton
    Left = 200
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Query'
    Enabled = False
    TabOrder = 4
    OnClick = btnQueryClick
  end
  object btnAccept: TButton
    Left = 438
    Top = 93
    Width = 75
    Height = 25
    Caption = 'Accept Item'
    Enabled = False
    TabOrder = 5
    OnClick = btnAcceptClick
  end
  object cbxBranded: TCheckBox
    Left = 40
    Top = 97
    Width = 97
    Height = 17
    Caption = 'Branded'
    Enabled = False
    TabOrder = 6
  end
  object redItems: TRichEdit
    Left = 24
    Top = 133
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
    TabOrder = 7
  end
  object edtQuery: TLabeledEdit
    Left = 40
    Top = 52
    Width = 121
    Height = 23
    EditLabel.Width = 62
    EditLabel.Height = 15
    EditLabel.Caption = 'Enter Query'
    TabOrder = 8
    Text = ''
    TextHint = 'Food name'
  end
end
