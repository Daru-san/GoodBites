unit frmDashboard_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ComCtrls,
  libUtils_U,libUser_u, libMeals_U,frmGreeter_U,conDB,frmAddFood_U,
  Vcl.WinXCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, Vcl.Mask,
  Vcl.WinXPanels, Vcl.Menus, Vcl.ToolWin,frmSettings_U,Math,libGoals_U,StrUtils,
  Vcl.DBCtrls;

type
  TfrmDashboard = class(TForm)
    lblEats: TLabel;
    pnlProgIndicator: TPanel;
    cbxFoods: TComboBox;
    edtPortion: TEdit;
    btnEaten: TButton;
    pnlCent: TPanel;
    cbxMealType: TComboBox;
    btnAddDB: TButton;
    pnlDate: TPanel;
    sbtnPrev: TSpeedButton;
    sbtnNext: TSpeedButton;
    edtCalories: TLabeledEdit;
    crplDashboard: TCardPanel;
    crdProgress: TCard;
    crdEating: TCard;
    tbDashboard: TToolBar;
    tbtSidebar: TToolButton;
    pnlGoal: TPanel;
    prgCalories: TProgressBar;
    pnlCal: TPanel;
    dpcDay: TDateTimePicker;
    crdGoals: TCard;
    redMeals: TRichEdit;
    pnlMeals: TPanel;
    pnlMealBottom: TPanel;
    btnShow: TButton;
    btnReset: TButton;
    btnEating: TButton;
    Panel1: TPanel;
    edtWater: TLabeledEdit;
    prgWater: TProgressBar;
    Panel3: TPanel;
    edtFat: TLabeledEdit;
    prgFat: TProgressBar;
    pnlCarb: TPanel;
    edtCarb: TLabeledEdit;
    prgCarb: TProgressBar;
    Panel5: TPanel;
    edtProtein: TLabeledEdit;
    prgProtein: TProgressBar;
    lblGoal: TLabel;
    pnlProgTop: TPanel;
    btnGoGoals: TButton;
    RichEdit1: TRichEdit;
    pnlFood: TPanel;
    pnlDisplay: TPanel;
    redFoodInfo: TRichEdit;
    svSidebar: TSplitView;
    edtSVCalorie: TLabeledEdit;
    edtSVWater: TLabeledEdit;
    btnReturn: TButton;
    lblHello: TLabel;
    btnSettings: TButton;
    btnLogOut: TButton;
    lblProg: TLabel;
    cbxMeals: TComboBox;

    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure btnEatenClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure tsEatingShow(Sender: TObject);
    procedure tsProgressShow(Sender: TObject);
    procedure tsWelcomeShow(Sender: TObject);
    procedure tsSearchShow(Sender: TObject);
    procedure tsSearchHide(Sender: TObject);
    procedure btnAddDBClick(Sender: TObject);
    procedure sbtnNextClick(Sender: TObject);
    procedure sbtnPrevClick(Sender: TObject);
    procedure dpcDayChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnEatingClick(Sender: TObject);
    procedure btnGoGoalsClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure svSidebarMouseEnter(Sender: TObject);
    procedure tbtSidebarClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure svSidebarResize(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure cbxFoodsChange(Sender: TObject);
  private
    { Private declarations }
    FCurrentUser : TUser;
    procedure PopulateFoods;
    procedure GetInfo;
    procedure PopulateMealType;
    procedure SetProgressBar(sItem : String; rValue, rTarget : Real);
    procedure ShowProgress(RecDate:TDate);
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;

  end;

var
  frmDashboard: TfrmDashboard;
  foodList : TStringList;
  FoodCount : integer;
  currentMeal : TMeal;

implementation

{$R *.dfm}

procedure TfrmDashboard.btnAddDBClick(Sender: TObject);
var
  frmFood : TfrmAddFood;
  isSuccess : boolean;
begin
  isSuccess := false;
  frmFood := TfrmAddFood.Create(nil);
  try
    frmFood.ShowModal;
  finally
    isSuccess := frmFood.ModalResult = mrYes;
    frmFood.Free;
  end;
  if isSuccess then
  PopulateFoods;
end;

procedure TfrmDashboard.btnGoGoalsClick(Sender: TObject);
begin
  crplDashboard.ActiveCard := crdGoals;
end;

procedure TfrmDashboard.btnEatenClick(Sender: TObject);
var
  iCheckInt : integer;
  sMealName,sMealType : string;
  rPortion : Real;
  Meal : TMeal;
  FoodItem : TFoodItem;
begin
  if cbxFoods.ItemIndex = -1 then
  begin
    cbxFoods.SetFocus;
    exit;
  end;
  if cbxMealType.ItemIndex = -1 then
  begin
    cbxMealType.SetFocus;
    exit;
  end;
  sMealName := cbxFoods.text;
  sMealType := cbxMealType.Text;

  Val(edtPortion.Text,rPortion,iCheckInt);

  if iCheckInt <> 0 then
  begin
    ShowMessage('Please enter the portion in grams');
  end;

  if MessageDlg('Are you sure you want to enter this food item',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    FoodItem := TFoodItem.Create(sMealName);

    if FoodItem.CheckExists then
    begin
      Meal := TMeal.Create(FoodItem,rPortion,sMealType);
      Meal.EatMeal(currentUser.UserID,currentUser.GetTotalMeals);
      GetInfo;
    end else
    ShowMessage('The item ' +  FoodItem.Foodname + ' does not exist in the database');

   Meal.Free;
   FoodItem.Free;
  end;

end;

procedure TfrmDashboard.btnEatingClick(Sender: TObject);
begin
  crplDashboard.ActiveCard := crdEating;
  btnReturn.Enabled := true;
end;

procedure TfrmDashboard.btnLoadDataClick(Sender: TObject);
var
  selectedDate,dEatenDate : TDate;
  iTotalCalories,iNumMeals : integer;
  i: Integer;
  sMealName,sMealString,sEatenDate : string;
begin
  GetInfo;
end;

procedure TfrmDashboard.GetInfo;
var
  dDate : TDate;
  iDayMeals,i : integer;
  sMealName,timeEaten : string;
  rTotalCalories, rTargetCalories : Real;
begin
  redMeals.Clear;

  dDate := dpcDay.Date;

  rTotalCalories := currentUser.GetDailyCalories(dDate);

  lblProg.Caption := 'Progress for ' + FormatDateTime('dd mmm',dDate);

  cbxMeals.Items.Clear;
  cbxMeals.Text := 'Choose a meal';

  iDayMeals := currentUser.GetMealCount(dDate);

  if iDayMeals = 0 then
  begin
    redMeals.Lines.Add('Nothing to see here! ' + #13 + 'Start eating!');
    cbxMeals.Enabled := false;
    btnShow.Enabled := false;
  end else
  begin
    cbxMeals.Enabled := true;
    btnShow.Enabled := true;
    with redMeals.Paragraph do
    begin
      TabCount := 1;
      Tab[0] := 50;
    end;
    redMeals.Lines.Add('Meal logs for ' + FormatDateTime('dd mmm',dDate));
    redMeals.Lines.Add('=============');
    redMeals.Lines.Add('');
    for i := 1 to iDayMeals do
    begin
      sMealName := currentUser.GetMealInfo(i,dDate,'name');
      timeEaten := currentUser.GetMealInfo(i,dDate,'time');
      redMeals.Lines.Add('Meal: #' + i.ToString + ' at ' + timeEaten);
      redMeals.Lines.Add('Name:' + #9 + sMealName);
      redMeals.Lines.Add('');
      cbxMeals.Items.Add('#'+i.ToString + ' ' + sMealName);
    end;
  end;
end;

procedure TfrmDashboard.ShowProgress;
const ITEMS : array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  Goal : TGoal;
  rTarget,rValue : Real;
  i: Integer;
begin
  for i := 1 to Length(ITEMS) do
  begin
    Goal := TGoal.Create(CurrentUser.UserID,ITEMS[i]);
    rTarget := Goal.Target;
    rValue := Goal.GetProgress(RecDate);

    SetProgressBar(Goal.Item,rValue,rTarget);
    Goal.free;
  end;

  Goal := TGoal.Create(CurrentUser.UserID,'Calorie');
  rValue := Goal.GetProgress(Date);
  rTarget := Goal.Target;
  edtSVCalorie.Text := FloatToStrF(rValue,ffFixed,8,2) +  '/'+ FloatToStrF(rTarget,ffFixed,8,2);

  Goal := TGoal.Create(CurrentUser.UserID,'Water');
  rValue := Goal.GetProgress(Date);
  rTarget := Goal.Target;
  edtSVWater.Text := FloatToStrF(rValue,ffFixed,8,2) +  '/'+ FloatToStrF(rTarget,ffFixed,8,2);
end;

procedure TfrmDashboard.svSidebarMouseEnter(Sender: TObject);
begin
  svSidebar.open;
end;

procedure TfrmDashboard.svSidebarResize(Sender: TObject);
begin
  with svSidebar do
  begin
    edtSVCalorie.Top := Ceil(Height - Height*5.5/6.5);
    edtSVWater.top := Ceil(Height - Height*4.5/6.5);

    btnSettings.Top := Ceil(Height - Height * 2.5/6.5);
    btnReturn.Top := Ceil(Height - Height * 1.5/6.5);
    btnLogout.Top := Ceil(Height - Height * 0.5/6.5);

    edtSVCalorie.Width := Ceil(Width*5/7);
    edtSVWater.Width := Ceil(Width*5/7);
    btnSettings.Width := Ceil(width*5/7);
    btnReturn.Width := Ceil(Width*5/7);
    btnLogout.Width := Ceil(Width*5/7);
  end;
end;

procedure TfrmDashboard.SetProgressBar(sItem : String;rValue, rTarget : Real);
begin
  rTarget := 300;
  rValue := RandomRange(10,300);
  case IndexStr(LowerCase(sItem),['calorie','water','carbohydrate','protein','fat']) of
  0: // Calorie
    begin
      edtCalories.Text := FloatToStrF(rValue,ffFixed,8,2) +'/'+ FloatToStrF(rTarget,ffFixed,8,2) + 'cal';
      prgCalories.Max := Ceil(rTarget);;
      prgCalories.Position := Ceil(rValue);
     end;
  1:  // Water
    begin
      edtWater.Text := FloatToStrF(rValue,ffFixed,8,2) +'/'+ FloatToStrF(rTarget,ffFixed,8,2)+' cups';
      prgWater.Max := Ceil(rTarget);
      prgWater.Position := Ceil(rValue);
    end;
  2: // Carbs
    begin
      edtCarb.Text := FloatToStrF(rValue,ffFixed,8,2) +'/'+ FloatToStrF(rTarget,ffFixed,8,2) + 'g';
      prgCarb.Max := Ceil(rTarget);
      prgCarb.Position := Ceil(rValue);
    end;
  3: // Protein
    begin
      edtProtein.Text := FloatToStrF(rValue,ffFixed,8,2) + '/'+FloatToStrF(rTarget,ffFixed,8,2) + 'g';
      prgProtein.Max := Ceil(rTarget);
      prgProtein.Position := Ceil(rValue);
    end;
  4: // Fat
    begin
     edtFat.Text := FloatToStrF(rValue,ffFixed,8,2) + '/'+FloatToStrF(rTarget,ffFixed,8,2) +'g';
     prgFat.Max := Ceil(rTarget);
     prgFat.Position := Ceil(rValue);
    end;
  end;
end;

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  self.ModalResult := mrClose;
end;

procedure TfrmDashboard.cbxFoodsChange(Sender: TObject);
var
  sFoodname: string;
  i: Integer;
  isFound : boolean;
  Protein,Carb,Fat,Calories,Sugar,Energy: real;
  FoodItem : TFoodItem;
begin

  if cbxFoods.ItemIndex <> -1 then
  begin
    cbxMealType.Enabled := true;
    if cbxMealType.ItemIndex <> -1 then
      btnEaten.Enabled := true;
  end
  else
  begin
    btnEaten.Enabled := false;
    cbxMealType.Enabled := false;
  end;
  sFoodname := cbxFoods.Text;
  isFound := false;

  { Loop through the food list until either i is at the food count or the food is found }
  i := 0;
  repeat
    if UpperCase(sFoodname) = UpperCase(foodList[i]) then
    begin
      isFound := true;
      FoodItem := TFoodItem.Create(foodList[i]);
      Protein := FoodItem.ProteinPer100G;
      Carb := FoodItem.CarbPer100G;
      Fat := FoodItem.FatPer100G;
      Calories := FoodItem.CaloriePer100G;
      Sugar := FoodItem.SugarPer100G;
      Energy := FoodItem.EnergyPer100G;
			FoodItem.Free;
    end else inc(i);
  until (i = FoodCount) or isFound;

  if isFound then
  with redFoodInfo do
  begin
    Clear;
    with Paragraph do
    begin
      TabCount := 1;
      Tab[0] := 150;
    end; // end with paragraph
    with Lines do
    begin
      Add('Information on ' + sFoodname);
      Add('----------------------------------------------------');
      Add('Calories per 100g:' + #9 + FloatToStrF(Calories,ffFixed,8,2)+'kcal');
      Add('Energy per 100g: ' + #9 + FloatToStrF(Energy,ffFixed,8,2)+'kJ');
      Add('Proteins per 100g:' + #9 + FloatToStrF(Protein,ffFixed,8,2)+'g');
      Add('Carbohydrates per 100g:' + #9 + FloatToStrF(Carb,ffFixed,8,2)+'g');
      Add('Fat per 100g:' + #9 + FloatToStrF(Fat,ffFixed,8,2)+'g');
      Add('Sugar per 100g:' + #9 + FloatToStrF(Sugar,ffFixed,8,2)+'g');
    end; // end lines
  end // end with redMealInfo
  else
  ShowMessage('Meal not found');

end;

procedure TfrmDashboard.cbxMealTypeChange(Sender: TObject);
begin
  if (cbxMealType.ItemIndex <> -1) and (cbxFoods.ItemIndex <> -1) then
    btnEaten.Enabled := true
  else
    btnEaten.Enabled := false;
end;
procedure TfrmDashboard.btnReturnClick(Sender: TObject);
begin
  crplDashboard.ActiveCard := crdProgress;
  btnReturn.Enabled := false;
end;

procedure TfrmDashboard.btnResetClick(Sender: TObject);
begin
  GetInfo;
end;

procedure TfrmDashboard.btnSettingsClick(Sender: TObject);
var
 Settings : TfrmSettings;
begin
  Settings := TfrmSettings.Create(nil);
  try
    Settings.currentUser := currentUser;
    Settings.ShowModal;
  finally
    Settings.free;
  end;
end;

procedure TfrmDashboard.btnShowClick(Sender: TObject);
var
  sFoodname,sMealType,sTime: string;
  iFoodIndex : Integer;
  dDate : TDate;
  isFound : Boolean;
  rPortion : Real;
  Meal : TMeal;
  FoodItem : TFoodItem;
begin
  if cbxMeals.ItemIndex = -1 then
  begin
    cbxMeals.SetFocus;
    exit;
  end;

  iFoodIndex := cbxMeals.ItemIndex+1;
  dDate := dpcDay.date;

  rPortion := StrToFloat(CurrentUser.GetMealInfo(iFoodIndex,dDate,'portion'));
  sMealType := CurrentUser.GetMealInfo(iFoodIndex,dDate,'type');
  sFoodname := CurrentUser.GetMealInfo(iFoodIndex,dDate,'name');
  sTime := CurrentUser.GetMealInfo(iFoodIndex,dDate,'time');

  FoodItem := TFoodItem.Create(sFoodname);
  Meal := TMeal.Create(FoodItem,rPortion,sMealType);

  redMeals.Clear;
  with redMeals.Paragraph do
  begin
    TabCount := 1;
    Tab[0] := 100;
  end;
  with redMeals.Lines do
  begin
    Add(sFoodname + ', eaten at ' + sTime);
    Add('=================================');
    Add('');
    Add('Eaten for '+ sMealType);
    Add('Portion size:' + #9 + FloatToStrF(rPortion,ffFixed,8,2)+'g');
    Add('Total calories:' + #9 + FloatToStrF(Meal.TotalCalories,ffFixed,8,2)+'kcal');
    Add('Total energy:' + #9 + FloatToStrF(Meal.TotalEnergy,ffFixed,8,2)+'kJ');

    Add('Total carb:' + #9 + FloatToStrF(
      FoodItem.CarbPer100G*(rPortion/100),
      ffFixed,
      8,2) + 'g'
    );

    Add('Total protein:' + #9 + FloatToStrF(
      FoodItem.ProteinPer100G*(rPortion/100),
      ffFixed,
      8,2) + 'g'
    );

    Add('Total Fat:' + #9 + FloatToStrF(
      FoodItem.FatPer100G*(rPortion/100),
      ffFixed,
      8,2) + 'g'
      );
  end;
end;
procedure TfrmDashboard.dpcDayChange(Sender: TObject);
begin
  if dpcDay.Date = Date then
    sbtnNext.Enabled := False
  else
    sbtnNext.Enabled := True;
  GetInfo;
end;

procedure TfrmDashboard.FormResize(Sender: TObject);
begin
  if svSidebar.Opened then
  begin
    svSidebar.OpenedWidth := Ceil(self.Width*7/48);
    crplDashboard.Width := Ceil(self.Width*41/48);
  end;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
var
  userGreeter : TfrmGreeter;
begin
  utilObj := TUtils.Create;
  loggerObj := TLOGS.Create;

  PopulateFoods;
  PopulateMealType;


  dpcDay.Date := Date;
  dpcDay.MaxDate := Date;

  GetInfo;

  crplDashboard.ActiveCard := crdProgress;

  lblHello.Caption := 'Hello, ' + CurrentUser.Username;

  if currentUser.GetFirstLogin then
  begin
   userGreeter := TfrmGreeter.Create(nil);
 //  userGreeter.currentUser := currentUser;
   with userGreeter do
   begin
    try
      ShowModal;
    finally
      Free;
    end;
   end;
  end;

  with redMeals.Paragraph do
  begin
    TabCount := 2;
    Tab[0] := 200;
    Tab[1] := 400;
  end;
end;

procedure TfrmDashboard.PopulateMealType;
begin
// Populating the combo box with meal types
  with cbxMealType.Items do
  begin
    Add('Breakfast');
    Add('Lunch');
    Add('Brunch');
    Add('Supper');
    Add('Snack');
    Add('Other');
  end;
end;

procedure TfrmDashboard.sbtnNextClick(Sender: TObject);
begin
  if dpcDay.Date < Date then
    dpcDay.Date := dpcDay.Date+1;
  dpcDayChange(self);
  GetInfo;
end;

procedure TfrmDashboard.sbtnPrevClick(Sender: TObject);
begin
  dpcDay.Date := dpcDay.Date-1;
  dpcDayChange(self);
  GetInfo;
end;

procedure TfrmDashboard.PopulateFoods;
var
 currentMeal : string;
 i : Integer;
begin
 i := 0;
 foodList := TStringList.Create;
 cbxFoods.Items.Clear;
 with dmData.tblFoods do
 begin
  Open;
  if FieldCount <> 0 then
  begin
    First;
    repeat
      currentMeal := FieldValues['Foodname'];
      if not ((currentMeal = '') or (currentMeal = 'Default')) then
      begin
        inc(i);
        foodList.Add(currentMeal);
        cbxFoods.Items.Add(currentMeal);
      end;
      Next;
    until Eof;
  end;
  Close;
  FoodCount := i;
 end;
end;

procedure TfrmDashboard.tbtSidebarClick(Sender: TObject);
begin
  if not svSidebar.Opened then
  begin
    svSidebar.Open;
    tbtSidebar.Caption := 'Close Sidebar';
  end
  else
  begin
    svSidebar.Close;
    tbtSidebar.Caption := 'Open sidebar';
  end;
end;

procedure TfrmDashboard.tsEatingShow(Sender: TObject);
begin
  //utilObj.SetLabel(lblHeading,'What are you eating?',15);
  GetInfo;
end;

procedure TfrmDashboard.tsProgressShow(Sender: TObject);
begin
 // utilObj.SetLabel(lblHeading,'Your current progress?',15);
end;

procedure TfrmDashboard.tsSearchHide(Sender: TObject);
begin
//  tsSearch.TabVisible := false;
end;

procedure TfrmDashboard.tsSearchShow(Sender: TObject);
begin
  //utilObj.SetLabel(lblHeading,'Search foods',15);
end;

procedure TfrmDashboard.tsWelcomeShow(Sender: TObject);
begin
  //utilObj.SetLabel(lblHeading,'Welcome to ' + Application.MainForm.Caption + '!',15);
end;

end.
