unit DataFetcher;

interface

uses Vcl.Dialogs,Utils;
type
  TDataFetcher = class(TObject)

  public
    procedure FetchData(filename:string;nutrientName:string);
  private
    procedure EditFile(filename,nutrientName:string);
  end;
  var
    isFailed : boolean;

implementation

//TODO: Send large amounts of text between procedures
procedure TDataFetcher.FetchData;
begin
  //TODO: Fetch data from an external source
  ShowMessage('The file ' + filename + ' will be edited');
  EditFile(filename,nutrientName);
  if isFailed then
  begin
    ShowMessage('An error occured');
    Exit;
  end;
end;

procedure TDataFetcher.EditFile;
var
  nutrientFile,dataFile : textfile;
  lineString : string;
begin
  if not TUtils.Create.CheckFileExists(filename) then
  begin
    TUtils.Create.WriteErrorLog('The file ' + filename + ' was needed but not found');
    isFailed := true;
    Exit;
  end;

  try
    AssignFile(nutrientFile,filename);
    AssignFile(dataFile,'tmp.txt');
    Rewrite(nutrientFile);
    repeat
      Readln(dataFile,lineString);
      Writeln(nutrientFile,lineString);
    until Eof(dataFile);
  finally
   CloseFile(nutrientFile);
   CloseFile(dataFile);
  end;

end;

end.
