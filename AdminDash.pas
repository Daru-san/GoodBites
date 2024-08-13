unit AdminDash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, dmBase,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmAdmin = class(TForm)
    TabControl1: TTabControl;
    pnlFooter: TPanel;
    btnLogout: TButton;
    dbgUsers: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

// TODO: Plot administator navigation

// Logging out
procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  Application.ShowMainForm := true;
  Self.CloseModal;
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
 // dbgUsers.DataSource := dmBase.dmData.dscUsers;
end;

end.
