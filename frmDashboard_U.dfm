object frmDashboard: TfrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 465
  ClientWidth = 960
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
    Top = 21
    Width = 820
    Height = 444
    Align = alClient
    ActiveCard = crdProgress
    Caption = 'CardPanel1'
    TabOrder = 0
    object crdProgress: TCard
      Left = 1
      Top = 1
      Width = 818
      Height = 442
      Caption = 'Progress'
      CardIndex = 0
      TabOrder = 0
      object pnlDate: TPanel
        Left = 0
        Top = 401
        Width = 818
        Height = 41
        Align = alBottom
        TabOrder = 0
        object sbtnPrev: TSpeedButton
          Left = 255
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
          Left = 336
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
        object btnEating: TButton
          Left = 712
          Top = 4
          Width = 75
          Height = 25
          Caption = 'Eating'
          TabOrder = 1
          OnClick = btnEatingClick
        end
      end
      object pnlProgIndicator: TPanel
        Left = 0
        Top = 0
        Width = 818
        Height = 401
        Hint = 'Select the date of progress'
        Align = alClient
        TabOrder = 1
        object pnlGoal: TPanel
          Left = 1
          Top = 1
          Width = 408
          Height = 399
          Align = alLeft
          TabOrder = 0
          object pnlCal: TPanel
            Left = 1
            Top = 287
            Width = 406
            Height = 111
            Align = alBottom
            TabOrder = 0
            object lblGoal: TLabel
              Left = 256
              Top = 40
              Width = 61
              Height = 15
              Caption = 'Good work!'
            end
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
            object btnGoGoals: TButton
              Left = 256
              Top = 72
              Width = 89
              Height = 25
              Caption = 'View Goals'
              TabOrder = 2
              OnClick = btnGoGoalsClick
            end
          end
          object Panel1: TPanel
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
          object Panel3: TPanel
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
          object pnlCarb: TPanel
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
          object Panel5: TPanel
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
        object pnlMeals: TPanel
          Left = 409
          Top = 1
          Width = 408
          Height = 399
          Align = alClient
          Caption = 'Panel1'
          TabOrder = 1
          object redMeals: TRichEdit
            Left = 1
            Top = 1
            Width = 406
            Height = 342
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            Lines.Strings = (
              'redMeals')
            ParentFont = False
            TabOrder = 0
            ExplicitTop = 4
          end
          object pnlMealBottom: TPanel
            Left = 1
            Top = 343
            Width = 406
            Height = 55
            Align = alBottom
            TabOrder = 1
            object btnShow: TButton
              Left = 200
              Top = 16
              Width = 75
              Height = 25
              Caption = 'Show info'
              Enabled = False
              TabOrder = 0
              OnClick = btnShowClick
            end
            object btnReset: TButton
              Left = 304
              Top = 16
              Width = 75
              Height = 25
              Caption = 'Reset'
              TabOrder = 1
              OnClick = btnResetClick
            end
            object cbxMeals: TComboBox
              Left = 41
              Top = 16
              Width = 145
              Height = 23
              Enabled = False
              TabOrder = 2
              Text = 'Choose a meal'
            end
          end
        end
      end
    end
    object crdEating: TCard
      Left = 1
      Top = 1
      Width = 818
      Height = 442
      Caption = 'Eating'
      CardIndex = 1
      TabOrder = 1
      object pnlCent: TPanel
        Left = 0
        Top = 0
        Width = 818
        Height = 442
        Align = alClient
        TabOrder = 0
        object lblEats: TLabel
          Left = 1
          Top = 1
          Width = 816
          Height = 23
          Align = alTop
          Alignment = taCenter
          Caption = 'Eatin'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 40
        end
        object RichEdit1: TRichEdit
          Left = 264
          Top = 288
          Width = 185
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            'RichEdit1')
          ParentFont = False
          TabOrder = 0
        end
        object pnlFood: TPanel
          Left = 1
          Top = 24
          Width = 432
          Height = 417
          Align = alLeft
          TabOrder = 1
          object pnlEating: TPanel
            Left = 1
            Top = 1
            Width = 430
            Height = 216
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 4
            ExplicitTop = 6
            object btnAddDB: TButton
              Left = 26
              Top = 160
              Width = 123
              Height = 25
              Caption = 'Search for new meal'
              TabOrder = 0
              OnClick = btnAddDBClick
            end
            object btnEaten: TButton
              Left = 262
              Top = 96
              Width = 75
              Height = 25
              Caption = 'Eaten'
              Enabled = False
              TabOrder = 1
              OnClick = btnEatenClick
            end
            object cbxFoods: TComboBox
              Left = 24
              Top = 50
              Width = 153
              Height = 23
              TabOrder = 2
              Text = 'Choose a food'
              OnChange = cbxFoodsChange
            end
            object cbxMealType: TComboBox
              Left = 26
              Top = 97
              Width = 145
              Height = 23
              Enabled = False
              TabOrder = 3
              Text = 'Meal type'
              OnChange = cbxMealTypeChange
            end
            object edtPortion: TEdit
              Left = 216
              Top = 50
              Width = 137
              Height = 23
              NumbersOnly = True
              TabOrder = 4
              TextHint = 'Portion size(g)'
            end
          end
          object pnlEatBottom: TPanel
            Left = 1
            Top = 217
            Width = 430
            Height = 199
            Align = alBottom
            TabOrder = 1
            ExplicitLeft = 4
            ExplicitTop = 200
          end
        end
        object pnlDisplay: TPanel
          Left = 433
          Top = 24
          Width = 384
          Height = 417
          Align = alClient
          TabOrder = 2
          object redFoodInfo: TRichEdit
            Left = 1
            Top = 1
            Width = 382
            Height = 216
            Align = alTop
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            Lines.Strings = (
              'redMeal')
            ParentFont = False
            TabOrder = 0
            ExplicitLeft = 5
            ExplicitTop = 6
          end
          object pnlDisplayBottom: TPanel
            Left = 1
            Top = 217
            Width = 382
            Height = 199
            Align = alClient
            TabOrder = 1
            ExplicitLeft = -7
            ExplicitTop = 223
          end
        end
      end
    end
    object crdGoals: TCard
      Left = 1
      Top = 1
      Width = 818
      Height = 442
      Caption = 'Edit goals'
      CardIndex = 2
      TabOrder = 2
    end
  end
  object tbDashboard: TToolBar
    Left = 0
    Top = 0
    Width = 960
    Height = 21
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 83
    Caption = 'Dashboard'
    Customizable = True
    List = True
    ShowCaptions = True
    TabOrder = 1
    object tbtSidebar: TToolButton
      Left = 0
      Top = 0
      Caption = 'Open Sidebar'
      ImageIndex = 0
      OnClick = tbtSidebarClick
    end
  end
  object svSidebar: TSplitView
    Left = 0
    Top = 21
    Width = 140
    Height = 444
    OpenedWidth = 140
    Placement = svpLeft
    TabOrder = 2
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
    object btnReturn: TButton
      Left = 17
      Top = 360
      Width = 89
      Height = 25
      Caption = 'Return to Main'
      TabOrder = 2
      OnClick = btnReturnClick
    end
    object btnSettings: TButton
      Left = 17
      Top = 319
      Width = 89
      Height = 25
      Caption = 'User Settings'
      TabOrder = 3
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
    end
  end
end
