unit frmDashboard_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ComCtrls,
  libUtils_U,libUser_u, libMeals_U,frmGreeter_U,conDB,frmAddFood_U,
  Vcl.WinXCtrls;

type
  TfrmDashboard = class(TForm)
    pnlCenter: TPanel;
    lblEats: TLabel;
    btnLogOut: TButton;
    dpcDay: TDateTimePicker;
    btnLoadData: TButton;
    pnlProgIndicator: TPanel;
    memMealLog: TMemo;
    lblDayCalorie: TLabel;
    edtCaloires: TEdit;
    cmbMeals: TComboBox;
    edtPortion: TEdit;
    btnEaten: TButton;
    pctDashboard: TPageControl;
    tsProgress: TTabSheet;
    tsEating: TTabSheet;
    pnlCent: TPanel;
    memMeal: TMemo;
    lblMeal: TLabel;
    memGoals: TMemo;
    pnlGoal: TPanel;
    btnSearch: TButton;
    tsSearch: TTabSheet;
    edtSearchMeal: TEdit;
    btnMealSearch: TButton;
    redMealInfo: TRichEdit;
    cmbMealType: TComboBox;
    btnAddDB: TButton;
    lblFoodname: TLabel;
    SplitView1: TSplitView;
    pnlUser: TPanel;
    lblUser: TLabel;
    btnSplit: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure btnEatenClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure tsEatingShow(Sender: TObject);
    procedure tsProgressShow(Sender: TObject);
    procedure tsWelcomeShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure tsSearchShow(Sender: TObject);
    procedure tsSearchHide(Sender: TObject);
    procedure btnMealSearchClick(Sender: TObject);
    procedure btnAddDBClick(Sender: TObject);
    procedure SplitView1Closing(Sender: TObject);
    procedure SplitView1Opened(Sender: TObject);
    procedure btnSplitClick(Sender: TObject);
  private
    { Private declarations }
    procedure PopulateFoods;
    procedure GetInfo;
    procedure PopulateMealType;
    FCurrentUser : TUser;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

var
  frmDashboard: TfrmDashboard;
  username : string;
  foodList : TStringList;
  FoodCount : integer;

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

procedure TfrmDashboard.btnEatenClick(Sender: TObject);
var
  iCheckInt,iPortion : integer;
  sMealName,sMealType : string;
  Meal : TMeal;
  FoodItem : TFoodItem;
