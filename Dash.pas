unit Dash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmDashboard = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    pnlProgress: TPanel;
    lblHeading: TLabel;
    pnlNav: TPanel;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDashboard: TfrmDashboard;

implementation

{$R *.dfm}

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
  lblHeading.Font.Size := 15;
  lblHeading.Font.Name := 'NotoSans';
end;

end.
