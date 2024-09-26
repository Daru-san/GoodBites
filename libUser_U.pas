// User creation and modification functions and procedures
unit libUser_U;

interface

uses system.SysUtils,conDB, Vcl.Dialogs,libUtils_U,Classes,Math,StrUtils,controls;

type
  TUser = class(TObject)
  private
    FUsername : string;
    FIsAdmin : boolean;
    FUserID : string;
    FLoggedIn : boolean;
    FDailyCalories : integer;
    FFullname : string;
    FAge : integer;

    // User creation
    function GenerateUserID(sUsername:string): string;
    function CheckUserID(sUserID:string) : boolean;
    function CheckUsername(sUsername:string) : boolean;
    function CheckPassword(sPassword:string):Boolean;
    function CheckDatabase(sUsername:string):boolean;
    function CheckUserExisting(sUsername:string):Boolean;
    function WriteUserPassFile(sUsername,sPassword:string): boolean;

    procedure RegisterUserInDB(sPassword,sUsername,userID : string);

    // User Login
    function DeleteUserPassFile(sUsername :string) :boolean;
    function CheckPresence(sPassword:string): boolean;
    function CheckLoginDetails(sPassword: string): boolean;
    function CheckAdmin(sUserID : string) : boolean;
    function GetUserID:string;
    function GetLastLogin:string;
    function GetUsername : string;

    procedure SaveLastLogin(userID : string; userIsAdmin : Boolean);
  public
    constructor Create(Username : string);
    destructor Destroy; override;

    property isAdmin: Boolean read FIsAdmin write FIsAdmin;
    property Username: string read FUsername write FUsername;
    property Fullname: string read FFullname write FFullname;
    property Age: Integer read FAge write FAge;
    property UserID: string read FUserID write FUserID;

    // Used by external procedures to get user login information
    function CheckLogin : boolean;
    function GetFirstLogin : boolean;

    // Meal related procedures
    function GetDailyCalories(currentDate:Tdate):integer;
    function GetTotalMeals:integer;
    function GetMealInfo(mealIndex: Integer;infoType : String = ''): string;

    procedure AddCalories(numCalories : Integer);

    // User modification: creation,deletion and login
    procedure ChangeUsername(sNewUsername: string);
    procedure RemoveUser(userID : string);
    procedure Login(sPassword:String);
    procedure SignUp(sPassword:String);

    procedure SaveUserInfo(sFullname : string;iAge : integer);
  end;

  var
    isFailed : boolean;
    loggerObj : TLogs;
    UtilObj : TUtils;

    // Stores all accumulated user-creation errors
    // An array would not work since the number of errors can change
    errorsList : TStringList;
implementation

{ The main constructor and destructor }
{$REGION constructor}

// Creates an empty user object
// Data is populated after login
constructor TUser.Create;
begin
  loggerObj := TLogs.Create;
  UtilObj := TUtils.Create;
  FLoggedIn := False;
  FIsAdmin := false;
  UserID := '';
  FUsername := Username;
end;

destructor TUser.Destroy;
begin
  UtilObj.Free;
  loggerObj.Free;
end;
{$ENDREGION}

{ User account creation  }
{$REGION Account creation }

procedure TUser.SignUp;
var
  isUserValid,userInDB, userInPassFile,isPassValid,userExistsing,isCorrect,isPresent: boolean;
  userID : string;
