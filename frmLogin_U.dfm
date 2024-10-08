object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Goodbites: Login'
  ClientHeight = 371
  ClientWidth = 605
  Color = clBtnFace
  Constraints.MinHeight = 410
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object crplLogin: TCardPanel
    Left = 0
    Top = 41
    Width = 605
    Height = 330
    Align = alClient
    ActiveCard = crdSign
    TabOrder = 0
    object crdLogin: TCard
      Left = 1
      Top = 1
      Width = 603
      Height = 328
      Caption = 'Login'
      CardIndex = 0
      TabOrder = 0
      OnEnter = crdLoginEnter
      object pnlLoginCenter: TPanel
        Left = 0
        Top = 35
        Width = 603
        Height = 293
        Align = alClient
        TabOrder = 0
        object pnlGoSignup: TPanel
          Left = 375
          Top = 6
          Width = 228
          Height = 115
          BevelKind = bkFlat
          TabOrder = 0
          object lblNew: TLabel
            Left = 66
            Top = 33
            Width = 55
            Height = 15
            Caption = 'New User?'
          end
          object btnGoSignUp: TButton
            Left = 62
            Top = 63
            Width = 75
            Height = 25
            Caption = 'Sign Up'
            TabOrder = 0
            OnClick = btnGoSignUpClick
          end
        end
        object pnlLogin: TPanel
          Left = 16
          Top = 6
          Width = 353
          Height = 270
          BevelKind = bkTile
          TabOrder = 1
          object btnLogin: TButton
            Left = 34
            Top = 192
            Width = 75
            Height = 25
            Caption = 'Login'
            Default = True
            Enabled = False
            TabOrder = 0
            OnClick = btnLoginClick
          end
          object edtUser: TLabeledEdit
            Left = 34
            Top = 64
            Width = 121
            Height = 23
            Hint = 'Enter your username'
            EditLabel.Width = 53
            EditLabel.Height = 15
            EditLabel.Caption = 'Username'
            MaxLength = 12
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            Text = ''
            TextHint = 'Lorem Ipsum'
            OnChange = edtUserChange
            OnKeyPress = edtUserKeyPress
          end
          object edtPassword: TLabeledEdit
            Left = 34
            Top = 138
            Width = 121
            Height = 23
            Hint = 'Enter your password'
            EditLabel.Width = 50
            EditLabel.Height = 15
            EditLabel.Caption = 'Password'
            MaxLength = 20
            ParentShowHint = False
            PasswordChar = '*'
            ShowHint = True
            TabOrder = 2
            Text = ''
            TextHint = 'Strong password'
            OnChange = edtPasswordChange
            OnKeyPress = edtPasswordKeyPress
          end
        end
      end
      object pnlLoginTop: TPanel
        Left = 0
        Top = 0
        Width = 603
        Height = 35
        Align = alTop
        Caption = 'Login'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object crdSign: TCard
      Left = 1
      Top = 1
      Width = 603
      Height = 328
      Caption = 'Sign Up'
      CardIndex = 1
      TabOrder = 1
      OnEnter = crdSignEnter
      object pnlSignUpTop: TPanel
        Left = 0
        Top = 0
        Width = 603
        Height = 35
        Align = alTop
        Caption = 'Sign Up'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object pnlSignUpCenter: TPanel
        Left = 0
        Top = 35
        Width = 603
        Height = 293
        Align = alClient
        TabOrder = 1
        object pnlNewSub: TPanel
          Left = 376
          Top = 6
          Width = 227
          Height = 115
          BevelKind = bkSoft
          TabOrder = 0
          object lblCreate: TLabel
            Left = 55
            Top = 30
            Width = 110
            Height = 15
            Caption = 'Create your account!'
          end
          object btnGoLogin: TButton
            Left = 63
            Top = 68
            Width = 86
            Height = 25
            Caption = 'Login Instead?'
            TabOrder = 0
            OnClick = btnGoLoginClick
          end
        end
        object pnlNewUser: TPanel
          Left = 16
          Top = 6
          Width = 354
          Height = 273
          BevelKind = bkFlat
          TabOrder = 1
          object btnCreate: TButton
            Left = 32
            Top = 234
            Width = 97
            Height = 25
            Caption = 'Create Account'
            Default = True
            Enabled = False
            TabOrder = 0
            OnClick = btnCreateClick
          end
          object cbxTerms: TCheckBox
            Left = 32
            Top = 211
            Width = 201
            Height = 17
            Caption = 'You agree with our terms of use'
            Enabled = False
            TabOrder = 1
            OnClick = cbxTermsClick
          end
          object edtNewPassConf: TLabeledEdit
            Left = 32
            Top = 165
            Width = 121
            Height = 23
            Hint = 'Ensure they are the same'
            EditLabel.Width = 113
            EditLabel.Height = 15
            EditLabel.Caption = 'Repeat that password'
            Enabled = False
            MaxLength = 20
            PasswordChar = '*'
            TabOrder = 2
            Text = ''
            TextHint = 'Really, really strong password'
            OnChange = edtNewPassConfChange
          end
          object edtNewPassword: TLabeledEdit
            Left = 32
            Top = 107
            Width = 121
            Height = 23
            Hint = 'Password must be over 8 characters and include a number/s'
            EditLabel.Width = 126
            EditLabel.Height = 15
            EditLabel.Caption = 'Enter a strong password'
            Enabled = False
            MaxLength = 20
            PasswordChar = '*'
            TabOrder = 3
            Text = ''
            TextHint = 'Really strong password'
            OnChange = edtNewPasswordChange
          end
          object edtNewUser: TLabeledEdit
            Left = 32
            Top = 45
            Width = 121
            Height = 23
            Hint = 'Enter your username'
            EditLabel.Width = 109
            EditLabel.Height = 15
            EditLabel.Caption = 'Enter your username'
            MaxLength = 12
            TabOrder = 4
            Text = ''
            TextHint = 'Lorem Ipsum'
            OnChange = edtNewUserChange
          end
          object cbxReveal: TCheckBox
            Left = 208
            Top = 168
            Width = 113
            Height = 17
            Caption = 'Reveal password'
            Enabled = False
            TabOrder = 5
            OnClick = cbxRevealClick
          end
        end
      end
    end
  end
  object pnlLoginHead: TPanel
    Left = 0
    Top = 0
    Width = 605
    Height = 41
    Align = alTop
    Caption = 'Welcome To Goodbites'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Bahnschrift'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object btnHome: TButton
    Left = 488
    Top = 319
    Width = 75
    Height = 25
    Caption = 'Home'
    TabOrder = 2
    OnClick = btnHomeClick
  end
end
