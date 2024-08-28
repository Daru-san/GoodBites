program GoodBites;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  {$IFnDEF FPC}
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  {$ELSE}
  {$ENDIF }
  App in 'App.pas' {frmApp},
  Login in 'Login.pas' {frmLogin},
  Dash in 'Dash.pas' {frmDashboard},
  AdminDash in 'AdminDash.pas' {frmAdmin},
  conDBBites in 'conDBBites.pas' {dbmData: TDataModule},
  InfoBoard in 'InfoBoard.pas' {frmInfo},
  UserMod in 'UserMod.pas',
  DataFetcher in 'DataFetcher.pas',
  Utils in 'Utils.pas',
  HelpForm in 'HelpForm.pas' {frmHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Material Oxford Blue SE');
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TdbmData, dbmData);
  Application.CreateForm(TfrmInfo, frmInfo);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.Run;
end.
