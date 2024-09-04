
unit Utils_U;

interface

uses System.SysUtils,System.Classes,VCL.StdCtrls,conDBBites;

type
  TUtils = Class(TObject)
  public
    function CheckFileExists(filename: string;isLogFile:boolean = false) : boolean;

    procedure SetLabel(LabelComponent:TLabel;labelMsg:string;fontSize : integer);
    procedure EditInDB(fieldName,fieldData : string);

  end;
  TLogs = Class(TObject)
  private
    procedure WriteLog(logMessage:string);
  public
    procedure WriteUserLog(logMessage:string);
    procedure WriteSysLog(logMessage:string);
    procedure WriteErrorLog(logMessage:string);
  End;

implementation

function TUtils.CheckFileExists;
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
      Tlogs.Create.WriteSysLog(logMSG);
    end;
  end else isExist := true;
  CheckFileExists := isExist;
end;

procedure TUtils.SetLabel;
begin
  with labelComponent do
  begin
    font.Name := 'Noto Sans';
    font.size := fontSize;
    Layout := tlCenter;
    Alignment := taCenter;
    Caption := labelMsg;
  end;
end;

procedure TUtils.EditInDB;
begin
  with dbmData.tblUsers do
  begin
    Edit;
    FieldValues[fieldName] := fieldData;
    Post;
    TLogs.Create.WriteSysLog('An entry has been modified in the database');
  end;
end;

procedure Tlogs.WriteUserLog;
var
  logMsg : string;
begin
  logMsg := '[USER] ' + logMessage;
  WriteLog(logMsg);
end;

procedure TLogs.WriteSysLog;
var
  logMsg : string;
begin
  logMsg := '[SYSTEM] ' + logMessage;
  WriteLog(logMsg);
end;

procedure TLogs.WriteErrorLog;
var
  logMsg : string;
begin
  logMsg := '[ERROR] ' + logMessage;
  WriteLog(logMsg);
end;

procedure  TLogs.WriteLog;
const FILENAME = 'logs';
var
  LogFile : textfile;
  logsExist : boolean;
begin
  AssignFile(LogFile,FILENAME);
  logsExist := Tutils.Create.CheckFileExists(FILENAME,true);
  try
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
  finally
    CloseFile(logFile);
  end;
end;
end.
