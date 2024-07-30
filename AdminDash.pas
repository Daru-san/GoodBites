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
    procedure FormShow(Sender: TObject);
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
procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  dbgUsers.DataSource := dmBase.dmData.dscUsers;
  dbgData.DataSource := dmBase.dmData.dscData;
  lblData.font.Size := lblUsers.Font.Size;
end;

end.
