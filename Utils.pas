
unit Utils;

interface

uses System.SysUtils;
type
  TBackend = Class(TObject);
  procedure WriteLog(logMessage:string);
  procedure WriteUserLog(logMessage:string);
  procedure WriteSysLog(logMessage:string);
  procedure WriteErrorLog(logMessage:string);
  function CheckFileExists(filename: string;isLogFile:boolean = false) : boolean;

  implementation

function CheckFileExists(filename: string; isLogFile : boolean = false) : boolean;
var
  logMsg : string;
  isExist : boolean;
begin
  logMsg := 'The file ' + filename + ' was need but not found';
  if not FileExists(filename) then
  begin
    isExist := false;
    if not isLogFile then
    begin
      WriteLog(logMSG);
     // WriteLn(logMSG);
    end;
    exit;
  end else isExist := true;
  CheckFileExists := isExist;
end;

procedure WriteUserLog;
var
  logMsg : string;
begin
  logMsg := '[USER] '+logMessage;
  WriteLog(logMsg);
end;

procedure WriteSysLog;
var
  logMsg : string;
begin
  logMsg := '[SYSTEM] '+logMessage;
  WriteLog(logMsg);
end;

procedure WriteErrorLog(logMessage : string);
var
  logMsg : string;
begin
  logMsg := '[ERROR] '+logMessage;
  WriteLog(logMsg);
end;

procedure WriteLog(logMessage : string);
const FILENAME = '.logs';
var
  LogFile : textfile;
  logsExist : boolean;
begin
  AssignFile(LogFile,FILENAME);
  logsExist := CheckFileExists(FILENAME,true);
  if logsExist then
    Append(logFile)
  else
  begin
    Rewrite(logFile);
    WriteLn(logFile,'# LOGS #' + #13 + '########');
  end;
  logMessage := FormatDateTime('ddddd@tt',now) + ': ' + logMessage;
  WriteLn(LogFile,logMessage);
  //WriteLn(logMessage);
  CloseFile(logFile);
end;
end.
