object frmAdmin: TfrmAdmin
  Left = 0
  Top = 0
  Caption = 'Goodbites:  Adminastration'
  ClientHeight = 552
  ClientWidth = 907
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
    Width = 907
    Height = 552
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 224
    ExplicitTop = 184
    ExplicitWidth = 185
    ExplicitHeight = 41
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 905
      Height = 41
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 264
      ExplicitTop = 208
      ExplicitWidth = 185
      object lblHeader: TLabel
        Left = 1
        Top = 1
        Width = 903
        Height = 39
        Align = alClient
        Alignment = taCenter
        Caption = 'Admin Panel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 125
        ExplicitHeight = 30
      end
    end
    object pnlBody: TPanel
      Left = 1
      Top = 42
      Width = 905
      Height = 468
      Align = alClient
      TabOrder = 1
      ExplicitTop = 47
      object lblUsers: TLabel
        Left = 9
        Top = 9
        Width = 155
        Height = 25
        Caption = 'User Management'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object dbgUsers: TDBGrid
        Left = 9
        Top = 40
        Width = 880
        Height = 217
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object pnlFooter: TPanel
      Left = 1
      Top = 510
      Width = 905
      Height = 41
      Align = alBottom
      TabOrder = 2
      ExplicitLeft = 360
      ExplicitTop = 256
      ExplicitWidth = 185
    end
  end
end
