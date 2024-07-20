object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 248
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 401
    Height = 242
    Align = alClient
    AutoSize = True
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 465
    ExplicitHeight = 265
    object lblPass: TLabel
      Left = 40
      Top = 147
      Width = 50
      Height = 15
      Caption = 'Password'
    end
    object lblUser: TLabel
      Left = 40
      Top = 67
      Width = 23
      Height = 15
      Caption = 'User'
    end
    object Edit2: TEdit
      Left = 160
      Top = 144
      Width = 121
      Height = 23
      TabOrder = 0
      Text = 'Edit2'
    end
    object Edit1: TEdit
      Left = 160
      Top = 64
      Width = 121
      Height = 23
      TabOrder = 1
      Text = 'Edit1'
    end
  end
end
