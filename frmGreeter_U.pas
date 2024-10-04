unit frmGreeter_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.NumberBox,
  libUser_U,libUtils_U, libGoals_U, Vcl.MPlayer;

type
  TfrmGreeter = class(TForm)
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
    pnlAge: TPanel;
    pnlFName: TPanel;
    pnlHeight: TPanel;
    pnlWeight: TPanel;
    pnlDetails: TPanel;
    crdWelcome: TCard;
    crdGoals: TCard;
    mpWelcome: TMediaPlayer;
    procedure FormShow(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure crdWelcomeEnter(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure edtFullnameChange(Sender: TObject);
    procedure spnAgeChange(Sender: TObject);
    procedure nbxHeightChange(Sender: TObject);
    procedure nbxWeightChange(Sender: TObject);

  private
    { Private declarations }
    FCurrentUser : TUser;
    procedure ViewDetailsCard;
    procedure ViewWelcomeCard;
    procedure ViewGoalsCard;
    procedure ReConfirmDetails;
    procedure ConfirmDetails;
    procedure CheckFilled;
    procedure SetGoals;
    procedure PostGoals;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

const
  arrGOALITEMS : array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  frmGreeter: TfrmGreeter;
  isConfirmed : Boolean;
  Utils : TUtils;

  arrTargets : array[1..5] of real;

implementation

{$R *.dfm}

procedure TfrmGreeter.btnBackClick(Sender: TObject);
begin
  if crplWelcome.ActiveCard = crdDetails then
    crplWelcome.ActiveCard := crdLanding;

  if crplWelcome.ActiveCard = crdWelcome then
  begin
    ReConfirmDetails;
    if not isConfirmed then
      crplWelcome.ActiveCard := crdDetails;
  end;
end;

procedure TfrmGreeter.btnContinueClick(Sender: TObject);
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
    PostGoals;
    crplWelcome.ActiveCard := crdWelcome;
    mpWelcome.Play;
  end;
  if crplWelcome.ActiveCard <> crdLanding then
    btnBack.Enabled := true;
end;

procedure TfrmGreeter.FormShow(Sender: TObject);
begin
  crplWelcome.ActiveCard := crdLanding;
  ShowMessage(
    'Hello, ' + CurrentUser.Username + '.' + #13
    + 'Welcome to GoodBites!' + #13
    + 'This is the onboarding page, here you can add your info and learn how to use this app!'
  );
  btnBack.Enabled := false;
  Utils := TUtils.Create;
end;

procedure TfrmGreeter.nbxHeightChange(Sender: TObject);
begin
  CheckFilled;
end;

procedure TfrmGreeter.nbxWeightChange(Sender: TObject);
begin
  CheckFilled;
end;

procedure TfrmGreeter.ReConfirmDetails;
begin
  if MessageDlg('Are you sure you would like to go back and edit your details?',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    isConfirmed := false;
  end;
end;

procedure TfrmGreeter.spnAgeChange(Sender: TObject);
begin
  CheckFilled;
end;

procedure TfrmGreeter.ConfirmDetails;
var
  iCheckInt : Integer;
  iAge : Integer;
  rWeight,rHeight : real;
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

  slsMessage := TStringList.Create;
  slsMessage.Add('Please confirm these details are correct');
  slsMessage.Add('Full name:' + #9 + sFName);
  slsMessage.Add('Age:' + #9 + iAge.ToString);
  slsMessage.Add('Weight:' + #9 + FloatToStrF(rWeight,ffFixed,8,2));
  slsMessage.Add('Height:' + #9 + FloatToStrF(rHeight,ffFixed,8,2));

  if MessageDlg(slsMessage.Text,mtConfirmation,mbYesNoCancel,0) = mrYes then
  begin
    CurrentUser.SaveUserInfo(sFName,iAge,rWeight,rHeight);
    isConfirmed := true;
    btnContinue.Enabled := true;
  end;
end;

procedure TfrmGreeter.crdWelcomeEnter(Sender: TObject);
begin
  btnBack.Enabled := false;
  btnContinue.Enabled := true;
end;

procedure TfrmGreeter.edtFullnameChange(Sender: TObject);
begin
  CheckFilled;
end;

procedure TfrmGreeter.CheckFilled;
var
  isName,isAge,isWeight,isHeight : Boolean;
  sFullname : String;
begin
  if crplWelcome.ActiveCard <> crdDetails then
  exit;

  isName := (edtFullname.text <> '');
  isAge := (spnAge.Value > 7) and (spnAge.Value < 150);
  isWeight := (nbxWeight.Value > 30) and (nbxWeight.Value < 1000);
  isHeight := (nbxHeight.Value > 30 ) and (nbxHeight.Value < 200);

  if isName and isAge and isWeight and isHeight then
    btnContinue.Enabled := true
  else
    btnContinue.Enabled := false;
end;

procedure TfrmGreeter.ViewWelcomeCard;
begin
  crplWelcome.ActiveCard := crdWelcome;
end;

procedure TfrmGreeter.ViewGoalsCard;
begin
  crplWelcome.ActiveCard := crdGoals;
end;

procedure TfrmGreeter.ViewDetailsCard;
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

procedure TfrmGreeter.SetGoals;
begin

end;

procedure TfrmGreeter.PostGoals;
begin

end;
end.
