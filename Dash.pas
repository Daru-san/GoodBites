unit Dash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,InfoBoard,Utils,user;

type
  TfrmDashboard = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    pnlProgress: TPanel;
    lblHeading: TLabel;
    pnlNav: TPanel;
    Label1: TLabel;
    pnlFoot: TPanel;
    btnLogOut: TButton;
    pnlInfo: TPanel;
    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure pnlInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    userObj : TUser;
  end;

var
  frmDashboard: TfrmDashboard;
  username : string;

implementation

{$R *.dfm}

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  // Get closing to work properly
  Application.MainForm.Visible := true;
  frmDashboard.Close;
  frmDashboard.Destroy;
  userObj.Free;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblHeading,'Dashboard',15);
  username := userObj.GetUser;
end;
procedure TfrmDashboard.pnlInfoClick(Sender: TObject);
var
  infoForm : InfoBoard.TfrmInfo;
begin
 infoForm := TfrmInfo.Create(nil);
 try
  infoForm.ShowModal;
  self.hide;
 finally
   infoForm.Free;
//   Self.Show;
 end;

end;

end.
