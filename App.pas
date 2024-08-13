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
    LoginForm.Free;
    if didLogin then
    begin
      if (not isAdmin) then
      begin
        Application.CreateForm(Dash.TfrmDashboard,DashForm);
        DashForm.Visible := true;
      end
        else
      if isAdmin then
      begin
        Application.CreateForm(AdminDash.TfrmAdmin,AdminForm);
        AdminForm.Visible := true;
      end;
      Application.ShowMainForm := false;
    end;
    Application.Run;
  end;
end;

end.
