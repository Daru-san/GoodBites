// User creation and modification functions and procedures
unit UserMod;

interface

uses system.SysUtils,conDBBites, Vcl.Dialogs, Utils,Classes;

type
  TUsers = class(Tobject)
  private
    function GenerateUserID(userString:string): string;
    function ValidateNewUser(userString,passString : string) : boolean;
    function CheckDatabase(userString:string):boolean;
    function WriteUserPassFile(userString,passString:string): boolean;
    function DeleteUserPassFile(userString :string) :boolean;

    procedure RegisterUserInDB(passString,userString,userID : string);
    procedure HandleUserError(userString: string; arrErrors : array of string; numErrors : integer);

  public
    function ValidPass(userString,passString:string): boolean;
    function CheckPass(userString: string; passString: string; filename: string): boolean;

    procedure SaveLastLogin(userString : string);
    procedure CreateUser(userString,passString: string);
    procedure RemoveUser(userID : string);
  end;

  var
    isFailed : boolean;
implementation

function TUsers.ValidateNewUser;
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

procedure TUsers.HandleUserError;
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
function TUsers.GenerateUserID;
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

function TUsers.WriteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isFileExist, isSuccessful : boolean;
begin
  if not TUtils.Create.CheckFileExists(FILENAME) then
  begin
    TUtils.Create.WriteSysLog(
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
    TUtils.Create.WriteUserLog('User ' + userString + ' has been saved in the PASSWORDS file');
    isSuccessful:= true;
  end;
  WriteUserPassFile := isSuccessful;
end;

function TUsers.DeleteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isSuccessful : boolean;
  passList : TStringList;
  indexNum : integer;
begin
  if not TUtils.Create.CheckFileExists(FILENAME) then
  begin
    TUtils.Create.WriteSysLog('User deletion attempted, but the password file is missing or corrupted');
    ShowMessage('An unkown error occured');
    isSuccessful := false;
  end else
  begin
    passList := TStringList.Create;
    passList.LoadFromFile(FILENAME);
    passList.NameValueSeparator := '#';
    indexNum := passList.IndexOfName(userString);
    if (indexNum <> -1) then
    begin
      passList.Delete(indexNum);
      passList.SaveToFile(FILENAME);
    end;
    passList.Free;
    TUtils.Create.WriteSysLog('Entry for user ' + userString + ' was removed from the passwords file');
    isSuccessful := true;
  end;
end;

procedure TUsers.CreateUser;
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
        TUtils.Create.WriteUserLog('The user ' + userString + ', uid ' + userID + ' has registered successfully');
        ShowMessage('You have successfully been registered, happy eating!');
      end;
    end
    else
    begin
      TUtils.Create.WriteUserLog(
        'The user ' + userString + ',uid ' + userID +
        ' attempted to register, but were not found in the database afterward.'
        + #13 + #9 + 'Something must have gone wrong'
      );
      ShowMessage('Some error occured and user registration has failed.' + #13 + 'Please try again');
    end;
  end;
end;

procedure TUsers.RegisterUserInDB;
begin
  with dbmData.tblUsers do
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

function TUsers.ValidPass;
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

function TUsers.CheckDatabase;
var
  isFound: boolean;
begin
  with dbmData.tblUsers do
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
function TUsers.CheckPass;
var
  passFile : textfile;
  fileString, userFileString, userPassString, userInDatabase : string;
  isCorrect,inDatabase : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);

  if not TUtils.Create.CheckFileExists(filename) then exit;

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

procedure TUsers.SaveLastLogin;
var
  userFound : boolean;
begin
  with dbmData.tblUsers do
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

procedure TUsers.RemoveUser;
var
  isFound, isRemoved : boolean;
  userString : string;
begin
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if FieldValues['UserID'] = userID then
        isFound := true
      else Next;
    until EOF or isFound;
    userString := FieldValues['Username'];

    isRemoved := DeleteUserPassFile(userString);
    if isRemoved then
    begin
      Delete;
      Post;
      TUtils.Create.WriteUserLog('User ' + userString + ', uid ' + userID + ' was removed completely');
    end;
  end;
end;

end.

