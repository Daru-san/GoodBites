object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 488
  ClientWidth = 855
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
    Width = 849
    Height = 412
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object edtPassword: TEdit
      Left = 697
      Top = 336
      Width = 121
      Height = 23
      PasswordChar = '*'
      TabOrder = 0
      TextHint = 'Password'
    end
    object edtUser: TEdit
      Left = 697
      Top = 288
      Width = 121
      Height = 23
      TabOrder = 1
      TextHint = 'User'
    end
    object btnGoLogin: TButton
      Left = 368
      Top = 96
      Width = 75
      Height = 25
      Caption = 'Login'
      TabOrder = 2
    end
    object btnGoSignUp: TButton
      Left = 368
      Top = 168
      Width = 75
      Height = 25
      Caption = 'Sign Up'
      TabOrder = 3
    end
  end
  object pnlHead: TPanel
    Left = 0
    Top = 0
    Width = 855
    Height = 41
    Align = alTop
    BevelEdges = [beBottom]
    BevelOuter = bvSpace
    TabOrder = 1
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 459
    Width = 855
    Height = 29
    Align = alBottom
    Caption = 'ToolBar1'
    TabOrder = 2
    DesignSize = (
      855
      29)
    object btnHome: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Home'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnHomeClick
    end
    object btnLogin: TButton
      Left = 75
      Top = 0
      Width = 71
      Height = 22
      Caption = 'Login'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnLoginClick
    end
    object btnSignUp: TButton
      Left = 146
      Top = 0
      Width = 75
      Height = 22
      Caption = 'Sign Up'
      TabOrder = 2
      OnClick = btnSignUpClick
    end
  end
end
