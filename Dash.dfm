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
    Height = 466
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 886
    ExplicitHeight = 465
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 888
      Height = 41
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 884
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
        ExplicitLeft = 2
        ExplicitTop = -3
      end
    end
    object pnlProgress: TPanel
      Left = 1
      Top = 42
      Width = 448
      Height = 423
      Align = alLeft
      TabOrder = 1
      ExplicitLeft = -5
      ExplicitTop = 47
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
      Height = 423
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
      object Panel1: TPanel
        Left = 48
        Top = 56
        Width = 329
        Height = 41
        Caption = 'Carbohydrates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 48
        Top = 188
        Width = 329
        Height = 41
        Caption = 'Fats and oils'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Panel3: TPanel
        Left = 48
        Top = 120
        Width = 329
        Height = 41
        Caption = 'Proteins'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object Panel4: TPanel
        Left = 48
        Top = 256
        Width = 329
        Height = 41
        Caption = 'Milk products'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
    end
  end
end
