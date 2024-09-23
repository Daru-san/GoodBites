unit frmDataRequest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent,Utils_U,Net.Mime;

type
  TfrmFetcher = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPRequest1: TNetHTTPRequest;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetApiKey : string;
  public
    { Public declarations }
    function SendQuery(sQuery:string;dataType:string = 'Foundation'):string;
  end;

var
  frmFetcher: TfrmFetcher;
  Utils : TUtils;
  logger : TLogs;

implementation

function TfrmFetcher.SendQuery;
var
  urlString,api_key : string;
  Params : TStringStream;
begin
  NetHTTPClient1.ContentType := 'application/json';
  NetHTTPClient1.AcceptEncoding := 'UTF-8';

  api_key := GetApiKey;

  Params := TStringStream.Create(
    '{"query":"'+sQuery+'","pageSize":10,"dataType": ["'+dataType+'"]}',
    TEncoding.UTF8
  );

  Result := NetHTTPRequest1.Post(
    'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=' + api_key,Params
  ).ContentAsString(TEncoding.UTF8);
  Params.Free;
end;

procedure TfrmFetcher.FormCreate(Sender: TObject);
begin
  NetHTTPRequest1.Client := NetHTTPClient1;
end;

function TfrmFetcher.GetApiKey : string;
const FILENAME = 'files\api_key.txt';
var keyFile : textfile;
begin
  Utils := TUtils.Create;
  logger := TLogs.Create;

  if Utils.CheckFileExists(FILENAME) then
  try
    AssignFile(keyFile,FILENAME);
    Reset(keyFile);
    Readln(keyFile,Result);
  finally
    CloseFile(keyFile);
  end;

end;


{$R *.dfm}

end.
