inherited frmAddFood: TfrmAddFood
  Caption = 'Search foods'
  ClientHeight = 338
  ClientWidth = 669
  Constraints.MinHeight = 377
  Constraints.MinWidth = 685
  OnShow = FormShow
  ExplicitWidth = 685
  ExplicitHeight = 377
  TextHeight = 15
  inherited Bevel1: TBevel
    Width = 574
    Height = 322
    ExplicitWidth = 574
    ExplicitHeight = 322
  end
  object lblSelectItem: TLabel [1]
    Left = 368
    Top = 31
    Width = 95
    Height = 15
    Caption = 'Select a food item'
  end
  inherited OKBtn: TButton
    Left = 588
    Caption = 'Accept'
    Enabled = False
    OnClick = OKBtnClick
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
    Visible = False
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
    Caption = 'Search'
    Enabled = False
    TabOrder = 4
    OnClick = btnQueryClick
  end
  object cbxBranded: TCheckBox
    Left = 40
    Top = 97
    Width = 97
    Height = 17
    Caption = 'Branded'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 5
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
    ReadOnly = True
    TabOrder = 6
  end
  object btnCustom: TButton
    Left = 588
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Custom Item'
    TabOrder = 7
    OnClick = btnCustomClick
  end
  object edtQuery: TLabeledEdit
    Left = 40
    Top = 52
    Width = 121
    Height = 23
    Hint = 'Name of the food item to query'
    EditLabel.Width = 88
    EditLabel.Height = 15
    EditLabel.Caption = 'Enter food name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Text = ''
    TextHint = 'Food name'
    OnChange = edtQueryChange
  end
end
