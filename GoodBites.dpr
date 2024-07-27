program GoodBites;

uses
  Vcl.Forms,
  App in 'App.pas' {frmApp},
  Login in 'Login.pas' {frmLogin},
  Dash in 'Dash.pas' {frmDashboard};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.Run;
end.
