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
  frmApp_U in 'frmApp_U.pas' {frmApp},
  frmLogin_U in 'frmLogin_U.pas' {frmLogin},
  libUtils_U in 'libUtils_U.pas',
  libUser_U in 'libUser_U.pas',
  libMeals_U in 'libMeals_U.pas',
  libFetchAPI_U in 'libFetchAPI_U.pas',
  libGoals_U in 'libGoals_U.pas',
  frmWelcome_U in 'frmWelcome_U.pas' {frmWelcome},
  OKCANCL2 in 'Inherited\OKCANCL2.PAS' {OKRightDlg},
  frmCustomFood_U in 'frmCustomFood_U.pas' {frmCustomFood},
  frmSettings_U in 'frmSettings_U.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Goodbites';
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmAddFood, frmAddFood);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmWelcome, frmWelcome);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.CreateForm(TfrmCustomFood, frmCustomFood);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;

end.
