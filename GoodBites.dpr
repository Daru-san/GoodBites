program GoodBites;

uses
  Vcl.Forms,
  App in 'App.pas' {frmApp},
  Login in 'Login.pas' {frmLogin},
  Dash in 'Dash.pas' {frmDashboard},
  AdminDash in 'AdminDash.pas' {frmAdmin},
  dmBase in 'dmBase.pas' {dmData: TDataModule},
  InfoBoard in 'InfoBoard.pas' {frmInfo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmInfo, frmInfo);
  Application.Run;
end.
