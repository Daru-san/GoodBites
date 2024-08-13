unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dash,AdminDash, {App,} dmBase, UserMod, Utils;

type
  TfrmLogin = class(TForm)
    edtUser: TEdit;
    edtPassword: TEdit;
    pnlCenter: TPanel;
    btnLogin: TButton;
    btnCancel: TButton;
    pnlFooter: TPanel;
    btnSignUp: TButton;
    pnlHead: TPanel;
    lblHead: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    function CheckAdmin(userString : string) : boolean;
    procedure btnSignUpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    isLoggedIn,isAdmin,isCancelled : boolean;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnCancelClick(Sender: TObject);
var
  LoginForm : TfrmLogin;
begin
  isCancelled := true;
  LoginForm.visible := false;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
const
  FILENAME = '.passwords';
var
  userString,passString : string;
  isCorrect,isValid,passFileExists : boolean;
begin
  userString := edtUser.Text;
  passString := edtPassword.Text;

  passFileExists := CheckFileExists(filename);
  isValid := ValidPass(userString,passString);

  if (isValid and passFileExists) then
  begin
    isCorrect := CheckPass(userString,passString,FILENAME);
    if isCorrect then
    begin
      isAdmin := CheckAdmin(userString);
      isLoggedIn := true;
      WriteLog('User ' + userString + ' logged in.' + 'Is admin? ' + isAdmin.ToString);
    end
    else
    begin
      ShowMessage('The username or password are incorrect');
      WriteLog('Failed login attempt by user ' + userString);
    end;
  end else
    ShowMessage('Invalid data');;
end;

procedure TfrmLogin.btnSignUpClick(Sender: TObject);
var
  confirm : integer;
  userString,passString:string;
begin
  userString := edtUser.text;
  passString := edtPassword.text;
  CreateUser(userString,passString);
end;

// Message dialog
function TfrmLogin.CheckAdmin(userString : string) : boolean;
var
  isAdmin,isFound : boolean;
begin
  isAdmin := false;
  isFound := false;
  with dmBase.dmData do
  begin
    tblUsers.open;
    tblUsers.First;
    repeat
    if UPPERCASE(tblUsers['Username']) = UPPERCASE(userString) then
    begin
      isFound := true;
      if tblUsers['isAdmin'] then isAdmin := true;
    end;
      tblUsers.next;
    until (tblUsers.EOF or isFound);
    tblUsers.Close;
  end;
  CheckAdmin := isAdmin;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  with lblHead do
  begin
    Caption := 'Login or create account';
    Font.Name := 'Noto Sans';
    AutoSize := true;
    font.Style := [fsBold];
    Alignment := taCenter;
  end;

end;

end.

