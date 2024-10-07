unit libUtils_U;

interface

uses System.SysUtils,System.Classes,VCL.StdCtrls,Dialogs,vcl.NumberBox,vcl.DBGrids,Spin;

type
  TFileUtils = Class(TObject)
  public
    function CheckFileExists(pFilename: string) : boolean;
    function CheckLogFile : Boolean;
  end;

  TControlUtils = Class(TObject)
  public
    procedure SetNumberBox(pNumberBox : TNumberBox;pMin,pMax : real);
    procedure SetSpinEdit(pSpinEdit : TSpinEdit;pMin,pMax : integer);
    procedure ResizeDBGrid(pDBGrid:TDBGrid);
  end;

  TStringUtils = Class(TObject)
  public
    function ValidateString(S,StringName: string; minLength: Integer = 0;
     maxLength: Integer = 0; allowedChars : String = 'letters'): Boolean;
  end;

  TLogService = Class(TObject)
  private
    procedure WriteLog(logMessage:string);
  public
    procedure WriteUserLog(pMessage:string);
    procedure WriteSysLog(pMessage:string);
    procedure WriteErrorLog(pMessage:string);
  end;

implementation

//Control utilities
{$REGION CONTROL}
procedure TControlUtils.SetNumberBox(pNumberBox: TNumberBox; pMin: Real; pMax: Real);
begin
  with pNumberBox do
  begin
    minValue := pMin;
    maxValue := pMax;
    Mode := nbmFloat;
    Enabled := false;
    UseMouseWheel := true;
  end;
end;

procedure TControlUtils.SetSpinEdit(pSpinEdit: TSpinEdit; pMin: Integer; pMax: Integer);
begin
  with pSpinEdit do
  begin
    minValue := pMin;
    maxValue := pMax;
    Value := pMin;
    Enabled := false;
  end;
end;
procedure TControlUtils.ResizeDBGrid(pDBGrid:TDBGrid);
var
  i : integer;
begin
  pDBGrid.ReadOnly := true;
  for i := 0 to pDBGrid.Columns.Count -1 do
  pDBGrid.Columns[i].Width := 5+pDBGrid.Canvas.TextWidth(pDBGrid.Columns[i].Title.Caption);
end;
{$ENDREGION}

// String utilities
{$REGION STRINGS}
function TStringUtils.ValidateString(S,StringName: string; minLength: Integer = 0;
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
      if (UpperCase(s)[i] in LETTERS) then
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
{$ENDREGION}

// File utilities
{$REGION FILES}
function TFileUtils.CheckFileExists(pFilename: string): Boolean;
var
  sLogMsg : string;
  isExist : boolean;
begin
  sLogMsg := 'The file ' + pFilename + ' was need but not found';

  if not FileExists(pFilename) then
  begin
    isExist := false;
    TLogService.Create.WriteSysLog(sLogMsg);
  end
  else
   isExist := true;
  Result := isExist;
end;

function TFileUtils.CheckLogFile: Boolean;
const LOGFILE = 'logs';
var isExisting : Boolean;
begin
  isExisting := FileExists(LOGFILE);
  Result := isExisting;
end;
{$ENDREGION}

// System logging
{$REGION LOGGING}
procedure TLogService.WriteUserLog;
var
  sLogMsg : string;
begin
  sLogMsg := '[USER] ' + pMessage;
  WriteLog(sLogMsg);
end;

procedure TLogService.WriteSysLog;
var
  sLogMsg : string;
begin
  sLogMsg := '[SYSTEM] ' + pMessage;
  WriteLog(sLogMsg);
end;

procedure TLogService.WriteErrorLog;
var
  sLogMsg : string;
begin
  sLogMsg := '[ERROR] ' + pMessage;
  WriteLog(sLogMsg);
end;

procedure  TLogService.WriteLog;
const LOGFILE = 'logs';
var
  tfLogs : textfile;
  logsExist : boolean;
begin
  AssignFile(tfLogs,LOGFILE);
  logsExist := TFileUtils.Create.CheckLogFile;
  try
    if logsExist then
      Append(tfLogs)
    else
    begin
      Rewrite(tfLogs);
      WriteLn(tfLogs,'# LOGS #' + #13 + '########');
    end;
    logMessage := FormatDateTime('ddddd@tt',now) + ': ' + logMessage;
    WriteLn(tfLogs,logMessage);
  finally
    CloseFile(tfLogs);
  end;
end;
{$ENDREGION}
end.
