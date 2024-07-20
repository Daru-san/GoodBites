program GoodBites;

uses
  Vcl.Forms,
  App in 'App.pas' {frmApp},
  Login in 'Login.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApp, frmApp);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
