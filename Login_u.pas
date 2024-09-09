unit Login_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Dashboard_U,Admin_U, conDBBites, User_u, Utils_U;

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
    currentUser : TUser;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnCancelClick(Sender: TObject);
var
  LoginForm : TfrmLogin;
begin
  LoginForm.visible := false;
  currentUser.Create('','',false,false);
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
const
  FILENAME = '.passwords';
var
  sUsername,sPassword : string;
  isCorrect,isValid,passFileExists : boolean;
begin
  sUsername := edtUser.Text;
  sPassword := edtPassword.Text;

  // Call the constructor, (username,password,is new user,are they loggin in)
  currentUser := TUser.Create(sUsername.Trim,sPassword.Trim,False);
end;

procedure TfrmLogin.btnSignUpClick(Sender: TObject);
var
  confirm : integer;
  sUsername,sPassword:string;
begin
  sUsername := edtUser.text;
  sPassword := edtPassword.text;
  currentUser := TUser.Create(sUsername.Trim,sPassword.Trim,true,False);
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
  edtUser.SetFocus;

end;

end.

