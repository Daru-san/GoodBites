object frmCustomFood: TfrmCustomFood
  Left = 0
  Top = 0
  Caption = 'Add Custom Food'
  ClientHeight = 396
  ClientWidth = 699
  Color = clBtnFace
  Constraints.MinHeight = 435
  Constraints.MinWidth = 715
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object tbTop: TToolBar
    Left = 0
    Top = 0
    Width = 699
    Height = 29
    TabOrder = 0
    ExplicitWidth = 702
  end
  object crplMain: TCardPanel
    Left = 0
    Top = 29
    Width = 699
    Height = 367
    Align = alClient
    ActiveCard = crdDetails
    Caption = 'Custom Food'
    TabOrder = 1
    ExplicitWidth = 702
    ExplicitHeight = 368
    object crdDetails: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 365
      Caption = '1. Food Details'
      CardIndex = 0
      TabOrder = 0
      ExplicitWidth = 700
      ExplicitHeight = 366
      object pnlDetailsCenter: TPanel
        Left = 0
        Top = 41
        Width = 697
        Height = 324
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 700
        ExplicitHeight = 325
        object lblCalories: TLabel
          Left = 288
          Top = 59
          Width = 42
          Height = 15
          Caption = 'Calories'
        end
        object lblFats: TLabel
          Left = 96
          Top = 195
          Width = 21
          Height = 15
          Caption = 'Fats'
        end
        object lblProteins: TLabel
          Left = 288
          Top = 126
          Width = 43
          Height = 15
          Caption = 'Proteins'
        end
        object lblCarb: TLabel
          Left = 288
          Top = 195
          Width = 72
          Height = 15
          Caption = 'Carbohydrate'
        end
        object lblSugars: TLabel
          Left = 96
          Top = 126
          Width = 84
          Height = 15
          Caption = 'Sugars(Sucrose)'
        end
        object lblDetailsDesc: TLabel
          Left = 472
          Top = 59
          Width = 114
          Height = 15
          Caption = 'Description(Optional)'
        end
        object lblDetailsDescMax: TLabel
          Left = 600
          Top = 231
          Width = 73
          Height = 15
          Caption = '50 words max'
        end
        object edtFoodName: TLabeledEdit
          Left = 96
          Top = 80
          Width = 121
          Height = 23
          EditLabel.Width = 60
          EditLabel.Height = 15
          EditLabel.Caption = 'Food name'
          TabOrder = 0
          Text = ''
          OnChange = edtFoodNameChange
        end
        object nbxCalories: TNumberBox
          Left = 288
          Top = 80
          Width = 121
          Height = 23
          Mode = nbmFloat
          MinValue = 1.000000000000000000
          MaxValue = 10000.000000000000000000
          TabOrder = 1
          Value = 1.000000000000000000
          UseMouseWheel = True
        end
        object nbxProtein: TNumberBox
          Left = 288
          Top = 147
          Width = 121
          Height = 23
          TabOrder = 2
        end
        object nbxCarbs: TNumberBox
          Left = 288
          Top = 216
          Width = 121
          Height = 23
          TabOrder = 3
        end
        object nbxFats: TNumberBox
          Left = 96
          Top = 216
          Width = 121
          Height = 23
          Mode = nbmFloat
          MaxValue = 1.000000000000000000
          TabOrder = 4
        end
        object btnNext: TButton
          Left = 96
          Top = 272
          Width = 75
          Height = 25
          Caption = 'Next'
          TabOrder = 5
          OnClick = btnNextClick
        end
        object redDesc: TRichEdit
          Left = 472
          Top = 80
          Width = 201
          Height = 145
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            'Description')
          MaxLength = 100
          ParentFont = False
          PlainText = True
          TabOrder = 6
        end
        object nbxSugars: TNumberBox
          Left = 96
          Top = 147
          Width = 121
          Height = 23
          Hint = 'Enter sugar per 100g'
          Mode = nbmFloat
          MinValue = 1.000000000000000000
          MaxValue = 1000.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          TextHint = 'Sugars per 100g'
          Value = 1.000000000000000000
          UseMouseWheel = True
        end
      end
      object pnlDetailsTop: TPanel
        Left = 0
        Top = 0
        Width = 697
        Height = 41
        Align = alTop
        Caption = 'Enter food information'
        TabOrder = 1
        ExplicitWidth = 700
      end
    end
    object crdConfirm: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 365
      Caption = '2. Confirmation'
      CardIndex = 1
      TabOrder = 1
      object pnlConfirmTop: TPanel
        Left = 0
        Top = 0
        Width = 697
        Height = 41
        Align = alTop
        Caption = 'Confirmation'
        TabOrder = 0
      end
      object pnlConfirmationCenter: TPanel
        Left = 0
        Top = 41
        Width = 697
        Height = 324
        Align = alClient
        TabOrder = 1
        object redConfirmation: TRichEdit
          Left = 72
          Top = 24
          Width = 409
          Height = 217
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            'redConfirmation')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object btnConfirmationBack: TButton
          Left = 72
          Top = 272
          Width = 75
          Height = 25
          Caption = 'Back'
          TabOrder = 1
          OnClick = btnConfirmationBackClick
        end
        object btnConfirmationConfirm: TButton
          Left = 168
          Top = 272
          Width = 75
          Height = 25
          Caption = 'Confirm'
          TabOrder = 2
          OnClick = btnConfirmationConfirmClick
        end
      end
    end
  end
end
