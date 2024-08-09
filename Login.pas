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
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    function CheckAdmin(userString : string) : boolean;
    procedure btnSignUpClick(Sender: TObject);
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
    end
    else
    begin
      ShowMessage('The username or password are incorrect');
    end;
  end;
end;

procedure TfrmLogin.btnSignUpClick(Sender: TObject);
var
  confirm : integer;
  userString,passString:string;
begin
  userString := InputBox('Goodbites: Account Creation','Enter a username','');
  passString := InputBox('Goodbites: Account Creation','Enter a password','');
  CreateUser(userString,passString);
end;

// Message dialog
function TfrmLogin.CheckAdmin(userString : string) : boolean;
var
  isAdmin : boolean;
begin
  isAdmin := false;
  with dmBase.dmData do
  begin
    tblUsers.Append;
    repeat
      if tblUsers['isAdmin'] then
        isAdmin := true;
      tblUsers.next;
    until (tblUsers.eof);
  end;
  CheckAdmin := isAdmin;
end;

end.
