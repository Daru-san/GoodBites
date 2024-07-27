unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dash;

type
  TfrmLogin = class(TForm)
    edtUser: TEdit;
    edtPassword: TEdit;
    pnlCenter: TPanel;
    btnLogin: TButton;
    procedure btnLoginClick(Sender: TObject);
    procedure CheckFile(filename:string);
    procedure OpenForm;
    function CheckPass(userString,passString,filename: string): boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

// TODO: Get usernames and user IDs from database
procedure TfrmLogin.btnLoginClick(Sender: TObject);
const
  FILENAME = '.passwords';
var
  userString,passString : string;
  isCorrect: boolean;
begin
  userString := edtUser.Text;
  passString := edtPassword.Text;

  isCorrect := CheckPass(userString,passString,FILENAME);
  if isCorrect then
  begin
    OpenForm;
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
  fileString, userFileString, userPassString : string;
  isCorrect : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);
  Append(passFile);
  Reset(passFile);

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
  CheckPass := isCorrect;
end;

// TODO: Make sure forms open and close properly
procedure TfrmLogin.OpenForm;
var
  DashForm : Dash.TfrmDashboard;
  LoginForm : TfrmLogin;
begin
  with DashForm do
  begin;
    try
      ShowModal;
    finally
      Free;
    end;
  end;
  LoginForm.Close;
end;

end.