begin
  isUserValid := false;
  userExistsing := False;
  isPassValid := False;
  isCorrect := false;

  isPresent := CheckPresence(sPassword);

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
    isUserValid := CheckUsername(Username);
    ShowMessage(isUserValid.ToString);
    if isUserValid then
    begin
      userExistsing := CheckUserExisting(Username);
      if not(userExistsing) then
      begin
        isPassValid := CheckPassword(sPassword);
      end;
    end;
    if not (isPassValid) or not(isUserValid) then
      ShowMessage('User creation errors ' + #13+#13+ errorsList.Text);
  end;
  errorsList.free;

  isCorrect := isPassValid and isUserValid and isPresent and not(userExistsing);

  {
    Process:
    1. generate the user ID
    2. Register the user in the database
    3. Ensure that they exist in the database
    4. Write the user to the passwords file
    5. Log their successful account creation

    If any steps fail logging will be done to let me debug the issue
  }
  if isCorrect then
  begin
    userID := GenerateUserID(Username);
    RegisterUserInDB(sPassword,Username,userID);
    userInDB := CheckDatabase(Username);
    if userInDB then
    begin
      userInPassFile := writeUserPassFile(Username,sPassword);
      if userInPassFile then
      begin
        LoggerObj.WriteUserLog('The user ' + Username + ', uid ' + userID + ' has registered successfully');
        ShowMessage('You have successfully been registered, happy eating!');
      end;
    end
    else
    begin
      LoggerObj.WriteUserLog(
        'The user ' + Username + ',uid ' + userID +
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
  Looping until the ID is completely unique, there may be a better way to do this, but this works for me
}
  isExisting := false;
  repeat
    sUserID := UPPERCASE(sUsername[1] + sUsername[2]) + IntToStr(RandomRange(1,9)) + FormatDateTime('t',now)[2] + FormatDateTime('m',date);
    isExisting := CheckUserID(sUserID);
  until not isExisting;
  Result := sUserID;
end;

function TUser.CheckUserID;
var
  isFound : boolean;
begin
  isFound := false;
  with dmData.tblUsers do
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

{
  Write the user into the passwords file,
  done as a function and not a procedure to do a check if
  the operation was not successful, so that if so
  the user is not added to the database
}
function TUser.WriteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isFileExist, isSuccessful : boolean;
begin

  // The condition here being whether the file exists or not
  // If not then the operation has to be aborted as soon as possible
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
    WriteLn(passFile,Username + '#' + sPassword);
    CloseFile(passFile);
    LoggerObj.WriteUserLog('User ' + Username + ' has been saved in the PASSWORDS file');
    isSuccessful:= true;
  end;
  WriteUserPassFile := isSuccessful;
end;

procedure TUser.RegisterUserInDB;
begin
  with dmData.tblUsers do
  begin
    Open;
    Append;
    FieldValues['userID'] := userID;
    FieldValues['Username'] := Username;
    FieldValues['RegisterDate'] := date;
    FieldValues['isAdmin'] := false;
    FieldValues['Age'] := 0;
    FieldValues['FirstLogin'] := true;
    Post;
    Close;
  end;
end;
{$ENDREGION}

{ User login }
{$REGION USER LOGIN}
// Ensure that the username is the same as in the database
// This prevents quircks from entering capitalized usernames
// That are still valid but misplaced after login
//
procedure TUser.Login;
var
  isCorrect,isValid,passFileExists,isSuccess : boolean;
  sFullName : string;
  iAge : Integer;
begin

  {
    Process:
    1. Validate the user by ensuring data is present
    2. Check if the data is correct(username and password)
    3. Get the user ID, using the username
    4. Check for administrator privilage using the user ID
    5. Get the username from the database to ensure the username is the original
      - Just ensuring if user Mat logs in as MAT, the username remains as Mat
    6. Save the last login entry in the database to the current date and time
    7. Update the logged in status to show that they are logged in incase any other procedure needs that info
      - These procedures being found in the main unit

    On failure:
    1. If username or password are invalid, inform the user to enter them properly
    2. If the username or password are incorrect, inform the user to correct them
  }
  isSuccess := false;
  isValid := CheckPresence(sPassword);

  if isValid then
  begin
    isCorrect := CheckLoginDetails(sPassword);
    if isCorrect then
    begin
      UserID := GetUserID;
      isAdmin := CheckAdmin(UserID);

      if isAdmin then
      if MessageDlg('Log in as a normal user?',mtConfirmation,mbYesNo,0) = mrYes then
       isAdmin := false;

      Username := GetUsername;
      SaveLastLogin(Username,isAdmin);
      isSuccess := true;
    end
    else
    begin
      ShowMessage('The username or password are incorrect');
    end;
  end;

  FUsername := Username;
  FIsAdmin := IsAdmin;
  FLoggedIn := isSuccess;
  if isSuccess then
  begin
    FUserID := UserID;
    FDailyCalories := GetDailyCalories(date);
  end;
end;

function TUser.GetUsername : string;
var
  isFound : Boolean;
  sUsername : string;
begin
  with dmData.tblUsers do
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

function TUser.GetUserId;
var
  sUserId : string;
  isFound : boolean;
begin
  isFound := false;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UpperCase(Username) = UpperCase(FieldValues['Username']) then
      begin
        isFound := true;
        sUserId := FieldValues['UserID'];
      end else Next;
    until Eof or isFound;
    Close;
  end;
  if not isFound then
  ShowMessage('User not found?' + Username);
  result := sUserId;
end;


function TUser.CheckPresence;
var
  isPresent : boolean;
begin

  if Username.isEmpty then
  begin
    ShowMessage('Please enter a username');
    isPresent := false;
  end
    else
  if sPassword.isEmpty then
  begin
    ShowMessage('Please enter a valid password');
    isPresent := false;
  end
   else
    isPresent := true;
  Result := isPresent;
end;

// Check if a user exists in the database already
function TUser.CheckDatabase;
var
  isFound: boolean;
begin
  with dmData.tblUsers do
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

// Check for administrator privilages
function TUser.CheckAdmin;
var
  userIsAdmin,isFound : boolean;
begin
  isAdmin := false;
  with dmData.tblUsers do
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

// Check user details to ensure they exist in the database and the passwords file
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
  inDatabase := CheckDatabase(Username);

  if not inDatabase then
  begin
    ShowMessage('The user ' + Username + ' is not found');
  end
  else
  try
    repeat
      ReadLn(passFile,fileString);
      delPos := pos('#',fileString);
      sUserInFile := copy(fileString,1,delPos-1);
      delete(fileString,1,delPos);
      sPassInFile := fileString;
      if ((UPPERCASE(sUserInFile) = UPPERCASE(Username)) and (sPassInFile = sPassword)) then
        isCorrect := true;
    until EOF(passFile) or isCorrect;
  finally
    CloseFile(passFile);
  end;

  CheckLoginDetails := isCorrect;
end;

// Save the last login parameter in the database as the current date
procedure TUser.SaveLastLogin;
var
  userFound : boolean;
begin
  with dmData.tblUsers do
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
    LoggerObj.WriteUserLog('Administrator ' + Username + ' uid ' + userID + ' logged in.');
  end
  else
  begin
    LoggerObj.WriteUserLog('User ' + Username + ' uid ' + userID + ' logged in.');
  end;
end;
{$ENDREGION}

{ Random used procedures}
{$REGION MISC}
//TODO: Evaluate whether this procedure is needed
function TUser.GetLastLogin: string;
var
  userFound : Boolean;
  sLastLogin : string;
begin
 with dmData.tblUsers do
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


function TUser.CheckLogin;
begin
  result := FLoggedIn;
end;

function TUser.GetFirstLogin;
var
  isFound : Boolean;
begin
  with dmData.tblUsers do
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

// Add extra information from new users on first login
procedure TUser.SaveUserInfo;
var
  userFound : Boolean;
begin
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      userFound := true else next;
    until (Eof) or userFound;
    Edit;
    FieldValues['Fullname'] := sFullname;
    FieldValues['Age'] := iAge;
    FieldValues['FirstLogin'] := false;
    Post;
  end;
end;
procedure TUser.ChangeUsername;
var
  isFound : Boolean;
begin
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
        isFound := true else Next;
    until (Eof) or isFound;
    Edit;
    FieldValues['Username'] := sNewUsername;
    Post;
  end;
end;
{$ENDREGION}

{ User deletion procedures }
{$REGION USER DELETION}
// Still in progress, removing a user from the database
//TODO: Come back to user removal
procedure TUser.RemoveUser;
var
  isFound, isRemoved : boolean;
  sUsername : string;
begin
  with dmData.tblUsers do
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

{
  A very incomplete attempt at removing entries from the passwords file
  The main issue is that the file begings with a `.`, giving it the hidden
  attribute, preventing me from rewriting it.
  I will either rename the file or find a workaround to solve this
}
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

    // Delete the password at the index in the file, e.g line 9
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
{$ENDREGION}

{ Meals }
{$REGION FOOD DATA}
// Calculate the number of calories consumed by a user on a particular day
function TUser.GetDailyCalories(currentDate: TDate): Integer;
var
  eatenDate : TDate;
  numCalories : integer;
begin
  numCalories := 0;
  with dmData.tblMeals do
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

// Increment daily calorie count(for the current day) as needed
procedure TUser.AddCalories(numCalories:integer);
begin
  FDailyCalories := FDailyCalories + numCalories;
end;

// Count the total amount of meals eaten by a user
// Userful in displaying them all by providing an index
// To use when searching for them, knowing where to start and stop
function TUser.GetTotalMeals: Integer;
var
  numMeals : integer;
begin
  numMeals := 0;
  with dmData.tblMeals do
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

// Get information on a specific meal eaten by the user, i.e the food they ate, time they ate it
function TUser.GetMealInfo(mealIndex: Integer;infoType : String = ''): string;
var
  sFoodName,sMealType : string;
  eatenDate,eatenTime : TDate;
  isMealFound : boolean;
begin
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        if mealIndex = FieldValues['UserMealID'] then
        begin
          isMealFound := true;
          eatenDate := FieldValues['DateEaten'];
          eatenTime := FieldValues['TimeEaten'];
          sFoodName := FieldValues['FoodName'];
          sMealType := FieldValues['MealType'];
        end else next;
      end else next;
    until EOF or isMealFound;
    Close;
  end;

  // Breakfast is not a valid date!
  // Infotype dictates the type of information we are to return based on a few options
  case IndexStr(LowerCase(infoType),['name','type','date','time']) of
  0 : Result := sFoodName;
  1 : Result := sMealType;
  2 : Result := DateToStr(eatenDate);
  3 : Result := FormatDateTime('tt',eatenTime);
  end;
end;
{$ENDREGION}
end.
