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
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 401
    Height = 164
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object edtPassword: TEdit
      Left = 48
      Top = 96
      Width = 121
      Height = 23
      PasswordChar = '*'
      TabOrder = 0
      TextHint = 'Password'
    end
    object edtUser: TEdit
      Left = 48
      Top = 40
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
    BevelOuter = bvSpace
    TabOrder = 1
    DesignSize = (
      407
      37)
    object btnLogin: TButton
      Left = 221
      Top = 3
      Width = 71
      Height = 25
      Caption = 'Login'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnLoginClick
    end
    object btnCancel: TButton
      Left = 298
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnSignUp: TButton
      Left = 140
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Sign Up'
      TabOrder = 2
      OnClick = btnSignUpClick
    end
  end
  object pnlHead: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 41
    Align = alTop
    BevelEdges = [beBottom]
    BevelOuter = bvSpace
    TabOrder = 2
    object lblHead: TLabel
      Left = 1
      Top = 1
      Width = 405
      Height = 39
      Align = alClient
      AutoSize = False
      Caption = 'To login or not to login? That is the question!'
      Layout = tlCenter
      ExplicitWidth = 3
      ExplicitHeight = 15
    end
  end
end
