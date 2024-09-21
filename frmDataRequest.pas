unit frmDataRequest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent,Utils_U;

type
  TfrmFetcher = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPRequest1: TNetHTTPRequest;
  private
    { Private declarations }
    function GetApiKey : string;
  public
    { Public declarations }
    function GetJsonData(sQuery:string) : string;
  end;

var
  frmFetcher: TfrmFetcher;
  Utils : TUtils;

implementation

function TfrmFetcher.GetJsonData(sQuery:string): string;
var urlString,api_key,sResult : string;
begin
  api_key := GetApiKey;
  urlString := 'https://api.nal.usda.gov/fdc/v1/foods/search?api_key='+api_key+'&query='+sQuery;

  //TODO: Format query
  NetHTTPRequest1.Post(urlString,sResult);

  // Do something on failure
  if sResult = '' then
  else
    Result := sResult;

end;

function TfrmFetcher.GetApiKey : string;
const FILENAME = 'files/api_key.txt';
var keyFile : textfile;
begin
  Utils := TUtils.Create;

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
