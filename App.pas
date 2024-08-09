unit App;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Login, dmBase,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Dash,AdminDash;

type
  TfrmApp = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeading: TLabel;
    btnLogin: TButton;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}


// TODO: Iron out login issues
procedure TfrmApp.btnLoginClick(Sender: TObject);
var
  LoginForm : Login.TfrmLogin;
  DashForm : Dash.TfrmDashboard;
  AdminForm : AdminDash.TfrmAdmin;
  didLogin,isAdmin,LoginCancelled : boolean;
begin
  Application.Initialize;
  LoginForm := TfrmLogin.Create(nil);
  Self.Visible := false;
  try
    LoginForm.ShowModal;
    didLogin := LoginForm.IsLoggedIn;
    isAdmin := LoginForm.isAdmin;
    LoginCancelled := LoginForm.isCancelled;
    ShowMessage(
      'Logged in?'+#9 + didLogin.ToString + #13
      + 'Is admin?'+#9 + isAdmin.toString + #13
      +  'Login cancelled?' + LoginCancelled.toString
    );
  finally
  begin
    if LoginCancelled then
    self.Visible := true;
    if didLogin or LoginCancelled then
    begin
      LoginForm.Free;
    end;
  end;
  end;

  if (didLogin and (not isAdmin)) then
  begin
    Application.CreateForm(Dash.TfrmDashboard,DashForm);
  end
  else
  if (didLogin and isAdmin) then
  begin
    Application.CreateForm(AdminDash.TfrmAdmin,AdminForm);
  end;
  Application.Run;
  LoginForm.Visible := true;
end;

end.
