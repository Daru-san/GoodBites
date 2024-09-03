// User creation and modification functions and procedures
unit User_u;

interface

uses system.SysUtils,conDBBites, Vcl.Dialogs, Utils,Classes;

type
  TUser = class(TObject)
  private
    Fusername : string;
    FisAdmin : boolean;
    FUserID : string;
    LoggedIn : boolean;
    FPassword : string;

    function GenerateUserID(userString:string): string;
    function ValidateNewUser(userString,passString : string) : boolean;
    function CheckDatabase(userString:string):boolean;
    function WriteUserPassFile(userString,passString:string): boolean;
    function DeleteUserPassFile(userString :string) :boolean;

    procedure RegisterUserInDB(passString,userString,userID : string);
    procedure HandleUserError(userString: string; arrErrors : array of string; numErrors : integer);
  public
    constructor Create(Username : string;Password:string;NewUser:Boolean);

    function CheckLogIn : boolean;
    property isAdmin: Boolean read FisAdmin write FisAdmin;
    property Username: string read Fusername write Fusername;
    property UserID: string read FUserID write FUserID;

    function ValidPass(userString,passString:string): boolean;
    function CheckPass(userString: string; passString: string): boolean;
    function CheckAdmin(sUserID : string) : boolean;
    function GetUserId(userString:string):string;

    procedure SaveLastLogin(userString,userID : string; userIsAdmin : Boolean);
    procedure CreateUser(userString,passString: string);
    procedure RemoveUser(userID : string);
  end;

  var
    isFailed : boolean;
    loggerObj : TLogs;
    UtilObj : TUtils;
implementation

constructor TUser.Create;
var
  isCorrect,isValid,passFileExists,loginSuccessful : boolean;
begin
  loggerObj := TLogs.Create;
  UtilObj := TUtils.Create;
  loginSuccessful := false;
  if NewUser then
  begin
    CreateUser(Username,Password);
  end else
  begin
    isValid := ValidPass(Username,Password);

    if isValid then
    begin
      isCorrect := CheckPass(Username,Password);
      UserId := GetUserID(Username);
      if isCorrect then
      begin
        isAdmin := CheckAdmin(UserID);
        SaveLastLogin(Username,UserID,isAdmin);
        loginSuccessful := true;
      end
      else
      begin
        ShowMessage('The username or password are incorrect');
        LoggerObj.WriteUserLog('Failed login attempt by user ' + Username);
      end;
    end else
      ShowMessage('Invalid data');
  end;

  Fusername := Username;
  FisAdmin := IsAdmin;
  LoggedIn := loginSuccessful;
  FPassword := Password;
  FUserID := UserID;
end;

function TUser.CheckLogin;
begin
  result := LoggedIn;
end;

function TUser.GetUserId;
var
  sUserId : string;
  isFound : boolean;
begin
  isFound := false;
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UpperCase(userString) = UpperCase(FieldValues['Username']) then
      begin
        isFound := true;
        sUserId := FieldValues['UserID'];
      end else Next;
    until Eof or isFound;
    Close;
  end;
  if not isFound then
  ShowMessage('User not found?' + userString);
  result := sUserId;
end;

function TUser.ValidateNewUser;
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

procedure TUser.HandleUserError;
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

function TUser.GenerateUserID;
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

function TUser.WriteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isFileExist, isSuccessful : boolean;
begin
  if not TUtils.Create.CheckFileExists(FILENAME) then
  begin
    LoggerObj.WriteSysLog(
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
    LoggerObj.WriteUserLog('User ' + userString + ' has been saved in the PASSWORDS file');
    isSuccessful:= true;
  end;
  WriteUserPassFile := isSuccessful;
end;

function TUser.DeleteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isSuccessful : boolean;
  passList : TStringList;
  indexNum : integer;
begin
  if not UtilObj.CheckFileExists(FILENAME) then
  begin
    LoggerObj.WriteSysLog('User deletion attempted, but the password file is missing or corrupted');
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
    LoggerObj.WriteSysLog('Entry for user ' + userString + ' was removed from the passwords file');
    isSuccessful := true;
  end;
end;

procedure TUser.CreateUser;
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
        LoggerObj.WriteUserLog('The user ' + userString + ', uid ' + userID + ' has registered successfully');
        ShowMessage('You have successfully been registered, happy eating!');
      end;
    end
    else
    begin
      LoggerObj.WriteUserLog(
        'The user ' + userString + ',uid ' + userID +
        ' attempted to register, but were not found in the database afterward.'
        + #13 + #9 + 'Something must have gone wrong'
      );
      ShowMessage('Some error occured and user registration has failed.' + #13 + 'Please try again');
    end;
  end;
end;

procedure TUser.RegisterUserInDB;
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

function TUser.ValidPass;
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

function TUser.CheckDatabase;
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

function TUser.CheckAdmin;
var
  userIsAdmin,isFound : boolean;
begin
  isAdmin := false;
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
    if UPPERCASE(FieldValues['UserID']) = UPPERCASE(sUserID) then
    begin
      isFound := true;
      if FieldValues['isAdmin'] then userIsAdmin := true;
    end else Next;
    until (EOF or isFound);
    Close;
  end;
  if not isFound then
  ShowMessage('User not found?');
  result := userIsAdmin;
end;

function TUser.CheckPass;
const
FILENAME = '.passwords';
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

procedure TUser.SaveLastLogin;
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
  if userIsAdmin then
  begin
    LoggerObj.WriteUserLog('Administrator ' + userString + ' uid ' + userID + ' logged in.');
  end
  else
  begin
    LoggerObj.WriteUserLog('User ' + userString + ' uid ' + userID + ' logged in.');
  end;
end;

procedure TUser.RemoveUser;
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
      loggerObj.WriteUserLog('User ' + userString + ', uid ' + userID + ' was removed completely');
    end;
  end;
end;

end.

