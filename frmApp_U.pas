unit frmApp_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, frmLogin_U,
  Vcl.Grids, frmDashboard_U,frmAdmin_U,libUser_U,frmHelp_U, Vcl.Imaging.pngimage,
  Vcl.WinXCtrls, Vcl.ButtonGroup,Math;

type
  TfrmApp = class(TForm)
    pnlCenter: TPanel;
    imgCenter: TImage;
    btnEnter: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure grpBtnItems1Click(Sender: TObject);
    procedure btnEnterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
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

procedure TfrmApp.btnEnterClick(Sender: TObject);
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
    if LoginForm.ModalResult = mrOk then
    begin
      currentUser := LoginForm.currentUser;
      didLogin := currentUser.CheckLogIn;
      isAdmin := currentUser.isAdmin;
    end else didLogin := false;
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
    Application.Run;
  end;
end;

procedure TfrmApp.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmApp.btnHelpClick(Sender: TObject);
var
  HelperForm : TfrmHelp;
begin
  HelperForm := TfrmHelp.Create(nil);
  Self.Visible := false;
  try
    HelperForm.ShowModal;
  finally
    HelperForm.Free;
  end;
end;


procedure TfrmApp.FormResize(Sender: TObject);
begin
  with self do
  begin
    btnEnter.Left := Ceil(Width/2);
    btnEnter.Top := Ceil(Height - Height/4);
  end;
end;

procedure TfrmApp.FormShow(Sender: TObject);
begin
  imgCenter.Picture.LoadFromFile('..\..\image.png');
  imgCenter.Stretch := true;
  self.FormResize(self);
end;

procedure TfrmApp.grpBtnItems1Click(Sender: TObject);
begin
  self.close;
end;

end.
