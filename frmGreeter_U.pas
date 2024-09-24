unit frmGreeter_U;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Samples.Spin,vcl.Dialogs,libUser_U;

type
  TfrmGreeter = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    edtFName: TEdit;
    spnAge: TSpinEdit;
    lblFName: TLabel;
    lblAge: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    currentUser : TUser;
  end;

var
  frmGreeter: TfrmGreeter;

implementation

{$R *.dfm}

procedure TfrmGreeter.FormShow(Sender: TObject);
begin
  spnAge.Value := -1;
  spnAge.MinValue := 7;
  spnAge.MaxValue := 149;
  ShowMessage('Welcome ' + currentUser.Username + ', please enter your information here');
end;

// We should probably get the birthday and calculate the age using that instead
procedure TfrmGreeter.OKBtnClick(Sender: TObject);
const LETTERS = ['A'..'Z'] + [' '];
var
  sFullname : string;
  iAge : Integer;
  isCorrect,isValid,isLong,isAgeValid : Boolean;
  i,iConf: Integer;
begin
  if edtFName.Text = '' then
  begin
    ShowMessage('Please enter your full name');
    Exit;
  end;
  sFullname := edtFName.Text;
  sFullname.Trim;
  for i := 1 to sFullname.Length do
  begin
    if not (UpperCase(sFullname)[i] in LETTERS) then
      isValid := False;
  end;
  if (sFullname.Length < 2) and (sFullname.Length > 15) then
  isLong := false;

  isAgeValid := iAge <> -1;

  if not isAgeValid then
   ShowMessage('Please enter a valid age');
  if not isValid then
   ShowMessage('Your name can only contain letters');
  if not isLong then
   ShowMessage('Your full name must be between 2 and 15 characters in length');

  isCorrect := isLong and isValid and isAgeValid;

  if isCorrect then
  begin
    iConf := MessageDlg(
      'Are you sure about these details?',
      mtConfirmation,
      mbYesNo,
      0
    );
    if iConf = mrYes then
    begin
      currentUser.SaveUserInfo(sFullname,iAge);
      ShowMessage('Welcome to ' + Application.Name + '!');
    end else self.ModalResult := mrNone;
  end else self.ModalResult := mrNone;
end;

end.
