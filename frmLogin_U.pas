unit frmLogin_U;
{ Provides the login screen for users and creates the `currentUser` object in memory,
 from there the object is passed between units as needed }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, libUser_U,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.Menus, Vcl.ExtActns, System.Actions,
  Vcl.ActnList, Vcl.Mask, Vcl.WinXPanels,StrUtils, System.ImageList, Vcl.ImgList;

type
  TfrmLogin = class(TForm)
    btnLogin: TButton;
    btnGoSignUp: TButton;
    edtUser: TLabeledEdit;
    edtPassword: TLabeledEdit;
    pnlLogin: TPanel;
    crplLogin: TCardPanel;
    crdLogin: TCard;
    crdSign: TCard;
    lblNew: TLabel;
    edtNewPassword: TLabeledEdit;
    edtNewPassConf: TLabeledEdit;
    edtNewUser: TLabeledEdit;
    btnCreate: TButton;
    cbxTerms: TCheckBox;
    lblCreate: TLabel;
    btnGoLogin: TButton;
    pnlGoSignup: TPanel;
    pnlNewUser: TPanel;
    pnlNewSub: TPanel;
    cbxReveal: TCheckBox;
    pnlLoginCenter: TPanel;
    pnlLoginTop: TPanel;
    pnlSignUpTop: TPanel;
    pnlSignUpCenter: TPanel;
    pnlLoginHead: TPanel;
    btnHome: TButton;
    procedure btnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGoSignUpClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure edtUserChange(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
    procedure edtNewUserChange(Sender: TObject);
    procedure edtNewPasswordChange(Sender: TObject);
    procedure edtNewPassConfChange(Sender: TObject);
    procedure cbxTermsClick(Sender: TObject);
    procedure btnGoLoginClick(Sender: TObject);
    procedure edtUserKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure cbxRevealClick(Sender: TObject);
    procedure tbtHomeClick(Sender: TObject);
    procedure crdLoginEnter(Sender: TObject);
    procedure crdSignEnter(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
  private
    { Private declarations }
    FLoginUser : TUser;

    procedure CheckFields(pState : String = 'Login');
  public
    { Public declarations }
    property LoginUser : TUser read FLoginUser write FLoginUser;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnGoLoginClick(Sender: TObject);
begin
  // Move to login card
  crplLogin.ActiveCard := crdLogin;

  // Reset the sign up card so when a user re-enters it
  // it will be clear of any data
  edtNewUser.Text := '';
  edtNewPassword.Text := '';
  edtNewPassConf.Text := '';
  cbxTerms.Checked := false;
  btnCreate.Enabled := false;
  edtNewPassword.PasswordChar := CharLower('*');
  edtNewPassword.PasswordChar := CharLower('*');
  edtNewPassword.Enabled := false;
  edtNewPassConf.Enabled := false;
  cbxReveal.Checked := false;
end;

procedure TfrmLogin.btnGoSignUpClick(Sender: TObject);
begin
  // Move to sign up card
  crplLogin.ActiveCard := crdSign;

  // Reset the login card
  edtUser.Text := '';
  edtPassword.Text := '';
  btnLogin.Enabled := false;
end;

procedure TfrmLogin.btnHomeClick(Sender: TObject);
begin
  self.ModalResult := mrClose;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  sUsername,sPassword : string;
begin
  sUsername := edtUser.Text;
  sPassword := edtPassword.Text;

  // Call the constructor
  LoginUser := TUser.Create(sUsername);
  LoginUser.Login(sPassword);

  // Closes the form when login is successful using modalresult
  // Closing manually using self.Close() does not work properly
  // so this is the best approach to use
  if LoginUser.CheckLogin then
    self.ModalResult := mrOk
  else
  begin
    self.ModalResult := mrNone;
    LoginUser.Free;
  end;
end;

procedure TfrmLogin.cbxRevealClick(Sender: TObject);
begin
  //Show password when checking the box
  if cbxReveal.Checked then
  begin
    edtNewPassword.PasswordChar := #0;
    edtNewPassConf.PasswordChar := #0;
  end
  else
  begin
    edtNewPassword.PasswordChar := CharLower('*');
    edtNewPassConf.PasswordChar := CharLower('*');
  end;
end;

// Checking the sign up fields to ensure that they have all been filled
procedure TfrmLogin.cbxTermsClick(Sender: TObject);
begin
  CheckFields('Signup');
end;

procedure TfrmLogin.edtNewPassConfChange(Sender: TObject);
begin
  CheckFields('Signup');
end;

procedure TfrmLogin.edtNewPasswordChange(Sender: TObject);
begin
  CheckFields('Signup');
end;

procedure TfrmLogin.edtNewUserChange(Sender: TObject);
begin
  CheckFields('Signup');
end;

// Ensuring that the login fields have been filled
procedure TfrmLogin.edtPasswordChange(Sender: TObject);
begin
  CheckFields('Login');
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFields('Login');
end;

procedure TfrmLogin.edtUserChange(Sender: TObject);
begin
  CheckFields('Login');
end;

procedure TfrmLogin.edtUserKeyPress(Sender: TObject; var Key: Char);
begin
  CheckFields('Login');
end;

procedure TfrmLogin.btnCreateClick(Sender: TObject);
var
  sUsername,sPassword,sPassConf:string;
  isSuccessful : Boolean;
begin
  sUsername := edtNewUser.text;
  sPassword := edtNewPassword.text;
  sPassConf := edtNewPassConf.Text;

  // Password match validation
  if sPassword <> sPassConf then
  begin
    ShowMessage('Passwords do not match');
    edtNewPassConf.Color := clRed;
    edtNewPassConf.SetFocus;
    exit;
  end;

  // We attempt to create the user
  // and sign them up, if a false is returned
  // we do not login
  LoginUser := TUser.Create(sUsername);
  isSuccessful := LoginUser.SignUp(sPassword);
  LoginUser.Free;

  // If the login is successful,
  // we recreate the object and call the login procedure
  if isSuccessful then
  begin
    LoginUser := TUser.Create(sUsername);
    LoginUser.Login(sPassword);
    self.ModalResult := mrOk;
  end;
end;

procedure TfrmLogin.CheckFields;
begin
  { Only enable certain elements when the other fields are active }
  case IndexStr(LowerCase(pState),['login','signup']) of
  0: begin
        if (edtUser.Text <> '') and (edtPassword.Text <> '') then
          btnLogin.Enabled := true
      else
        btnLogin.Enabled := false;
    end;
  1: begin
      if edtNewUser.Text <> '' then
      begin
        edtNewPassword.Enabled := true;
        cbxReveal.Enabled := true;
        if (edtNewUser.Text <> '') and (edtNewPassword.Text <> '') then
        begin
          edtNewPassConf.Enabled := true;
          if (edtNewPassword.Text <> '') and (edtNewPassConf.Text <> '') then
          begin
            cbxTerms.Enabled := true;
            if cbxTerms.Checked then
              btnCreate.Enabled := true
            else
              btnCreate.Enabled := false;
          end
          else
          begin
            cbxTerms.Enabled := false;
            btnCreate.Enabled := false;
          end;
        end
        else
          edtNewPassConf.Enabled := false;
      end;
    end;
  end;
end;

// Focusing the edit boxes based on the current card
procedure TfrmLogin.crdLoginEnter(Sender: TObject);
begin
  edtUser.SetFocus;
end;

procedure TfrmLogin.crdSignEnter(Sender: TObject);
begin
  edtNewUser.SetFocus;
end;

// Start at login
procedure TfrmLogin.FormShow(Sender: TObject);
begin
 crplLogin.ActiveCard := crdLogin;
end;
procedure TfrmLogin.tbtHomeClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;
end.
