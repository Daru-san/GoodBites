object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 248
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 401
    Height = 205
    Align = alClient
    AutoSize = True
    TabOrder = 0
    ExplicitWidth = 397
    ExplicitHeight = 204
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
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 211
    Width = 407
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 210
    ExplicitWidth = 403
    DesignSize = (
      407
      37)
    object btnLogin: TButton
      Left = 231
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Login'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnLoginClick
      ExplicitLeft = 227
    end
    object btnCancel: TButton
      Left = 318
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 314
    end
  end
end
