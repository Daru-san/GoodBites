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
  Main_U in 'Main_U.pas' {frmApp},
  Login_u in 'Login_u.pas' {frmLogin},
  Dashboard_U in 'Dashboard_U.pas' {frmDashboard},
  Admin_U in 'Admin_U.pas' {frmAdmin},
  conDBBites in 'conDBBites.pas' {dbmData: TDataModule},
  InfoBoard in 'InfoBoard.pas' {frmInfo},
  User_u in 'User_u.pas',
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
