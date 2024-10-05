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
    FActivityLevel : Real;
    FHeight : real;
    FWeight : Real;

    // User creation
    function CheckUserID(pUserID:string) : boolean;
    function CheckUsername(pUsername:string) : boolean;
    function CheckPassword(pPassword:string):Boolean;
    function CheckDatabase(pUsername:string):boolean;
    function CheckUserExisting(pUsername:string):Boolean;
    function WriteUserPassFile(pUsername,pPassword:string): boolean;

    procedure RegisterUserInDB(pPassword : string);
    procedure GenerateUserID;

    // User Login
    function CheckPresence(pPassword:string): boolean;
    function CheckLoginDetails(pPassword: string): boolean;

    procedure DeleteUserPassFile;
    procedure GetUsername;
    procedure SetAdmin;
    procedure GetUserID;

    procedure SaveLastLogin;
  public
    constructor Create(Username : string);
    destructor Destroy; override;

    property isAdmin: Boolean read FIsAdmin write FIsAdmin;
    property Username: string read FUsername write FUsername;
    property Fullname: string read FFullname write FFullname;
    property Age: Integer read FAge write FAge;
    property UserID: string read FUserID write FUserID;
    property ActivityLevel : Real read FActivityLevel write FActivityLevel;
    property Height: real read FHeight write FHeight;
    property Weight: real read FWeight write FWeight;

    // Used by external procedures to get user login information
    function CheckLogin : boolean;
    function GetFirstLogin : boolean;

    // Meal related procedures
    function GetDailyCalories(pDate:Tdate):integer;
    function CalcTotalCalories : Real;
    function GetMealCount(pDate : TDate): Integer;
    function GetTotalMeals : Integer;
    function GetMealInfo(pMealIndex: Integer ;pDate : TDate; pInfoType : String = ''): string;

    procedure AddCalories(pCalories : Integer);

    // User modification: creation,deletion and login
    procedure ChangeUsername(pUsername: string);
    procedure RemoveUser(pUserID : string);
    procedure Login(pPassword:String);
    procedure SignUp(pPassword:String);
    procedure CompleteSignUp;

    procedure SaveUserInfo;
    procedure GetUserInfo;
  end;

  var
    LogService : TLogService;
    FileUtils : TFileUtils;

    // Stores all accumulated user-creation errors
    // An array would not work since the number of errors can change
    AccountErrors : TStringList;

implementation

{ The main constructor and destructor }
{$REGION constructor}

// Creates an empty user object
// Data is populated after login
constructor TUser.Create;
begin
  LogService := TLogService.Create;
  FileUtils := TFileUtils.Create;
  FLoggedIn := False;
  FIsAdmin := false;
  UserID := '';
  FUsername := Username;
end;

