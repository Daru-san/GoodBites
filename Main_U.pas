unit Main_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Login_u,
  Vcl.Grids, Dashboard_U,Admin_U,User_u,Helpform, Vcl.Imaging.pngimage;

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
    currentUser : TUser;
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
  LoginForm : TfrmLogin;
  DashForm : TfrmDashboard;
  AdminForm : TfrmAdmin;
  didLogin,isAdmin,LoginCancelled : boolean;
begin
  Application.Initialize;
  LoginForm := TfrmLogin.Create(nil);
  Self.Hide;
  try
    LoginForm.ShowModal;

    //Obtain the currently logged in user from the login form, all data is filled in the object if login was successful
    currentUser := LoginForm.currentUser;
    isAdmin := currentUser.isAdmin;
    didLogin := currentUser.CheckLogIn;
  finally
    LoginForm.Free;
    if didLogin then
    begin
      if (not isAdmin) then
      begin
        Application.CreateForm(TfrmDashboard,DashForm);
        try
          DashForm.currentUser := currentUser;
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
        Application.CreateForm(TfrmAdmin,AdminForm);
        try
          AdminForm.currentAdmin := currentUser;
          AdminForm.ShowModal;
          self.Hide;
        finally
          AdminForm.Free;
          Self.Visible := true;
        end;
      end;
    end;

    //Free current user if login was somehow unsuccessful or new user was created
    if not didLogin then
    begin
      currentUser.Free;
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
