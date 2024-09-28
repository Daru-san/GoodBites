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

      Util : TUtils;

      ResultString : string;
      FQuerySuccessful : Boolean;

      function GetAPIKey : string;
    public
      constructor Create;
      destructor Destroy; override;

      procedure SendQuery(sQuery:string;dataType :string = 'Foundation');
      property QuerySuccessful : Boolean read FQuerySuccessful write FQuerySuccessful;

      function GetJson : string;
  end;

implementation

constructor TFetchAPI.Create;
begin
  Util := TUtils.Create;
end;

destructor TFetchAPI.Destroy;
begin
  Util.Free;
end;

procedure TFetchAPI.SendQuery(sQuery: string; dataType: string = 'Foundation');
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
      '{"query":"'+sQuery+'","pageSize":10,"dataType": ["'+dataType+'"]}',
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
      // I want to ensure I can avoid any access voilations due to internet connection
      ShowMessage('An error occured, please check your internet connection');
    end;
      QuerySuccessful := false;
  finally
    strSearchParams.Free;
    HTPPClient.Free;
    HTTPRequest.Free;
  end;
end;

function TFetchAPI.GetJson: string;
begin
  //TODO: Validate the output

  Result := ResultString;
end;

function TFetchAPI.GetAPIKey : string;
const FILENAME = 'files\api_key.txt';
var keyFile : textfile; sAPIKey : string;
begin
  sAPIKey := '';

  { This check is in the assumption that a missing key file would mean that the key does not work anymore, hence would use default }
  if Util.CheckFileExists(FILENAME) then
  try
    AssignFile(keyFile,FILENAME);
    Reset(keyFile);
    Readln(keyFile,sAPIKey);
  finally
    CloseFile(keyFile);
  end;

  { The API provides a demo key that can be used,
    I would rather have a higher rate limit though
    If by any chance the key does not exist, we will
    default to the DEMO_KEY which can be used, albeit
    at a much lower rate per hour than a specialized key }
  if sAPIKey = '' then
    Result := 'DEMO_KEY'
  else
    Result := sAPIKey;
end;
end.
