inherited frmSettings: TfrmSettings
  Caption = 'User Settings'
  ClientHeight = 251
  ClientWidth = 486
  OnShow = FormShow
  ExplicitWidth = 502
  ExplicitHeight = 290
  TextHeight = 15
  inherited Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 384
    Height = 251
    Align = alClient
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 345
    ExplicitHeight = 251
  end
  object lblHeight: TLabel [1]
    Left = 40
    Top = 107
    Width = 36
    Height = 15
    Caption = 'Height'
  end
  object lblWeight: TLabel [2]
    Left = 40
    Top = 152
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object lblAge: TLabel [3]
    Left = 200
    Top = 107
    Width = 34
    Height = 15
    Caption = 'Label3'
  end
  object LabeledEdit1: TLabeledEdit [4]
    Left = 40
    Top = 72
    Width = 121
    Height = 23
    EditLabel.Width = 67
    EditLabel.Height = 15
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 1
    Text = ''
  end
  object nbxWeight: TNumberBox [5]
    Left = 40
    Top = 128
    Width = 121
    Height = 23
    TabOrder = 2
  end
  object nbxHeight: TNumberBox [6]
    Left = 40
    Top = 173
    Width = 121
    Height = 23
    TabOrder = 3
  end
  object pnlSide: TPanel [7]
    Left = 384
    Top = 0
    Width = 102
    Height = 251
    Align = alRight
    TabOrder = 0
  end
  inherited OKBtn: TButton
    Left = 403
    Top = 16
    TabOrder = 4
    ExplicitLeft = 403
    ExplicitTop = 16
  end
  inherited CancelBtn: TButton
    Left = 403
    Top = 55
    TabOrder = 5
    ExplicitLeft = 403
    ExplicitTop = 55
  end
  object spnAge: TSpinEdit
    Left = 200
    Top = 128
    Width = 41
    Height = 24
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
end
