unit InfoBoard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, OpenAI, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,Utils, DataFetcher;

type
  TfrmInfo = class(TForm)
    pnlCenter: TPanel;
    pnlTop: TPanel;
    lblHeader: TLabel;
    pnlFoot: TPanel;
    btnLoad: TButton;
    cbxNutrients: TComboBox;
    memInfo: TMemo;
    btnData: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure LoadData(nutrientIndex : integer; nutrientName: string);
    procedure SetIndices;
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
  nutrientIndex : integer;
begin

  nutrientIndex := cbxNutrients.ItemIndex;
  if cbxNutrients.ItemIndex < 0 then
  LoadData(nutrientIndex,nutrientName)
  else
    ShowMessage('Please select an option');
end;

procedure TfrmInfo.LoadData;
var
  tInfoFile : TextFile;
  fileString, fileText : string;
begin
  fileString := 'info\';
  case nutrientIndex of
    0 : fileString := fileString + 'carbs.txt';
    1 : fileString := fileString + 'fats.txt';
    2 : fileString := fileString + 'proteins.txt';
    3 : fileString := fileString + 'vits.txt';
  end;
  AssignFile(tInfoFile,fileString);
  if CheckFileExists(fileString) then
  begin
    memInfo.lines.clear;
    memInfo.Lines.Add('Information on ' + nutrientName);
    try
      Reset(tInfoFile);
      repeat
        Readln(tInfoFile,fileText);
        memInfo.Lines.Add(fileText);
      until EOf(tInfoFile);
    finally
      CloseFile(tInfoFile);
    end;
  end;
end;

procedure TfrmInfo.SetIndices;
begin
  with cbxNutrients do
  begin
    Items[0] := 'Carbohydrates';
    Items[1] := 'Fats';
    Items[2] := 'Proteins';
    Items[3] := 'Vitamins and Minerals';
  end;

end;
procedure TfrmInfo.FormShow(Sender: TObject);
begin
  SetLabel(lblHeader,'About nutrients');
  memInfo.ReadOnly := true;
end;

end.
