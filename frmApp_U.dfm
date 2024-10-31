object frmApp: TfrmApp
  Left = 0
  Top = 0
  Caption = 'Goodbites'
  ClientHeight = 381
  ClientWidth = 642
  Color = clBtnFace
  Constraints.MinHeight = 420
  Constraints.MinWidth = 656
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object pnlCenter: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 636
    Height = 375
    Align = alClient
    AutoSize = True
    TabOrder = 0
    object imgCenter: TImage
      Left = 1
      Top = 1
      Width = 634
      Height = 373
      Align = alClient
      AutoSize = True
      Center = True
      IncrementalDisplay = True
      Stretch = True
      Transparent = True
      ExplicitWidth = 1600
      ExplicitHeight = 1131
    end
    object pnlEnter: TPanel
      AlignWithMargins = True
      Left = 48
      Top = 256
      Width = 129
      Height = 33
      Hint = 'Begin your eating journey'
      BevelKind = bkSoft
      Caption = 'Start Eating'
      Color = clLime
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Bahnschrift SemiBold'
      Font.Style = []
      Locked = True
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = pnlEnterClick
    end
    object pnlExit: TPanel
      Left = 48
      Top = 295
      Width = 129
      Height = 26
      Caption = 'Leave'
      Color = clGrayText
      ParentBackground = False
      TabOrder = 1
      OnClick = pnlExitClick
    end
  end
end
