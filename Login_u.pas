unit Login_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, User_u;

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
  self.ModalResult := mrCancel;

  // Create an empty user 
  // The object will return false upon checking login 
  // on the main form
  currentUser.Create('');
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

  // Call the constructor
  currentUser := TUser.Create(sUsername.Trim);
  currentUser.Login(sPassword.trim);

  // Closes the form when login is successful using modalresult
  // Closing manually using self.Close() does not work properly
  // so this is the best approach to use
  if currentUser.CheckLogin then
    self.ModalResult := mrOk
  else
  begin
    self.ModalResult := mrNone;
    currentUser.Free;
  end;
end;

procedure TfrmLogin.btnSignUpClick(Sender: TObject);
var
  confirm : integer;
  sUsername,sPassword:string;
begin
  sUsername := edtUser.text;
  sPassword := edtPassword.text;

  // Since the user is only created when signing up, the currentUser 
  // object is freed from memory immediately after account creation
  // The user signs up and logs in sequentially
  currentUser := TUser.Create(sUsername.Trim);
  currentUser.SignUp(sPassword.Trim);
  currentUser.Free;
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
