unit frmDashboard_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ComCtrls,
  libUtils_U,libUser_u, libMeals_U,conDB,frmAddFood_U,
  Vcl.WinXCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, Vcl.Mask,
  Vcl.WinXPanels, Vcl.Menus, Vcl.ToolWin,frmSettings_U,Math,libGoals_U,StrUtils,
  Vcl.DBCtrls, Vcl.NumberBox;

type
  TfrmDashboard = class(TForm)
    pnlProgressCenter: TPanel;
    cbxFoods: TComboBox;
    btnEaten: TButton;
    pnlCent: TPanel;
    cbxMealType: TComboBox;
    btnSearchFood: TButton;
    pnlDateNavigation: TPanel;
    sbtnPrev: TSpeedButton;
    sbtnNext: TSpeedButton;
    edtCalories: TLabeledEdit;
    crplDashboard: TCardPanel;
    crdProgress: TCard;
    crdEating: TCard;
    pnlProgressGoals: TPanel;
    prgCalories: TProgressBar;
    pnlProgressCal: TPanel;
    dpcDay: TDateTimePicker;
    crdGoals: TCard;
    redMeals: TRichEdit;
    pnlProgressMeals: TPanel;
    pnlMealBottom: TPanel;
    btnReset: TButton;
    btnGoEating: TButton;
    pnlProgressWater: TPanel;
    edtWater: TLabeledEdit;
    prgWater: TProgressBar;
    pnlProgressFat: TPanel;
    edtFat: TLabeledEdit;
    prgFat: TProgressBar;
    pnlProgressCarb: TPanel;
    edtCarb: TLabeledEdit;
    prgCarb: TProgressBar;
    pnlProgressProtein: TPanel;
    edtProtein: TLabeledEdit;
    prgProtein: TProgressBar;
    pnlProgTop: TPanel;
    btnGoGoals: TButton;
    pnlFood: TPanel;
    pnlDisplay: TPanel;
    redFoodInfo: TRichEdit;
    svSidebar: TSplitView;
    edtSVCalorie: TLabeledEdit;
    edtSVWater: TLabeledEdit;
    btnGoProgress: TButton;
    lblHello: TLabel;
    btnSettings: TButton;
    btnLogOut: TButton;
    lblProg: TLabel;
    cbxMeals: TComboBox;
    pnlEating: TPanel;
    pnlDrinkingWater: TPanel;
    crplGoals: TCardPanel;
    pnlGoalTop: TPanel;
    crdGoalOV: TCard;
    edtGoalCal: TLabeledEdit;
    btnGoalCalories: TButton;
    btnGoalWater: TButton;
    edtGoalWater: TLabeledEdit;
    edtGoalProtein: TLabeledEdit;
    btnGoalProtein: TButton;
    edtGoalCarb: TLabeledEdit;
    btnGoalCarb: TButton;
    edtGoalFat: TLabeledEdit;
    btnGoalFat: TButton;
    crdGoalView: TCard;
    edtGoalTarget: TLabeledEdit;
    edtAverageProg: TLabeledEdit;
    prgAverage: TProgressBar;
    pnlGoalDesc: TPanel;
    redGoalDesc: TRichEdit;
    pnlGoalOV: TPanel;
    pnlGoalHead: TPanel;
    pnlDesc: TPanel;
    pnlGoalAve: TPanel;
    edtGoalDays: TLabeledEdit;
    prgDays: TProgressBar;
    btnEditGoal: TButton;
    pnlDescBottom: TPanel;
    btnGoalDescEdit: TButton;
    btnGoalDescPost: TButton;
    lblDescMaxChar: TLabel;
    btnBackOV: TButton;
    edtGoalDate: TLabeledEdit;
    btnDrinking: TButton;
    pnlEatingFoodHeader: TPanel;
    pnlDrinkingHeader: TPanel;
    cbxGoalUnit: TComboBox;
    pnlEatingHead: TPanel;
    pnlGoalsOVTop: TPanel;
    pnlGoalsOVCenter: TPanel;
    redGoalsHelp: TRichEdit;
    nbxPortion: TNumberBox;
    nbxWaterInput: TNumberBox;
    lblMealType: TLabel;
    lblMeal: TLabel;
    lblPortion: TLabel;
    lblWaterInput: TLabel;
    redWaterInfo: TRichEdit;

    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure btnEatenClick(Sender: TObject);
    procedure btnSearchFoodClick(Sender: TObject);
    procedure sbtnNextClick(Sender: TObject);
    procedure sbtnPrevClick(Sender: TObject);
    procedure dpcDayChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnGoEatingClick(Sender: TObject);
    procedure btnGoGoalsClick(Sender: TObject);
    procedure btnGoProgressClick(Sender: TObject);
    procedure svSidebarMouseEnter(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure svSidebarResize(Sender: TObject);
    procedure cbxFoodsChange(Sender: TObject);
    procedure cbxMealTypeChange(Sender: TObject);
    procedure btnGoalDescEditClick(Sender: TObject);
    procedure btnEditGoalClick(Sender: TObject);
    procedure crdGoalOVEnter(Sender: TObject);
    procedure btnGoalCaloriesClick(Sender: TObject);
    procedure btnGoalWaterClick(Sender: TObject);
    procedure btnGoalProteinClick(Sender: TObject);
    procedure btnGoalCarbClick(Sender: TObject);
    procedure btnGoalFatClick(Sender: TObject);
    procedure btnGoalDescPostClick(Sender: TObject);
    procedure btnBackOVClick(Sender: TObject);
    procedure cbxMealsChange(Sender: TObject);
		procedure btnDrinkingClick(Sender: TObject);
    procedure crdEatingEnter(Sender: TObject);
    procedure cbxGoalUnitChange(Sender: TObject);
    procedure nbxPortionChange(Sender: TObject);
    procedure nbxWaterInputChangeValue(Sender: TObject);
  private
    { Private declarations }
    FCurrentUser : TUser;

    // crdProgress
    procedure GetProgressInfo;
    procedure ShowProgress(pRecDate:TDate);
    procedure SetProgressBar(pItem : String; pValue, pTarget : Real);
    procedure ShowMealLog(pDate :TDate);
    procedure ShowMealInfo;

    // crdEating
    procedure PopulateFoods;
    procedure PopulateMealType;
    procedure DisplayFoodInfo(pFoodname : String);
    procedure DisplayWaterInfo;
    procedure LogEatenFood;
    procedure LogGoalProgress(pMeal : TMeal);
    procedure DrinkWater(pAmount : real);
    procedure CheckMealFields;

    // crdGoals
    procedure ShowGoalOverview;
    procedure FillGoalEditBox(pGoalItem : String;pTarget:Real);
    procedure PopulateGoalUnits(pGoalItem:string);
    procedure ShowGoalInfo(pGoalItem : string);
    procedure ResetGoalInfo;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

var
  frmDashboard: TfrmDashboard;
  strFoods : TStringList;
  FoodCount : integer;
  ControlUtils : TControlUtils;

implementation

{$R *.dfm}

{ Progress panel}
{$REGION PROGRESS}

// Get our date and show our progress on said date
procedure TfrmDashboard.GetProgressInfo;
var
  dDate : TDate;
begin
  dDate := dpcDay.Date;
  lblProg.Caption := 'Progress for ' + FormatDateTime('dd mmm',dDate);
  ShowProgress(dDate);
  ShowMealLog(dDate);
end;

// Reset the meal rich edit and show meal logs
procedure TfrmDashboard.ShowMealLog;
var
	iDayMeals,i : integer;
	sFoodname,tEaten,sLine : string;
	rAmount : Real;
begin
	cbxMeals.Items.Clear;
	cbxMeals.Text := 'Choose a meal';

	redMeals.Clear;

	// We get the meal count for the particular
	// date that has been selected by the user
	iDayMeals := currentUser.GetMealCount(pDate);

	// If our days are zero then we don`t have to do much
	if iDayMeals = 0 then
	begin
		redMeals.Lines.Add('Nothing to see here! ' + #13 + 'Start eating!');

		// If our date is the current day we can give users a nice message
		if pDate = Date then
			redMeals.Lines.Add('Head to the `Eating and drinking` section to start!');

		// Disable the combo box as there will be no information to show
		cbxMeals.Enabled := false;
	end else
	begin
		// Enable our combo box since our info is now present
		cbxMeals.Enabled := true;

		//Displaying
		redMeals.Lines.Add('Meal logs for ' + FormatDateTime('dd mmm',pDate));
		redMeals.Lines.Add('=============');

		for i := 1 to iDayMeals do
		begin
			// Get information on each item that was eaten on that day
			sFoodname := currentUser.GetMealInfo(i,pDate,'name');
			rAmount := StrToFloat(CurrentUser.GetMealInfo(i,pDate,'portion'));
			tEaten := currentUser.GetMealInfo(i,pDate,'time');


			// Show our meal header
			redMeals.Lines.Add('Meal: #' + i.ToString + ' at ' + tEaten);

			// Get our line to display
			sLine := FloatToStrF(rAmount,ffFixed,8,2) + 'g of ' + sFoodname;
			redMeals.Lines.Add(sLine);

			redMeals.Lines.Add('--------------------');

			// Adding line to the combo box
			cbxMeals.Items.Add('#'+ i.ToString + ' ' + sLine);
    end;
  end;
end;

procedure TfrmDashboard.ShowProgress(pRecDate: TDate);
const ITEMS : array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  Goal : TGoal;
  rTarget,rValue : Real;
  i: Integer;
begin
  // Create each goal item and display their progress
  for i := 1 to Length(ITEMS) do
	begin
		// Get our goal info and targets
		Goal := TGoal.Create(CurrentUser.UserID,ITEMS[i]);
		rTarget := Goal.Target;

		rValue := Goal.GetProgress(pRecDate);

		// Each item will get it`s progress bar set separately
    SetProgressBar(Goal.Item,rValue,rTarget);

    Goal.free;
	end;

	// Sidebar inforomation display
	Goal := TGoal.Create(CurrentUser.UserID,'Calorie');
	rValue := Goal.GetProgress(Date);
	rTarget := Goal.Target;
	edtSVCalorie.Text := FloatToStrF(rValue,ffFixed,8,2) +  '/'+ FloatToStrF(rTarget,ffFixed,8,2);
	Goal.Free;

	Goal := TGoal.Create(CurrentUser.UserID,'Water');
	rValue := Goal.GetProgress(Date);
	rTarget := Goal.Target;

	rValue := rValue/500;
	rTarget := rTarget/500;
	edtSVWater.Text := Trunc(rValue).ToString +  '/'+ Round(rTarget).ToString + ' glasses';
	Goal.Free;
end;

procedure TfrmDashboard.SetProgressBar(pItem : String;pValue, pTarget : Real);
begin
	case IndexStr(LowerCase(pItem),['calorie','water','carbohydrate','protein','fat']) of
	0: // Calorie
		begin
			edtCalories.Text := FloatToStrF(pValue,ffFixed,8,2) +'/'+ FloatToStrF(pTarget,ffFixed,8,2) + 'cal';
			prgCalories.Max := Ceil(pTarget);;
			prgCalories.Position := Ceil(pValue);
		 end;
	1:  // Water
		begin
			edtWater.Text := FloatToStrF(pValue,ffFixed,8,2) +'/'+ FloatToStrF(pTarget,ffFixed,8,2)+'ml';
			prgWater.Max := Ceil(pTarget);
			prgWater.Position := Ceil(pValue);
		end;
	2: // Carbs
		begin
			edtCarb.Text := FloatToStrF(pValue,ffFixed,8,2) +'/'+ FloatToStrF(pTarget,ffFixed,8,2) + 'g';
			prgCarb.Max := Ceil(pTarget);
			prgCarb.Position := Ceil(pValue);
		end;
	3: // Protein
		begin
			edtProtein.Text := FloatToStrF(pValue,ffFixed,8,2) + '/'+FloatToStrF(pTarget,ffFixed,8,2) + 'g';
			prgProtein.Max := Ceil(pTarget);
			prgProtein.Position := Ceil(pValue);
		end;
	4: // Fat
		begin
		 edtFat.Text := FloatToStrF(pValue,ffFixed,8,2) + '/'+FloatToStrF(pTarget,ffFixed,8,2) +'g';
		 prgFat.Max := Ceil(pTarget);
		 prgFat.Position := Ceil(pValue);
		end;
	end;
end;

// Reset goal rich edit
procedure TfrmDashboard.btnResetClick(Sender: TObject);
begin
	GetProgressInfo;
end;

procedure TfrmDashboard.ShowMealInfo;
var
	sFoodname,sMealType,sTime, sHeader: string;
	iFoodIndex : Integer;
	dDate : TDate;
	rPortion : Real;
	Meal : TMeal;
	FoodItem : TFoodItem;
	strMealInfo : TStringList;
begin
	// Stop if none selected
	if cbxMeals.ItemIndex = -1 then
	begin
		cbxMeals.SetFocus;
		exit;
	end;

	iFoodIndex := cbxMeals.ItemIndex+1;
	dDate := dpcDay.date;
	strMealInfo := TStringList.Create;

	// Portion should be convertablet to float even if it is recieved as a string
	rPortion := StrToFloat(CurrentUser.GetMealInfo(iFoodIndex,dDate,'portion'));

	// Other information
	sMealType := CurrentUser.GetMealInfo(iFoodIndex,dDate,'type');
	sFoodname := CurrentUser.GetMealInfo(iFoodIndex,dDate,'name');
	sTime := CurrentUser.GetMealInfo(iFoodIndex,dDate,'time');

	// Our food item is created to obtain data on the food item such as nutrient values
	FoodItem := TFoodItem.Create(sFoodname);

	// Our meal does all the calculations, we do not `eat` this meal though, only use it
	Meal := TMeal.Create(FoodItem,rPortion,sMealType);

	// Store the log in a string list
	// Makes it easier for me to know what is being displayed over using the rich edit solely
	with strMealInfo do
  begin
    Add(sFoodname + ', eaten at ' + sTime);
    Add('=================================');
    Add('');
    Add('Eaten for '+ sMealType);
    Add('Portion size:' + #9 + FloatToStrF(rPortion,ffFixed,8,2)+'g');
    Add('Total calories:' + #9 + FloatToStrF(Meal.TotalCalories,ffFixed,8,2)+'kcal');
    Add('Total energy:' + #9 + FloatToStrF(Meal.TotalEnergy,ffFixed,8,2)+'kJ');

		// Calculating totals not stored in the meal object
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


	// Tidying up our rich edit display
	with redMeals.Paragraph do
	begin
		TabCount := 1;
		Tab[0] := 100;
	end;

	// Display our info
  redMeals.Text := strMealInfo.Text;

	strMealInfo.free;
	Meal.Free;
	FoodItem.Free;
end;

procedure TfrmDashboard.dpcDayChange(Sender: TObject);
begin
	// Prevent going back to days
	// before the user has registered
	// and going beyond the current data
	if dpcDay.Date = Date then
		sbtnNext.Enabled := False
	else
		sbtnNext.Enabled := True;

	if (dpcDay.Date = CurrentUser.GetRegisterDate) then
		sbtnPrev.Enabled := false
	else
		sbtnPrev.Enabled := true;

	// Show our day-based progress
  GetProgressInfo;
end;


// We obtain our foods from the database and place them
// into the foods combo box
procedure TfrmDashboard.PopulateFoods;
var
 sFoodItem : string;
 i : Integer;
begin
 i := 0;
 // Create our food string list
 strFoods := TStringList.Create;

 cbxFoods.Items.Clear;
 with dmData.tblFoods do
 begin
	Open;
	if FieldCount <> 0 then
	begin
		First;
		repeat
			sFoodItem := FieldValues['Foodname'];

      // We want to prevent empty fields and the `Default` field I use for testing the object
			if not ((sFoodItem = '') or (sFoodItem = 'Default')) then
			begin
			// Count our food items
				inc(i);

				// Add our food item to the string list and the combo box
        strFoods.Add(sFoodItem);
        cbxFoods.Items.Add(sFoodItem);
      end;
      Next;
    until Eof;
	end;
	Close;
	FoodCount := i;
 end;
end;

// Going forward a day
procedure TfrmDashboard.sbtnNextClick(Sender: TObject);
begin
	if dpcDay.Date < Date then
		dpcDay.Date := dpcDay.Date+1;
	dpcDayChange(self);
	GetProgressInfo;
end;
// Going back a day
procedure TfrmDashboard.sbtnPrevClick(Sender: TObject);
begin
  dpcDay.Date := dpcDay.Date-1;
  dpcDayChange(self);
  GetProgressInfo;
end;
{$ENDREGION}

{ Sidebar }
{$REGION SIDEBAR}

procedure TfrmDashboard.svSidebarMouseEnter(Sender: TObject);
begin
  svSidebar.open;
end;

procedure TfrmDashboard.svSidebarResize(Sender: TObject);
begin
	// Dealing with our sidebar sizing
	// Each item is positioned based on a ratio of 6.5
  // each step is the position of the next item
  with svSidebar do
  begin
    edtSVCalorie.Top := Ceil(Height - Height*5.5/6.5);
    edtSVWater.top := Ceil(Height - Height*4.5/6.5);

    //btnSettings.Top := Ceil(Height - Height * 4;
    btnGoEating.top := Ceil(Height - Height * 2.5/6.5);
    btnGoGoals.Top := Ceil(Height - Height * 1.5/6.5);
    btnGoProgress.Top := Ceil(Height - Height * 3.5/6.5);
    btnLogout.Top := Ceil(Height - Height * 0.5/6.5);

		// Every object should be 5 7ths the sizde of the sidebar
		edtSVCalorie.Width := Ceil(Width*5/7);
		edtSVWater.Width := Ceil(Width*5/7);
		btnSettings.Width := Ceil(width*5/7);
		btnGoEating.Width := Ceil(width*5/7);
		btnGoGoals.Width := Ceil(width*5/7);
		btnGoProgress.Width := Ceil(Width*5/7);
		btnLogout.Width := Ceil(Width*5/7);

		// The ratio was not chosen for specficreeason
		// but it works to keep the items relatively
		// centered based on theri width
		// and the sidebar width using
		// a ratio of 17 to 140
    edtSVCalorie.left := Ceil(Width*17/140);
    edtSVWater.left := Ceil(Width*17/140);
    btnSettings.left := Ceil(Width*17/140);
    btnGoEating.left := Ceil(Width*17/140);
    btnGoGoals.left := Ceil(Width*17/140);
    btnGoProgress.left := Ceil(Width*17/140);
    btnLogout.left := Ceil(Width*17/140);
  end;
end;

// Couldn't finish
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

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  self.ModalResult := mrClose;
end;

{$ENDREGION}

{ Form navigation }
{$REGION NAVIGATION}
// Enter our progress card, the first card
procedure TfrmDashboard.btnGoProgressClick(Sender: TObject);
begin
	crplDashboard.ActiveCard := crdProgress;
	btnGoProgress.Enabled := false;
	btnGoGoals.Enabled := true;
	btnGoEating.Enabled := true;
end;

// Enter our goals card and call the onEnter event of
// the goals card to display the data
procedure TfrmDashboard.btnGoGoalsClick(Sender: TObject);
begin
  crplGoals.ActiveCard := crdGoalOV;
  crplDashboard.ActiveCard := crdGoals;
  btnGoProgress.Enabled := true;
  btnGoEating.Enabled := true;
  btnGoGoals.Enabled := false;
  crdGoalOVEnter(nil);
end;

// Enter the eating card and call the onEnter event
// to reset the card components
procedure TfrmDashboard.btnGoEatingClick(Sender: TObject);
begin
	crplDashboard.ActiveCard := crdEating;
	btnGoProgress.Enabled := true;
	btnGoGoals.Enabled := true;
	btnGoEating.Enabled := false;
	btnGoEating.Default := false;
	crdEatingEnter(nil);
end;

procedure TfrmDashboard.btnBackOVClick(Sender: TObject);
begin
	crplGoals.ActiveCard := crdGoalOV;
end;


// Upon entering our eating card
procedure TfrmDashboard.crdEatingEnter(Sender: TObject);
begin
	// Reset the combo box
	cbxFoods.ItemIndex := -1;
	cbxFoods.Text := 'Choose a food';
	cbxFoods.SetFocus;

	// Ensure our number boxes are formatted correctly
	ControlUtils.SetNumberBox(nbxPortion,1,999);
	ControlUtils.SetNumberBox(nbxWaterInput,10,999);
	nbxWaterInput.Enabled := true;

	cbxMealType.ItemIndex := -1;
	cbxMealType.Text := 'Meal type';

	// Show info on water in our rich edit
	DisplayWaterInfo;

	// Rich edit display
	with redFoodInfo.Lines do
	begin
		Clear;
		Add('Select a food item and get information');
		Add('Click `Search foods` if you can`t find what you are looking for');
	end;
end;

// Reset our goal info and fill our goal overview components
procedure TfrmDashboard.crdGoalOVEnter(Sender: TObject);
begin
  ResetGoalInfo;
  ShowGoalOverview;
end;
{$ENDREGION}

{ Meal eating }
{$REGION MEAL EATING }
procedure TfrmDashboard.btnEatenClick(Sender: TObject);
var
  iCheckInt : integer;
  sMealName,sMealType : string;
  rPortion : Real;
  Meal : TMeal;
  FoodItem : TFoodItem;
begin
	// Log the food item in the database
	LogEatenFood;

	// Prompt to show updated progress
	if MessageDlg('Show updated progress?',mtConfirmation,mbYesNo,0) = mrYes then
		btnGoProgressClick(nil);

	btnEaten.Default := false;
end;

procedure TfrmDashboard.LogEatenFood;
var
  sMealName,sMealType : String;
  rPortion : Real;
  Meal : TMeal;
  FoodItem : TFoodItem;
begin
  sMealName := cbxFoods.text;
  sMealType := cbxMealType.Text;

  rPortion := nbxPortion.Value;

	// Confirmation
	if MessageDlg('Are you sure you want to enter this food item',mtConfirmation,mbYesNo,0) = mrYes then
	begin
		FoodItem := TFoodItem.Create(sMealName);

		// Ensuring our food item exists in the database, ensuring
		// the user is eating an item that exists
		if FoodItem.CheckExists then
		begin
			Meal := TMeal.Create(FoodItem,rPortion,sMealType);

			// Logs our meal into the database
			Meal.EatMeal(currentUser.UserID,currentUser.GetTotalMeals);

			// Log our progress into the database
			LogGoalProgress(Meal);

			// Updates our goal information once the operation is complete
      GetProgressInfo;
		end else
		// This error may not appear often, but I hope to prevent it from happening anyway
			ShowMessage('The item ' +  FoodItem.Foodname + ' does not exist in the database');

   Meal.Free;
   FoodItem.Free;
  end;
end;

procedure TfrmDashboard.btnDrinkingClick(Sender: TObject);
var
  rAmount : real;
  iCheckInt : Integer;
begin
	// Get our water values and add them to the database
	rAmount := nbxWaterInput.Value;
	DrinkWater(rAmount);

	// Update our progress oce done
  GetProgressInfo;
  nbxWaterInput.Value := 10;
  btnDrinking.Default := false;
end;

// Saving water progress to the database
procedure TfrmDashboard.DrinkWater(pAmount: Real);
var
  Goal : TGoal;
begin
  Goal := TGoal.Create(CurrentUser.UserID,'Water');
  Goal.SaveProgress(pAmount);
  Goal.Free;
end;

procedure TfrmDashboard.LogGoalProgress;
var
  rCalories,rProtein,rCarb,rFat : Real;
  Goal : TGoal;
  sUserID : String;
begin
	sUserID := CurrentUser.UserID;
	// We obtain our calories and save progress
	rCalories := pMeal.TotalCalories;
	Goal := TGoal.Create(sUserID,'Calorie');
	Goal.SaveProgress(rCalories);

	// Each food item has specific nutrient values
	// hence we can save their values individually in the progress table

  rProtein := pMeal.FoodItem.ProteinPer100G * (pMeal.PortionSize/100);
  Goal := TGoal.Create(sUserID,'Protein');
  Goal.SaveProgress(rProtein);

  rCarb := pMeal.FoodItem.CarbPer100G * (pMeal.PortionSize/100);
  Goal := TGoal.Create(sUserID,'Carbohydrate');
  Goal.SaveProgress(rCarb);

  rFat := pMeal.FoodItem.FatPer100G * (pMeal.PortionSize/100);
  Goal := TGoal.Create(sUserID,'Fat');
  Goal.SaveProgress(rFat);
  Goal.Free;
end;

//Enabling our eating button when our portion size is present
procedure TfrmDashboard.nbxPortionChange(Sender: TObject);
begin
	btnEaten.Default := true;
end;

// Same with water
procedure TfrmDashboard.nbxWaterInputChangeValue(Sender: TObject);
begin
  btnDrinking.Default := true;
end;

{ Dealing with food information when combo box selected item changes }
procedure TfrmDashboard.cbxFoodsChange(Sender: TObject);
var sFoodname : String;
begin
	// Check our meal fields to ensure they are all filled before allowing eating
	CheckMealFields;
	//Display our food item info when a food item is selecte
  if cbxFoods.ItemIndex <> -1 then
  begin
    sFoodname := cbxFoods.Text;
    DisplayFoodInfo(sFoodname);
  end;
end;

// Get our water info from the text file
procedure TfrmDashboard.DisplayWaterInfo;
const FILENAME = 'info/water.txt';
var isExist : Boolean;
begin
  isExist := FileUtils.CheckFileExists(FILENAME);
  if isExist then
  with redWaterInfo.Lines do
  begin
    Clear;
    LoadFromFile(FILENAME);
  end;
end;

procedure TfrmDashboard.DisplayFoodInfo;
var
  i: Integer;
  isFound : boolean;
  rProtein,rCarb,rFat,rCalories,rSugar,rEnergy: real;
  FoodItem : TFoodItem;
  sCategory : String;
begin
  isFound := false;

  { Loop through the food list until either i is at the food count or the food is found }
  i := 0;
  repeat
    if UpperCase(pFoodname) = UpperCase(strFoods[i]) then
    begin
			isFound := true;

			// Obtain our food data which is gotten from the database
			FoodItem := TFoodItem.Create(strFoods[i]);
			sCategory := FoodItem.Category;
			rProtein := FoodItem.ProteinPer100G;
			rCarb := FoodItem.CarbPer100G;
			rFat := FoodItem.FatPer100G;
			rCalories := FoodItem.CaloriePer100G;
			rSugar := FoodItem.SugarPer100G;
			rEnergy := FoodItem.EnergyPer100G;
			FoodItem.Free;
		end else inc(i);
	until (i = FoodCount) or isFound;

	// if the item is not founds nothing is done
	if isFound then
	with redFoodInfo do
	begin
		Clear;
		//Formatting our rich edit
		with Paragraph do
		begin
			TabCount := 1;
			Tab[0] := 150;
		end; // end with paragraph

		// Display our food item information
		with Lines do
		begin
			Add('Information on ' + pFoodname);
			Add('----------------------------------------------------');
			Add('Category' + #9 + sCategory);
			Add('Calories per 100g:' + #9 + FloatToStrF(rCalories,ffFixed,8,2)+'kcal');
			Add('Energy per 100g: ' + #9 + FloatToStrF(rEnergy,ffFixed,8,2)+'kJ');
			Add('Proteins per 100g:' + #9 + FloatToStrF(rProtein,ffFixed,8,2)+'g');
			Add('Carbohydrates per 100g:' + #9 + FloatToStrF(rCarb,ffFixed,8,2)+'g');
			Add('Fat per 100g:' + #9 + FloatToStrF(rFat,ffFixed,8,2)+'g');
			Add('Sugar per 100g:' + #9 + FloatToStrF(rSugar,ffFixed,8,2)+'g');
		end; // end lines
  end; // end with redMealInfo
end;

// Show food info when the meal combo box is updates
procedure TfrmDashboard.cbxMealsChange(Sender: TObject);
begin
	ShowMealInfo;
end;

// Ensuring our fields are filled
procedure TfrmDashboard.cbxMealTypeChange(Sender: TObject);
begin
  CheckMealFields;
end;

// Ensure every field is filled before allowing eating
procedure TfrmDashboard.CheckMealFields;
var
  isFoodSelected, isMealSelected, isPortionEntered : Boolean;
begin
  isFoodSelected := cbxFoods.ItemIndex <> -1;
  isMealSelected := cbxMealType.ItemIndex <> -1;

  if not isFoodSelected then
    cbxMealType.Enabled := false
  else
    nbxPortion.Enabled := true;

  if isFoodSelected and not(isMealSelected) then
  begin
    cbxMealType.Enabled := true;
    btnEaten.Enabled := false;
  end;

  if isFoodSelected and isMealSelected then
    btnEaten.Enabled := true
  else
    btnEaten.Enabled := false;
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

// Show our food addition form
procedure TfrmDashboard.btnSearchFoodClick(Sender: TObject);
var
  frmFood : TfrmAddFood;
  isSuccess : boolean;
begin
  isSuccess := false;
  frmFood := TfrmAddFood.Create(nil);
  try
    frmFood.ShowModal;
  finally
    isSuccess := frmFood.ModalResult = mrOk;
    frmFood.Free;
  end;
  if isSuccess then
    PopulateFoods;
end;
{$ENDREGION}

{ Form creation and showing }
{$REGION FORM CREATION AND SHOW}
procedure TfrmDashboard.FormResize(Sender: TObject);
begin
	// Keep our sidebar as 7/48 of the form width and
	// the screen as the rest
	if svSidebar.Opened then
	begin
		svSidebar.OpenedWidth := Ceil(self.Width*7/48);
		crplDashboard.Width := Ceil(self.Width*41/48);
	end;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
	//Initialize our objects
  FileUtils := TFileUtils.Create;
  LogService := TLogService.Create;

	// Populate our food combo boxes and arrays
	PopulateFoods;
	PopulateMealType;

	// Set our date to the current day
	// formatting our date edit
	dpcDay.Date := Date;
	dpcDay.MaxDate := Date;
	dpcDay.MinDate := CurrentUser.GetRegisterDate;
	dpcDayChange(nil);

	// Get today`s progress
	GetProgressInfo;

	crplDashboard.ActiveCard := crdProgress;

	lblHello.Caption := 'Hello, ' + CurrentUser.Username;

	// Make the eating button default for navigation help
  btnGoEating.Default := true;
  btnGoEating.Hint := 'Start eating to update progress';
  btnGoEating.ShowHint := true;
end;
{$ENDREGION}

{ Goals and goal modification }
{$REGION GOALS }

procedure TfrmDashboard.ShowGoalInfo(pGoalItem: string);
var
  Goal : TGoal;
  rTarget,rAverage : Real;
  iTotalDays,iAchievedDays : Integer;
  dStartDate : TDate;
begin
  pnlGoalHead.Caption := pGoalItem;

	// Get our goal description
	Goal := TGoal.Create(CurrentUser.UserID,pGoalItem);
	redGoalDesc.Text := Goal.GetDesc;

	// Get our goal targets and average
	rTarget := Goal.Target;
	rAverage := Goal.CalcAverage;

	// Setting our progress bars
	prgAverage.Max := Ceil(rTarget);
	prgAverage.Position := Ceil(rAverage);

	// Showing averges
	edtAverageProg.ReadOnly := true;
	edtAverageProg.Text := FloatToStrF(rAverage,ffFixed,8,2)+'/'+FloatToStrF(rTarget,ffFixed,8,2);

	//Showing our total
	// Water will change it`s display depending on the unit selected
	edtGoalTarget.ReadOnly := true;
	edtGoalTarget.Text := FloatToStrF(rTarget,ffGeneral,8,2)+'g';

	// Populate our units of measurement
	// Useful for water unit formatting
  PopulateGoalUnits(pGoalItem);
  cbxGoalUnit.ItemIndex := 0;
	cbxGoalUnitChange(nil);

	// Get our day counts and display them
  iTotalDays := Goal.GetTotalDays;
  iAchievedDays := GOAL.CalcDaysAchieved;

  edtGoalDays.ReadOnly := TRUE;
  edtGoalDays.Text := iAchievedDays.ToString + '/' + iTotalDays.ToString;
  prgDays.Max := iTotalDays;
  prgDays.Position := iAchievedDays;

  dStartDate := Goal.StartDate;
  edtGoalDate.Text := FormatDateTime('dd mmmm yyyy',dStartDate);

  Goal.Free;

	// Go to our goal view card
  crplGoals.ActiveCard := crdGoalView;
end;

procedure TfrmDashboard.cbxGoalUnitChange(Sender: TObject);
var
  isWater : Boolean;
  iUnitIndex : Integer;
  rTarget : Real;
  Goal : TGoal;
begin
	iUnitIndex := cbxGoalUnit.ItemIndex;
	isWater := cbxGoalUnit.items.count = 3;
	// Ensure our item is indeed water
	if isWater then
	begin
		Goal := TGoal.Create(CurrentUser.UserID,'Water');
		rTarget := Goal.Target;
		Goal.Free;
		// Change the unit of measurement based on the unit selected
		// in the combo box
    case iUnitIndex of
    0: edtGoalTarget.Text := FloatToStrF(rTarget,ffFixed,8,2)+'ml';
    1: edtGoalTarget.Text := FloatToStrF(rTarget/1000,ffFixed,8,2)+'l';
    2: edtGoalTarget.Text := FloatToStrF(rTarget/500,ffFixed,8,0)+' glasses';
    end;
  end;
end;

// Populate our goal units
procedure TfrmDashboard.PopulateGoalUnits(pGoalItem: string);
var isWater : Boolean;
begin
  cbxGoalUnit.Items.Clear;
  isWater := LowerCase(pGoalItem) = 'water';
  if isWater then
  begin
    cbxGoalUnit.Items.Add('millilitres');
    cbxGoalUnit.Items.Add('litres');
    cbxGoalUnit.Items.Add('glasses');
  end
  else
    cbxGoalUnit.Items.Add('grams');
end;

// Show goal information for specific items
procedure TfrmDashboard.btnGoalCaloriesClick(Sender: TObject);
begin
  ShowGoalInfo('Calorie');
end;
procedure TfrmDashboard.btnGoalCarbClick(Sender: TObject);
begin
  ShowGoalInfo('Carbohydrate');
end;
procedure TfrmDashboard.btnGoalFatClick(Sender: TObject);
begin
  ShowGoalInfo('Fat');
end;
procedure TfrmDashboard.btnGoalProteinClick(Sender: TObject);
begin
  ShowGoalInfo('Protein');
end;
procedure TfrmDashboard.btnGoalWaterClick(Sender: TObject);
begin
  ShowGoalInfo('Water');
end;

// Enable goal description editing
procedure TfrmDashboard.btnGoalDescEditClick(Sender: TObject);
begin
  btnGoalDescPost.Enabled := True;
  btnGoalDescEdit.Enabled := false;
  redGoalDesc.ReadOnly := false;
end;

// Post our new edited description and show it
procedure TfrmDashboard.btnGoalDescPostClick(Sender: TObject);
var
	sNewDesc : String;
	sGoalItem : String;
	Goal : TGoal;
begin
	sGoalItem := pnlGoalHead.Caption;
	Goal := TGoal.Create(CurrentUser.UserID,sGoalItem);

	sNewDesc := redGoalDesc.Text;
	if MessageDlg('Are you sure you want to change the goal description?',mtConfirmation,mbYesNoCancel,0) = mrYes then
	begin
		Goal.EditDesc(sNewDesc);
		redGoalDesc.Text := Goal.GetDesc;
	end;
end;

// Changing our goal targets
procedure TfrmDashboard.btnEditGoalClick(Sender: TObject);
var
  sTargetStr : String;
  rNewTarget : real;
  iCheckNum : Integer;
  Goal : TGoal;
  sGoalItem : String;
begin
  sTargetStr := InputBox('Enter a new goal target','New target','');
  sGoalItem := pnlGoalHead.Caption;

	// Presense validation
  if sTargetStr = '' then
  begin
    ShowMessage('Please enter a value for goal target');
    exit;
	end;

  Val(sTargetStr,rNewTarget,iCheckNum);

	// If our check integer is not zero
	// there is a non-number value in the string
	// prevent continuing when that happens
	if iCheckNum <> 0 then
	begin
		ShowMessage('Please ensure that the goal target is a number');
		exit;
	end;

	// Confirmation
  if MessageDlg('Are you sure you want to change this value to ' + sTargetStr,mtConfirmation,mbYesNo,0) = mrYes then
  begin
    Goal := TGoal.Create(CurrentUser.UserID,sGoalItem);

		// Set our new targets, this resets current goal information
		Goal.Target := rNewTarget;
		Goal.SetGoalTarget;

		ShowMessage('Goal changed successfully!');

		// Show our updated progress info
    GetProgressInfo;
    ShowGoalInfo(sGoalItem);
  end;
end;

// Reset the goal info screen upon leaving
procedure TfrmDashboard.ResetGoalInfo;
begin
  btnGoalDescPost.Enabled := false;
  btnGoalDescEdit.Enabled := true;
  redGoalDesc.ReadOnly := true;
  cbxGoalUnit.clear;
  cbxGoalUnit.Text := 'Unit of measurement';
  edtGoalDate.Text := '';
  edtGoalDays.Text := '';
  prgDays.Position := 0;
  prgAverage.Position := 0;
  redGoalDesc.Lines.Clear;
  pnlGoalHead.Caption := 'Goal';
end;

// Showing our goal items on the overview screen
procedure TfrmDashboard.ShowGoalOverview;
const GOALITEMS :array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  Goal : TGoal;
  sUserID,sGoalUnit : String;
  i: Integer;
  rTarget : real;
begin
  sUserID := CurrentUser.UserID;

	// Each item is displayed from the array
	for i := 1 to Length(GOALITEMS) do
	begin
		Goal := TGoal.Create(sUserID,GOALITEMS[I]);
		rTarget := Goal.Target;
		sGoalUnit := Goal.GoalUnit;
		FillGoalEditBox(GOALITEMS[i],rTarget);
		Goal.Free;
	end;

	// Give some help
  with redGoalsHelp.Lines do
  begin
    Clear;
    Add('Tip:');
    Add('Welcome to the goals section!');
    Add('Here you can view all of your goals as a user and modify them as you wish');
  end;
end;

// Fill our goal edit boxes based on which item is being passed from the array
procedure TfrmDashboard.FillGoalEditBox(pGoalItem : String;pTarget:Real);
begin
  case IndexStr(LowerCase(pGoalItem),['calorie','water','carbohydrate','protein','fat']) of
  0: begin
    edtGoalCal.Text := FloatToStrF(pTarget,ffGeneral,8,2)+'g';
  end;
  1: begin
    edtGoalWater.Text := FloatToStrF(pTarget,ffGeneral,8,2)+'ml';
  end;
  2: begin
    edtGoalCarb.Text := FloatToStrF(pTarget,ffGeneral,8,2)+'g';
  end;
  3: begin
    edtGoalProtein.Text := FloatToStrF(pTarget,ffGeneral,8,2)+'g';
  end;
  4: begin
    edtGoalFat.Text := FloatToStrF(pTarget,ffGeneral,8,2)+'g';
  end;
  else
    begin
      ShowMessage('FillGoalEditBox parameter `sGoalItem` is not one of `Calorie`, `Water`, `Carbohydrate`, `Protein` or `Fat`');
    end;
  end;
end;

{$ENDREGION}
end.
