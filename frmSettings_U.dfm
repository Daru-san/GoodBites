object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  ClientHeight = 427
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 564
    Height = 29
    ButtonHeight = 15
    Caption = 'ToolBar1'
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 0
      Width = 249
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object lblHead: TLabel
      Left = 249
      Top = 0
      Width = 68
      Height = 15
      Caption = 'User Settings'
    end
    object ToolButton2: TToolButton
      Left = 317
      Top = 0
      Width = 246
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
  end
  object crplSettings: TCardPanel
    Left = 0
    Top = 29
    Width = 564
    Height = 398
    Align = alClient
    ActiveCard = crdMain
    Caption = 'CardPanel1'
    TabOrder = 1
    object crdMain: TCard
      Left = 1
      Top = 1
      Width = 562
      Height = 396
      Caption = 'Main'
      CardIndex = 0
      TabOrder = 0
      object lblAge: TLabel
        Left = 207
        Top = 235
        Width = 21
        Height = 15
        Caption = 'Age'
      end
      object btnChangePass: TButton
        Left = 218
        Top = 170
        Width = 75
        Height = 25
        Caption = 'Change?'
        TabOrder = 0
        OnClick = btnChangePassClick
      end
      object edtUser: TLabeledEdit
        Left = 72
        Top = 104
        Width = 121
        Height = 23
        Hint = 'Cannot be changed'
        DoubleBuffered = False
        EditLabel.Width = 53
        EditLabel.Height = 15
        EditLabel.Caption = 'Username'
        ParentDoubleBuffered = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        Text = ''
        TextHint = 'Unchangable'
      end
      object edtPassword: TLabeledEdit
        Left = 72
        Top = 171
        Width = 121
        Height = 23
        EditLabel.Width = 50
        EditLabel.Height = 15
        EditLabel.Caption = 'Password'
        ReadOnly = True
        TabOrder = 2
        Text = '************'
      end
      object edtName: TLabeledEdit
        Left = 232
        Top = 104
        Width = 121
        Height = 23
        EditLabel.Width = 32
        EditLabel.Height = 15
        EditLabel.Caption = 'Name'
        TabOrder = 3
        Text = ''
      end
      object spnAge: TSpinEdit
        Left = 207
        Top = 256
        Width = 41
        Height = 24
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 0
      end
      object btnUpdate: TButton
        Left = 80
        Top = 255
        Width = 75
        Height = 25
        Caption = 'Update Info'
        TabOrder = 5
      end
      object edtHeight: TLabeledEdit
        Left = 360
        Top = 256
        Width = 121
        Height = 23
        EditLabel.Width = 36
        EditLabel.Height = 15
        EditLabel.Caption = 'Height'
        NumbersOnly = True
        TabOrder = 6
        Text = ''
      end
    end
    object crdPassChange: TCard
      Left = 1
      Top = 1
      Width = 562
      Height = 396
      Caption = 'Change Password'
      CardIndex = 1
      TabOrder = 1
    end
  end
end
