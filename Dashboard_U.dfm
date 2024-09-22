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
  object pnlFoot: TPanel
    Left = 0
    Top = 425
    Width = 890
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnLogOut: TButton
      Left = 784
      Top = 16
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Log Out'
      ModalResult = 8
      TabOrder = 0
      OnClick = btnLogOutClick
    end
  end
  object pctDashboard: TPageControl
    Left = 0
    Top = 41
    Width = 890
    Height = 384
    ActivePage = tsEating
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpBottom
    object tsWelcome: TTabSheet
      Caption = 'Welcome'
      ImageIndex = 2
      OnShow = tsWelcomeShow
    end
    object tsProgress: TTabSheet
      Caption = 'Progress'
      OnShow = tsProgressShow
      object pnlCenter: TPanel
        Left = 0
        Top = 0
        Width = 882
        Height = 356
        Align = alClient
        TabOrder = 0
        object lblHeading: TLabel
          Left = 1
          Top = 1
          Width = 880
          Height = 23
          Align = alTop
          Alignment = taCenter
          Caption = 'Progress'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 68
        end
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
        Width = 882
        Height = 356
        Align = alClient
        TabOrder = 0
        object lblEats: TLabel
          Left = 1
          Top = 1
          Width = 880
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
        object btnAddDB: TButton
          Left = 328
          Top = 297
          Width = 75
          Height = 25
          Caption = 'Add new Item'
          TabOrder = 6
          OnClick = btnAddDBClick
        end
      end
    end
    object tsSearch: TTabSheet
      Caption = 'Search Foods'
      ImageIndex = 3
      OnHide = tsSearchHide
      OnShow = tsSearchShow
      object edtSearchMeal: TEdit
        Left = 40
        Top = 112
        Width = 121
        Height = 23
        TabOrder = 0
        TextHint = 'Enter Meal name'
      end
      object btnMealSearch: TButton
        Left = 40
        Top = 168
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
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 890
    Height = 41
    Align = alTop
    TabOrder = 2
    object lblHeader: TLabel
      Left = 1
      Top = 1
      Width = 703
      Height = 39
      Align = alClient
      Alignment = taCenter
      Caption = 'Welcome'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Noto Sans'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 105
      ExplicitHeight = 36
    end
    object pnlUser: TPanel
      Left = 704
      Top = 1
      Width = 185
      Height = 39
      Align = alRight
      TabOrder = 0
      object lblUser: TLabel
        Left = 72
        Top = 16
        Width = 3
        Height = 15
      end
    end
  end
end
