object frmWelcome: TfrmWelcome
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
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object crplWelcome: TCardPanel
    Left = 0
    Top = 0
    Width = 834
    Height = 389
    Align = alClient
    ActiveCard = crdLanding
    Caption = 'Welcome Panel'
    TabOrder = 0
    object crdLanding: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 387
      Caption = '1.Landing'
      CardIndex = 0
      TabOrder = 0
      object pnlLandingCenter: TPanel
        Left = 0
        Top = 0
        Width = 832
        Height = 387
        Align = alClient
        TabOrder = 0
        object lblWelcome: TLabel
          Left = 1
          Top = 1
          Width = 830
          Height = 32
          Align = alTop
          Alignment = taCenter
          Caption = 'Welcome to Goodbites!'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Bac'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 290
        end
        object pnlLandingIMG: TPanel
          Left = 120
          Top = 72
          Width = 225
          Height = 153
          TabOrder = 0
          object imgLanding: TImage
            Left = 1
            Top = 1
            Width = 223
            Height = 151
            Align = alClient
            Center = True
            Proportional = True
            Stretch = True
            ExplicitLeft = 113
            ExplicitTop = 25
          end
        end
        object memExplanation: TMemo
          Left = 464
          Top = 73
          Width = 321
          Height = 216
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            'What to expect from here:'
            '- We will ask for your information to calculate '
            'your goals'
            '- You can view your goals after your first login'
            '- A short video will be given to help you get '
            'up '
            'to scratch'
            ''
            'Happy Eating!')
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object crdDetails: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 387
      Caption = '2.User Details'
      CardIndex = 1
      TabOrder = 1
      object pnlDetailsHead: TPanel
        Left = 0
        Top = 0
        Width = 832
        Height = 51
        Align = alTop
        Caption = 'Enter your info'
        TabOrder = 0
      end
      object pnlDetails: TPanel
        Left = 0
        Top = 51
        Width = 832
        Height = 336
        Align = alClient
        TabOrder = 1
        ExplicitTop = 47
        object lblHeight: TLabel
          Left = 217
          Top = 178
          Width = 61
          Height = 15
          Caption = 'Height(cm)'
        end
        object lblWeight: TLabel
          Left = 58
          Top = 178
          Width = 59
          Height = 15
          Caption = 'Weight(kg)'
        end
        object lblAge: TLabel
          Left = 217
          Top = 72
          Width = 21
          Height = 15
          Caption = 'Age'
        end
        object lblHelpNote: TLabel
          Left = 608
          Top = 72
          Width = 32
          Height = 15
          Caption = 'NOTE:'
        end
        object rgpActivity: TRadioGroup
          Left = 362
          Top = 178
          Width = 185
          Height = 105
          Caption = 'Activity Levels'
          Enabled = False
          Items.Strings = (
            'Sleeping all day'
            'Inside most of the time'
            'Somewhat active '
            'Pretty Active'
            'Very Active')
          TabOrder = 0
          OnClick = rgpActivityClick
        end
        object nbxHeight: TNumberBox
          Left = 217
          Top = 199
          Width = 121
          Height = 23
          Mode = nbmFloat
          MinValue = 30.000000000000000000
          MaxValue = 300.000000000000000000
          TabOrder = 1
          Value = 30.000000000000000000
          StyleName = 'Windows'
          UseMouseWheel = True
          OnChange = nbxHeightChange
        end
        object nbxWeight: TNumberBox
          Left = 58
          Top = 199
          Width = 121
          Height = 23
          Mode = nbmFloat
          MinValue = 10.000000000000000000
          MaxValue = 1000.000000000000000000
          TabOrder = 2
          Value = 10.000000000000000000
          StyleName = 'Windows'
          UseMouseWheel = True
          OnChange = nbxWeightChange
        end
        object spnAge: TSpinEdit
          Left = 217
          Top = 93
          Width = 41
          Height = 24
          MaxValue = 150
          MinValue = 7
          TabOrder = 3
          Value = 7
          OnChange = spnAgeChange
        end
        object edtFullname: TLabeledEdit
          Left = 58
          Top = 93
          Width = 121
          Height = 23
          EditLabel.Width = 49
          EditLabel.Height = 15
          EditLabel.Caption = 'Fullname'
          TabOrder = 4
          Text = ''
          OnChange = edtFullnameChange
        end
        object rgpGender: TRadioGroup
          Left = 362
          Top = 64
          Width = 185
          Height = 79
          Caption = 'Biological Sex'
          Enabled = False
          Items.Strings = (
            'Male'
            'Female')
          TabOrder = 5
        end
        object redInfoHelp: TRichEdit
          Left = 608
          Top = 93
          Width = 185
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            'These values are used to calculate '
            'your total recommended '
            'nutrients')
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
      end
    end
    object crdWelcome: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 387
      Caption = '4.Welcome Tutorial'
      CardIndex = 2
      TabOrder = 2
      OnEnter = crdWelcomeEnter
      object mpWelcomeVideo: TWindowsMediaPlayer
        Left = 0
        Top = 0
        Width = 832
        Height = 387
        Align = alClient
        TabOrder = 0
        OnEndOfStream = mpWelcomeVideoEndOfStream
        ExplicitWidth = 245
        ExplicitHeight = 240
        ControlData = {
          000300000800000000000500000000000000F03F030000000000050000000000
          0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
          08000200000000000300320000000B00000008000A000000660075006C006C00
          00000B0000000B0000000B00FFFF0B00FFFF0B00000008000200000000000800
          020000000000080002000000000008000200000000000B000000FD550000FF27
          0000}
      end
    end
    object crdGoals: TCard
      Left = 1
      Top = 1
      Width = 832
      Height = 387
      Caption = '3.Goals'
      CardIndex = 3
      TabOrder = 3
      object pnlGoalsHead: TPanel
        Left = 0
        Top = 0
        Width = 832
        Height = 41
        Align = alTop
        Caption = 'Your Goals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Bahnschrift'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object crplGoals: TCardPanel
        Left = 0
        Top = 41
        Width = 832
        Height = 346
        Align = alClient
        ActiveCard = crdGoalsOverview
        BevelOuter = bvNone
        Caption = 'Goals'
        TabOrder = 1
        object crdGoalsOverview: TCard
          Left = 0
          Top = 0
          Width = 832
          Height = 346
          Caption = '1. Overview'
          CardIndex = 0
          TabOrder = 0
          object pnlGoalOVCenter: TPanel
            Left = 0
            Top = 41
            Width = 832
            Height = 305
            Align = alClient
            TabOrder = 0
            object lblCarbTargetPerc: TLabel
              Left = 255
              Top = 109
              Width = 106
              Height = 15
              Caption = '50% of total calories'
            end
            object lblFatTargetPerc: TLabel
              Left = 472
              Top = 109
              Width = 106
              Height = 15
              Caption = '30% of total calories'
            end
            object lblProteinTargetPerc: TLabel
              Left = 656
              Top = 109
              Width = 106
              Height = 15
              Caption = '20% of total calories'
            end
            object lblTotalCalCalc: TLabel
              Left = 74
              Top = 109
              Width = 56
              Height = 15
              Caption = 'Calculated'
            end
            object lblWaterAdd: TLabel
              Left = 73
              Top = 209
              Width = 133
              Height = 15
              Caption = 'Edit your daily water goal'
            end
            object edtGoalCalories: TLabeledEdit
              Left = 73
              Top = 80
              Width = 121
              Height = 23
              EditLabel.Width = 77
              EditLabel.Height = 15
              EditLabel.Caption = 'Target Calories'
              ReadOnly = True
              TabOrder = 0
              Text = ''
            end
            object edtGoalCarb: TLabeledEdit
              Left = 255
              Top = 80
              Width = 121
              Height = 23
              EditLabel.Width = 107
              EditLabel.Height = 15
              EditLabel.Caption = 'Target Carbohydrate'
              NumbersOnly = True
              ReadOnly = True
              TabOrder = 1
              Text = ''
            end
            object edtGoalProtein: TLabeledEdit
              Left = 656
              Top = 80
              Width = 121
              Height = 23
              EditLabel.Width = 73
              EditLabel.Height = 15
              EditLabel.Caption = 'Target Protein'
              NumbersOnly = True
              ReadOnly = True
              TabOrder = 2
              Text = ''
            end
            object edtGoalFats: TLabeledEdit
              Left = 472
              Top = 80
              Width = 121
              Height = 23
              EditLabel.Width = 56
              EditLabel.Height = 15
              EditLabel.Caption = 'Target Fats'
              NumbersOnly = True
              ReadOnly = True
              TabOrder = 3
              Text = ''
            end
            object edtGoalWater: TLabeledEdit
              Left = 73
              Top = 180
              Width = 121
              Height = 23
              EditLabel.Width = 88
              EditLabel.Height = 15
              EditLabel.Caption = 'Water Target(ml)'
              NumbersOnly = True
              TabOrder = 4
              Text = ''
              TextHint = '2000ml'
            end
          end
          object pnlGoalOVTop: TPanel
            Left = 0
            Top = 0
            Width = 832
            Height = 41
            Align = alTop
            Caption = 'They can be edited via the dashboard'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsItalic]
            ParentFont = False
            TabOrder = 1
          end
        end
      end
    end
  end
  object pnlNav: TPanel
    Left = 0
    Top = 389
    Width = 834
    Height = 32
    Align = alBottom
    AutoSize = True
    TabOrder = 1
    object btnBack: TButton
      Left = 296
      Top = 1
      Width = 75
      Height = 30
      Caption = 'Back'
      TabOrder = 0
      OnClick = btnBackClick
    end
    object btnContinue: TButton
      Left = 416
      Top = 1
      Width = 75
      Height = 30
      Caption = 'Continue'
      Default = True
      TabOrder = 1
      OnClick = btnContinueClick
    end
  end
end
