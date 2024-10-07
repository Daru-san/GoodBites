unit frmApp_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, frmLogin_U, frmWelcome_U,
  frmDashboard_U,frmAdmin_U,libUser_U, Vcl.Imaging.pngimage,
  Vcl.WinXCtrls, Vcl.ButtonGroup,Math;

type
  TfrmApp = class(TForm)
    pnlCenter: TPanel;
    imgCenter: TImage;
    btnEnter: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnEnterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FAppUser : TUser;

    procedure ShowForms;
    procedure ShowDashboardForm;
    procedure ShowAdminForm;
    procedure ShowWelcomeForm;
  public
    { Public declarations }
    property AppUser : TUser read FAppUser write FAppUser;
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}

procedure TfrmApp.btnEnterClick(Sender: TObject);
var
  LoginForm : TfrmLogin;
  isLogin : boolean;
begin
  // We initialize the app
  // and disable MainFormOnTaskBar to show
  // all forms on the taskbar
  Application.Initialize;
  Self.Hide;
  Application.MainFormOnTaskBar := False;
  Application.CreateForm(TfrmLogin,LoginForm);
  try
    LoginForm.ShowModal;

    // This means the login was successful
    if LoginForm.ModalResult = mrOk then
    begin
      AppUser := LoginForm.LoginUser;
      isLogin := AppUser.CheckLogIn;
    end else isLogin := false;
  finally
    LoginForm.Free;
  end;
  if isLogin then
  ShowForms;

  Application.Run;
end;

procedure TfrmApp.ShowForms;
var
  isAdmin : Boolean;
  isNewUser : Boolean;
begin
  isAdmin := AppUser.isAdmin;
  isNewUser := AppUser.CheckFirstLogin;
  if isAdmin then
    ShowAdminForm
  else
  begin
    if isNewUser then
      ShowWelcomeForm
    else
      ShowDashboardForm;
  end;
end;

procedure TfrmApp.ShowAdminForm;
var
  AdminForm : TfrmAdmin;
begin
  Application.CreateForm(TfrmAdmin,AdminForm);
  with AdminForm do
  try
    AdminUser := AppUser;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmApp.ShowWelcomeForm;
var
  WelcomeForm : TfrmWelcome;
  isLoginComplete : Boolean;
begin
  Application.CreateForm(TfrmWelcome,WelcomeForm);
  with WelcomeForm do
  try
    CurrentUser := AppUser;
    ShowModal;
  finally
    isLoginComplete := ModalResult = mrYes;
    Free;
  end;
  if isLoginComplete then
    ShowDashboardForm;
end;

procedure TfrmApp.ShowDashboardForm;
var
  Dashboard : TfrmDashboard;
begin
  Application.CreateForm(TfrmDashboard,Dashboard);
  with Dashboard do
  try
    CurrentUser := AppUser;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmApp.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmApp.FormResize(Sender: TObject);
begin
  with pnlCenter do
  begin
    btnEnter.Left := Round(Width/2);
    btnEnter.Top := Round(Height - Height/4);
  end;
end;

procedure TfrmApp.FormShow(Sender: TObject);
begin
  imgCenter.Picture.LoadFromFile('..\..\image.png');
  imgCenter.Stretch := true;
  self.FormResize(self);
end;

end.