destructor TUser.Destroy;
begin
  FileUtils.Free;
  LogService.Free;
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

  isPresent := CheckPresence(pPassword);

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
    AccountErrors := TStringList.Create;
    isUserValid := CheckUsername(Username);
    ShowMessage(isUserValid.ToString);
    if isUserValid then
    begin
      userExistsing := CheckUserExisting(Username);
      if not(userExistsing) then
      begin
        isPassValid := CheckPassword(pPassword);
      end;
    end;
    if not (isPassValid) or not(isUserValid) then
      ShowMessage('User creation errors ' + #13+#13+ AccountErrors.Text);
  end;
  AccountErrors.free;

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
    GenerateUserID;
    RegisterUserInDB(pPassword);
    userInDB := CheckDatabase(Username);
    if userInDB then
    begin
      WriteUserPassFile(Username,pPassword);
      LogService.WriteUserLog('The user ' + Username + ', uid ' + userID + ' has registered successfully');
      ShowMessage('You have successfully been registered, happy eating!');
    end
    else
    begin
      LogService.WriteUserLog(
        'The user ' + Username + ',uid ' + userID +
        ' attempted to register, but were not found in the database afterward.'
        + #13 + #9 + 'Something must have gone wrong'
      );
      ShowMessage('Some error occured and user registration has failed.' + #13 + 'Please try again');
    end;
  end;
end;

function TUser.CheckPassword(pPassword:string):Boolean;
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
  if (pPassword.length < 2) or (pPassword.Length > 20) then
  begin
    isLong := false;
    AccountErrors.Add('Password must be between 3 to 20 characters in length');
  end else isLong := true;

  //Ensure presence of upper and lower case characters and numbers, special characters are optional
  for I := 1 to pPassword.Length do
  begin

    if pPassword[i] in LOWERCHARS then
    begin
      hasLowcase := true;
    end;

    if pPassword[i] in UPPERCHARS then
    begin
      hasUpcase := true;
    end;

    if pPassword[i] in NUMBERS then
    begin
      hasNumbers := true;
    end;

    // Ensure no characters outside of the valid range are present, being letters, numbers and certain characters
    if pPassword[i] in VALIDCHARS then
    begin
      hasValidChars := true;
    end;
  end;

  if (not hasLowcase) or (not hasUpcase) then
  AccountErrors.Add('Password must contain uppercase and lowercase characters');

  if not hasNumbers then
  AccountErrors.Add('Password must contain a number');

  // Special characters are optional but restricted to a range
  if not hasValidChars then
  AccountErrors.Add('Password can numbers, letters and any of the special characters ' + '.,,,/,\,(,),!,@,#,%,&,*');

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
  if (pUsername.Length < 2) or (pUsername.Length > 10) then
  begin
    AccountErrors.Add('Username must be between 2 and 10 characters in length');
    isLong := false;
  end else isLong := True;

  // Ensuring username has no characters outside of the range of letters and numbers
  for i := 1 to pUsername.Length do
  begin
    if pUsername[i] in VALIDCHARS then
    begin
      hasValidChars := true;
    end;
    if not (pUsername[i] in VALIDCHARS) then
    begin
      hasExtraChars := true;
    end;
  end;
  // Ensure that characters are only numbers and letters
  if (hasValidChars and hasExtraChars) or hasExtraChars or (not hasValidChars) then
  AccountErrors.Add('Username must only have letters and numbers, special characters are not allowed');

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
  isUserDatabase := CheckDatabase(pUsername);
  if FileUtils.CheckFileExists(FILENAME) then
  begin
    AssignFile(passFile,FILENAME);
    Reset(passFile);
    repeat
      Readln(passFile,fileString);

      // Get the delimiter position
      delimPos := pos('#',fileString);

      // Copy the username in the file
      sUserinFile := Copy(fileString,1,delimPos-1);

      if UpperCase(sUserinFile) = UpperCase(pUsername) then
      begin
        hasPassword := true;
      end;
    until Eof(passFile) or hasPassword;
    CloseFile(passFile);
  end;

  if isUserDatabase or hasPassword then
  begin
    ShowMessage('The user ' + pUsername + ' already exists');
  end;
  Result := isUserDatabase or hasPassword;
end;

procedure TUser.GenerateUserID;
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
    sUserID := UPPERCASE(Username[1] + Username[2]) + IntToStr(RandomRange(1,9)) + FormatDateTime('t',now)[2] + FormatDateTime('m',date);
    isExisting := CheckUserID(sUserID);
  until not isExisting;
  UserID := sUserID;
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
      if pUserID = FieldValues['UserID'] then
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
  if not TFileUtils.Create.CheckFileExists(FILENAME) then
  begin
    LogService.WriteSysLog(
      'User register attempted, but the password file is missing' + #13
      + #9 + 'This may cause errrors, manual intervention is required'
    );
    ShowMessage('An unkown error occured');
    isSuccessful := false;
  end else
  begin
    AssignFile(passFile,FILENAME);
    Append(passFile);
    WriteLn(passFile,Username + '#' + pPassword);
    CloseFile(passFile);
    LogService.WriteUserLog('User ' + Username + ' has been saved in the PASSWORDS file');
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
    FieldValues['userID'] := UserID;
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
  isValid := CheckPresence(pPassword);

  if isValid then
  begin
    isCorrect := CheckLoginDetails(pPassword);
    if isCorrect then
    begin
      GetUserID;
      SetAdmin;
      GetUsername;

      if isAdmin then
      if MessageDlg('Log in as a normal user?',mtConfirmation,mbYesNo,0) = mrYes then
       isAdmin := false;

      SaveLastLogin;

      if not GetFirstLogin then
        GetUserInfo;

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

procedure TUser.GetUsername;
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
        Username := FieldValues['Username'];
      end else Next;
    until eof or isFound;
    Close;
  end;
end;

procedure TUser.GetUserID;
var
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
        UserID := FieldValues['UserID'];
      end else Next;
    until Eof or isFound;
    Close;
  end;
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
  if pPassword.isEmpty then
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
      if UPPERCASE(FieldValues['Username']) = UPPERCASE(pUsername) then isFound := true;
      Next;
    Until EOF or isFound;
    Close;
  end;
  CheckDatabase := isFound;
end;

// Check for administrator privilages
procedure TUser.SetAdmin;
var
  isFound : boolean;
begin
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
    if FieldValues['UserID'] = UserID then
    begin
      isFound := true;
      isAdmin := FieldValues['isAdmin'];
    end else Next;
    until (EOF or isFound);
    Close;
    if not isFound then
      isAdmin := false;
  end;
end;

// Check user details to ensure they exist in the database and the passwords file
function TUser.CheckLoginDetails;
const
FILENAME = '.passwords';
var
  tfPasswords : textfile;
  sLine, sUserInFile, sPassInFile : string;
  isFound,inDatabase : boolean;
  delPos : integer;
begin
  AssignFile(tfPasswords,filename);
  isFound := false;

  if not FileUtils.CheckFileExists(FILENAME) then
  begin
    ShowMessage('An unkown error ocurred, please contact an administrator');
    LogService.WriteSysLog('The passwords file was needed but not found');
    Result := false;
    exit;
  end;

  Reset(tfPasswords);

  inDatabase := CheckDatabase(Username);

  if not inDatabase then
  begin
    ShowMessage('The user ' + Username + ' is not found');
  end
  else
  try
    repeat
      ReadLn(tfPasswords,sLine);
      delPos := pos('#',sLine);
      sUserInFile := copy(sLine,1,delPos-1);
      delete(sLine,1,delPos);
      sPassInFile := sLine;
      if ((UpperCase(sUserInFile) = UpperCase(Username)) and (sPassInFile = pPassword)) then
        isFound := true;
    until EOF(tfPasswords) or isFound;
  finally
    CloseFile(tfPasswords);
  end;

  Result := isFound;
end;

// Save the last login parameter in the database as the current date
procedure TUser.SaveLastLogin;
var
  isFound : boolean;
begin
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UpperCase(FieldValues['UserID']) = UpperCase(userID) then
      begin
        isFound := true;
        Edit;
        FieldValues['LastLogin'] := date;
        Post;
      end
      else Next;
    until EOF or isFound;
    Close;
  end;

  if isAdmin then
  begin
    LogService.WriteUserLog('Administrator ' + Username + ' uid ' + userID + ' logged in.');
  end
  else
  begin
    LogService.WriteUserLog('User ' + Username + ' uid ' + userID + ' logged in.');
  end;
end;
{$ENDREGION}

{ Random used procedures}
{$REGION MISC}
procedure TUser.CompleteSignUp;
var isFound : Boolean;
begin
  isFound := false;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
        isFound := true
      else next;
    until EOF or isFound;
    if isFound then
    begin
      Edit;
      FieldValues['FirstLogin'] := False;
      Post;
    end;
    Close;
  end;
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
      begin
        isFound := true;
        Result := FieldValues['FirstLogin'];
      end
      else next;
    until EOF or isFound;
    Close;
  end;
end;

// Add extra information from new users on first login
procedure TUser.SaveUserInfo;
var
  isFound : Boolean;
begin
  isFound := false;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        isFound := true;
        Edit;
        FieldValues['Fullname'] := Fullname;
        FieldValues['Age'] := Age;
        FieldValues['Height'] := Height;
        FieldValues['Weight'] := Weight;
        FieldValues['ActivityLevel'] := ActivityLevel;
        Post;
      end else next
    until (Eof) or isFound;
    Close;
  end;
end;

procedure TUser.GetUserInfo;
var
  isFound : Boolean;
begin
  isFound := false;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
        isFound := true
      else next;
    until EOF or isFound;

    if isFound then
    begin
      Fullname := FieldValues['Fullname'];
      Age := FieldValues['Age'];
      Height := FieldValues['Height'];
      Weight := FieldValues['Weight'];
      ActivityLevel := FieldValues['ActivityLevel'];
    end;
    Close;
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
        isFound := true
      else Next;
    until (Eof) or isFound;
    if isFound then
    begin
      Edit;
      FieldValues['Username'] := pUsername;
      Post;
    end;
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
begin
 { with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if FieldValues['UserID'] = userID then
        isFound := true
      else Next;
    until EOF or isFound;
    sUsername := FieldValues['Username'];

    isRemoved := DeleteUserPassFile(Username);
    if isRemoved then
    begin
      Delete;
      Post;
      loggerObj.WriteUserLog('User ' + sUsername + ', uid ' + userID + ' was removed completely');
    end;
  end; }
end;

{
  A very incomplete attempt at removing entries from the passwords file
  The main issue is that the file begings with a `.`, giving it the hidden
  attribute, preventing me from rewriting it.
  I will either rename the file or find a workaround to solve this
}
procedure TUser.DeleteUserPassFile;
const FILENAME = '.passwords';
var
  passFile : textfile;
  isSuccessful : boolean;
  passList : TStringList;
  indexNum : integer;
begin
  if not FileUtils.CheckFileExists(FILENAME) then
  begin
    LogService.WriteSysLog('User deletion attempted, but the password file is missing or corrupted');
    ShowMessage('An unkown error occured');
    isSuccessful := false;
  end else
  begin
    passList := TStringList.Create;
    passList.LoadFromFile(FILENAME);
    passList.NameValueSeparator := '#';

    // Delete the password at the index in the file, e.g line 9
    indexNum := passList.IndexOfName(Username);
    if (indexNum <> -1) then
    begin
      passList.Delete(indexNum);
      passList.SaveToFile(FILENAME);
    end;
    passList.Free;
    LogService.WriteSysLog('Entry for user ' + Username + ' was removed from the passwords file');
    isSuccessful := true;
  end;
end;
{$ENDREGION}

{ Meals }
{$REGION FOOD DATA}
// Calculate the number of calories consumed by a user on a particular day
function TUser.GetDailyCalories(pDate: TDate): Integer;
var
  dEaten : TDate;
  iCalories : integer;
begin
  iCalories := 0;
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        dEaten := FieldValues['DateEaten'];
        if FormatDateTime('dd/mm/yy',pDate) = FormatDateTime('dd/mm/yy',dEaten) then
          iCalories := iCalories + FieldValues['TotalCalories'];
      end;
      Next;
    until EOF;
    Close;
  end;
  Result := iCalories;
end;

// Increment daily calorie count(for the current day) as needed
procedure TUser.AddCalories(pCalories:integer);
begin
  FDailyCalories := FDailyCalories + pCalories;
end;

// Count the total amount of meals eaten by a user
// Userful in displaying them all by providing an index
// To use when searching for them, knowing where to start and stop
function TUser.GetTotalMeals: Integer;
var
  iNumMeals : integer;
begin
  iNumMeals := 0;
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      inc(iNumMeals);
      next;
    until EOF;
    Close;
  end;
  result := iNumMeals;
end;

function TUser.GetMealCount(pDate: TDate): Integer;
var
  iNumMeals : Integer;
begin
  iNumMeals := 0;
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (pDate = FieldValues['DateEaten']) then
        inc(iNumMeals);
      next;
    until EOF;
    Close;
  end;
  Result := iNumMeals;
end;

// Get information on a specific meal eaten by the user, i.e the food they ate, time they ate it
function TUser.GetMealInfo(pMealIndex: Integer;pDate : TDate; pInfoType : String = ''): string;
var
  sFoodName,sMealType : string;
  tEaten : TDate;
  isMealFound : boolean;
  rPortion : Real;
  i : Integer;
begin
  i := 1;
  isMealFound := false;
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if (UserID = FieldValues['UserID']) and (pDate = FieldValues['DateEaten']) then
      begin
        if (pMealIndex = i) then
        begin
          isMealFound := true;
          tEaten := FieldValues['TimeEaten'];
          sFoodName := FieldValues['MealName'];
          sMealType := FieldValues['MealType'];
          rPortion := FieldValues['PortionSize'];
        end
        else
        begin
          next;
          inc(i);
        end;
      end else next;
    until EOF or isMealFound;
    Close;
  end;

  // Breakfast is not a valid date!
  // Infotype dictates the type of information we are to return based on a few options
  case IndexStr(LowerCase(pInfoType),['name','type','time','portion']) of
  0 : Result := sFoodName;
  1 : Result := sMealType;
  2 : Result := FormatDateTime('tt',tEaten);
  3 : Result := FloatToStr(rPortion);
  else
  begin
    ShowMessage('GetMealInfo() parameter is not one of: name, type, time or portion');
  end;
  end;
end;


function TUser.CalcTotalCalories;
var
  rTotalCalories : REAL;
begin
  { Formula = 10 * weight + 6.25 * height + 5 * age }
  //TODO: Add calculations based on biological sex
  rTotalCalories := (10*Weight) + (6.25 * Height) + (5*Age);
  Result := rTotalCalories * ActivityLevel;
end;
{$ENDREGION}
end.
