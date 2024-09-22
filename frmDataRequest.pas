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
    function FormatQuery(sQuery:String):string;
  public
    { Public declarations }
    function GetJsonData(sQuery:string) : string;
  end;

var
  frmFetcher: TfrmFetcher;
  Utils : TUtils;

implementation

function TfrmFetcher.GetJsonData(sQuery:string): string;
var urlString,api_key,sResult,finalQuery : string;
begin
  api_key := GetApiKey;

  finalQuery := FormatQuery(sQuery);

  urlString := 'https://api.nal.usda.gov/fdc/v1/foods/search?api_key='+api_key+'&query='+finalQuery;

  NetHTTPRequest1.Post(urlString,sResult);

  // Do something on failure
  if sResult = '' then
  else
    Result := sResult;

end;

{
  Format the food name query in the format
  word%20word2 as would be preferred when searching
  for an item using a query on a url with spaces
}
function TfrmFetcher.FormatQuery(sQuery: string): string;
var
  delPos : Integer;
  currentWord,finalQuery : string;
begin

  finalQuery := '';
  {
    Repeating this process seems to work the best,
    The final query should have every word after
    the other separated the `%20` to fit the query scheme

    NOTE: I do not yet know what to do when there are multiple
    spaces, but I would rather have a check to ensure
    that does not happen
  }
  delPos := Pos(' ',sQuery);
  currentWord := Copy(sQuery,1,delPos-1);
  finalQuery := currentWord;
  Delete(sQuery,1,delPos);
  repeat
    delPos := Pos(' ',sQuery);
    if delPos <> 0 then
    begin
      currentWord := Copy(sQuery,1,delPos-1);
      finalQuery := finalQuery+'%20'+currentWord;
      Delete(sQuery,1,delPos);
    end;
  until delpos = 0;

  Result := finalQuery;
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
