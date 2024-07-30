unit AdminDash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, dmBase,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAdmin = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    pnlBody: TPanel;
    pnlFooter: TPanel;
    dbgUsers: TDBGrid;
    lblUsers: TLabel;
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

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  dbgUsers.DataSource := dmBase.dmData.dscUsers;
end;

end.
