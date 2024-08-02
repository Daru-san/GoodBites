unit App;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Login, dmBase,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TfrmApp = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeading: TLabel;
    btnLogin: TButton;
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApp: TfrmApp;

implementation

{$R *.dfm}

// TODO: Show the login form when the button is pressed
// The error seems to persist somehow, research that
procedure TfrmApp.btnLoginClick(Sender: TObject);
var
  LoginForm : Login.TfrmLogin;
begin
  try
    LoginForm.Visible := true;
    self.Visible := false;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

end.
