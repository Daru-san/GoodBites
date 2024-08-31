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
        Width = 886
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
      ExplicitLeft = 454
      ExplicitTop = 47
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 439
        Height = 23
        Align = alTop
        Alignment = taCenter
        Caption = 'Information'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 96
      end
      object pnlInfo: TPanel
        Left = 120
        Top = 304
        Width = 185
        Height = 41
        Caption = 'Information'
        TabOrder = 0
        OnClick = pnlInfoClick
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
