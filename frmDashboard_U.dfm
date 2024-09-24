object frmDashboard: TfrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 466
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object pctDashboard: TPageControl
    Left = 50
    Top = 0
    Width = 840
    Height = 466
    ActivePage = tsProgress
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpLeft
    ExplicitLeft = 0
    ExplicitTop = 41
    ExplicitWidth = 890
    ExplicitHeight = 384
    object tsProgress: TTabSheet
      Caption = 'Progress'
      OnShow = tsProgressShow
      object pnlCenter: TPanel
        Left = 0
        Top = 0
        Width = 809
        Height = 458
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 659
        ExplicitHeight = 376
        object btnLoadData: TButton
          Left = 288
          Top = 302
          Width = 75
          Height = 25
          Caption = 'Load Data'
          TabOrder = 0
          OnClick = btnLoadDataClick
        end
        object dpcDay: TDateTimePicker
          Left = 80
          Top = 304
          Width = 186
          Height = 23
          Hint = 'Select the date of progress'
          Date = 45539.000000000000000000
          Time = 0.691364155092742300
          TabOrder = 1
        end
        object pnlProgIndicator: TPanel
          Left = -1
          Top = 30
          Width = 441
          Height = 241
          Hint = 'Select the date of progress'
          TabOrder = 2
          object lblDayCalorie: TLabel
            Left = 16
            Top = 32
            Width = 99
            Height = 15
            Caption = 'Total Daily Calories'
          end
          object memMealLog: TMemo
            Left = 136
            Top = 29
            Width = 304
            Height = 196
            Lines.Strings = (
              'memMealLog')
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object edtCaloires: TEdit
            Left = 19
            Top = 61
            Width = 96
            Height = 23
            NumbersOnly = True
            ReadOnly = True
            TabOrder = 1
          end
        end
        object pnlGoal: TPanel
          Left = 504
          Top = 30
          Width = 351
          Height = 241
          TabOrder = 3
          object memGoals: TMemo
            Left = 24
            Top = 32
            Width = 313
            Height = 193
            Lines.Strings = (
              'memGoals')
            TabOrder = 0
          end
        end
      end
    end
    object tsEating: TTabSheet
      Caption = 'Eating'
      ImageIndex = 1
      OnShow = tsEatingShow
      object pnlCent: TPanel
        Left = 0
        Top = 0
        Width = 809
        Height = 458
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 659
        ExplicitHeight = 376
        object lblEats: TLabel
          Left = 1
          Top = 1
          Width = 807
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
        object lblMeal: TLabel
          Left = 499
          Top = 89
          Width = 69
          Height = 15
          Caption = 'Current Meal'
        end
        object btnEaten: TButton
          Left = 328
          Top = 328
          Width = 75
          Height = 25
          Caption = 'Eaten'
          TabOrder = 0
          OnClick = btnEatenClick
        end
        object cmbMeals: TComboBox
          Left = 32
          Top = 56
          Width = 153
          Height = 23
          TabOrder = 1
          Text = 'Choose a food'
        end
        object edtPortion: TEdit
          Left = 240
          Top = 56
          Width = 137
          Height = 23
          NumbersOnly = True
          TabOrder = 2
          TextHint = 'Portion size(g)'
        end
        object memMeal: TMemo
          Left = 499
          Top = 110
          Width = 356
          Height = 235
          Lines.Strings = (
            'memMeal')
          TabOrder = 3
        end
        object btnSearch: TButton
          Left = 227
          Top = 328
          Width = 75
          Height = 25
          Caption = 'Search Foods'
          TabOrder = 4
          OnClick = btnSearchClick
        end
        object cmbMealType: TComboBox
          Left = 32
          Top = 81
          Width = 145
          Height = 23
          TabOrder = 5
          Text = 'Meal type'
        end
      end
    end
    object tsSearch: TTabSheet
      Caption = 'Search Foods'
      ImageIndex = 3
      OnHide = tsSearchHide
      OnShow = tsSearchShow
      object lblFoodname: TLabel
        Left = 40
        Top = 83
        Width = 115
        Height = 15
        Caption = 'Enter your food name'
      end
      object edtSearchMeal: TEdit
        Left = 176
        Top = 80
        Width = 121
        Height = 23
        TabOrder = 0
        TextHint = 'Enter Meal name'
      end
      object btnMealSearch: TButton
        Left = 222
        Top = 128
        Width = 75
        Height = 25
        Caption = 'Search Meals'
        TabOrder = 1
        OnClick = btnMealSearchClick
      end
      object redMealInfo: TRichEdit
        Left = 376
        Top = 32
        Width = 465
        Height = 297
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Lines.Strings = (
          'redMealInfo')
        ParentFont = False
        TabOrder = 2
      end
      object btnAddDB: TButton
        Left = 174
        Top = 297
        Width = 123
        Height = 25
        Caption = 'Search for new meal'
        TabOrder = 3
        OnClick = btnAddDBClick
      end
    end
  end
  object SplitView1: TSplitView
    Left = 0
    Top = 0
    Width = 50
    Height = 466
    CloseStyle = svcCompact
    Opened = False
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 1
    OnClosing = SplitView1Closing
    OnOpened = SplitView1Opened
    ExplicitLeft = -6
    object btnLogOut: TButton
      Left = -10
      Top = 437
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Log Out'
      ModalResult = 8
      TabOrder = 0
      OnClick = btnLogOutClick
    end
    object pnlUser: TPanel
      Left = 0
      Top = 4
      Width = 73
      Height = 41
      TabOrder = 1
      object lblUser: TLabel
        Left = 24
        Top = 16
        Width = 3
        Height = 15
      end
    end
    object btnSplit: TButton
      Left = -4
      Top = 416
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 2
      OnClick = btnSplitClick
    end
  end
end
