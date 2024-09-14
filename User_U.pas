// User creation and modification functions and procedures
unit User_U;

interface

uses system.SysUtils,conDBBites, Vcl.Dialogs, Utils_U,Classes,Math;

type
  TUser = class(TObject)
  private
    Fusername : string;
    FisAdmin : boolean;
    FUserID : string;
    FLoggedIn : boolean;
    FPassword : string;
    FDailyCalories : integer;
    FFullname : string;
    FAge : integer;

    function GenerateUserID(sUsername:string): string;
    function CheckUserID(sUserID:string) : boolean;
    function CheckUsername(sUsername:string) : boolean;
    function CheckDatabase(sUsername:string):boolean;
    function WriteUserPassFile(sUsername,sPassword:string): boolean;
    function DeleteUserPassFile(sUsername :string) :boolean;
    function CheckPresence(sUsername,sPassword:string): boolean;
    function CheckLoginDetails(sUsername: string; sPassword: string): boolean;
    function CheckAdmin(sUserID : string) : boolean;
    function GetUserId(sUsername:string):string;
    function CheckPassword(sPassword:string):Boolean;
    function CheckUserExisting(sUsername:string):Boolean;
    function GetLastLogin:string;
    function GetUsername : string;

    procedure SaveLastLogin(sUsername,userID : string; userIsAdmin : Boolean);
    procedure CreateUser(sUsername,sPassword: string);
    procedure RegisterUserInDB(sPassword,sUsername,userID : string);
  public
    constructor Create(sUsername : string;Password:string;NewUser:Boolean = false;LoggingIn : boolean = true);

    property isAdmin: Boolean read FisAdmin write FisAdmin;
    property Username: string read Fusername write Fusername;
    property Fullname: string read FFullname write FFullname;
    property Age: Integer read FAge write FAge;
    property UserID: string read FUserID write FUserID;

    function CheckLogIn : boolean;
    function GetFirstLogin : boolean;
    function GetDailyCalories(currentDate:Tdate):integer;
    function GetTotalMeals:integer;
    function GetMeal(mealIndex: Integer;ValueIndex:integer = 0): string;


    procedure RemoveUser(userID : string);
    procedure AddCalories(numCalories : Integer);
    procedure SaveUserInfo(sUserID,sFullname : string;iAge : integer);
  end;

  var
    isFailed : boolean;
    loggerObj : TLogs;
    UtilObj : TUtils;

    // Stores all accumulated user-creation errors
    errorsList : TStringList;
implementation

constructor TUser.Create;
var
  isCorrect,isValid,passFileExists,loginSuccessful : boolean;
  sFullName : string;
  iAge : Integer;
begin
  loggerObj := TLogs.Create;
  UtilObj := TUtils.Create;
  loginSuccessful := false;

  if NewUser then
  begin
    CreateUser(sUsername,Password);
  end;

  if LoggingIn then
  begin
    isValid := CheckPresence(sUsername,Password);

    if isValid then
    begin
      isCorrect := CheckLoginDetails(sUsername,Password);
      if isCorrect then
      begin
        UserID := GetUserID(sUsername);
        isAdmin := CheckAdmin(UserID);
        Username := GetUsername;
        SaveLastLogin(Username,UserID,isAdmin);
        loginSuccessful := true;
      end
      else
      begin
        ShowMessage('The username or password are incorrect');
      end;
      // end if
    end;
  end else
  begin
    UserID := 'Bob';
    FisAdmin := false;
    loginSuccessful := false;
  end;

  Fusername := Username;
  FisAdmin := IsAdmin;
  FLoggedIn := loginSuccessful;
  if loginSuccessful then
  begin
    FPassword := Password;
    FUserID := UserID;
    FDailyCalories := GetDailyCalories(date);
  end;
function TUser.GetUsername : string;
var
  isFound : Boolean;
  sUsername : string;
begin
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        isFound := true;
        sUsername := FieldValues['Username'];
      end else Next;
    until eof or isFound;
    Close;
  end;
  Result := sUsername;
end;

function TUser.CheckLogin;
begin
  result := FLoggedIn;
end;

function TUser.GetFirstLogin;
var
  isFound : Boolean;
begin
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
        isFound := true
      else next;
    until EOF or isFound;
    Result := FieldValues['FirstLogin'];
    Close;
  end;
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
      if UpperCase(sUsername) = UpperCase(FieldValues['Username']) then
      begin
        isFound := true;
        sUserId := FieldValues['UserID'];
      end else Next;
    until Eof or isFound;
    Close;
  end;
  if not isFound then
  ShowMessage('User not found?' + sUsername);
  result := sUserId;
end;

// Add extra information from new users on first login
procedure TUser.SaveUserInfo;
var
  userFound : Boolean;
