unit InfoBoard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, OpenAI, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,Utils;

type
  TfrmInfo = class(TForm)
    pnlCenter: TPanel;
    pnlTop: TPanel;
    lblHeader: TLabel;
    redText: TRichEdit;
    pnlFoot: TPanel;
    btnLoad: TButton;
    cbxNutrients: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInfo: TfrmInfo;

implementation

{$R *.dfm}

procedure TfrmInfo.btnLoadClick(Sender: TObject);
var
  nutrientName : string;
begin

  nutrientName := cbxNutrients.text;
  if cbxNutrients.ItemIndex < 0 then
  LoadData(nutrientName)
  else
    ShowMessage('Please select an option');

end;

procedure TfrmInfo.FormShow(Sender: TObject);
begin
  SetLabel(lblHeader,'About nutrients');
end;

end.
