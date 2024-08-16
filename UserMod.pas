// User creation and modification functions and procedures
unit UserMod;

interface

uses system.SysUtils,dmBase, Vcl.Dialogs, Utils;

type
  TLib = class(Tobject);
  function CheckPass(userString: string; passString: string; filename: string): boolean;
  function ValidPass(userString,passString:string): boolean;
  function CheckDatabase(userString:string):boolean;
  function GenerateUserID(userString:string): string;
  function ValidateNewUser(userString,passString : string) : boolean;

  procedure CreateUser(userString,passString: string);
  procedure RegisterUserInDB(passString,userString,userID : string);
  procedure HandleUserError(userString: string; arrErrors : array of string; numErrors : integer);
  procedure SaveLastLogin(userString : string);

  var
    isFailed : boolean;
implementation

function ValidateNewUser(userString,passString:string):boolean;
const
  VALIDCHARS = ['A'..'Z','a'..'z','0'..'9'];
var
  isNameValid,isPassValid, errorsPresent, isAlreadyRegistered : boolean;
  intInPass,strValidPass : boolean;
  arrErrors : array [1..50] of string;
  numErrors,passErrorCode : integer;
  tempString : string;
  I,j, tempInt: Integer;
begin
  isNameValid := false;
  isPassValid := false;
  errorsPresent := false;

  numErrors := 0;

  if userString.Length < 2 then
  begin
    inc(numErrors);
    errorsPresent := true;
    arrErrors[numErrors] := 'Username must be over 2 characters';
  end;
  if CheckDatabase(userString) then
  begin
    inc(numErrors);
    errorsPresent := true;
    isAlreadyRegistered := true;
    arrErrors[numErrors] := 'User ' + userString + ' already exists';
  end;
  if userString.Length > 10 then
  begin
    inc(numErrors);
    errorsPresent := true;
    arrErrors[numErrors] := 'Username ' + userString + ' is too long, maximum length is 10 characters';
  end;

  if passString.Length < 8 then
  begin
    inc(numErrors);
    errorsPresent := true;
    arrErrors[numErrors] := 'Password must be over 8 characters';
  end;

  intInPass := false;
  strValidPass := true;

  for i := 1 to userString.Length do
  begin
    if not (userString[i] in VALIDCHARS) then
    begin
      strValidPass := false;
      errorsPresent := true;
      inc(numErrors);
      arrErrors[numErrors] := 'Username must not have any special characters';
      break;
    end;
  end;

  for i := 1 to passString.Length do
  begin
    val(passString,tempInt,passErrorCode);
    if passErrorCode = 0 then
    begin
      intInPass := true;
      errorsPresent := true;
      inc(numErrors);
      arrErrors[numErrors] := 'Password must have a number';
    end;
    if not (passString[i] in VALIDCHARS) then
    begin
      strValidPass := false;
      errorsPresent := true;
      inc(numErrors);
      arrErrors[numErrors] := 'Password is not valid, only use numbers and letters in your password';
    end;
  end;

  if (numErrors = 0) and not errorsPresent then
  begin
    isNameValid := true;
    isPassValid := true;
  end else
    HandleUserError(userString,arrErrors,numErrors);
  ValidateNewUser := isNameValid;
end;

procedure HandleUserError(userString: string; arrErrors : array of string; numErrors : integer);
var
  errorMsg : string;
  i: Integer;
begin
  errorMsg := '';
  for i := 1 to numErrors do
  begin
    errorMsg := errorMsg + arrErrors[i] + #13;
  end;
  ShowMessage(errorMsg);
end;
function GenerateUserID(userString:string): string;
var
  randomInt, iPos : integer;
  dateStr,finalDateStr, tempStr, userID,nameStr : string;
  i: Integer;
begin
  randomInt := Random(10)+1;
  dateStr := FormatDateTime('d/m/y',date);
  nameStr := UPPERCASE(userString[1] + userString[2]);

  FinalDateStr := dateStr[2];

  for i := 1 to 2 do
  begin
    iPos := pos('/',dateStr);
    delete(dateStr,i,iPos);
    FinalDateStr := FinalDateStr + dateStr[1];
  end;

  userID := nameStr + IntToStr(randomInt) + dateStr;
  GenerateUserID := userID;
