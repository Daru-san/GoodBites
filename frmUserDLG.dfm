object OKRightDlg: TOKRightDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 179
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 161
    Shape = bsFrame
  end
  object lblFName: TLabel
    Left = 80
    Top = 45
    Width = 52
    Height = 15
    Caption = 'Full name'
  end
  object lblAge: TLabel
    Left = 80
    Top = 107
    Width = 21
    Height = 15
    Caption = 'Age'
  end
  object OKBtn: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edtFName: TEdit
    Left = 160
    Top = 42
    Width = 121
    Height = 23
    TabOrder = 2
    TextHint = 'Full name'
  end
  object spnAge: TSpinEdit
    Left = 160
    Top = 104
    Width = 121
    Height = 24
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
end
