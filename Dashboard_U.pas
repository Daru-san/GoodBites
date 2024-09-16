unit Dashboard_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,InfoBoard,Utils_U,User_u,
  Vcl.ComCtrls,Meals_U,conDBBites,frmGreeter_U;

type
  TfrmDashboard = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    lblHeading: TLabel;
    lblEats: TLabel;
    pnlFoot: TPanel;
    btnLogOut: TButton;
    pnlUser: TPanel;
    lblUser: TLabel;
    dpcDay: TDateTimePicker;
    btnLoadData: TButton;
    pnlProgIndicator: TPanel;
    memMealLog: TMemo;
    lblDayCalorie: TLabel;
    edtCaloires: TEdit;
    cmbMeals: TComboBox;
    edtPortion: TEdit;
    btnEaten: TButton;
    pnlNewMeal: TPanel;
    lblCustomMeal: TLabel;
    cbxAddDB: TCheckBox;
    edtMealName: TEdit;
    edtNumCalories: TEdit;
    cbxNewFood: TCheckBox;
    pctDashboard: TPageControl;
    tsProgress: TTabSheet;
    tsEating: TTabSheet;
    pnlCent: TPanel;
    memMeal: TMemo;
    lblMeal: TLabel;
    tsWelcome: TTabSheet;
    memGoals: TMemo;
    pnlGoal: TPanel;
    btnSearch: TButton;
    tsSearch: TTabSheet;
    edtSearchMeal: TEdit;
    btnMealSearch: TButton;
    redMealInfo: TRichEdit;
    cmbMealType: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure pnlInfoClick(Sender: TObject);
    procedure btnEatenClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure tsEatingShow(Sender: TObject);
    procedure tsProgressShow(Sender: TObject);
    procedure tsWelcomeShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure tsSearchShow(Sender: TObject);
    procedure tsSearchHide(Sender: TObject);
    procedure btnMealSearchClick(Sender: TObject);
  private
    { Private declarations }
    procedure PopulateFoods;
    procedure GetInfo;
    procedure PopulateMealType;
  public
    { Public declarations }
    currentUser : TUser;
    currentMeal : TMeal;
  end;

var
  frmDashboard: TfrmDashboard;
  username : string;
  foodList : TStringList;
  gFoodCount : integer;

implementation

{$R *.dfm}

procedure TfrmDashboard.btnEatenClick(Sender: TObject);
var
  selectedOpt,iCalories,iCheckInt,iPortion : integer;
  sMealName : string;
begin
  sMealName := cmbMeals.text;
  Val(edtPortion.Text,iPortion,iCheckInt);
  Val(edtCaloires.Text,iCalories,iCheckInt);
  selectedOpt := MessageDlg('Are you sure you want to enter this food item',mtConfirmation,mbYesNo,0);
  if selectedOpt = mrYes then
  begin
    if cbxNewFood.Checked then
      currentMeal.Create(sMealName,iCalories,iPortion,false) else
      currentMeal.Create(sMealName,0,iPortion,false);
    currentMeal.EatMeal(currentUser);
    currentMeal.Free;
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
  if dpcDay.Checked then
  selectedDate := dpcDay.Date
  else selectedDate := Date;
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
      sMealName := currentUser.GetMeal(i,1);
      dateEaten := currentUser.GetMeal(i,3);
      timeEaten := currentUser.GetMeal(i,4);
      if StrToDate(dateEaten) = selectedDate then
      memMealLog.Lines.Add(
        timeEaten + ': ' + sMealName + ' eaten for '+ currentUser.GetMeal(i,2)
      );
    end;
    edtCaloires.Text := IntToStr(iTotalCalories);
  end;
end;

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  // Get closing to work properly
  Application.MainForm.Visible := true;
  currentUser.Free;
  frmDashboard.Close;
  frmDashboard.Destroy;
end;

procedure TfrmDashboard.btnMealSearchClick(Sender: TObject);
var
  sMealName,sCurrentMeal : string;
  i: Integer;
  isMealFound : boolean;
  iProteins,iCarbs,iFat,iCalories: integer;
begin
  sMealName := edtSearchMeal.text;
  isMealFound := false;
  i := 0;
  repeat
    if UpperCase(sMealName) = foodList[i] then
    begin
      isMealFound := true;
      currentMeal.Create(foodList[i]);
      iProteins := currentMeal.GetFoodInfo('Nutrient','Protein');
      iCarbs := currentMeal.GetFoodInfo('Nutrient','Carbohydrate');
      iFat := currentMeal.GetFoodInfo('Nutrient','Fat');
      iCalories := currentMeal.GetFoodInfo('Calories');
      currentMeal.Free;
    end else inc(i);
  until (i = gFoodCount) or isMealFound;

  if isMealFound then
  with redMealInfo do
  begin
    with Paragraph do
    begin
      TabCount := 2;
      Tab[0] := 150;
      Tab[1] := 250;
    end;
    with Lines do
    begin
      Clear;
      Add('Information on ' + sMealName);
      Add('----------------------------');
      Add('Calories per 100g:' + #9 + IntToStr(iCalories));
      Add('Proteins per 100g:' + #9 + IntToStr(iProteins));
      Add('Carbohydrates per 100g:' + #9 + IntToStr(iCalories));
      Add('Fat per 100g:' + #9 + IntToStr(iProteins));
    end;
  end else
  ShowMessage('Meal not found');

end;

procedure TfrmDashboard.btnSearchClick(Sender: TObject);
begin
  tsSearch.TabVisible := true;
  pctDashboard.TabIndex := 3;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
var
  userGreeter : TfrmGreeter;
begin
  utilObj := TUtils.Create;
  utilObj.SetLabel(lblHeading,'Dashboard',15);
  username := currentUser.Username;
  utilObj.SetLabel(lblUser,'Logged in as ' + username,8);
  PopulateFoods;
  PopulateMealType;
  pctDashboard.TabIndex := 0;
  tsSearch.TabVisible := false;
  GetInfo;



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
procedure TfrmDashboard.PopulateFoods;
var
 currentMeal : string;
 i : Integer;
begin
 i := 0;
 foodList := TStringList.Create;
 with dbmData.tblFoods do
 begin
  Open;
  First;
  repeat
    inc(i);
    currentMeal := FieldValues['Foodname'];
    if not (currentMeal = '') then
    begin
      foodList.Add(currentMeal);
      cmbMeals.Items.Add(currentMeal);
      Next;
    end;
  until Eof;
  Close;
 end;
end;

procedure TfrmDashboard.tsEatingShow(Sender: TObject);
begin
  utilObj.SetLabel(lblHeading,'What are you eating?',15);
end;

procedure TfrmDashboard.tsProgressShow(Sender: TObject);
begin
  utilObj.SetLabel(lblHeading,'Your current progress?',15);
end;

procedure TfrmDashboard.tsSearchHide(Sender: TObject);
begin
  tsSearch.TabVisible := false;
end;

procedure TfrmDashboard.tsSearchShow(Sender: TObject);
begin
  utilObj.SetLabel(lblHeading,'Search foods',15);
end;

procedure TfrmDashboard.tsWelcomeShow(Sender: TObject);
begin
  utilObj.SetLabel(lblHeading,'Welcome to ' + Application.MainForm.Caption + '!',15);
end;

procedure TfrmDashboard.pnlInfoClick(Sender: TObject);
var
  infoForm : InfoBoard.TfrmInfo;
begin
 infoForm := TfrmInfo.Create(nil);
 try
  infoForm.ShowModal;
  self.hide;
 finally
   infoForm.Free;
//   Self.Show;
 end;

end;

end.
