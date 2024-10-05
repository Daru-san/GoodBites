unit frmSettings_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, OKCANCL2, Vcl.StdCtrls, Vcl.ExtCtrls, libUser_U,libUtils_U,
  Vcl.NumberBox, Vcl.Mask, Vcl.Samples.Spin;

type
  TfrmSettings = class(TOKRightDlg)
    pnlSide: TPanel;
    LabeledEdit1: TLabeledEdit;
    nbxWeight: TNumberBox;
    nbxHeight: TNumberBox;
    lblHeight: TLabel;
    lblWeight: TLabel;
    spnAge: TSpinEdit;
    lblAge: TLabel;
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
  ControlUtils : TControlUtils;

implementation

{$R *.dfm}

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  inherited;
  ControlUtils := TControlUtils.Create;
  ControlUtils.SetNumberBox(nbxHeight,30,200);
  ControlUtils.SetNumberBox(nbxWeight,20,1000);
end;

end.
