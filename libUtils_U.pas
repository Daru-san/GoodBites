unit libUtils_U;

interface

uses System.SysUtils,System.Classes,VCL.StdCtrls,Dialogs;

type
  TUtils = Class(TObject)
  public
    function CheckFileExists(filename: string;isLogFile:boolean = false) : boolean;
    function ValidateString(S,StringName: string; minLength: Integer = 0;
     maxLength: Integer = 0; allowedChars : String = 'letters'): Boolean;

    procedure SetLabel(LabelComponent:TLabel;labelMsg:string;fontSize : integer);

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

function TUtils.ValidateString(S,StringName: string; minLength: Integer = 0;
     maxLength: Integer = 0; allowedChars : String = 'letters'): Boolean;
const
NUMS = ['1'..'9'];
SPECIAL = ['.',',','/','\','!','@','#','%','&','*'];
LETTERS = ['A'..'Z'] + [' '];
var
  isPresent,isLong,isValid:Boolean;
  hasNum : Boolean;
  hasSpecial : Boolean;
  hasLetters : Boolean;
  allowNum,allowSpecial,allowLetters : Boolean;
  checkNum,checkSpecial,checkLetter : Boolean;
  i: Integer;
begin

  allowLetters := false;
  allowNum := false;
  allowLetters := false;

  if LowerCase(allowedChars).Contains('letters') then
  allowLetters := true;

  if LowerCase(allowedChars).Contains('numbers') then
  allowNum := true;

  if LowerCase(allowedChars).Contains('other') then
  allowSpecial := true;

  if S = '' then
  begin
    isPresent := false;
  end;
  if (S.Length < minLength) or (S.Length > maxLength) then
  isLong := false;

  for i := 1 to S.Length do
  begin
    if allowLetters then
      if (s[i] in LETTERS) then
      hasLetters := True;
    if allowNum then
      if (s[i] in NUMS) then
      hasNum := True;
    if allowSpecial then
     if s[i] in SPECIAL then
     hasSpecial := true;
  end;

  if not(allowLetters and hasLetters) then
    ShowMessage(StringName + ' must have letters');

  checkNum := (allowNum and (hasNum or not(hasNum))) or (not(allowNum) and not(hasNum));
  checkSpecial := (allowSpecial and (hasSpecial or not(hasSpecial))) or (not(allowSpecial) and not(hasSpecial));
  checkLetter := (allowLetters and hasLetters) or (not(allowLetters) and not(hasLetters));

  { Only return true if both conditions being allowing and having are correct }
  isValid := checkNum and checkLetter;

  //Result := isPresent and isLong and isValid;
  Result := true;
end;


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
