unit frmWelcome_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.NumberBox,
  libUser_U,libUtils_U, libGoals_U, Vcl.MPlayer;

type
  TfrmWelcome = class(TForm)
    crplWelcome: TCardPanel;
    tbTop: TToolBar;
    crdLanding: TCard;
    btnContinue: TButton;
    btnBack: TButton;
    crdDetails: TCard;
    spnAge: TSpinEdit;
    tbNavbar: TToolBar;
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
    mpWelcome: TMediaPlayer;
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
    procedure FormShow(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure crdWelcomeEnter(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure edtFullnameChange(Sender: TObject);
    procedure spnAgeChange(Sender: TObject);
    procedure nbxHeightChange(Sender: TObject);
    procedure nbxWeightChange(Sender: TObject);
    procedure rgpActivityClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    FCurrentUser : TUser;
    procedure ViewDetailsCard;
    procedure ViewWelcomeCard;
    procedure ViewGoalsCard;

    procedure GoalCardForward;

    procedure ReConfirmDetails;
    procedure ConfirmDetails;
    procedure CheckFilled;

    procedure SetNewGoals;
    procedure SetGoal(pGoalItem,pGoalUnit : String; pTarget : Real);
    procedure CalculateGoals;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

const
  arrGOALITEMS : array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  frmWelcome: TfrmWelcome;
  isConfirmed : Boolean;
  FileUtils : TFileUtils;

  arrTargets : array[1..5] of real;

implementation

{$R *.dfm}


// Form controls
{$REGION FORM CONTROLS}
procedure TfrmWelcome.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.ModalResult := mrClose;
end;

procedure TfrmWelcome.FormShow(Sender: TObject);
begin
  crplWelcome.ActiveCard := crdLanding;
  ShowMessage(
    'Hello, ' + CurrentUser.Username + '.' + #13
    + 'Welcome to GoodBites!' + #13
    + 'This is the onboarding page, here you can add your info and learn how to use this app!'
  );
  btnBack.Enabled := false;
  FileUtils := TFileUtils.Create;
end;

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

procedure TfrmWelcome.spnAgeChange(Sender: TObject);
begin
  CheckFilled;
end;

procedure TfrmWelcome.crdWelcomeEnter(Sender: TObject);
begin
  btnBack.Enabled := false;
  btnContinue.Enabled := true;
end;

procedure TfrmWelcome.edtFullnameChange(Sender: TObject);
begin
  CheckFilled;
end;


{$ENDREGION}

// Navigation
{$REGION NAVIGATION }
procedure TfrmWelcome.btnBackClick(Sender: TObject);
begin
  if crplWelcome.ActiveCard = crdDetails then
    crplWelcome.ActiveCard := crdLanding;

  if crplWelcome.ActiveCard = crdGoals then
  begin
    ReConfirmDetails;
    if not isConfirmed then
      crplWelcome.ActiveCard := crdDetails;
  end;
end;

procedure TfrmWelcome.btnContinueClick(Sender: TObject);
begin
  if (crplWelcome.ActiveCard = crdLanding) then
  begin
    ViewDetailsCard;
  end else
  if crplWelcome.ActiveCard = crdDetails then
  begin
    ConfirmDetails;

    if isConfirmed then
      ViewGoalsCard;
  end else
  if crplWelcome.ActiveCard = crdGoals then
  begin
    GoalCardForward;
  end;
  if crplWelcome.ActiveCard <> crdLanding then
    btnBack.Enabled := true;
end;


procedure TfrmWelcome.GoalCardForward;
var
  sMessage : TStringList;
begin
  sMessage := TStringList.Create;
  sMessage.Add('Are you sure you would like to continue?');
  sMessage.Add('You can modify your goals once you have reached the dashboard');
  if MessageDlg(sMessage.text,mtConfirmation,mbYesNo,0) = mrYes then
  begin
    SetNewGoals;
    ViewWelcomeCard;
  end;
  sMessage.Free;
end;

{$ENDREGION}

// Presence checks
{$REGION Checks }
procedure TfrmWelcome.CheckFilled;
var
  isName,isAge,isWeight,isHeight,isActive : Boolean;
  sFullname : String;
begin
  if crplWelcome.ActiveCard <> crdDetails then
  exit;

  isName := (edtFullname.text <> '');
  isAge := (spnAge.Value > 7) and (spnAge.Value < 150);
  isWeight := (nbxWeight.Value > 30) and (nbxWeight.Value < 1000);
  isHeight := (nbxHeight.Value > 30 ) and (nbxHeight.Value < 200);
  isActive := rgpActivity.ItemIndex <> -1;
  if isName and isAge and isWeight and isHeight then
    btnContinue.Enabled := true
  else
    btnContinue.Enabled := false;
end;
{$ENDREGION}

// Opening cards
{$REGION VIEW CARDS}
procedure TfrmWelcome.ViewDetailsCard;
begin
  if not isConfirmed then
  begin
    nbxWeight.Value := 0;
    nbxHeight.Value := 0;
    spnAge.Value := 0;
    btnContinue.Enabled := false;
    crplWelcome.ActiveCard := crdDetails;
  end;
end;

procedure TfrmWelcome.ViewWelcomeCard;
begin
  crplWelcome.ActiveCard := crdWelcome;
  CurrentUser.CompleteSignUp;
  tbNavbar.Hide;
end;

procedure TfrmWelcome.ViewGoalsCard;
begin
  CalculateGoals;
  crplWelcome.ActiveCard := crdGoals;
  crplGoals.ActiveCard := crdGoalsOverview;
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
begin
  if (spnAge.Value < 7) or (spnAge.Value > 150) then
  begin
    ShowMessage('Please enter an age between 7 and 150 years');
    Exit;
  end;
  rWeight := nbxWeight.Value;
  rHeight := nbxHeight.Value;
  sFName := edtFullname.Text;
  iAge := spnAge.Value;

  case rgpActivity.itemIndex of
  0 : rActivityLevel := 0.4;
  1 : rActivityLevel := 0.8;
  2 : rActivityLevel := 1.2;
  3 : rActivityLevel := 1.6;
  4 : rActivityLevel := 2.0;
  end;

  slsMessage := TStringList.Create;
  slsMessage.Add('Please confirm these details are correct');
  slsMessage.Add('Full name:' + #9 + sFName);
  slsMessage.Add('Age:' + #9 + iAge.ToString);
  slsMessage.Add('Weight:' + #9 + FloatToStrF(rWeight,ffFixed,8,2));
  slsMessage.Add('Height:' + #9 + FloatToStrF(rHeight,ffFixed,8,2));

  if MessageDlg(slsMessage.Text,mtConfirmation,mbYesNoCancel,0) = mrYes then
  begin
    CurrentUser.Age := iAge;
    CurrentUser.Height := rHeight;
    CurrentUser.Weight := rWeight;
    CurrentUser.Fullname := sFName;
    CurrentUser.ActivityLevel := rActivityLevel;
    CurrentUser.SaveUserInfo;
    isConfirmed := true;
    btnContinue.Enabled := true;
  end;
end;

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
  NewGoal := TGoal.Create(CurrentUser.UserID,pGoalItem);
  NewGoal.Target := pTarget;
  NewGoal.GoalUnit := pGoalUnit;
  NewGoal.AddGoal;
  NewGoal.Free;
end;

procedure TfrmWelcome.CalculateGoals;
const
  PROTEIN = 0.2;
  CARB = 0.5;
  FAT = 0.3;
var
  rProtein, rCarb, rFat, rTotalCalories : Real;
begin
  rTotalCalories := CurrentUser.CalcTotalCalories;

  rProtein := rTotalCalories * PROTEIN;
  rCarb := rTotalCalories * CARB;
  rFat := rTotalCalories * FAT;

  edtGoalCalories.Text := FloatToStrf(rTotalCalories,ffFixed,8,2);
  edtGoalProtein.Text := FloatToStrF(rProtein,ffFixed,8,2);
  edtGoalCarb.Text := FloatToStrF(rCarb,ffFixed,8,2);
  edtGoalFats.Text := FloatToStrF(rFat,ffFixed,8,2);
  edtGoalWater.Text := 2000.ToString;
end;

procedure TfrmWelcome.SetNewGoals;
var
  rProtein, rCarb, rFat, rTotalCalories, rWater : Real;
  sWaterUnit : String;
begin
  rTotalCalories := StrToFloat(edtGoalCalories.Text);
  rProtein := StrToFloat(edtGoalProtein.Text);
  rFat := StrToFloat(edtGoalFats.Text);
  rCarb := StrToFloat(edtGoalCarb.Text);
  rWater := StrToFloat(edtGoalWater.Text);

  SetGoal('Calorie','g',rTotalCalories);
  SetGoal('Protein','g',rProtein);
  SetGoal('Carbohydrate','g',rCarb);
  SetGoal('Fat','g',rFat);
  SetGoal('Water','ml',rWater);;
end;
{$ENDREGION}
end.