begin
  if cmbMeals.ItemIndex = -1 then
  exit;
  if cmbMealType.ItemIndex = -1 then
  exit;
  sMealName := cmbMeals.text;
  sMealType := cmbMealType.Text;

  Val(edtPortion.Text,iPortion,iCheckInt);

  if iCheckInt <> 0 then
  begin
    ShowMessage('Please enter the portion in grams');
  end;

  if MessageDlg('Are you sure you want to enter this food item',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    FoodItem := TFoodItem.Create(sMealName);

    if FoodItem.CheckExists then
    begin
    Meal := TMeal.Create(FoodItem,iPortion,sMealType);
    Meal.EatMeal(currentUser.UserID,currentUser.GetTotalMeals);
    end else
    ShowMessage('The item ' +  FoodItem.Foodname + ' does not exist in the database');

   Meal.Free;
   FoodItem.Free;
  end;

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
  selectedDate : TDate;
  iTotalCalories,iNumMeals : integer;
  i: Integer;
  sMealName,dateEaten,timeEaten : string;
begin
  memMealLog.Clear;
  selectedDate := dpcDay.Date;
  iTotalCalories := currentUser.GetDailyCalories(selectedDate);
  iNumMeals := currentUser.GetTotalMeals;
  if iNumMeals = 0 then
    begin
    memMealLog.Lines.Add('Nothing to see here! ' + #13 + 'Start eating!');
    edtCaloires.Text := 0.ToString;
  end else
  begin
    for i := 1 to iNumMeals do
    begin
      sMealName := currentUser.GetMealInfo(i,'name');
      dateEaten := currentUser.GetMealInfo(i,'date');
      timeEaten := currentUser.GetMealInfo(i,'time');
      if StrToDate(dateEaten) = selectedDate then
      memMealLog.Lines.Add(
        timeEaten + ': ' + sMealName + ' eaten for '+ currentUser.GetMealInfo(i,'type')
      );
    end;
    edtCaloires.Text := IntToStr(iTotalCalories);
  end;
end;

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  self.ModalResult := mrClose;
end;

procedure TfrmDashboard.btnMealSearchClick(Sender: TObject);
var
  sFoodname: string;
  i: Integer;
  isFound : boolean;
  Protein,Carb,Fat,Calories,Sugar,Energy: real;
  FoodItem : TFoodItem;
begin
  if edtSearchMeal.text = '' then
    exit;
  sFoodname := edtSearchMeal.text;
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
  until (i = FoodCount-1) or isFound;

  if isFound then
  with redMealInfo do
  begin
    Clear;
    with Paragraph do
    begin
      TabCount := 2;
      Tab[0] := 100;
      Tab[1] := 150;
    end; // end with paragraph
    with Lines do
    begin
      Clear;
      Add('Information on ' + sFoodname);
      Add('----------------------------');
      Add('Calories per 100g:' + #9 + FloatToStrF(Calories,ffFixed,8,2));
      Add('Energy per 100g: ' + #9 + FloatToStrF(Energy,ffFixed,8,2));
      Add('Proteins per 100g:' + #9 + FloatToStrF(Protein,ffFixed,8,2));
      Add('Carbohydrates per 100g:' + #9 + FloatToStrF(Carb,ffFixed,8,2));
      Add('Fat per 100g:' + #9 + FloatToStrF(Fat,ffFixed,8,2));
      Add('Sugar per 100g:' + #9 + FloatToStrF(Sugar,ffFixed,8,2));
    end; // end lines
  end // end with redMealInfo
  else
  ShowMessage('Meal not found');

end;

procedure TfrmDashboard.btnSearchClick(Sender: TObject);
begin
  tsSearch.TabVisible := true;
  pctDashboard.TabIndex := 3;
end;

procedure TfrmDashboard.btnSplitClick(Sender: TObject);
begin
  if SplitView1.Opened then
  SplitView1.Close
  else SplitView1.Open;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
var
  userGreeter : TfrmGreeter;
begin
  utilObj := TUtils.Create;
  loggerObj := TLOGS.Create;
 // utilObj.SetLabel(lblHeading,'Dashboard',15);
  username := currentUser.Username;
  utilObj.SetLabel(lblUser,username,8);
  PopulateFoods;
  PopulateMealType;
  pctDashboard.TabIndex := 0;
  tsSearch.TabVisible := false;
  dpcDay.Date := Date;

  if currentUser.GetFirstLogin then
  begin
   userGreeter := TfrmGreeter.Create(nil);
   userGreeter.currentUser := currentUser;
   with userGreeter do
   begin
    try
      ShowModal;
    finally
      Free;
    end;
   end;
  end;

end;

procedure TfrmDashboard.PopulateMealType;
begin
// Populating the combo box with meal types
  with cmbMealType.Items do
  begin
    Add('Breakfast');
    Add('Lunch');
    Add('Brunch');
    Add('Supper');
    Add('Snack');
    Add('Other');
  end;
end;

procedure TfrmDashboard.SplitView1Closing(Sender: TObject);
begin
  btnLogOut.Caption := 'L';
  btnSplit.Caption := 'Open';
end;

procedure TfrmDashboard.SplitView1Opened(Sender: TObject);
begin
  btnLogOut.Caption := 'Log out';
  btnSplit.Caption := 'Close';
end;

procedure TfrmDashboard.PopulateFoods;
var
 currentMeal : string;
 i : Integer;
begin
 i := 0;
 foodList := TStringList.Create;
 cmbMeals.Clear;
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
        cmbMeals.Items.Add(currentMeal);
      end;
      Next;
    until Eof;
  end;
  Close;
  FoodCount := i;
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
  tsSearch.TabVisible := false;
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
