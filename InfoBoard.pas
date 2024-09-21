unit InfoBoard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, OpenAI, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls,conDB,Utils_U;

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
    procedure btnDataClick(Sender: TObject);
  private
    procedure SetIndices;
    function GetFileStr(nutrientIndex:integer):string;
    function GetNutrient:string;
    procedure LoadData(nutrientIndex : integer; nutrientName: string);
    { Private declarations }
  public
    { Public declarations }
    utilObj : TUtils;
    logObJ : TLogs;
  end;

var
  frmInfo: TfrmInfo;
  nutrientArr : array of string;

implementation

{$R *.dfm}


procedure TfrmInfo.btnDataClick(Sender: TObject);
var
  fileString : string;
  nutrientIndex : integer;
  nutrientName : string;
begin
  nutrientIndex := cbxNutrients.ItemIndex;
  nutrientName := GetNutrient;
  fileString := GetFileStr(nutrientIndex);
  if fileString.IsEmpty then
  exit;
  TDataFetcher.Create.FetchData(fileString,nutrientName);
end;

function TfrmInfo.GetNutrient;
var
  nutrientName : string;
  nutrientIndex : integer;
begin
  nutrientIndex := cbxNutrients.ItemIndex;
  if nutrientIndex <= -1 then
  begin
    nutrientName := '';
    getNutrient := nutrientName;
  end
  else
  begin
    nutrientName := GetNutrient;
    if nutrientName.IsEmpty then
    exit else GetNutrient := nutrientName;
  end;
end;

function TfrmInfo.GetFileStr;
var
  fileString : string;
begin
  if nutrientIndex <= -1 then
  begin
    ShowMessage('Please select an option');
    fileString := '';
    GetFileStr := '';
    exit;
  end else
  begin
    fileString := 'info\';
    case nutrientIndex of
      0 : fileString := fileString + 'carbs.txt';
      1 : fileString := fileString + 'fibre.txt';
      2 : fileString := fileString + 'proteins.txt';
      3 : fileString := fileString + 'fats.txt';
      4 : fileString := fileString + 'vits.txt';
    end;
  end;
  if not utilObj.CheckFileExists(fileString) then
  begin
    ShowMessage('An unknown error occured, please contact an administrator');
    logObj.WriteErrorLog('The file ' + fileString + ' was needed but not found');
    fileString := '';
  end else
  GetFileStr := fileString;
end;

procedure TfrmInfo.btnLoadClick(Sender: TObject);
var
  nutrientName : string;
  nutrientIndex : integer;
begin
  nutrientName := GetNutrient;
  nutrientIndex := cbxNutrients.ItemIndex;
  if cbxNutrients.ItemIndex > -1 then
    LoadData(nutrientIndex,nutrientName)
  else
  begin
    ShowMessage('Please select an option');
  end;
end;

procedure TfrmInfo.LoadData;
var
  tInfoFile : TextFile;
  fileString, fileText : string;
begin
  nutrientName := GetNutrient;
  fileString := GetFileStr(nutrientIndex);
  if fileString.IsEmpty then
  exit;

  AssignFile(tInfoFile,fileString);
  if utilObj.CheckFileExists(fileString) then
  begin
  //TODO: Get markdown rendering done
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
  end else ShowMessage('An unkown error has occured, please ask an administrator to check on the issue');
end;

procedure TfrmInfo.SetIndices;
var
  I: Integer;
begin
 { with cbxNutrients do
  begin
    with dbmData.tblNutrients do
    begin
      Open;
      First;
      repeat
        inc(i);
        Items.Add(FieldValues['NutrientName']);
        Next;
      until eof;
      Close;
    end;
  end;     }
end;
procedure TfrmInfo.FormShow(Sender: TObject);
begin
  memInfo.ReadOnly := true;
  SetIndices;
  utilObj := TUtils.Create;
  logObJ := TLogs.Create;
  utilObj.SetLabel(lblHeader,'About nutrients',15);
end;

end.
