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
        ExplicitLeft = -1
        ExplicitTop = 5
      end
      object pnlDetails: TPanel
        Left = 0
        Top = 57
        Width = 832
        Height = 304
        Align = alClient
        TabOrder = 1
        object lblHeight: TLabel
          Left = 98
          Top = 139
          Width = 36
          Height = 15
          Caption = 'Height'
        end
        object lblWeight: TLabel
          Left = 272
          Top = 144
          Width = 38
          Height = 15
          Caption = 'Weight'
        end
        object lblAge: TLabel
          Left = 272
          Top = 65
          Width = 21
          Height = 15
          Caption = 'Age'
        end
        object rgpActivity: TRadioGroup
          Left = 488
          Top = 83
          Width = 185
          Height = 105
          Caption = 'Activity Levels'
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
          Left = 98
          Top = 165
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
          Left = 272
          Top = 165
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
          Left = 264
          Top = 86
          Width = 121
          Height = 24
          MaxValue = 150
          MinValue = 7
          TabOrder = 3
          Value = 7
          OnChange = spnAgeChange
        end
        object edtFullname: TLabeledEdit
          Left = 98
          Top = 86
          Width = 121
          Height = 23
          EditLabel.Width = 49
          EditLabel.Height = 15
          EditLabel.Caption = 'Fullname'
          TabOrder = 4
          Text = ''
          OnChange = edtFullnameChange
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
        Left = 360
        Top = 296
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
        ExplicitLeft = 304
        ExplicitTop = 168
        ExplicitWidth = 185
      end
      object crplGoals: TCardPanel
        Left = 0
        Top = 41
        Width = 832
        Height = 320
        Align = alClient
        ActiveCard = crdGoalsOverview
        BevelOuter = bvNone
        Caption = 'Goals'
        TabOrder = 1
        ExplicitLeft = 392
        ExplicitTop = 200
        ExplicitWidth = 300
        ExplicitHeight = 200
        object crdGoalsOverview: TCard
          Left = 0
          Top = 0
          Width = 832
          Height = 320
          Caption = '1. Overview'
          CardIndex = 0
          TabOrder = 0
          ExplicitWidth = 185
          ExplicitHeight = 41
          object pnlGoalOVCenter: TPanel
            Left = 0
            Top = 41
            Width = 832
            Height = 279
            Align = alClient
            TabOrder = 0
            ExplicitLeft = -1
            ExplicitTop = 36
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
            ExplicitLeft = -1
            ExplicitTop = 5
            ExplicitWidth = 830
          end
        end
      end
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
    Transparent = True
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
