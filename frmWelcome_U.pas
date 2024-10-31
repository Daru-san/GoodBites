unit frmWelcome_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.NumberBox,
  libUser_U,libUtils_U, libGoals_U, Vcl.OleCtrls, Vcl.Imaging.pngimage;

type
  TfrmWelcome = class(TForm)
    crplWelcome: TCardPanel;
    crdLanding: TCard;
    btnContinue: TButton;
    btnBack: TButton;
    crdDetails: TCard;
    spnAge: TSpinEdit;
    pnlDetailsHead: TPanel;
    lblAge: TLabel;
    nbxHeight: TNumberBox;
    nbxWeight: TNumberBox;
    lblWeight: TLabel;
    lblHeight: TLabel;
    edtFullname: TLabeledEdit;
    pnlDetails: TPanel;
    crdWelcome: TCard;
    crdGoals: TCard;
    rgpActivity: TRadioGroup;
    pnlGoalsHead: TPanel;
    edtGoalCalories: TLabeledEdit;
    edtGoalCarb: TLabeledEdit;
    edtGoalProtein: TLabeledEdit;
    edtGoalFats: TLabeledEdit;
    edtGoalWater: TLabeledEdit;
    crplGoals: TCardPanel;
    crdGoalsOverview: TCard;
    pnlGoalOVCenter: TPanel;
    pnlGoalOVTop: TPanel;
    lblCarbTargetPerc: TLabel;
    lblFatTargetPerc: TLabel;
    lblProteinTargetPerc: TLabel;
    lblTotalCalCalc: TLabel;
    lblWaterAdd: TLabel;
    lblAppName: TLabel;
    pnlLandingCenter: TPanel;
    pnlNav: TPanel;
    rgpGender: TRadioGroup;
    redInfoHelp: TRichEdit;
    redGreeting: TRichEdit;
    lblTagline: TLabel;
    pnlGetEating: TPanel;
    lblWelcome: TLabel;
    crdTutorial: TCard;
    pcTutorial: TPageControl;
    tabDashboard: TTabSheet;
    tabEating: TTabSheet;
    tabCustomFoods: TTabSheet;
    tabGoalsOverview: TTabSheet;
    tabGoalsEdit: TTabSheet;
    s: TImage;
    imgEating: TImage;
    imgCustomFoods: TImage;
    imgGoalOverview: TImage;
    imgGoalEdit: TImage;
    btnSkip: TButton;
    pnlTutorialHeader: TPanel;
    pnlPhysicalTraits: TPanel;
    pnlGeneralInfo: TPanel;
    pnlActivityLevel: TPanel;
    redWelcomeInfo: TRichEdit;
		procedure FormShow(Sender: TObject);
		procedure crdWelcomeEnter(Sender: TObject);
		procedure edtFullnameChange(Sender: TObject);
		procedure spnAgeChange(Sender: TObject);
		procedure nbxHeightChange(Sender: TObject);
		procedure nbxWeightChange(Sender: TObject);
		procedure rgpActivityClick(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure pnlNavResize(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure pnlGetEatingClick(Sender: TObject);
		procedure rgpGenderClick(Sender: TObject);

		// Overload this procedure to control the tutorial page control
		// instead of the card panel
		procedure ContinueClick; overload;
		procedure BackClick; overload;

    procedure btnBackClick(Sender: TObject);
		procedure btnContinueClick(Sender: TObject);
    procedure tabDashboardEnter(Sender: TObject);
    procedure tabGoalsEditEnter(Sender: TObject);
    procedure tabGoalsEditExit(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
	private
		{ Private declarations }
		FCurrentUser : TUser;
		procedure ShowDetailsCard;
		procedure ShowWelcomeCard;
		procedure ShowGoalsCard;
		procedure ShowLandingCard;
		procedure ShowTutorial;
		procedure GoalCardForward;

		procedure ReConfirmDetails;
		procedure ConfirmDetails;
		procedure CheckFilled;

		procedure SetNewGoals;
		procedure SetGoal(pGoalItem,pGoalUnit : String; pTarget : Real);
		procedure CalculateGoals;

		procedure ContinueClick(isTutorial : Boolean); overload;
		procedure BackClick(isTutorial : Boolean); overload;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

const
	// Contrainting values
  MINAGE = 7;
  MAXAGE = 150;
  MINHEIGHT = 60;
  MAXHEIGHT =  299;
  MINWEIGHT = 15;
  MAXWEIGHT = 999;
var
  frmWelcome: TfrmWelcome;
  isConfirmed : Boolean;
  FileUtils : TFileUtils;
  LogService : TLogService;
  ControlUtils : TControlUtils;

implementation

{$R *.dfm}


// Form controls
{$REGION FORM CONTROLS}
procedure TfrmWelcome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	FileUtils.Free;
	LogService.Free;
	self.ModalResult := mrClose;
end;

procedure TfrmWelcome.FormResize(Sender: TObject);
begin
	//Ensure that the navigation bar is 1 16th of the height
	pnlNav.Height := Round(self.Height *1/16);

	// The navigation bar width should always be the same as the
	pnlNav.Width := Self.Width;

	// Centering the Welcome button
	pnlGetEating.Left := Round(self.Width/2 - pnlGetEating.Width/2);

	// Center the greeting rich edit
	redGreeting.Left := Round((self.Width - redGreeting.Width)/2);
	redWelcomeInfo.Left := Round((self.Width - redWelcomeInfo.Width)/2);

	lblWelcome.Left := 1;
end;

procedure TfrmWelcome.FormShow(Sender: TObject);
begin
	// Object initialization
	FileUtils := TFileUtils.Create;
	LogService := TLogService.Create;
	ControlUtils := TControlUtils.Create;

	ShowMessage('Hello, ' + CurrentUser.Username + '. Let`s begin.');

	//Show our initial card
	ShowLandingCard;

	// Evades the check error where we may not be able to move our cards
	// if this is true, causing a stand-still on the landing page
	isConfirmed := false;

	// Hide and disable the tutorial skip button
	btnSkip.Enabled := false;
	btnSkip.Visible := false;
end;


// Checking if all input components are filled before proceeding
procedure TfrmWelcome.nbxHeightChange(Sender: TObject);
begin
	CheckFilled;
end;
procedure TfrmWelcome.nbxWeightChange(Sender: TObject);
begin
	CheckFilled;
end;
procedure TfrmWelcome.rgpActivityClick(Sender: TObject);
begin
	CheckFilled;
end;
procedure TfrmWelcome.rgpGenderClick(Sender: TObject);
begin
	CheckFilled;
end;
procedure TfrmWelcome.spnAgeChange(Sender: TObject);
begin
	CheckFilled;
end;
procedure TfrmWelcome.edtFullnameChange(Sender: TObject);
begin
	CheckFilled;
end;

// Changing the navigation buttons based
// on which section of the tutorial we are on

// First page should only give us the option to go forward
procedure TfrmWelcome.tabDashboardEnter(Sender: TObject);
begin
	btnBack.Enabled := false;
	btnContinue.Enabled := true;
end;

// Last page should indicate that the procedure can now be `finished`
procedure TfrmWelcome.tabGoalsEditEnter(Sender: TObject);
begin
	btnBack.Enabled := true;
	btnContinue.Caption := 'Finish';
end;

// Upon leaving the last page, incase of going back, set our button to next
procedure TfrmWelcome.tabGoalsEditExit(Sender: TObject);
begin
	btnContinue.Caption := 'Next';
end;


// Disable all buttons once we reach the welcome card
procedure TfrmWelcome.crdWelcomeEnter(Sender: TObject);
begin
	btnBack.Enabled := false;
	btnContinue.Enabled := false;
	btnSkip.Enabled := false;
	btnSkip.Visible := false;
	pnlNav.Hide;
	pnlNav.Enabled := false;
end;

// Exit, leaving mrOk as the modal result
// The dasboard will obtain this value and use it
// as confirmation to move onto the next form
procedure TfrmWelcome.pnlGetEatingClick(Sender: TObject);
begin
	ModalResult := mrYes;
end;


// Dynamic component sizes in the navbar
// Should be 80% of the height
procedure TfrmWelcome.pnlNavResize(Sender: TObject);
begin
	btnContinue.Width := btnBack.Width;

	// Our continue and back buttons
	// are centered based on their width and height
	with btnContinue do
	begin
		Top := 1;
		Height := Round(pnlNav.Height * 8/10);
		Left := Round((self.Width/2) + 30);
	end;
	with btnBack do
	begin
		Top := 1;
		Height := Round(pnlNav.Height * 8/10);
		Left := Round((self.Width/2-width) - 30);
	end;

	// Skip button should be at the very end
	with btnSkip do
	begin
		Top := 1;
		Height := Round(pnlNav.Height * 8/10);
		Left := Round(self.Width-Width)-30;
	end;
end;
{$ENDREGION}

// Navigation
{$REGION NAVIGATION }

// Form controls
procedure TfrmWelcome.btnBackClick(Sender: TObject);
begin
	// This override will navigate cards if the tutorial is not open
	// if the tutorial is open it will only navigate the tutorial page control
	if crplWelcome.ActiveCard = crdTutorial then
		BackClick(true)
	else
		BackClick;
end;

procedure TfrmWelcome.btnContinueClick(Sender: TObject);
begin
	// This override will navigate cards if the tutorial is not open
	// if the tutorial is open it will only navigate the tutorial page control
	if crplWelcome.ActiveCard = crdTutorial then
		ContinueClick(true)
	else
    ContinueClick;
end;

// Skipping the tutorial
procedure TfrmWelcome.btnSkipClick(Sender: TObject);
begin
	if MessageDlg('Skip the tutorial?',mtConfirmation,mbYesNo,0) = mrYes then
		ShowWelcomeCard;
end;

{ Card panel movement }

// Going back each card
procedure TfrmWelcome.BackClick;
begin
	// Going back to the landing page from the details page
	if crplWelcome.ActiveCard = crdDetails then
		ShowLandingCard;

	// Reconfirm in case of post editing
	if crplWelcome.ActiveCard = crdGoals then
	begin
		ReConfirmDetails;
		if not isConfirmed then
			crplWelcome.ActiveCard := crdDetails;
	end;
end;

// Going forward in cards
procedure TfrmWelcome.ContinueClick;
begin
	// Landing page to details page
	if (crplWelcome.ActiveCard = crdLanding) then
		ShowDetailsCard
	else
	// We then confirm our details and show goals when confirmed
	if crplWelcome.ActiveCard = crdDetails then
	begin
		ConfirmDetails;

		if isConfirmed then
			ShowGoalsCard;
	end else
	// Else we go to the tutorial
	if crplWelcome.ActiveCard = crdGoals then
		GoalCardForward;

	// Enable back button on cards except the landing one and the welcoming card
	if (crplWelcome.ActiveCard <> crdLanding) and (crplWelcome.ActiveCard <> crdWelcome) then
		btnBack.Enabled := true;
end;

{ Tutorial page control movement }

// We move to the next tutorial item
procedure TfrmWelcome.ContinueClick(isTutorial : Boolean);
var
	iCurrentTabIndex : Integer;
begin
	// Getting and increasing the current tab
	iCurrentTabIndex := pcTutorial.TabIndex;
	inc(iCurrentTabIndex);

	btnBack.Enabled := true;

	// Making the component text dymically changed based
	// on the location of the user works really well here
	if iCurrentTabIndex + 1 = pcTutorial.PageCount then
		btnContinue.Caption := 'Finish'
	else
		btnContinue.Caption := 'Next';

	// We only continue if we are not on the last page
	if iCurrentTabIndex <> pcTutorial.PageCount then
		pcTutorial.TabIndex := iCurrentTabIndex;
	// If we are, we go to the welcome page
	if iCurrentTabIndex = pcTutorial.PageCount then
		ShowWelcomeCard;
end;

procedure TfrmWelcome.BackClick(isTutorial: Boolean);
var
	iCurrentTabIndex : Integer;
begin
	// Getting and decreasing our tab index
	iCurrentTabIndex := pcTutorial.TabIndex;
	dec(iCurrentTabIndex);

	btnContinue.Caption := 'Next';

	// Only go back if we are not on the first tab
	if iCurrentTabIndex > -1 then
		pcTutorial.TabIndex := iCurrentTabIndex;
	// and disable the button if we are on the first
	if iCurrentTabIndex = 0 then
		btnBack.Enabled := false
	else
		btnBack.Enabled := true;
end;

{$ENDREGION}

// Presence checks
{$REGION Checks }
procedure TfrmWelcome.CheckFilled;
var
	isNameFilled,isAgeFilled,isWeightFilled,isHeightFilled,isActiveFilled,isGenderFilled : Boolean;
	sFullname : String;
begin
	// Do not do this on any other card except the details card
	if crplWelcome.ActiveCard <> crdDetails then
	exit;

	isNameFilled := (edtFullname.text <> '');

	// The controls do this already, preventing values outside the range
	// this is to ensure that it is enforced
	isAgeFilled := (spnAge.Value >= MINAGE) and (spnAge.Value <= MAXAGE);
	isWeightFilled := (nbxWeight.Value >= MINWEIGHT) and (nbxWeight.Value <= MAXWEIGHT);
	isHeightFilled := (nbxHeight.Value >= MINHEIGHT) and (nbxHeight.Value <= MAXHEIGHT);

	isActiveFilled := rgpActivity.ItemIndex <> -1;
	isGenderFilled := rgpGender.ItemIndex <> -1;

	// If our name is filled, we continue
	if isNameFilled then
	begin
		spnAge.Enabled := true;
		nbxWeight.Enabled := true;
		nbxHeight.Enabled := true;
		rgpActivity.Enabled := true;
		rgpGender.Enabled := true;
	end;

	// Everything must be filled before enabling the continue button
	if isNameFilled and isAgeFilled and isWeightFilled and isHeightFilled and isGenderFilled and isActiveFilled then
		btnContinue.Enabled := true
	else
		btnContinue.Enabled := false;
end;
{$ENDREGION}

// Opening cards
{$REGION VIEW CARDS}
procedure TfrmWelcome.ShowLandingCard;
const GREETINGFILE = 'info\greeting.txt';
var slsGreeting : TStringList;
begin
 btnContinue.Enabled := true;
 btnBack.Enabled := false;
 crplWelcome.ActiveCard := crdLanding;

 // Ensure that the greeting text file exists, if not display default text
 // We check in both the current and upper directories
 slsGreeting := TStringList.Create;
 if FileExists(GREETINGFILE) then
	slsGreeting.LoadFromFile(GREETINGFILE)
 else
 if FileExists('..\..\'+GREETINGFILE) then
	slsGreeting.LoadFromFile('..\..\'+GREETINGFILE)
 else
 // This will log the missing file
	FileUtils.CheckFileExists(GREETINGFILE);

 with redGreeting.Lines do
 begin
	Clear;
	Add('Hello, ' + CurrentUser.Username+'.');
	Add(slsGreeting.Text);
 end;
 slsGreeting.Free;
end;

procedure TfrmWelcome.ShowDetailsCard;
begin
	// We reset all the controls when entering the card
	if not isConfirmed then
	begin
		ControlUtils.SetNumberBox(nbxHeight,MINHEIGHT,MAXHEIGHT);
		ControlUtils.SetNumberBox(nbxWeight,MINWEIGHT,MAXWEIGHT);
		ControlUtils.SetSpinEdit(spnAge,MINAGE,MAXAGE);
		edtFullname.Text := '';
		rgpActivity.ItemIndex := -1;
		rgpGender.ItemIndex := -1;
		btnContinue.Enabled := false;
		crplWelcome.ActiveCard := crdDetails;
		edtFullname.SetFocus;
	end;
end;

procedure TfrmWelcome.ShowWelcomeCard;
begin
	crplWelcome.ActiveCard := crdWelcome;

	// Log registration completion and set FirstLogin in the database to false
	CurrentUser.RegisterComplete;
	LogService.WriteUserLog('User ' + CurrentUser.Username + ' uid ' + CurrentUser.UserID + ' has completed the sign up course!');

	// Disabling our buttons
	btnBack.Enabled := false;
	btnContinue.Enabled := false;
	btnSkip.Enabled := false;
	btnSkip.Visible := false;

	// Greeting our new users
	with lblWelcome do
	begin
		Font.Size := 15;
		Font.Style := [fsBold];
		Align := alTop;
		Alignment := taCenter;
		Caption := 'Welcome to GoodBites, ' + CurrentUser.Username+'!';
	end;

	// Giving some extra information before they leave
	if FileUtils.CheckFileExists('..\..\info\welcome.txt') then
		redWelcomeInfo.Lines.LoadFromFile('..\..\info\welcome.txt')
	else
	with redWelcomeInfo.Lines do
	begin
		Clear;
		Add('You registration is complete');
    Add('From here we head to the dashboard');
		Add('Let`s get eating!');
  end;
end;

procedure TfrmWelcome.ShowGoalsCard;
begin
	CalculateGoals;
	crplWelcome.ActiveCard := crdGoals;
	crplGoals.ActiveCard := crdGoalsOverview;
end;

procedure TfrmWelcome.GoalCardForward;
var
	slsMessage : TStringList;
begin
	// Store our confirmation message in a string list
	// makes it easier to type
	slsMessage := TStringList.Create;
	slsMessage.Add('Are you sure you would like to continue?');
	slsMessage.Add('You can modify your goals once you have reached the dashboard');
	if MessageDlg(slsMessage.text,mtConfirmation,mbYesNo,0) = mrYes then
	begin
		// Set our goals and move to tutorial card
		SetNewGoals;
		ShowTutorial;
	end;
	slsMessage.Free;
end;
{$ENDREGION}

// Tutorial card
{$REGION TUTORIAL}
procedure TfrmWelcome.ShowTutorial;
begin
	crplWelcome.ActiveCard := crdTutorial;
	pcTutorial.TabIndex := 0;
	btnBack.Enabled := false;
	btnBack.Caption := 'Back';
	btnContinue.Caption := 'Next';
	btnContinue.Enabled := true;
	btnSkip.Enabled := true;
	btnSkip.Visible := true;
end;
{$ENDREGION}

// Confirmation
{$REGION Detail Confirmation }

procedure TfrmWelcome.ConfirmDetails;
var
	iCheckInt : Integer;
	iAge : Integer;
	rWeight,rHeight, rActivityLevel : real;
	slsMessage : TStringList;
	sFName : String;
	sGender : String;
begin
	//Get the necessary data
  // Already been validated so validation is not needed here
  rWeight := nbxWeight.Value;
  rHeight := nbxHeight.Value;
  sFName := edtFullname.Text;
  iAge := spnAge.Value;

  case rgpGender.ItemIndex of
  0 : sGender := 'Male';
  1 : sGender := 'Female';
  end;

  case rgpActivity.itemIndex of
  0 : rActivityLevel := 1.0;
  1 : rActivityLevel := 1.2;
  2 : rActivityLevel := 1.4;
  3 : rActivityLevel := 1.6;
  4 : rActivityLevel := 2.0;
  end;

	// Creating our confirmation message
  slsMessage := TStringList.Create;
  slsMessage.Add('Are you sure you want to continue with these details?');
  slsMessage.Add('Name:' + #9 + sFName);
  slsMessage.Add('Sex:' + #9 + sGender);
  slsMessage.Add('Age:' + #9 + iAge.ToString + ' years');
  slsMessage.Add('Weight:' + #9 + FloatToStrF(rWeight,ffFixed,8,2) + 'kg');
  slsMessage.Add('Height:' + #9 + FloatToStrF(rHeight,ffFixed,8,2) + 'cm');

  // Add our user`s info
  if MessageDlg(slsMessage.Text,mtConfirmation,mbYesNo,0) = mrYes then
  begin
    CurrentUser.Age := iAge;
    CurrentUser.Height := rHeight;
    CurrentUser.Weight := rWeight;
    CurrentUser.Fullname := sFName;
    CurrentUser.ActivityLevel := rActivityLevel;
    CurrentUser.Gender := sGender;
    CurrentUser.SaveUserInfo;
    isConfirmed := true;
    btnContinue.Enabled := true;
  end;
end;

// Enable users to go back in case they need to change any info
procedure TfrmWelcome.ReConfirmDetails;
begin
  if MessageDlg('Are you sure you would like to go back and edit your details?',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    isConfirmed := false;
  end;
end;

{$ENDREGION}

// Goal calculation, setting and display
{$REGION Goals }
procedure TfrmWelcome.SetGoal(pGoalItem: string; pGoalUnit: string; pTarget: Real);
var
  NewGoal : TGoal;
begin
  // Create our goal, set targets and post
  NewGoal := TGoal.Create(CurrentUser.UserID,pGoalItem);
  NewGoal.Target := pTarget;
  NewGoal.GoalUnit := pGoalUnit;
  NewGoal.AddGoal;
  NewGoal.Free;
end;

procedure TfrmWelcome.CalculateGoals;
var
  rProtein, rCarb, rFat, rTotalCalories : Real;
begin
  rTotalCalories := CurrentUser.CalcTotalCalories;

  // Protein is calculated as weight x 150% by the activity level
  // It should equate to about 20% of the daily caloric intake
  rProtein := (CurrentUser.Weight * 1.5) * CurrentUser.ActivityLevel;

  // Carbohydrates are 50% of total calories over four
  rCarb := (rTotalCalories*0.50)/4;

  // Fats are 30% of total calories over 9
  rFat := (rTotalCalories*0.3)/9;

	// Display our goals
  edtGoalCalories.Text := FloatToStrf(rTotalCalories,ffFixed,8,2);
  edtGoalProtein.Text := FloatToStrF(rProtein,ffFixed,8,2);
  edtGoalCarb.Text := FloatToStrF(rCarb,ffFixed,8,2);
  edtGoalFats.Text := FloatToStrF(rFat,ffFixed,8,2);
  edtGoalWater.Text := 2000.ToString;
end;

// Setting our new goals
procedure TfrmWelcome.SetNewGoals;
var
	rProtein, rCarb, rFat, rTotalCalories, rWater : Real;
	sWaterUnit : String;
begin
	// We get the data back from the edits
	rTotalCalories := StrToFloat(edtGoalCalories.Text);
	rProtein := StrToFloat(edtGoalProtein.Text);
	rFat := StrToFloat(edtGoalFats.Text);
	rCarb := StrToFloat(edtGoalCarb.Text);
	rWater := StrToFloat(edtGoalWater.Text);

  // Set the goals
  SetGoal('Calorie','g',rTotalCalories);
	SetGoal('Protein','g',rProtein);
  SetGoal('Carbohydrate','g',rCarb);
  SetGoal('Fat','g',rFat);
  SetGoal('Water','ml',rWater);;
end;
{$ENDREGION}
end.
