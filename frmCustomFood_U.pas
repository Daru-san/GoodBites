unit frmCustomFood_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.WinXPanels, Vcl.NumberBox, libMeals_U, libUtils_U;

type
  TfrmCustomFood = class(TForm)
    pnlDetailsCenter: TPanel;
    tbTop: TToolBar;
    edtFoodName: TLabeledEdit;
    nbxCalories: TNumberBox;
    nbxProtein: TNumberBox;
    nbxCarbs: TNumberBox;
    nbxFats: TNumberBox;
    btnNext: TButton;
    redDesc: TRichEdit;
    lblCalories: TLabel;
    lblFats: TLabel;
    lblProteins: TLabel;
    lblCarb: TLabel;
    crplMain: TCardPanel;
    crdDetails: TCard;
    crdConfirm: TCard;
    pnlDetailsTop: TPanel;
    pnlConfirmTop: TPanel;
    pnlConfirmationCenter: TPanel;
    redConfirmation: TRichEdit;
    btnConfirmationBack: TButton;
    btnConfirmationConfirm: TButton;
    nbxSugars: TNumberBox;
    lblSugars: TLabel;
    lblDetailsDesc: TLabel;
    lblDetailsDescMax: TLabel;
    procedure btnConfirmationConfirmClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnConfirmationBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtFoodNameChange(Sender: TObject);
  private
    { Private declarations }
    procedure ShowConfirmationCard;
    procedure CheckItemPresence;
  public
    { Public declarations }
  end;

var
  frmCustomFood: TfrmCustomFood;
  Foodname : String;
  FoodDesc : TStringList;
  Calories, Protein, Carbs, Energy, Fat, Sugar : real;
  LogService : TLogService;
  StringUtils : TStringUtils;
  ControlUtils : TControlUtils;


implementation

{$R *.dfm}

procedure TfrmCustomFood.btnNextClick(Sender: TObject);
var
  i: Integer;
  isNameValid : Boolean;
begin
  Foodname := edtFoodName.Text;
  isNameValid := StringUtils.ValidateString(Foodname,'foodname',3,20,'letters');

  if not isNameValid then
  exit;

  FoodDesc := TStringList.Create;
  for i := 1 to redDesc.Lines.count do
  begin
    FoodDesc.Add(redDesc.Lines[i]);
  end;

  Calories := nbxCalories.Value;
  Protein := nbxProtein.Value;
  Carbs := nbxCarbs.Value;
  Sugar := nbxSugars.Value;
  Fat := nbxFats.Value;
  Energy := Calories * 4.18;

  ShowConfirmationCard;
end;

procedure TfrmCustomFood.FormShow(Sender: TObject);
begin
  crplMain.ActiveCard := crdDetails;
  StringUtils := TStringUtils.Create;
  LogService := TLogService.Create;
  ControlUtils := TControlUtils.Create;

  ControlUtils.SetNumberBox(nbxCalories,0,10000);
  ControlUtils.SetNumberBox(nbxProtein,0.01,1000);
  ControlUtils.SetNumberBox(nbxFats,0.01,1000);
  ControlUtils.SetNumberBox(nbxCarbs,0.01,1000);
  ControlUtils.SetNumberBox(nbxSugars,0.01,1000);
  btnNext.Enabled := false;
end;


procedure TfrmCustomFood.CheckItemPresence;
var
  isNamePresent : Boolean;
begin
  isNamePresent := edtFoodName.Text <> '';

  if isNamePresent then
  begin
    nbxCalories.Enabled := true;
    nbxProtein.Enabled := true;
    nbxFats.Enabled := true;
    nbxCarbs.Enabled := true;
    nbxSugars.Enabled := true;
    btnNext.Enabled := true;
  end
  else
  begin
    btnNext.Enabled := false;
  end;
end;

procedure TfrmCustomFood.edtFoodNameChange(Sender: TObject);
begin
  CheckItemPresence;
end;

procedure TfrmCustomFood.ShowConfirmationCard;
begin
  crplMain.ActiveCard := crdConfirm;

  with redConfirmation do
  begin
    Clear;
    with Paragraph do
    begin
      TabCount := 1;
      Tab[0] := 100;
    end;
    with Lines do
    begin
      Add('Food item ' + Foodname);
      Add('============================================');
      Add('');
      Add('Calories per 100g' + #9 + FloatToStrF(Calories,ffFixed,8,2)+'cal');
      Add('Energy per 100g' + #9 + FloatToStrF(Energy,ffFixed,8,2)+'kJ');
      Add('Protien per 100g' + #9 + FloatToStrF(Protein,ffFixed,8,2)+'g');
      Add('Carbohydrate per 100g' + #9 + FloatToStrF(Carbs,ffFixed,8,2)+'g');
      Add('Fats per 100g' + #9 + FloatToStrF(Fat,ffFixed,8,2)+'g');
      Add('Sugar per 100g' + #9 + FloatToStrF(Sugar,ffFixed,8,2)+'g');
    end;
  end;
end;

procedure TfrmCustomFood.btnConfirmationBackClick(Sender: TObject);
begin
  crplMain.ActiveCard := crdDetails;
end;

procedure TfrmCustomFood.btnConfirmationConfirmClick(Sender: TObject);
var
  FoodItem : TFoodItem;
begin
  FoodItem := TFoodItem.Create(Foodname);
  FoodItem.AddNutrients(Calories,Protein,Carbs,Fat,Energy,Sugar);
  FoodItem.AddFoodToDB(FoodDesc.Text);
  FoodItem.Free;
  ShowMessage('Item added to database successfully!');
  LogService.WriteSysLog('Food item ' + Foodname + ' was added to the database!');
  Self.ModalResult := mrClose;
end;

end.
