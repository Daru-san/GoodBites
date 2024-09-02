object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Goodbites:  Adminastration'
  ClientHeight = 552
  ClientWidth = 907
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlFooter: TPanel
    Left = 0
    Top = 515
    Width = 907
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      907
      37)
    object btnLogout: TButton
      Left = 820
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Log Out'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnLogoutClick
    end
  end
  object pageCtrl: TPageControl
    Left = 0
    Top = 25
    Width = 907
    Height = 490
    ActivePage = tsLogs
    Align = alClient
    TabOrder = 1
    ExplicitTop = 0
    ExplicitHeight = 515
    object tsHome: TTabSheet
      Caption = 'Home'
      ImageIndex = 3
    end
    object tsUsers: TTabSheet
      Caption = 'Manage Users'
      OnShow = tsUsersShow
      object pnl: TPanel
        Left = 0
        Top = 0
        Width = 899
        Height = 41
        Align = alTop
        TabOrder = 0
        object lblUsers: TLabel
          Left = 1
          Top = 1
          Width = 897
          Height = 39
          Align = alClient
          Caption = 'User Management'
          ExplicitWidth = 97
          ExplicitHeight = 15
        end
      end
      object dbgUsers: TDBGrid
        Left = 40
        Top = 72
        Width = 809
        Height = 329
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDrawColumnCell = dbgUsersDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'userID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Username'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RegisterDate'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LastLogin'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'isAdmin'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Age'
            Visible = True
          end>
      end
      object pnlUserNav: TPanel
        Left = 416
        Top = 407
        Width = 433
        Height = 75
        TabOrder = 2
        object lblNav: TLabel
          Left = 1
          Top = 1
          Width = 431
          Height = 15
          Align = alTop
          Alignment = taCenter
          Caption = 'Record Navigation'
          Layout = tlCenter
          ExplicitWidth = 98
        end
        object btnLast: TButton
          Left = 126
          Top = 38
          Width = 75
          Height = 25
          Caption = 'Last'
          TabOrder = 0
          OnClick = btnLastClick
        end
        object btnPrev: TButton
          Left = 229
          Top = 38
          Width = 75
          Height = 25
          Caption = '&Previous'
          TabOrder = 1
          OnClick = btnPrevClick
        end
        object btnNext: TButton
          Left = 334
          Top = 38
          Width = 75
          Height = 25
          Caption = '&Next'
          TabOrder = 2
          OnClick = btnNextClick
        end
        object btnFirst: TButton
          Left = 21
          Top = 38
          Width = 75
          Height = 25
          Caption = 'First'
          TabOrder = 3
          OnClick = btnFirstClick
        end
      end
      object pnlMod: TPanel
        Left = 40
        Top = 407
        Width = 361
        Height = 75
        TabOrder = 3
        object lblRecMod: TLabel
          Left = 1
          Top = 1
          Width = 359
          Height = 15
          Align = alTop
          Alignment = taCenter
          Caption = 'Record Modification'
          ExplicitWidth = 108
        end
        object btnUserDel: TButton
          Left = 240
          Top = 51
          Width = 115
          Height = 25
          Caption = 'Delete Selected User'
          TabOrder = 0
          OnClick = btnUserDelClick
        end
        object edtField: TEdit
          Left = 16
          Top = 22
          Width = 121
          Height = 23
          Hint = 'Name of Field'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TextHint = 'Field'
        end
        object edtData: TEdit
          Left = 16
          Top = 51
          Width = 121
          Height = 23
          TabOrder = 2
          TextHint = 'Field Data'
        end
        object btnFieldEdit: TButton
          Left = 159
          Top = 22
          Width = 90
          Height = 25
          Caption = 'Edit Field Data'
          TabOrder = 3
          OnClick = btnFieldEditClick
        end
      end
    end
    object tsLogs: TTabSheet
      Caption = 'View Logs'
      ImageIndex = 1
      OnShow = tsLogsShow
      object memLogs: TMemo
        Left = 32
        Top = 88
        Width = 849
        Height = 305
        Lines.Strings = (
          'memLogs')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object pnlLogHeader: TPanel
        Left = 0
        Top = 0
        Width = 899
        Height = 41
        Align = alTop
        TabOrder = 1
        object lblLogs: TLabel
          Left = 1
          Top = 1
          Width = 897
          Height = 39
          Align = alClient
          Alignment = taCenter
          Caption = 'Logs'
          Layout = tlBottom
          ExplicitWidth = 25
          ExplicitHeight = 15
        end
      end
      object btnClear: TButton
        Left = 806
        Top = 441
        Width = 75
        Height = 24
        Caption = 'Clear Logs'
        TabOrder = 2
        OnClick = btnClearClick
      end
      object edtFilter: TEdit
        Left = 40
        Top = 441
        Width = 121
        Height = 23
        TabOrder = 3
        TextHint = 'Filter'
      end
      object btnFilter: TButton
        Left = 167
        Top = 440
        Width = 75
        Height = 25
        Caption = 'Filter Logs'
        TabOrder = 4
        OnClick = btnFilterClick
      end
    end
    object tsNutrients: TTabSheet
      Caption = 'Modify Nutrients'
      ImageIndex = 2
      OnShow = tsNutrientsShow
      object dbgNutrients: TDBGrid
        Left = 32
        Top = 80
        Width = 809
        Height = 281
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDrawColumnCell = dbgNutrientsDrawColumnCell
      end
      object pnlNutrientHeader: TPanel
        Left = 0
        Top = 0
        Width = 899
        Height = 41
        Align = alTop
        TabOrder = 1
        object lblNutrient: TLabel
          Left = 1
          Top = 1
          Width = 897
          Height = 39
          Align = alClient
          Alignment = taCenter
          Caption = 'Nutrients Management'
          ExplicitWidth = 123
          ExplicitHeight = 15
        end
      end
      object pnlAddition: TPanel
        Left = 32
        Top = 360
        Width = 441
        Height = 123
        TabOrder = 2
        object lblNumCalories: TLabel
          Left = 6
          Top = 88
          Width = 66
          Height = 15
          Caption = 'Min Calories'
        end
        object lblRecQty: TLabel
          Left = 168
          Top = 88
          Width = 130
          Height = 15
          Caption = 'Recommended Quantity'
        end
        object pnlNutHead: TPanel
          Left = 1
          Top = 1
          Width = 439
          Height = 41
          Align = alTop
          TabOrder = 0
          object lblNutHead: TLabel
            Left = 200
            Top = 16
            Width = 3
            Height = 15
          end
        end
        object btnNutrient: TButton
          Left = 328
          Top = 40
          Width = 75
          Height = 25
          Caption = 'Add nutrient'
          TabOrder = 1
          OnClick = btnNutrientClick
        end
        object edtNutrient: TEdit
          Left = 19
          Top = 48
          Width = 121
          Height = 23
          TabOrder = 2
          TextHint = 'Nutrient name'
        end
        object spnCalories: TSpinEdit
          Left = 78
          Top = 85
          Width = 62
          Height = 24
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object cbxDaily: TCheckBox
          Left = 184
          Top = 48
          Width = 97
          Height = 17
          Caption = 'Needed Daily'
          TabOrder = 4
        end
        object spnRecQty: TSpinEdit
          Left = 320
          Top = 84
          Width = 57
          Height = 24
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
      end
    end
  end
  object pnlHead: TPanel
    Left = 0
    Top = 0
    Width = 907
    Height = 25
    Align = alTop
    TabOrder = 2
    object pnlUser: TPanel
      Left = 721
      Top = 1
      Width = 185
      Height = 23
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 360
      ExplicitTop = -8
      ExplicitHeight = 41
      object lblUser: TLabel
        Left = 72
        Top = 8
        Width = 34
        Height = 15
        Caption = 'Label1'
      end
    end
  end
end
