unit libFetchAPI_U;
{
 Query the API provided by https://www.usda.gov/
 Details on the API at https://fdc.nal.usda.gov/api-guide.html

 This works quite nicely, I am very pleased by how this turned out ^.^
 I still have quite a bit to learn about web apis but putting this together was an amazing learning experience :)
}

interface

uses System.Net.HttpClient, System.Net.HttpClientComponent, libUtils_U, Classes, SysUtils,Dialogs;

type
  TFetchAPI = class(TObject)
    private
      HTPPClient : TNetHTTPClient;
      HTTPRequest : TNetHTTPRequest;

      FResponseLength : Integer;
      FQuerySuccessful : Boolean;
      FJSONResponse : TStringStream;

      function GetAPIKey : string;
    public
      constructor Create;
      destructor Destroy; override;

      property ResponseLength : Integer read FResponseLength write FResponseLength;
      property QuerySuccessful : Boolean read FQuerySuccessful write FQuerySuccessful;
      property JSONResponse : TStringStream read FJSONResponse write FJSONResponse;

      procedure SendQuery(pQuery:string;pDataType : string = 'Foundation');
  end;

  var
    FileUtils : TFileUtils;

implementation

// Controlling our FileUtils class
constructor TFetchAPI.Create;
begin
  FileUtils := TFileUtils.Create;
end;

destructor TFetchAPI.Destroy;
begin
  FileUtils.Free;
end;

procedure TFetchAPI.SendQuery(pQuery: string; pDataType: string = 'Foundation');
var
  sAPIKey,sResult : string;
  strSearchParams : TStringStream;
begin

  sAPIKey := GetAPIKey;

  QuerySuccessful := False;

  try
    HTPPClient := TNetHTTPClient.Create(nil);
    HTTPRequest := TNetHTTPRequest.Create(nil);

    { Limit the maximum queries to 10, preventing a huge string that would take
      ages to parse to be returned }
    strSearchParams := TStringStream.Create(
      '{"query":"'+pQuery+'","pageSize":10,"dataType": ["'+pDataType+'"]}',
      TEncoding.UTF8
    );

    try
      HTPPClient.ContentType := 'application/json';
      HTPPClient.AcceptEncoding := 'UTF-8';

      HTTPRequest.Client := HTPPClient;

      { GET was also an option, but POST allows for greater customizability in terms of search parameters }
      sResult := HTTPRequest.Post(
        'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=' + sAPIKey,strSearchParams
      ).ContentAsString(TEncoding.UTF8);

      QuerySuccessful := true;
    except on E: ENetHTTPClientException do
    begin
      ShowMessage('An error occured, please check your internet connection');
      QuerySuccessful := false;
    end;  // end except
    end; // end try
  finally
    strSearchParams.Free;
    HTPPClient.Free;
    HTTPRequest.Free;
  end;

  if QuerySuccessful then
  begin
    JSONResponse := TStringStream.Create(sResult);
    ResponseLength := Length(sResult);
  end;
end;

function TFetchAPI.GetAPIKey : string;
const FILENAME = 'files\api_key.txt';
var tfKey : textfile; sKey : string;
begin
  sKey := '';

  if FileUtils.CheckFileExists(FILENAME) then
  try
    AssignFile(tfKey,FILENAME);
    Reset(tfKey);
    Readln(tfKey,sKey);
  finally
    CloseFile(tfKey);
  end;

  { The API provides a demo key that can be used,
    I would rather have a higher rate limit though
    If by any chance the key does not exist, we will
    default to the DEMO_KEY which can be used, albeit
    at a much lower rate per hour than a specialized key }
  if sKey = '' then
    Result := 'DEMO_KEY'
  else
    Result := sKey;
end;
end.