begin
  with dbmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if sUserID = FieldValues['UserID'] then
      userFound := true else next;
    until (Eof) or userFound;
    Edit;
    FieldValues['Fullname'] := sFullname;
    FieldValues['Age'] := iAge;
    FieldValues['FirstLogin'] := false;
    Post;
  end;
end;

{ Account creation }

procedure TUser.CreateUser;
var
  isUserValid,userInDB, userInPassFile,isPassValid,userExistsing,isCorrect,isPresent: boolean;
  userID : string;
begin
  isUserValid := false;
  userExistsing := False;
  isPassValid := False;
  isCorrect := false;

  isPresent := CheckPresence(sUsername,sPassword);

  {
    Steps, if one of these fails the process stops
    -> Check if the username and password are present
    -> Check if the username is valid
    -> Check if the user exists
    -> Check if the password is valid
    -> Show error message if username or password is invalid
  }
  if isPresent then
  begin
    errorsList := TStringList.Create;
    isUserValid := CheckUsername(sUsername);
    ShowMessage(isUserValid.ToString);
    if isUserValid then
    begin
      userExistsing := CheckUserExisting(sUsername);
      if not(userExistsing) then
      begin
        isPassValid := CheckPassword(sPassword);
      end;
    end;
    if not (isPassValid) or not(isUserValid) then
      ShowMessage('User creation errors ' + #13+#13+ errorsList.Text);
  end;

  isCorrect := isPassValid and isUserValid and isPresent and not(userExistsing);

  if isCorrect then
  begin
    userID := GenerateUserID(sUsername);
    RegisterUserInDB(sPassword,sUsername,userID);
    userInDB := CheckDatabase(sUsername);
    if userInDB then
    begin
      userInPassFile := writeUserPassFile(sUsername,sPassword);
      if userInPassFile then
      begin
        LoggerObj.WriteUserLog('The user ' + sUsername + ', uid ' + userID + ' has registered successfully');
        ShowMessage('You have successfully been registered, happy eating!');
      end;
    end
    else
    begin
      LoggerObj.WriteUserLog(
        'The user ' + sUsername + ',uid ' + userID +
        ' attempted to register, but were not found in the database afterward.'
        + #13 + #9 + 'Something must have gone wrong'
      );
      ShowMessage('Some error occured and user registration has failed.' + #13 + 'Please try again');
    end;
  end;
end;

function TUser.CheckPassword(sPassword:string):Boolean;
const
  LOWERCHARS = ['a'..'z'];
  UPPERCHARS = ['A'..'z'];
  NUMBERS = ['0'..'9'];
  SPECIALCHARS = ['.',',','/','\','!','@','#','%','&','*','(',')'];
  VALIDCHARS = LOWERCHARS + UPPERCHARS + NUMBERS + SPECIALCHARS;
var
  hasUpcase,hasLowcase,hasNumbers,isValid,hasSpecial,isLong,hasValidChars : boolean;
  I: Integer;
begin
  hasUpcase := false;
  hasLowcase := False;
  hasNumbers := False;
  hasSpecial := False;
  isValid := false;
  hasValidChars := False;

  //Ensure password is between 2 and 20 characters
  if (sPassword.length < 2) or (sPassword.Length > 20) then
  begin
    isLong := false;
    errorsList.Add('Password must be between 3 to 20 characters in length');
  end else isLong := true;

  //Ensure presence of upper and lower case characters and numbers, special characters are optional
  for I := 1 to sPassword.Length do
  begin

    if sPassword[i] in LOWERCHARS then
    begin
      hasLowcase := true;
    end;

    if sPassword[i] in UPPERCHARS then
    begin
      hasUpcase := true;
    end;

    if sPassword[i] in NUMBERS then
    begin
      hasNumbers := true;
    end;

    // Ensure no characters outside of the valid range are present, being letters, numbers and certain characters
    if sPassword[i] in VALIDCHARS then
    begin
      hasValidChars := true;
    end;
  end;

  if (not hasLowcase) or (not hasUpcase) then
  errorsList.Add('Password must contain uppercase and lowercase characters');

  if not hasNumbers then
  errorsList.Add('Password must contain a number');

  // Special characters are optional but restricted to a range
  if not hasValidChars then
  errorsList.Add('Password can numbers, letters and any of the special characters ' + '.,,,/,\,(,),!,@,#,%,&,*');

  // If the password has upper and lower case letters, numbers, valid characters and is of good length
  result := hasLowcase and hasLowcase and hasNumbers and hasValidChars and isLong;
end;

function TUser.CheckUsername;
const
  // Set of characters that must be in the username
  VALIDCHARS = ['A'..'Z','a'..'z','0'..'9'];
var
  isLong,hasValidChars,hasExtraChars : Boolean;
  i: Integer;
begin
  isLong := false;
  hasValidChars := false;
  hasExtraChars := false;

  //Ensure username is between 2 and 10 characters
  if (sUsername.Length < 2) or (sUsername.Length > 10) then
  begin
    errorsList.Add('Username must be between 2 and 10 characters in length');
    isLong := false;
  end else isLong := True;

  // Ensuring username has no characters outside of the range of letters and numbers
  for i := 1 to sUsername.Length do
  begin
    if sUsername[i] in VALIDCHARS then
    begin
      hasValidChars := true;
    end;
    if not (sUsername[i] in VALIDCHARS) then
    begin
      hasExtraChars := true;
    end;
  end;
  // Ensure that characters are only numbers and letters
  if (hasValidChars and hasExtraChars) or hasExtraChars or (not hasValidChars) then
  errorsList.Add('Username must only have letters and numbers, special characters are not allowed');

  // If the password is long enough, has only numbers and letters
  Result := isLong and hasValidChars and (not hasExtraChars);
end;

function TUser.CheckUserExisting;
const FILENAME = '.passwords';
var
  isUserDatabase,hasPassword : Boolean;
  passFile : TextFile;
  fileString,sUserinFile : string;
  delimPos : Integer;
begin
  hasPassword := false;
  isUserDatabase := CheckDatabase(sUsername);
  if UtilObj.CheckFileExists(FILENAME) then
  begin
    AssignFile(passFile,FILENAME);
    Reset(passFile);
    repeat
      Readln(passFile,fileString);

      // Get the delimiter position
      delimPos := pos('#',fileString);

      // Copy the username in the file
      sUserinFile := Copy(fileString,1,delimPos-1);


      if UpperCase(sUserinFile) = UpperCase(sUsername) then
      begin
        hasPassword := true;
      end;
    until Eof(passFile) or hasPassword;
    CloseFile(passFile);
  end;

  if isUserDatabase or hasPassword then
  begin
    ShowMessage('The user ' + sUsername + ' already exists');
  end;
  Result := isUserDatabase or hasPassword;
end;

function TUser.GenerateUserID;
var
	isExisting : boolean;
  sUserID : string;
begin
	{
		Generate a userID using:
		- A random number with between 1 and 9
		- The current month
		- The current hour, discarding the `1` and `2` if above 9 hours
		- The first two characters of the username
		- Example: Hanzal -> HA759
	}

	{
		Will check if the user ID exists in the database already, incase of multiple users with similar details
		Looping until the ID is completely unique
	}
	isExisting := false;
	repeat
  	sUserID := UPPERCASE(sUsername[1] + sUsername[2]) + IntToStr(RandomRange(1,9)) + FormatDateTime('t',now)[2] + FormatDateTime('m',date);
		isExisting := CheckUserID(sUserID);
	until not isExisting;
  Result := sUserID;
end;

// Check if a UserID already exists in the database
function TUser.CheckUserID;
var
	isFound : boolean;
begin
	isFound := false;
	with dbmData.tblUsers do
	begin
    Open;
		First;
		repeat
			if sUserID = FieldValues['UserID'] then
			begin
				isFound := true;
			end else next;
		until EOF or isFound;
	end;
	Result := isFound;
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
    WriteLn(passFile,sUsername + '#' + sPassword);
    CloseFile(passFile);
    LoggerObj.WriteUserLog('User ' + sUsername + ' has been saved in the PASSWORDS file');
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
    indexNum := passList.IndexOfName(sUsername);
    if (indexNum <> -1) then
    begin
      passList.Delete(indexNum);
      passList.SaveToFile(FILENAME);
    end;
    passList.Free;
    LoggerObj.WriteSysLog('Entry for user ' + sUsername + ' was removed from the passwords file');
    isSuccessful := true;
  end;
end;


procedure TUser.RegisterUserInDB;
begin
  with dbmData.tblUsers do
  begin
    Open;
    Append;
    FieldValues['userID'] := userID;
    FieldValues['Username'] := sUsername;
    FieldValues['RegisterDate'] := date;
    FieldValues['isAdmin'] := false;
    FieldValues['Age'] := 0;
    FieldValues['FirstLogin'] := true;
    Post;
    Close;
  end;

end;

function TUser.CheckPresence;
var
  isValid : boolean;
begin

  if sUsername.isEmpty then
  begin
    ShowMessage('Please enter a username');
    isValid := false;
  end
    else
  if sPassword.isEmpty then
  begin
    ShowMessage('Please enter a valid password');
    isValid := false;
  end
   else
    isValid := true;
  CheckPresence := isValid;
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
      if UPPERCASE(FieldValues['Username']) = UPPERCASE(sUsername) then isFound := true;
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
    if FieldValues['UserID'] = sUserID then
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

function TUser.CheckLoginDetails;
const
FILENAME = '.passwords';
var
  passFile : textfile;
  fileString, sUserInFile, sPassInFile, userInDatabase : string;
  isCorrect,inDatabase : boolean;
  delPos : integer;
begin
  AssignFile(passFile,filename);
  isCorrect := false;

  if not TUtils.Create.CheckFileExists(filename) then
  begin
    ShowMessage('An unkown error ocurred, please contact an administrator');
    loggerObj.WriteSysLog('The passwords file was needed but not found');
    Result := false;
    exit;
  end;

  Reset(passFile);

  isCorrect := false;
  inDatabase := CheckDatabase(sUsername);

  if not inDatabase then
  begin
    ShowMessage('The user ' + sUsername + ' is not found');
  end
  else
  repeat
    ReadLn(passFile,fileString);
    delPos := pos('#',fileString);
    sUserInFile := copy(fileString,1,delPos-1);
    delete(fileString,1,delPos);
    sPassInFile := fileString;
    if ((UPPERCASE(sUserInFile) = UPPERCASE(sUsername)) and (sPassInFile = sPassword)) then
      isCorrect := true;
  until EOF(passFile) or isCorrect;
  CloseFile(passFile);

  CheckLoginDetails := isCorrect;
end;

procedure TUser.SaveLastLogin;
var
  userFound : boolean;
begin
  with dbmData.tblUsers do
  begin
    Open;
    repeat
      if UpperCase(FieldValues['UserID']) = UpperCase(userID) then
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
    LoggerObj.WriteUserLog('Administrator ' + sUsername + ' uid ' + userID + ' logged in.');
  end
  else
  begin
    LoggerObj.WriteUserLog('User ' + sUsername + ' uid ' + userID + ' logged in.');
  end;
end;

function TUser.GetLastLogin: string;
var
  userFound : Boolean;
  sLastLogin : string;
begin
 with dbmData.tblUsers do
 begin
   Open;
   repeat
     if UserID = FieldValues['UserID'] then
     begin
       userFound := true;
       sLastLogin := FieldValues['LastLogin'];
     end else next;
   until EOF or userFound;
   Close;
 end;
  Result := sLastLogin;
end;

procedure TUser.RemoveUser;
var
  isFound, isRemoved : boolean;
  sUsername : string;
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
    sUsername := FieldValues['Username'];

    isRemoved := DeleteUserPassFile(sUsername);
    if isRemoved then
    begin
      Delete;
      Post;
      loggerObj.WriteUserLog('User ' + sUsername + ', uid ' + userID + ' was removed completely');
    end;
  end;
end;

function TUser.GetDailyCalories(currentDate: TDate): Integer;
var
  eatenDate : TDate;
  numCalories : integer;
begin
  numCalories := 0;
  with dbmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        eatenDate := FieldValues['DateEaten'];
        if FormatDateTime('dd/mm/yy',currentDate) = FormatDateTime('dd/mm/yy',eatenDate) then
          numCalories := numCalories + FieldValues['TotalCalories'];
      end;
      Next;
    until EOF;
    Close;
  end;
  Result := numCalories;
end;

procedure TUser.AddCalories(numCalories:integer);
begin
  FDailyCalories := FDailyCalories + numCalories;
end;

function TUser.GetTotalMeals: Integer;
var
  numMeals : integer;
begin
  numMeals := 0;
  with dbmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      inc(numMeals);
      next;
    until EOF;
    Close;
  end;
  result := numMeals;
end;

function TUser.GetMeal(mealIndex: Integer;ValueIndex:integer = 0): string;
var
  sMealName,sMealType : string;
  eatenDate,eatenTime : TDate;
  isMealFound : boolean;
begin
{
  ValueIndex is the index of the specific value one is looking for:
  1 = name of the meal
  2 = Type of mean i.e dinner, breakfast etc.
  3 = Day the meal was eaten
  4 = Time the meal was eaten
  }
  with dbmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        if mealIndex = FieldValues['MealIndex'] then
        begin
          isMealFound := true;
          eatenDate := FieldValues['DateEaten'];
          eatenTime := FieldValues['TimeEaten'];
          sMealName := FieldValues['FoodName'];
          sMealType := FieldValues['MealType'];
        end else next;
      end else next;
    until EOF or isMealFound;
    Close;
  end;
  case ValueIndex of
  1 : Result := sMealName;
  2 : Result := sMealType;
  3 : Result := DateToStr(eatenDate);
  4 : Result := FormatDateTime('tt',eatenTime);
  end;
end;
end.
