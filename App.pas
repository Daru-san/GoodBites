unit App;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Login, conDBBites,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Dash,AdminDash,Helpform, Vcl.Imaging.pngimage;

type
  TfrmApp = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeading: TLabel;
    btnLogin: TButton;
    btnHelp: TButton;
    pnlFoot: TPanel;
    btnExit: TButton;
    imgCenter: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}

procedure TfrmApp.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmApp.btnHelpClick(Sender: TObject);
var
  HelperForm : Helpform.TfrmHelp;
begin
  HelperForm := TfrmHelp.Create(nil);
  Self.Visible := false;
  try
    HelperForm.ShowModal;
  finally
    HelperForm.Free;
  end;
end;

procedure TfrmApp.btnLoginClick(Sender: TObject);
var
  LoginForm : Login.TfrmLogin;
  DashForm : Dash.TfrmDashboard;
  AdminForm : AdminDash.TfrmAdmin;
  didLogin,isAdmin,LoginCancelled : boolean;
begin
  Application.Initialize;
  LoginForm := TfrmLogin.Create(nil);
  Self.Hide;
  try
    LoginForm.ShowModal;
    didLogin := LoginForm.IsLoggedIn;
    isAdmin := LoginForm.isAdmin;
    LoginCancelled := LoginForm.isCancelled;
   { ShowMessage(
      'Logged in?'+#9 + didLogin.ToString + #13
      + 'Is admin?'+#9 + isAdmin.toString + #13
      +  'Login cancelled?' + LoginCancelled.toString
    ); }
  finally
  //TODO: Do something about form closing and switching
    LoginForm.Free;
    if didLogin then
    begin
      if (not isAdmin) then
      begin
        Application.CreateForm(Dash.TfrmDashboard,DashForm);
        try
          DashForm.ShowModal;
          Self.Hide;
        finally
          DashForm.free;
          Self.Visible := true;
        end;
      end
        else
      if isAdmin then
      begin
        Application.CreateForm(AdminDash.TfrmAdmin,AdminForm);
        try
          AdminForm.ShowModal;
          self.Hide;
        finally
          AdminForm.Free;
          Self.Visible := true;
        end;
      end;
    end;
    Application.Run;
  end;
end;

procedure TfrmApp.FormShow(Sender: TObject);
begin
  btnLogin.SetFocus;
 // imgCenter.Picture.LoadFromFile('image.png');
  imgCenter.Stretch := true;
end;

end.
