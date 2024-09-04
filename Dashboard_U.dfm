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
  object pnlCenter: TPanel
    Left = 0
    Top = 0
    Width = 890
    Height = 425
    Align = alClient
    TabOrder = 0
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 888
      Height = 41
      Align = alTop
      TabOrder = 0
      object lblHeader: TLabel
        Left = 1
        Top = 1
        Width = 701
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
        Left = 702
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
    object pnlProgress: TPanel
      Left = 1
      Top = 42
      Width = 448
      Height = 382
      Align = alLeft
      TabOrder = 1
      object lblHeading: TLabel
        Left = 1
        Top = 1
        Width = 446
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
      object dpcDay: TDateTimePicker
        Left = 80
        Top = 304
        Width = 186
        Height = 23
        Hint = 'Select the date of progress'
        Date = 45539.000000000000000000
        Time = 0.691364155092742300
        TabOrder = 0
      end
      object btnLoadData: TButton
        Left = 288
        Top = 302
        Width = 75
        Height = 25
        Caption = 'Load Data'
        TabOrder = 1
        OnClick = btnLoadDataClick
      end
      object pnlProgIndicator: TPanel
        Left = 1
        Top = 24
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
          Left = 232
          Top = 29
          Width = 208
          Height = 196
          Lines.Strings = (
            'memMealLog')
          TabOrder = 0
        end
        object edtCaloires: TEdit
          Left = 130
          Top = 29
          Width = 96
          Height = 23
          NumbersOnly = True
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object pnlNav: TPanel
      Left = 448
      Top = 42
      Width = 441
      Height = 382
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 449
      ExplicitTop = 39
      object lblEats: TLabel
        Left = 1
        Top = 1
        Width = 439
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
      object cmbMeals: TComboBox
        Left = 32
        Top = 72
        Width = 153
        Height = 33
        TabOrder = 0
        Text = 'Choose a food'
      end
      object edtPortion: TEdit
        Left = 240
        Top = 72
        Width = 137
        Height = 33
        NumbersOnly = True
        TabOrder = 1
        TextHint = 'Portion size(g)'
      end
      object btnEaten: TButton
        Left = 328
        Top = 328
        Width = 75
        Height = 25
        Caption = 'Eaten'
        TabOrder = 2
        OnClick = btnEatenClick
      end
      object pnlNewMeal: TPanel
        Left = 7
        Top = 129
        Width = 434
        Height = 193
        TabOrder = 3
        object lblCustomMeal: TLabel
          Left = 128
          Top = 9
          Width = 161
          Height = 25
          Caption = 'Add a custom meal'
        end
        object cbxAddDB: TCheckBox
          Left = 40
          Top = 160
          Width = 169
          Height = 17
          Caption = 'Add to database'
          TabOrder = 0
        end
        object edtMealName: TEdit
          Left = 32
          Top = 48
          Width = 121
          Height = 33
          TabOrder = 1
          TextHint = 'Meal name'
        end
        object edtNumCalories: TEdit
          Left = 32
          Top = 87
          Width = 177
          Height = 33
          NumbersOnly = True
          TabOrder = 2
          TextHint = 'Number of calories'
        end
        object cbxNewFood: TCheckBox
          Left = 40
          Top = 126
          Width = 177
          Height = 17
          Caption = 'Add this food item'
          TabOrder = 3
        end
      end
    end
  end
  object pnlFoot: TPanel
    Left = 0
    Top = 425
    Width = 890
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnLogOut: TButton
      Left = 784
      Top = 16
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Log Out'
      TabOrder = 0
      OnClick = btnLogOutClick
    end
  end
end
