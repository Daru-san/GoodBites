object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Goodbites:  Adminastration'
  ClientHeight = 581
  ClientWidth = 907
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pnlFooter: TPanel
    Left = 0
    Top = 544
    Width = 907
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      907
      37)
    object btnLogout: TButton
      Left = 828
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
    Top = 29
    Width = 907
    Height = 515
    ActivePage = tsUsers
    Align = alClient
    TabOrder = 1
    ExplicitTop = 25
    ExplicitHeight = 519
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
        Top = 433
        Width = 75
        Height = 24
        Caption = 'Clear Logs'
        TabOrder = 2
        OnClick = btnClearClick
      end
      object edtFilter: TEdit
        Left = 32
        Top = 434
        Width = 121
        Height = 23
        TabOrder = 3
        TextHint = 'Filter'
      end
      object btnFilter: TButton
        Left = 167
        Top = 432
        Width = 75
        Height = 25
        Caption = 'Filter Logs'
        TabOrder = 4
        OnClick = btnFilterClick
      end
    end
    object tsFoods: TTabSheet
      Caption = 'Manage Foods'
      ImageIndex = 3
      OnShow = tsFoodsShow
      object dbgFoods: TDBGrid
        Left = 48
        Top = 40
        Width = 785
        Height = 361
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDrawColumnCell = dbgFoodsDrawColumnCell
      end
    end
  end
  object tbTop: TToolBar
    Left = 0
    Top = 0
    Width = 907
    Height = 29
    ButtonHeight = 23
    ButtonWidth = 30
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 2
    object tbtUser: TToolButton
      Left = 0
      Top = 0
      Caption = 'User'
      ImageIndex = 0
      OnClick = tbtUserClick
    end
  end
end
