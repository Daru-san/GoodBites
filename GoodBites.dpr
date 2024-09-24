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
  frmGreeter_U in 'frmGreeter_U.pas' {frmGreeter},
  conDB in 'conDB.pas' {dmData: TDataModule},
  OKCANCL2 in 'c:\program files (x86)\embarcadero\studio\23.0\ObjRepos\EN\DelphiWin32\OKCANCL2.PAS' {OKRightDlg},
  frmAddFood_U in 'frmAddFood_U.pas' {frmAddFood},
  frmAdmin_U in 'frmAdmin_U.pas' {frmAdmin},
  frmDashboard_U in 'frmDashboard_U.pas' {frmDashboard},
  frmHelp_U in 'frmHelp_U.pas' {frmHelp},
  frmApp_U in 'frmApp_U.pas' {frmApp},
  frmLogin_U in 'frmLogin_U.pas' {frmLogin},
  libUtils_U in 'libUtils_U.pas',
  libUser_U in 'libUser_U.pas',
  libMeals_U in 'libMeals_U.pas',
  libFetchAPI_U in 'libFetchAPI_U.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Material Oxford Blue SE');
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmGreeter, frmGreeter);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmAddFood, frmAddFood);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;

end.
