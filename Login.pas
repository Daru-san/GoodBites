unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dash,AdminDash, conDBBites, UserMod, Utils;

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

  passFileExists := TUtils.Create.CheckFileExists(filename);
  isValid := TUsers.Create.ValidPass(userString,passString);

  if (isValid and passFileExists) then
  begin
    isCorrect := TUsers.Create.CheckPass(userString,passString,FILENAME);
    if isCorrect then
    begin
      TUsers.Create.SaveLastLogin(userString);
      isAdmin := TUsers.Create.CheckAdmin(userString);
      isLoggedIn := true;
      if isAdmin then
        TUtils.Create.WriteUserLog('Administrator ' + userString + ' logged in.')
      else
        TUtils.Create.WriteUserLog('User ' + userString + ' logged in.');
    end
    else
    begin
      ShowMessage('The username or password are incorrect');
      TUtils.Create.WriteUserLog('Failed login attempt by user ' + userString);
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
  TUsers.Create.CreateUser(userString,passString);
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

