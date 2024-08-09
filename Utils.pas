
unit Utils;

interface

uses System.SysUtils;
type
  TBackend = Class(TObject);
  procedure WriteLog(logMessage:string);
  function CheckFileExists(filename: string) : boolean;

  implementation

function CheckFileExists(filename: string) : boolean;
begin
  if not FileExists(filename) then
  begin
    //WriteLog('The file ' + filename + ' was needed but not found');
    exit;
  end;
end;

procedure WriteLog(logMessage : string);
const FILENAME = '.logs';
var
  LogFile : textfile;
  logsExist : boolean;
begin
  AssignFile(LogFile,FILENAME);
  logsExist := CheckFileExists(FILENAME);
  if logsExist then
    Append(logFile)
  else
  begin
    Rewrite(logFile);
    WriteLn(logFile,'# LOGS #' + #13);
  end;
  logMessage := DateToStr(date) + ': ' + logMessage;
  WriteLn(LogFile,logMessage);
  CloseFile(logFile);
end;
end.
