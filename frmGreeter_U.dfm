object frmGreeter: TfrmGreeter
  Left = 0
  Top = 0
  Caption = 'Welcome'
  ClientHeight = 421
  ClientWidth = 834
  Color = clBtnFace
  Constraints.MinHeight = 460
  Constraints.MinWidth = 850
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object crplWelcome: TCardPanel
    Left = 0
    Top = 29
    Width = 834
    Height = 363
    Align = alClient
    ActiveCard = crdWelcome
    Caption = 'Welcome Panel'
    TabOrder = 0
    object crdLanding: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 361
      Caption = '1.Landing'
      CardIndex = 0
      TabOrder = 0
    end
    object crdDetails: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 361
      Caption = '2.User Details'
      CardIndex = 1
      TabOrder = 1
      object pnlDetailsHead: TPanel
        Left = 0
        Top = 0
        Width = 832
        Height = 57
        Align = alTop
        Caption = 'Enter your info'
        TabOrder = 0
      end
      object pnlDetails: TPanel
        Left = 0
        Top = 57
        Width = 832
        Height = 304
        Align = alClient
        TabOrder = 1
        object pnlAge: TPanel
          Left = 424
          Top = 73
          Width = 185
          Height = 69
          TabOrder = 0
          object lblAge: TLabel
            Left = 28
            Top = 10
            Width = 21
            Height = 15
            Caption = 'Age'
          end
          object spnAge: TSpinEdit
            Left = 24
            Top = 31
            Width = 121
            Height = 24
            MaxValue = 150
            MinValue = 7
            TabOrder = 0
            Value = 7
            OnChange = spnAgeChange
          end
        end
        object pnlFName: TPanel
          Left = 208
          Top = 71
          Width = 185
          Height = 69
          TabOrder = 1
          object edtFullname: TLabeledEdit
            Left = 24
            Top = 26
            Width = 121
            Height = 23
            EditLabel.Width = 49
            EditLabel.Height = 15
            EditLabel.Caption = 'Fullname'
            TabOrder = 0
            Text = ''
            OnChange = edtFullnameChange
          end
        end
        object pnlHeight: TPanel
          Left = 208
          Top = 175
          Width = 185
          Height = 69
          TabOrder = 2
          object lblHeight: TLabel
            Left = 24
            Top = 5
            Width = 36
            Height = 15
            Caption = 'Height'
          end
          object nbxHeight: TNumberBox
            Left = 24
            Top = 26
            Width = 121
            Height = 23
            Mode = nbmFloat
            MinValue = 30.000000000000000000
            MaxValue = 300.000000000000000000
            TabOrder = 0
            Value = 30.000000000000000000
            StyleName = 'Windows'
            UseMouseWheel = True
            OnChange = nbxHeightChange
          end
        end
        object pnlWeight: TPanel
          Left = 424
          Top = 175
          Width = 185
          Height = 69
          TabOrder = 3
          object lblWeight: TLabel
            Left = 24
            Top = 5
            Width = 38
            Height = 15
            Caption = 'Weight'
          end
          object nbxWeight: TNumberBox
            Left = 20
            Top = 26
            Width = 121
            Height = 23
            Mode = nbmFloat
            MinValue = 10.000000000000000000
            MaxValue = 1000.000000000000000000
            TabOrder = 0
            Value = 10.000000000000000000
            StyleName = 'Windows'
            UseMouseWheel = True
            OnChange = nbxWeightChange
          end
        end
      end
    end
    object crdWelcome: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 361
      Caption = '4.Welcome Tutorial'
      CardIndex = 2
      TabOrder = 2
      OnEnter = crdWelcomeEnter
      object mpWelcome: TMediaPlayer
        Left = 312
        Top = 304
        Width = 141
        Height = 30
        VisibleButtons = [btPlay, btPause, btStop, btPrev, btStep]
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
    end
    object crdGoals: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 361
      Caption = '3.Goals'
      CardIndex = 3
      TabOrder = 3
    end
  end
  object tbTop: TToolBar
    Left = 0
    Top = 0
    Width = 834
    Height = 29
    TabOrder = 1
  end
  object tbNavbar: TToolBar
    Left = 0
    Top = 392
    Width = 834
    Height = 29
    Align = alBottom
    Caption = 'ToolBar1'
    TabOrder = 2
    object btnBack: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 22
      Caption = 'Back'
      TabOrder = 0
      OnClick = btnBackClick
    end
    object btnContinue: TButton
      Left = 75
      Top = 0
      Width = 75
      Height = 22
      Caption = 'Continue'
      TabOrder = 1
      OnClick = btnContinueClick
    end
  end
end
