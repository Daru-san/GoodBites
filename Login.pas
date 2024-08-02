unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dash,AdminDash, {App,} dmBase;

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

    procedure CheckFile(filename:string);
    procedure OpenForm(isAdmin : boolean);

    function CheckPass(userString,passString,filename: string): boolean;
    function CheckAdmin(userString : string) : boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnCancelClick(Sender: TObject);
{var
  LoginForm : TfrmLogin;
  AppForm : App.TfrmApp;}
begin
  {with AppForm do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
  LoginForm.Close;  }

end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
const
  FILENAME = '.passwords';
var
  userString,passString : string;
  isCorrect, isAdmin : boolean;
begin
  userString := edtUser.Text;
  passString := edtPassword.Text;

  isCorrect := CheckPass(userString,passString,FILENAME);
  if isCorrect then
  begin
    isAdmin := CheckAdmin(userString);
    OpenForm(isAdmin);
  end
  else
  begin
    ShowMessage('The username or password are incorrect');
    exit;
  end;
end;

procedure TfrmLogin.CheckFile(filename: string);
var
  passFile : textfile;
begin
  if not FileExists(filename) then
  begin
    AssignFile(passFile,filename);
    Rewrite(passFile);
  end;
end;
function TfrmLogin.CheckPass(userString: string; passString: string; filename: string): boolean;
var
  passFile : textfile;
  fileString, userFileString, userPassString, userInDatabase : string;
  isCorrect, isInDB : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);
  Append(passFile);
  Reset(passFile);

  isCorrect := false;
  isInDB := false;

  repeat
    ReadLn(passFile,fileString);
    delPos := pos(',',fileString);
    userFileString := copy(fileString,0,delPos);
    delete(fileString,0,delPos);
    userPassString := fileString;
    if ((userFileString = userString) and (userPassString = passString)) then
      isCorrect := true
      else isCorrect := false;
  until EOF(passFile);

  if isCorrect then
  with dmBase.dmData do
  begin
    tblUsers.Append;
    Repeat
      if tblUsers['Username'] = userString then
      begin
        isInDB := true;
        break;
      end;
      tblUsers.Next;
    Until tblUsers.eof;
  end;
  if not isInDB then
  begin
    ShowMessage(
          'The user ' + userString
          + ' has a password but is not present in the database'
          + #13 + 'Are you sure they are registered?'
    );
    isCorrect := false;
  end;
  CheckPass := isCorrect;
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
// TODO: Make sure forms open and close properly
procedure TfrmLogin.OpenForm(isAdmin : boolean);
var
  DashForm : Dash.TfrmDashboard;
  LoginForm : TfrmLogin;
  AdminDashForm : AdminDash.TfrmAdmin;
begin
  if not isAdmin then
  with DashForm do
  begin;
    try
      ShowModal;
    finally
      Free;
    end;
  end
  else
  with AdminDashForm do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
  LoginForm.close;
end;

end.
