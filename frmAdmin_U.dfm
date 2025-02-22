object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Goodbites:  Administration'
  ClientHeight = 538
  ClientWidth = 908
  Color = clBtnFace
  Constraints.MinHeight = 465
  Constraints.MinWidth = 920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pageCtrl: TPageControl
    Left = 90
    Top = 0
    Width = 818
    Height = 538
    ActivePage = tsFoods
    Align = alClient
    TabOrder = 0
    object tsUsers: TTabSheet
      Caption = 'Manage Users'
      OnShow = tsUsersShow
      object pnlUserHead: TPanel
        Left = 0
        Top = 0
        Width = 810
        Height = 41
        Align = alTop
        Caption = 'Manage Users'
        TabOrder = 0
      end
      object pnlUsersBottom: TPanel
        Left = 0
        Top = 408
        Width = 810
        Height = 100
        Align = alBottom
        TabOrder = 1
        object pnlUserNav: TPanel
          Left = 377
          Top = 1
          Width = 432
          Height = 98
          Align = alClient
          TabOrder = 0
          object lblUserRecordNav: TLabel
            Left = 1
            Top = 1
            Width = 98
            Height = 15
            Align = alTop
            Alignment = taCenter
            Caption = 'Record Navigation'
            Layout = tlCenter
          end
          object btnUserLast: TButton
            Left = 126
            Top = 38
            Width = 75
            Height = 25
            Caption = 'Last'
            TabOrder = 0
            OnClick = btnUserLastClick
          end
          object btnUserPrevious: TButton
            Left = 229
            Top = 38
            Width = 75
            Height = 25
            Caption = '&Previous'
            TabOrder = 1
            OnClick = btnUserPreviousClick
          end
          object btnUserNext: TButton
            Left = 334
            Top = 38
            Width = 75
            Height = 25
            Caption = '&Next'
            TabOrder = 2
            OnClick = btnUserNextClick
          end
          object btnUserFirst: TButton
            Left = 21
            Top = 38
            Width = 75
            Height = 25
            Caption = 'First'
            TabOrder = 3
            OnClick = btnUserFirstClick
          end
        end
        object pnlMod: TPanel
          Left = 1
          Top = 1
          Width = 376
          Height = 98
          Align = alLeft
          TabOrder = 1
          object lblUserRecordMod: TLabel
            Left = 1
            Top = 1
            Width = 374
            Height = 15
            Align = alTop
            Alignment = taCenter
            Caption = 'Record Modification'
            ExplicitWidth = 108
          end
          object btnUserDelete: TButton
            Left = 232
            Top = 53
            Width = 115
            Height = 25
            Caption = 'Delete Selected User'
            TabOrder = 0
            OnClick = btnUserDeleteClick
          end
          object edtUserData: TEdit
            Left = 16
            Top = 51
            Width = 121
            Height = 23
            Hint = 'Name of Field'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TextHint = 'Field data'
          end
          object btnUserFieldEdit: TButton
            Left = 232
            Top = 22
            Width = 90
            Height = 25
            Caption = 'Edit Field Data'
            TabOrder = 2
            OnClick = btnUserFieldEditClick
          end
          object cbxUserField: TComboBox
            Left = 16
            Top = 22
            Width = 145
            Height = 23
            TabOrder = 3
            Text = 'Table field'
          end
        end
      end
      object pnlUsersCenter: TPanel
        Left = 0
        Top = 41
        Width = 810
        Height = 367
        Align = alClient
        TabOrder = 2
        object dbgUsersTable: TDBGrid
          Left = 1
          Top = 1
          Width = 808
          Height = 365
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
      end
    end
    object tsLogs: TTabSheet
      Caption = 'View Logs'
      ImageIndex = 1
      OnShow = tsLogsShow
      object pnlLogHeader: TPanel
        Left = 0
        Top = 0
        Width = 810
        Height = 41
        Align = alTop
        Caption = 'View Logs'
        TabOrder = 0
      end
      object pnlLogsCenter: TPanel
        Left = 0
        Top = 41
        Width = 810
        Height = 383
        Align = alClient
        TabOrder = 1
        object memLogs: TMemo
          Left = 1
          Top = 1
          Width = 808
          Height = 381
          Align = alClient
          Lines.Strings = (
            'memLogs')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object pnlLogsBottom: TPanel
        Left = 0
        Top = 424
        Width = 810
        Height = 84
        Align = alBottom
        TabOrder = 2
        object btnClear: TButton
          Left = 699
          Top = 25
          Width = 75
          Height = 24
          Caption = 'Clear Logs'
          TabOrder = 0
          OnClick = btnClearClick
        end
        object btnFilter: TButton
          Left = 167
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Filter Logs'
          TabOrder = 1
          OnClick = btnFilterClick
        end
        object edtFilter: TEdit
          Left = 32
          Top = 26
          Width = 121
          Height = 23
          TabOrder = 2
          TextHint = 'Filter'
        end
        object btnUnfilter: TButton
          Left = 272
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Reset Filter'
          TabOrder = 3
          OnClick = btnUnfilterClick
        end
      end
    end
    object tsFoods: TTabSheet
      Caption = 'Manage Foods'
      ImageIndex = 3
      OnShow = tsFoodsShow
      object pnlFoodTop: TPanel
        Left = 0
        Top = 0
        Width = 810
        Height = 41
        Align = alTop
        Caption = 'Food Management'
        TabOrder = 0
      end
      object pnlFoodCenter: TPanel
        Left = 0
        Top = 41
        Width = 810
        Height = 375
        Align = alClient
        TabOrder = 1
        object dbgFoodsTable: TDBGrid
          Left = 1
          Top = 1
          Width = 808
          Height = 373
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnDrawColumnCell = dbgFoodsTableDrawColumnCell
        end
      end
      object pnlFoodBottom: TPanel
        Left = 0
        Top = 416
        Width = 810
        Height = 92
        Align = alBottom
        TabOrder = 2
        object pnlFoodRecordMod: TPanel
          Left = 1
          Top = 1
          Width = 376
          Height = 90
          Align = alLeft
          TabOrder = 0
          object lblFoodRecordMod: TLabel
            Left = 1
            Top = 1
            Width = 374
            Height = 15
            Align = alTop
            Alignment = taCenter
            Caption = 'Record Modification'
            ExplicitWidth = 108
          end
          object edtFoodData: TEdit
            Left = 16
            Top = 54
            Width = 121
            Height = 23
            Hint = 'Name of Field'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TextHint = 'Field data'
          end
          object btnFoodEdit: TButton
            Left = 248
            Top = 22
            Width = 83
            Height = 25
            Caption = 'Edit Food Data'
            TabOrder = 1
            OnClick = btnFoodEditClick
          end
          object cbxFoodField: TComboBox
            Left = 16
            Top = 25
            Width = 145
            Height = 23
            TabOrder = 2
            Text = 'Food Field'
            OnChange = cbxFoodFieldChange
          end
          object btnFoodDelete: TButton
            Left = 232
            Top = 53
            Width = 99
            Height = 25
            Caption = 'Delete Food Item'
            TabOrder = 3
            OnClick = btnFoodDeleteClick
          end
        end
        object pnlFoodRecordNav: TPanel
          Left = 377
          Top = 1
          Width = 432
          Height = 90
          Align = alClient
          TabOrder = 1
          object lblFoodRecordNav: TLabel
            Left = 1
            Top = 1
            Width = 98
            Height = 15
            Align = alTop
            Alignment = taCenter
            Caption = 'Record Navigation'
            Layout = tlCenter
          end
          object btnFoodFirst: TButton
            Left = 32
            Top = 40
            Width = 75
            Height = 25
            Caption = '&First'
            TabOrder = 0
            OnClick = btnFoodFirstClick
          end
          object btnFoodLast: TButton
            Left = 113
            Top = 40
            Width = 75
            Height = 25
            Caption = '&Last'
            TabOrder = 1
            OnClick = btnFoodLastClick
          end
          object btnFoodPrev: TButton
            Left = 216
            Top = 40
            Width = 75
            Height = 25
            Caption = '&Previous'
            TabOrder = 2
            OnClick = btnFoodPrevClick
          end
          object btnFoodNext: TButton
            Left = 304
            Top = 40
            Width = 75
            Height = 25
            Caption = '&Next'
            TabOrder = 3
            OnClick = btnFoodNextClick
          end
        end
      end
    end
  end
  object svSidebar: TSplitView
    Left = 0
    Top = 0
    Width = 90
    Height = 538
    OpenedWidth = 90
    Placement = svpLeft
    TabOrder = 1
    DesignSize = (
      90
      538)
    object lblUser: TLabel
      Left = 0
      Top = 0
      Width = 90
      Height = 20
      Align = alTop
      Caption = 'Hello'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 36
    end
    object btnLogout: TButton
      Left = 9
      Top = 493
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Log Out'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnLogoutClick
    end
    object btnBackupDB: TButton
      Left = 7
      Top = 462
      Width = 81
      Height = 25
      Caption = 'Backup DB'
      TabOrder = 1
      OnClick = btnBackupDBClick
    end
    object edtTotalUsers: TLabeledEdit
      Left = -2
      Top = 104
      Width = 86
      Height = 23
      EditLabel.Width = 55
      EditLabel.Height = 15
      EditLabel.Caption = 'Total users'
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object edtTotalFoods: TLabeledEdit
      Left = -2
      Top = 168
      Width = 86
      Height = 23
      EditLabel.Width = 58
      EditLabel.Height = 15
      EditLabel.Caption = 'Total foods'
      ReadOnly = True
      TabOrder = 3
      Text = ''
    end
  end
end
