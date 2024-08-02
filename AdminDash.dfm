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
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 907
    Height = 515
    Align = alClient
    Style = tsButtons
    TabOrder = 0
    Tabs.Strings = (
      'Tab 1'
      'Tab 2')
    TabIndex = 1
    ExplicitWidth = 903
    ExplicitHeight = 514
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 515
    Width = 907
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 514
    ExplicitWidth = 903
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
      ExplicitLeft = 816
    end
  end
end