end;

function WriteUserPassFile(userString,passString:string): boolean;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isFileExist, isSuccessful : boolean;
begin
  if not CheckFileExists(FILENAME) then
  begin
    WriteSysLog(
      'User register attempted, but the password file is missing' + #13
      + #9 + 'This may cause errrors, manual intervention is required'
    );
    ShowMessage('An unkown error occured');
    isSuccessful := false;
  end else
  begin
    AssignFile(passFile,FILENAME);
    Append(passFile);
    WriteLn(passFile,userString + '#' + passString);
    CloseFile(passFile);
    WriteUserLog('User ' + userString + ' has been saved in the PASSWORDS file');
    isSuccessful:= true;
  end;
  WriteUserPassFile := isSuccessful;
end;

procedure CreateUser(userString,passString: string);
var
  isUserValid,userInDB, userInPassFile : boolean;
  userID : string;
begin
  isUserValid := ValidateNewUser(userString,passString);
  if isUserValid then
  begin
    userID := GenerateUserID(userString);
    RegisterUserInDB(passString,userString,userID);
    userInDB := CheckDatabase(userString);
    if userInDB then
    begin
      userInPassFile := writeUserPassFile(userString,passString);
      if userInPassFile then
      begin
        WriteUserLog('The user ' + userString + ', uid ' + userID + ' has registered successfully');
        ShowMessage('You have successfully been registered, happy eating!');
      end;
    end
    else
    begin
      WriteUserLog(
        'The user ' + userString + ',uid ' + userID +
        ' attempted to register, but were not found in the database afterward.'
        + #13 + #9 + 'Something must have gone wrong'
      );
      ShowMessage('Some error occured and user registration has failed.' + #13 + 'Please try again');
    end;
  end;
end;

procedure RegisterUserInDB(passString,userString,userID : string);
begin
  with dmBase.dmData.tblUsers do
  begin
    Open;
    Append;
    FieldValues['userID'] := userID;
    FieldValues['Username'] := userString;
    FieldValues['RegisterDate'] := date;
    FieldValues['isAdmin'] := false;
    FieldValues['Age'] := 0;
    Post;
    Close;
  end;

end;

function ValidPass(userString,passString: string):boolean;
var
  isValid : boolean;
begin

  if userString.isEmpty then
  begin
    ShowMessage('Please enter a username');
    isValid := false;
  end
    else
  if passString.isEmpty then
  begin
    ShowMessage('Please enter a valid password');
    isValid := false;
  end
   else
    isValid := true;
  ValidPass := isValid;
end;

function CheckDatabase(userString : string): boolean;
var
  isFound: boolean;
begin
  with dmBase.dmData.tblUsers do
  begin
    Open;
    First;
    Repeat
      if UPPERCASE(FieldValues['Username']) = UPPERCASE(userString) then isFound := true;
      Next;
    Until EOF or isFound;
    Close;
  end;
  CheckDatabase := isFound;
end;
function CheckPass(userString: string; passString: string; filename: string): boolean;
var
  passFile : textfile;
  fileString, userFileString, userPassString, userInDatabase : string;
  isCorrect,inDatabase : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);

  if not CheckFileExists(filename) then exit;

  Reset(passFile);

  isCorrect := false;
  inDatabase := CheckDatabase(userString);

  if not inDatabase then
  begin
    ShowMessage('The user ' + userString + ' is not found');
  end
  else
  repeat
    ReadLn(passFile,fileString);
    delPos := pos('#',fileString);
    userFileString := copy(fileString,1,delPos-1);
    delete(fileString,1,delPos);
    userPassString := fileString;
    if ((UPPERCASE(userFileString) = UPPERCASE(userString)) and (userPassString = passString)) then
      isCorrect := true;
  until EOF(passFile) or isCorrect;
  CloseFile(passFile);

  CheckPass := isCorrect;
end;

procedure SaveLastLogin(userString : string);
var
  userFound : boolean;
begin
  with dmBase.dmData.tblUsers do
  begin
    Open;
    repeat
      if FieldValues['Username'] = userString then
      begin
        userFound := true;
      end
      else Next;
    until EOF or userFound;

    Edit;
    FieldValues['LastLogin'] := date;
    Post;

    Close;
  end;
end;
end.

