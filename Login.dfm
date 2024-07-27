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
    ExplicitWidth = 397
    ExplicitHeight = 241
    object edtPassword: TEdit
      Left = 48
      Top = 144
      Width = 121
      Height = 23
      PasswordChar = '*'
      TabOrder = 0
      TextHint = 'Password'
    end
    object edtUser: TEdit
      Left = 48
      Top = 64
      Width = 121
      Height = 23
      TabOrder = 1
      TextHint = 'User'
    end
    object btnLogin: TButton
      Left = 256
      Top = 143
      Width = 75
      Height = 25
      Caption = 'Login'
      TabOrder = 2
      OnClick = btnLoginClick
    end
  end
end
