unit libFetchAPI_U;
{
 Searching the API provided by https://www.usda.gov/
 Details on the API at https://fdc.nal.usda.gov/api-guide.html

 This works quite nicely, I am very pleased by how this turned out ^.^
 I still have quite a bit to learn about putting these together but this was an amazing learning experience :)
}

interface

uses System.Net.HttpClient, System.Net.HttpClientComponent, libUtils_U, Classes, SysUtils;

type
  TFetchAPI = class(TObject)
    private
      NHClient : TNetHTTPClient;
      NHREQ : TNetHTTPRequest;

      Util : TUtils;

      ResultString : string;

      function GetAPIKey : string;
    public
      constructor Create;
      destructor Destroy; override;

      procedure SendQuery(sQuery:string;dataType :string = 'Foundation');

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
  api_key : string;
  searchParams : TStringStream;
begin
  NHClient.ContentType := 'application/json';
  NHClient.AcceptEncoding := 'UTF-8';

  { From a safety standpoint, providing the API key as a variable or constan would be very unsafe,
    I assume this approach of obtaining the key from a separate file works best, although it may make
    it difficult to update the API key. I at least hope the key won'will not expire for a long time :) }
  api_key := GetApiKey;

  { Limit the maximum queries to 10, preventing a huge string that would take
    ages to parse to be returned }
  searchParams := TStringStream.Create(
    '{"query":"'+sQuery+'","pageSize":10,"dataType": ["'+dataType+'"]}',
    TEncoding.UTF8
  );

  { GET was also an option, but POST allows for greater customizability in terms of parameters }
  ResultString := NHREQ.Post(
    'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=' + api_key,searchParams
  ).ContentAsString(TEncoding.UTF8);

  Params.Free;
end;

function TFetchAPI.GetJson: string;
begin
  //TODO: Validate the output

  Result := ResultString;
end;

function TFetchAPI.GetApiKey : string;
const FILENAME = 'files\api_key.txt';
var keyFile : textfile; sKey : string;
begin
  sKey := '';

  { This check is in the assumption that a missing key file would mean that the key does not work anymore, hence would use default }
  if Util.CheckFileExists(FILENAME) then
  try
    AssignFile(keyFile,FILENAME);
    Reset(keyFile);
    Readln(keyFile,sKey);
  finally
    CloseFile(keyFile);
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
