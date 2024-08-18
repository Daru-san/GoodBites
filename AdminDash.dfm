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
    Top = 0
    Width = 907
    Height = 515
    ActivePage = tsUsers
    Align = alClient
    TabOrder = 1
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
        DataSource = dmData.dscUsers
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
      object btnPrev: TButton
        Left = 758
        Top = 424
        Width = 75
        Height = 25
        Caption = '&Previous'
        TabOrder = 2
        OnClick = btnPrevClick
      end
      object btnNext: TButton
        Left = 664
        Top = 424
        Width = 75
        Height = 25
        Caption = '&Next'
        TabOrder = 3
        OnClick = btnNextClick
      end
      object btnUserDel: TButton
        Left = 48
        Top = 424
        Width = 115
        Height = 25
        Caption = 'Delete Selected User'
        TabOrder = 4
        OnClick = btnUserDelClick
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
        Height = 337
        DataSource = dmData.dscNutrients
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
    end
  end
end
