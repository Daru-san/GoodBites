program GoodBites;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  {$IFNDEF FPC}
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  {$ELSE}
  {$ENDIF }
  Main_U in 'Main_U.pas' {frmApp},
  Login_u in 'Login_u.pas' {frmLogin},
  Dashboard_U in 'Dashboard_U.pas' {frmDashboard},
  Admin_U in 'Admin_U.pas' {frmAdmin},
  InfoBoard in 'InfoBoard.pas' {frmInfo},
  User_U in 'User_U.pas',
  Utils_U in 'Utils_U.pas',
  HelpForm in 'HelpForm.pas' {frmHelp},
  Meals_U in 'Meals_U.pas',
  frmGreeter_U in 'frmGreeter_U.pas' {frmGreeter},
  frmDataRequest in 'frmDataRequest.pas' {frmFetcher},
  conDB in 'conDB.pas' {dmData: TDataModule},
  OKCANCL2 in 'c:\program files (x86)\embarcadero\studio\23.0\ObjRepos\EN\DelphiWin32\OKCANCL2.PAS' {OKRightDlg},
  frmAddFood_U in 'frmAddFood_U.pas' {frmAddFood};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Material Oxford Blue SE');
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmInfo, frmInfo);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmGreeter, frmGreeter);
  Application.CreateForm(TfrmFetcher, frmFetcher);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmAddFood, frmAddFood);
  Application.Run;

end.
