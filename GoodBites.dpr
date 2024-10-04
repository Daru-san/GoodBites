program GoodBites;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

uses
  {$IFNDEF FPC}
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  {$ENDIF }
  conDB in 'conDB.pas' {dmData: TDataModule},
  frmAddFood_U in 'frmAddFood_U.pas' {frmAddFood},
  frmAdmin_U in 'frmAdmin_U.pas' {frmAdmin},
  frmDashboard_U in 'frmDashboard_U.pas' {frmDashboard},
  frmHelp_U in 'frmHelp_U.pas' {frmHelp},
  frmApp_U in 'frmApp_U.pas' {frmApp},
  frmLogin_U in 'frmLogin_U.pas' {frmLogin},
  libUtils_U in 'libUtils_U.pas',
  libUser_U in 'libUser_U.pas',
  libMeals_U in 'libMeals_U.pas',
  libFetchAPI_U in 'libFetchAPI_U.pas',
  frmSettings_U in 'frmSettings_U.pas' {frmSettings},
  libGoals_U in 'libGoals_U.pas',
  frmGreeter_U in 'frmGreeter_U.pas' {frmGreeter},
  OKCANCL2 in 'Inherited\OKCANCL2.PAS' {OKRightDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Material Oxford Blue');
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmAddFood, frmAddFood);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmGreeter, frmGreeter);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.Run;

end.
