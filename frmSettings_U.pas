unit frmSettings_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.WinXPanels, Vcl.ToolWin, Vcl.ComCtrls,libUser_U;

type
  TfrmSettings = class(TForm)
    ToolBar1: TToolBar;
    crplSettings: TCardPanel;
    btnChangePass: TButton;
    crdMain: TCard;
    edtUser: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtName: TLabeledEdit;
    spnAge: TSpinEdit;
    lblAge: TLabel;
    btnUpdate: TButton;
    edtHeight: TLabeledEdit;
    ToolButton1: TToolButton;
    lblHead: TLabel;
    ToolButton2: TToolButton;
    crdPassChange: TCard;
    procedure btnChangePassClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCurrentUser : TUser;
  public
    { Public declarations }
    property CurrentUser : TUser read FCurrentUser write FCurrentUser;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.btnChangePassClick(Sender: TObject);
begin
  crplSettings.ActiveCard := crdPassChange;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  edtUser.Text := CurrentUser.Username;
end;

end.
