unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dash,AdminDash, {App,} dmBase, lib;

type
  TfrmLogin = class(TForm)
    edtUser: TEdit;
    edtPassword: TEdit;
    pnlCenter: TPanel;
    btnLogin: TButton;
    btnCancel: TButton;
    pnlFooter: TPanel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

    function CheckAdmin(userString : string) : boolean;
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

  passFileExists := CheckFile(filename);
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
