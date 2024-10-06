object frmDashboard: TfrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 472
  ClientWidth = 995
  Color = clBtnFace
  Constraints.MinHeight = 465
  Constraints.MinWidth = 960
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object crplDashboard: TCardPanel
    Left = 140
    Top = 0
    Width = 855
    Height = 472
    Align = alClient
    ActiveCard = crdProgress
    Caption = 'CardPanel1'
    TabOrder = 0
    object crdProgress: TCard
      Left = 1
      Top = 1
      Width = 853
      Height = 470
      Caption = '1. Progress'
      CardIndex = 0
      TabOrder = 0
      object pnlDateNavigation: TPanel
        Left = 0
        Top = 429
        Width = 853
        Height = 41
        Align = alBottom
        TabOrder = 0
        object sbtnPrev: TSpeedButton
          Left = 239
          Top = 6
          Width = 57
          Height = 22
          Caption = 'Prev'
          OnClick = sbtnPrevClick
        end
        object sbtnNext: TSpeedButton
          Left = 538
          Top = 6
          Width = 57
          Height = 22
          Caption = 'Next'
          Enabled = False
          OnClick = sbtnNextClick
        end
        object dpcDay: TDateTimePicker
          Left = 328
          Top = 5
          Width = 186
          Height = 23
          Hint = 'Select the date of progress'
          Date = 45539.000000000000000000
          Time = 45539.000000000000000000
          MinDate = 45292.000000000000000000
          TabOrder = 0
          OnChange = dpcDayChange
        end
      end
      object pnlProgressCenter: TPanel
        Left = 0
        Top = 0
        Width = 853
        Height = 429
        Hint = 'Select the date of progress'
        Align = alClient
        TabOrder = 1
        object pnlProgressGoals: TPanel
          Left = 1
          Top = 1
          Width = 408
          Height = 427
          Align = alLeft
          TabOrder = 0
          object pnlProgressCal: TPanel
            Left = 1
            Top = 315
            Width = 406
            Height = 111
            Align = alBottom
            TabOrder = 0
            object edtCalories: TLabeledEdit
              Left = 21
              Top = 44
              Width = 121
              Height = 23
              EditLabel.Width = 71
              EditLabel.Height = 15
              EditLabel.Caption = 'Daily Calories'
              TabOrder = 0
              Text = ''
            end
            object prgCalories: TProgressBar
              Left = 21
              Top = 73
              Width = 150
              Height = 17
              Smooth = True
              TabOrder = 1
            end
          end
          object pnlProgressWater: TPanel
            Left = 1
            Top = 231
            Width = 406
            Height = 60
            Align = alTop
            TabOrder = 1
            object edtWater: TLabeledEdit
              Left = 21
              Top = 28
              Width = 121
              Height = 23
              EditLabel.Width = 66
              EditLabel.Height = 15
              EditLabel.Caption = 'Water intake'
              TabOrder = 0
              Text = ''
            end
            object prgWater: TProgressBar
              Left = 148
              Top = 28
              Width = 252
              Height = 23
              Smooth = True
              TabOrder = 1
            end
          end
          object pnlProgressFat: TPanel
            Left = 1
            Top = 171
            Width = 406
            Height = 60
            Align = alTop
            TabOrder = 2
            object edtFat: TLabeledEdit
              Left = 21
              Top = 28
              Width = 121
              Height = 23
              EditLabel.Width = 16
              EditLabel.Height = 15
              EditLabel.Caption = 'Fat'
              TabOrder = 0
              Text = ''
            end
            object prgFat: TProgressBar
              Left = 148
              Top = 28
              Width = 255
              Height = 24
              Smooth = True
              TabOrder = 1
            end
          end
          object pnlProgressCarb: TPanel
            Left = 1
            Top = 51
            Width = 406
            Height = 60
            Align = alTop
            Locked = True
            TabOrder = 3
            object edtCarb: TLabeledEdit
              Left = 21
              Top = 28
              Width = 121
              Height = 23
              EditLabel.Width = 72
              EditLabel.Height = 15
              EditLabel.Caption = 'Carbohydrate'
              TabOrder = 0
              Text = ''
            end
            object prgCarb: TProgressBar
              Left = 148
              Top = 28
              Width = 254
              Height = 23
              Smooth = True
              TabOrder = 1
            end
          end
          object pnlProgressProtein: TPanel
            Left = 1
            Top = 111
            Width = 406
            Height = 60
            Align = alTop
            TabOrder = 4
            object edtProtein: TLabeledEdit
              Left = 21
              Top = 23
              Width = 121
              Height = 23
              EditLabel.Width = 38
              EditLabel.Height = 15
              EditLabel.Caption = 'Protein'
              TabOrder = 0
              Text = ''
            end
            object prgProtein: TProgressBar
              Left = 148
              Top = 23
              Width = 254
              Height = 23
              Smooth = True
              TabOrder = 1
            end
          end
          object pnlProgTop: TPanel
            Left = 1
            Top = 1
            Width = 406
            Height = 50
            Align = alTop
            TabOrder = 5
            object lblProg: TLabel
              Left = 1
              Top = 1
              Width = 404
              Height = 48
              Align = alClient
              Alignment = taCenter
              Caption = 'Progress for'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -23
              Font.Name = 'Bahnschrift'
              Font.Style = []
              ParentFont = False
              Layout = tlCenter
              ExplicitWidth = 130
              ExplicitHeight = 28
            end
          end
        end
        object pnlProgressMeals: TPanel
          Left = 409
          Top = 1
          Width = 443
          Height = 427
          Align = alClient
          Caption = 'Panel1'
          TabOrder = 1
          object redMeals: TRichEdit
            Left = 1
            Top = 1
            Width = 441
            Height = 370
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            Lines.Strings = (
              'redMeals')
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object pnlMealBottom: TPanel
            Left = 1
            Top = 371
            Width = 441
            Height = 55
            Align = alBottom
            TabOrder = 1
            object btnReset: TButton
              Left = 304
              Top = 16
              Width = 75
              Height = 25
              Caption = 'Reset'
              TabOrder = 0
              OnClick = btnResetClick
            end
            object cbxMeals: TComboBox
              Left = 41
              Top = 16
              Width = 200
              Height = 23
              Enabled = False
              TabOrder = 1
              Text = 'Choose a meal'
              OnChange = cbxMealsChange
            end
          end
        end
      end
    end
    object crdEating: TCard
      Left = 1
      Top = 1
      Width = 853
      Height = 470
      Caption = '2. Eating'
      CardIndex = 1
      TabOrder = 1
      OnEnter = crdEatingEnter
      object pnlCent: TPanel
        Left = 0
        Top = 0
        Width = 853
        Height = 470
        Align = alClient
        TabOrder = 0
        object pnlFood: TPanel
          Left = 1
          Top = 42
          Width = 851
          Height = 219
          Align = alClient
          TabOrder = 0
          object pnlEating: TPanel
            Left = 1
            Top = 1
            Width = 407
            Height = 217
            Align = alClient
            BevelOuter = bvSpace
            TabOrder = 0
            object btnAddDB: TButton
              Left = 18
              Top = 160
              Width = 123
              Height = 25
              Caption = 'Search for new meal'
              TabOrder = 0
              OnClick = btnAddDBClick
            end
            object btnEaten: TButton
              Left = 278
              Top = 112
              Width = 75
              Height = 25
              Caption = 'Eat food'
              Enabled = False
              TabOrder = 1
              OnClick = btnEatenClick
            end
            object cbxFoods: TComboBox
              Left = 18
              Top = 66
              Width = 153
              Height = 23
              TabOrder = 2
              Text = 'Choose a food'
              OnChange = cbxFoodsChange
            end
            object cbxMealType: TComboBox
              Left = 18
              Top = 113
              Width = 145
              Height = 23
              Enabled = False
              TabOrder = 3
              Text = 'Meal type'
              OnChange = cbxMealTypeChange
            end
            object edtPortion: TEdit
              Left = 216
              Top = 66
              Width = 137
              Height = 23
              NumbersOnly = True
              TabOrder = 4
              TextHint = 'Portion size(g)'
            end
            object pnlEatingFoodHeader: TPanel
              Left = 1
              Top = 1
              Width = 405
              Height = 41
              Align = alTop
              Caption = 'Eating Food items'
              TabOrder = 5
            end
          end
          object pnlDrinkingWater: TPanel
            Left = 408
            Top = 1
            Width = 442
            Height = 217
            Align = alRight
            BevelOuter = bvSpace
            TabOrder = 1
            object btnDrinking: TButton
              Left = 44
              Top = 136
              Width = 97
              Height = 25
              Caption = 'Drink Water'
              TabOrder = 0
              OnClick = btnDrinkingClick
            end
            object edtWaterInput: TLabeledEdit
              Left = 42
              Top = 80
              Width = 121
              Height = 23
              EditLabel.Width = 66
              EditLabel.Height = 15
              EditLabel.Caption = 'Water Intake'
              TabOrder = 1
              Text = ''
              TextHint = 'Numbers only(ml)'
              OnChange = edtWaterInputChange
            end
            object pnlDrinkingHeader: TPanel
              Left = 1
              Top = 1
              Width = 440
              Height = 41
              Align = alTop
              Caption = 'Drinking Water'
              TabOrder = 2
            end
          end
        end
        object pnlDisplay: TPanel
          Left = 1
          Top = 261
          Width = 851
          Height = 208
          Align = alBottom
          TabOrder = 1
          object redFoodInfo: TRichEdit
            Left = 1
            Top = 1
            Width = 407
            Height = 206
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            Lines.Strings = (
              'redMeal')
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
          object pnlMealHelp: TPanel
            Left = 408
            Top = 1
            Width = 442
            Height = 206
            Align = alRight
            BevelOuter = bvLowered
            TabOrder = 1
          end
        end
        object pnlEatingHead: TPanel
          Left = 1
          Top = 1
          Width = 851
          Height = 41
          Align = alTop
          Caption = 'Eating and Drinking'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object crdGoals: TCard
      Left = 1
      Top = 1
      Width = 853
      Height = 470
      Caption = '3. Edit goals'
      CardIndex = 2
      TabOrder = 2
      object crplGoals: TCardPanel
        Left = 0
        Top = 41
        Width = 853
        Height = 429
        Align = alClient
        ActiveCard = crdGoalOV
        TabOrder = 0
        object crdGoalOV: TCard
          Left = 1
          Top = 1
          Width = 851
          Height = 427
          Caption = 'Goals Overview'
          CardIndex = 0
          TabOrder = 0
          OnEnter = crdGoalOVEnter
          object pnlGoalsOVTop: TPanel
            Left = 0
            Top = 0
            Width = 851
            Height = 41
            Align = alTop
            Caption = 'Overview'
            TabOrder = 0
          end
          object pnlGoalsOVCenter: TPanel
            Left = 0
            Top = 41
            Width = 851
            Height = 386
            Align = alClient
            TabOrder = 1
            object btnGoalCalories: TButton
              Left = 72
              Top = 120
              Width = 105
              Height = 25
              Caption = 'View Calorie Goal'
              TabOrder = 0
              OnClick = btnGoalCaloriesClick
            end
            object btnGoalCarb: TButton
              Left = 72
              Top = 272
              Width = 105
              Height = 25
              Caption = 'View Carbs Goal'
              TabOrder = 1
              OnClick = btnGoalCarbClick
            end
            object btnGoalFat: TButton
              Left = 282
              Top = 272
              Width = 95
              Height = 25
              Caption = 'View Fats Goal'
              TabOrder = 2
              OnClick = btnGoalFatClick
            end
            object btnGoalProtein: TButton
              Left = 528
              Top = 120
              Width = 105
              Height = 25
              Caption = 'View Protein Goal'
              TabOrder = 3
              OnClick = btnGoalProteinClick
            end
            object btnGoalWater: TButton
              Left = 282
              Top = 120
              Width = 105
              Height = 25
              Caption = 'View Water Goal'
              TabOrder = 4
              OnClick = btnGoalWaterClick
            end
            object edtGoalCal: TLabeledEdit
              Left = 72
              Top = 48
              Width = 121
              Height = 23
              EditLabel.Width = 42
              EditLabel.Height = 15
              EditLabel.Caption = 'Calories'
              ReadOnly = True
              TabOrder = 5
              Text = ''
            end
            object edtGoalCarb: TLabeledEdit
              Left = 72
              Top = 200
              Width = 121
              Height = 23
              EditLabel.Width = 77
              EditLabel.Height = 15
              EditLabel.Caption = 'Carbohydrates'
              ReadOnly = True
              TabOrder = 6
              Text = ''
            end
            object edtGoalFat: TLabeledEdit
              Left = 282
              Top = 200
              Width = 121
              Height = 23
              EditLabel.Width = 57
              EditLabel.Height = 15
              EditLabel.Caption = 'Fats/Lipids'
              ReadOnly = True
              TabOrder = 7
              Text = ''
            end
            object edtGoalProtein: TLabeledEdit
              Left = 528
              Top = 48
              Width = 121
              Height = 23
              EditLabel.Width = 38
              EditLabel.Height = 15
              EditLabel.Caption = 'Protein'
              ReadOnly = True
              TabOrder = 8
              Text = ''
            end
            object edtGoalWater: TLabeledEdit
              Left = 282
              Top = 48
              Width = 121
              Height = 23
              EditLabel.Width = 66
              EditLabel.Height = 15
              EditLabel.Caption = 'Water intake'
              ReadOnly = True
              TabOrder = 9
              Text = ''
            end
            object redGoalsHelp: TRichEdit
              Left = 528
              Top = 200
              Width = 209
              Height = 101
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              HideSelection = False
              Lines.Strings = (
                'redGoalsHelp')
              ParentFont = False
              PlainText = True
              ReadOnly = True
              TabOrder = 10
              Transparent = True
            end
          end
        end
        object crdGoalView: TCard
          Left = 1
          Top = 1
          Width = 851
          Height = 427
          Caption = 'View Goal'
          CardIndex = 1
          TabOrder = 1
          object pnlGoalDesc: TPanel
            Left = 547
            Top = 0
            Width = 304
            Height = 427
            Align = alRight
            TabOrder = 0
            object redGoalDesc: TRichEdit
              Left = 1
              Top = 42
              Width = 302
              Height = 288
              Align = alClient
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Segoe UI'
              Font.Style = []
              Lines.Strings = (
                'redGoalDesc')
              MaxLength = 100
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
            end
            object pnlDesc: TPanel
              Left = 1
              Top = 1
              Width = 302
              Height = 41
              Align = alTop
              Caption = 'Goal Description'
              TabOrder = 1
            end
            object pnlDescBottom: TPanel
              Left = 1
              Top = 330
              Width = 302
              Height = 96
              Align = alBottom
              TabOrder = 2
              object lblDescMaxChar: TLabel
                Left = 184
                Top = 72
                Width = 103
                Height = 15
                Caption = '100 Characters max'
              end
              object btnGoalDescEdit: TButton
                Left = 40
                Top = 32
                Width = 89
                Height = 25
                Caption = 'Enable Editing'
                TabOrder = 0
                OnClick = btnGoalDescEditClick
              end
              object btnGoalDescPost: TButton
                Left = 160
                Top = 32
                Width = 121
                Height = 25
                Caption = 'Post new description'
                Enabled = False
                TabOrder = 1
                OnClick = btnGoalDescPostClick
              end
            end
          end
          object pnlGoalOV: TPanel
            Left = 0
            Top = 0
            Width = 547
            Height = 427
            Align = alClient
            TabOrder = 1
            object edtGoalTarget: TLabeledEdit
              Left = 72
              Top = 76
              Width = 121
              Height = 23
              EditLabel.Width = 32
              EditLabel.Height = 15
              EditLabel.Caption = 'Target'
              ReadOnly = True
              TabOrder = 0
              Text = ''
            end
            object pnlGoalHead: TPanel
              Left = 1
              Top = 1
              Width = 545
              Height = 41
              Align = alTop
              Caption = 'Goal'
              TabOrder = 1
            end
            object pnlGoalAve: TPanel
              Left = 72
              Top = 121
              Width = 345
              Height = 216
              TabOrder = 2
              object edtAverageProg: TLabeledEdit
                Left = 24
                Top = 40
                Width = 121
                Height = 23
                EditLabel.Width = 91
                EditLabel.Height = 15
                EditLabel.Caption = 'Average Progress'
                ReadOnly = True
                TabOrder = 0
                Text = ''
              end
              object prgAverage: TProgressBar
                Left = 24
                Top = 69
                Width = 298
                Height = 20
                TabOrder = 1
              end
              object edtGoalDays: TLabeledEdit
                Left = 176
                Top = 120
                Width = 121
                Height = 23
                EditLabel.Width = 97
                EditLabel.Height = 15
                EditLabel.Caption = 'No. Days achieved'
                ReadOnly = True
                TabOrder = 2
                Text = ''
              end
              object prgDays: TProgressBar
                Left = 24
                Top = 160
                Width = 289
                Height = 17
                TabOrder = 3
              end
              object edtGoalDate: TLabeledEdit
                Left = 24
                Top = 120
                Width = 121
                Height = 23
                EditLabel.Width = 51
                EditLabel.Height = 15
                EditLabel.Caption = 'Start Date'
                ReadOnly = True
                TabOrder = 4
                Text = ''
              end
            end
            object btnEditGoal: TButton
              Left = 72
              Top = 360
              Width = 209
              Height = 25
              Caption = 'Edit Goal(Resets previous progress)'
              TabOrder = 3
              OnClick = btnEditGoalClick
            end
            object btnBackOV: TButton
              Left = 320
              Top = 360
              Width = 99
              Height = 25
              Caption = 'Back to overview'
              TabOrder = 4
              OnClick = btnBackOVClick
            end
            object cbxGoalUnit: TComboBox
              Left = 240
              Top = 76
              Width = 145
              Height = 23
              TabOrder = 5
              Text = 'Unit of measurement'
              OnChange = cbxGoalUnitChange
            end
          end
        end
      end
      object pnlGoalTop: TPanel
        Left = 0
        Top = 0
        Width = 853
        Height = 41
        Align = alTop
        Caption = 'Goals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object svSidebar: TSplitView
    Left = 0
    Top = 0
    Width = 140
    Height = 472
    OpenedWidth = 140
    Placement = svpLeft
    TabOrder = 1
    OnMouseEnter = svSidebarMouseEnter
    OnResize = svSidebarResize
    object lblHello: TLabel
      Left = 0
      Top = 0
      Width = 140
      Height = 24
      Align = alTop
      Alignment = taCenter
      Caption = 'Hello User'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Bahnschrift'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 96
    end
    object edtSVCalorie: TLabeledEdit
      Left = 1
      Top = 65
      Width = 121
      Height = 23
      Alignment = taCenter
      EditLabel.Width = 84
      EditLabel.Height = 15
      EditLabel.Caption = 'Today'#39's Calories'
      TabOrder = 0
      Text = ''
    end
    object edtSVWater: TLabeledEdit
      Left = 1
      Top = 127
      Width = 121
      Height = 23
      Alignment = taCenter
      EditLabel.Width = 108
      EditLabel.Height = 15
      EditLabel.Caption = 'Today'#39's Water Intake'
      TabOrder = 1
      Text = ''
    end
    object btnGoProgress: TButton
      Left = 17
      Top = 360
      Width = 89
      Height = 25
      Caption = 'Progress'
      Enabled = False
      TabOrder = 2
      OnClick = btnGoProgressClick
    end
    object btnSettings: TButton
      Left = 17
      Top = 200
      Width = 89
      Height = 25
      Caption = 'User Settings'
      TabOrder = 3
      Visible = False
      OnClick = btnSettingsClick
    end
    object btnLogOut: TButton
      Left = 17
      Top = 406
      Width = 100
      Height = 25
      Caption = 'Log Out'
      ModalResult = 8
      TabOrder = 4
      OnClick = btnLogOutClick
    end
    object btnGoGoals: TButton
      Left = 17
      Top = 307
      Width = 89
      Height = 25
      Caption = 'View Goals'
      TabOrder = 5
      OnClick = btnGoGoalsClick
    end
    object btnGoEating: TButton
      Left = 17
      Top = 260
      Width = 89
      Height = 25
      Caption = 'Eat and Drink'
      TabOrder = 6
      OnClick = btnGoEatingClick
    end
  end
end
