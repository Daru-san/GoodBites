// User creation and modification functions and procedures
unit libUser_U;

interface

uses system.SysUtils,conDB, Vcl.Dialogs,libUtils_U,Classes,Math,StrUtils,controls, libGoals_U;

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
    FGender : String;

    // User creation
    function CheckUserID(pUserID:string) : boolean;
    function CheckUsername(pUsername:string) : boolean;
    function ValidatePassword(pPassword:string):Boolean;
    function CheckDatabase(pUsername:string):boolean;
    function CheckUserExisting(pUsername:string):Boolean;
    function WriteUserPassFile(pUsername,pPassword:string): boolean;
    function ValidateUserDetails(pPassword:string) : Boolean;
    function AddUser(pPassword:String) : Boolean;

    procedure RegisterUserInDB(pPassword : string);
    procedure GenerateUserID;

    // User Login
    function CheckPresence(pPassword:string): boolean;
    function CheckLoginDetails(pPassword: string): boolean;
    function CheckPassword(pPassword : String = ''): Boolean;


    procedure GetUsername;
    procedure SetAdmin;
    procedure GetUserID;
    procedure SaveLastLogin;

    // Deleting users
    procedure DeletePassword;
    procedure RemoveUserDB;
    procedure DeleteGoals;
    procedure DeleteMeals;
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
    property Gender: String read FGender write FGender;

    // Used by external procedures to get user login information
    function CheckLogin : boolean;
    function CheckFirstLogin : boolean;
    function GetRegisterDate : TDate;

    // Meal related procedures
    function GetDailyCalories(pDate:Tdate):integer;
    function CalcTotalCalories : Real;
    function GetMealCount(pDate : TDate): Integer;
    function GetTotalMeals : Integer;
    function GetMealInfo(pMealIndex: Integer ;pDate : TDate; pInfoType : String = ''): string;

    procedure AddCalories(pCalories : Integer);

    // User modification: creation,deletion and login
    procedure ChangeUsername(pUsername: string);
    procedure Login(pPassword:String);
    function SignUp(pPassword:String) : Boolean;
    procedure CompleteSignUp;
    procedure DeleteUser(pUserID:String);

    procedure SaveUserInfo;
    procedure GetUserInfo;
  end;

  const PASSWORDFILE = 'passwords';
  var
    LogService : TLogService;
    FileUtils : TFileUtils;

    // Stores all accumulated user-creation errors
    // An array would not work since the number of errors can change
    slsAccountErrors : TStringList;

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

function TUser.SignUp(pPassword: string): Boolean;
var
  isPresent, isValid, isAdded : boolean;
begin
  isAdded := false;
  isValid := false;

  isPresent := CheckPresence(pPassword);

  if isPresent then
    isValid := ValidateUserDetails(pPassword);

  if isValid then
    isAdded := AddUser(pPassword);

  if isAdded then
  begin
    LogService.WriteUserLog('The user ' + Username + ', uid ' + userID + ' has registered successfully');
    ShowMessage('You have successfully been registered, happy eating!');
  end;
  Result := isAdded;
end;

function TUser.AddUser(pPassword: string) : Boolean;
var
  isAdded, hasPassword, isDatabase : Boolean;
begin
  isAdded := false;
  GenerateUserID;

  RegisterUserInDB(pPassword);
  isDatabase := CheckDatabase(Username);
  hasPassword := WriteUserPassFile(Username,pPassword);

  // If the user is in the database but password creation failed, delete them from the database
  if isDatabase and not(hasPassword) then
    RemoveUserDB;

  // If the user has a password but is not in the database, delete them from the password file
  if hasPassword and not(isDatabase) then
    DeletePassword;

  if isDatabase and hasPassword then
    isAdded := true;
  Result := isAdded;
end;

function TUser.ValidateUserDetails(pPassword: string): Boolean;
var
  isUsername,isExisting,isPassword, isValid : Boolean;
begin
  slsAccountErrors := TStringList.Create;
  isUsername := CheckUsername(Username);

  if isUsername then
  begin
    isExisting := CheckUserExisting(Username);
    if not(isExisting) then
    begin
      isPassword := ValidatePassword(pPassword);
    end;
  end;

  isValid := isUsername and isPassword;
  if not isValid then
    ShowMessage('User creation errors ' + #13 + #13+ slsAccountErrors.Text);
  slsAccountErrors.free;
  Result := isValid;
end;

function TUser.ValidatePassword(pPassword:string):Boolean;
const
  LOWERCHARS = ['a'..'z'];
  UPPERCHARS = ['A'..'z'];
  NUMBERS = ['0'..'9'];
  SPECIALCHARS = ['.',',','/','\','!','@','#','%','&','*','(',')'];
  VALIDCHARS = LOWERCHARS + UPPERCHARS + NUMBERS + SPECIALCHARS;
var
  hasUpcase,
  hasLowcase,
  hasNumbers,
  isValid,
  hasSpecial,
  isLong,
  hasInValidChars : boolean;
  I: Integer;
begin
  hasUpcase := false;
  hasLowcase := False;
  hasNumbers := False;
  hasSpecial := False;
  isValid := false;
  hasInValidChars := False;

  //Ensure password is between 8 and 20 characters
  if (pPassword.length < 8) or (pPassword.Length > 20) then
  begin
    isLong := false;
    slsAccountErrors.Add('Password must be between 8 to 20 characters in length');
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
    if not (pPassword[i] in VALIDCHARS) then
    begin
      hasInValidChars := true;
    end;
  end;

  if (not hasLowcase) or (not hasUpcase) then
  slsAccountErrors.Add('Password must contain uppercase and lowercase characters');

  if not hasNumbers then
  slsAccountErrors.Add('Password must contain a number');

  // Special characters are optional but restricted to a range
  if hasInValidChars then
  slsAccountErrors.Add('Password can numbers, letters and any of the special characters ' + '.,,,/,\,(,),!,@,#,%,&,*');

  // If the password has upper and lower case letters, numbers, valid characters and is of good length
  result := hasLowcase and hasLowcase and hasNumbers and (not hasInValidChars) and isLong;
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

  //Ensure username is between 2 and 12 characters
  if (pUsername.Length < 2) or (pUsername.Length > 12) then
  begin
    slsAccountErrors.Add('Username must be between 2 and 12 characters in length');
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
  slsAccountErrors.Add('Username must only have letters and numbers, special characters and spaces are not allowed');

  // If the password is long enough, has only numbers and letters
  Result := isLong and hasValidChars and (not hasExtraChars);
end;

function TUser.CheckUserExisting;
var
  isUserDatabase,hasPassword : Boolean;
begin
  hasPassword := false;
  isUserDatabase := CheckDatabase(pUsername);
  hasPassword := CheckPassword;

  if isUserDatabase or hasPassword then
  begin
    ShowMessage('The user ' + pUsername + ' already exists');
    slsAccountErrors.Add('The user ' + pUsername + ' already exists');
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
    if FieldCount <> 0 then
    repeat
      if pUserID = FieldValues['UserID'] then
      begin
	      isFound := true;
      end else next;
    until EOF or isFound;
    Close;
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
const PASSWORDFILE = '.passwords';
var
  tfPasswords : textfile;
  isFileExist, isSuccessful : boolean;
begin
  isSuccessful := false;
  if FileUtils.CheckFileExists(PASSWORDFILE) then
  try
    AssignFile(tfPasswords,PASSWORDFILE);
    Append(tfPasswords);
    WriteLn(tfPasswords,Username + '#' + pPassword);
  finally
    CloseFile(tfPasswords);
    LogService.WriteUserLog('User ' + Username + ' has been saved in the PASSWORDS file');
    isSuccessful := true;
  end;
  Result := isSuccessful;
end;

procedure TUser.RegisterUserInDB;
begin
  with dmData.tblUsers do
  begin
    Open;
    Append;
    FieldValues['UserID'] := UserID;
    FieldValues['Username'] := Username;
    FieldValues['RegisterDate'] := date;
    FieldValues['isAdmin'] := false;
    FieldValues['Age'] := 0;
    FieldValues['FirstLogin'] := true;
    FieldValues['Fullname'] := 'TBD';
    FieldValues['ActivityLevel'] := 0;
    FieldValues['Height'] := 0;
    FieldValues['weight'] := 0;
    FieldValues['LastLogin'] := date;
    FieldValues['Gender'] := 'TBD';
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
      if MessageDlg('Log in as an administrator?',mtConfirmation,mbYesNo,0) = mrYes then
       isAdmin := true
      else
        isAdmin := false;

      SaveLastLogin;

      if not CheckFirstLogin then
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
    if FieldCount <> 0 then
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
var
  inDatabase, isCorrect : Boolean;
begin
  inDatabase := CheckDatabase(Username);
  isCorrect := CheckPassword(pPassword);

  Result := inDatabase and isCorrect;
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

function TUser.CheckPassword(pPassword : String = '') : Boolean;
var
  tfPasswords : textfile;
  sLine, sUserInFile, sPassInFile : string;
  isPassword, isUsername : Boolean;
  delPos : integer;
begin
  isUsername := false;
  isPassword := false;
  if FileUtils.CheckFileExists(PASSWORDFILE) then
  try
    AssignFile(tfPasswords,PASSWORDFILE);
    Reset(tfPasswords);
    repeat
      ReadLn(tfPasswords,sLine);
      delPos := pos('#',sLine);
      sUserInFile := copy(sLine,1,delPos-1);
      delete(sLine,1,delPos);
      sPassInFile := sLine;
      isUsername := Uppercase(sUserInFile) = Uppercase(Username);
      isPassword := sPassInFile = pPassword;
    until EOF(tfPasswords) or isUsername;
  finally
      CloseFile(tfPasswords);
  end;

  // If the password field is empty, only return whether the user is found
  if pPassword = '' then
    Result := isUsername
  else
    Result := isUsername and isPassword;
end;

function TUser.CheckLogin;
begin
  result := FLoggedIn;
end;

function TUser.CheckFirstLogin;
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

function TUser.GetRegisterDate: TDate;
var
  isFound : Boolean;
  dDate : TDate;
begin
  isFound := false;
  dDate := Date;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        isFound := true;
        dDate := FieldValues['RegisterDate'];
      end else next;
    until EOF or isFound;
    Close;
  end;
  Result := dDate;
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
        FieldValues['Gender'] := Gender;
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
      Gender := FieldValues['Gender'];
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

procedure TUser.DeleteUser(pUserID: string);
begin
  UserID := pUserID;
  DeletePassword;
  RemoveUserDB;
end;

procedure TUser.DeletePassword;
var
  tfPasswords : textfile;
  isSuccessful : boolean;
  slsPasswords : TStringList;
  iUserIndex : integer;
begin
  if FileUtils.CheckFileExists(PASSWORDFILE) then
  begin
    slsPasswords := TStringList.Create;
    slsPasswords.LoadFromFile(PASSWORDFILE);
    slsPasswords.NameValueSeparator := '#';

    // Delete the password at the index in the file, e.g line 9
    iUserIndex := slsPasswords.IndexOfName(Username);
    if (iUserIndex <> -1) then
    begin
      slsPasswords.Delete(iUserIndex);
      slsPasswords.SaveToFile(PASSWORDFILE);
    end;
    slsPasswords.Free;
    LogService.WriteSysLog('Entry for user ' + Username + ' was removed from the passwords file');
    isSuccessful := true;
  end;
end;

procedure TUser.DeleteGoals;
const GOALITEMS :array[1..5] of string = ('Calorie','Water','Carbohydrate','Protein','Fat');
var
  CurrentGoal : TGoal;
  i: Integer;
begin
  for i := 1 to Length(GOALITEMS) do
  begin
    CurrentGoal := TGoal.Create(UserID,GOALITEMS[i]);
    CurrentGoal.DeleteGoal;
  end;
end;

procedure TUser.DeleteMeals;
begin
  with dmData.tblMeals do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
        Delete;
    until EOF;
    Close;
  end;
end;

procedure TUser.RemoveUserDB;
var isFound : Boolean;
begin
  isFound := false;
  DeleteGoals;
  with dmData.tblUsers do
  begin
    Open;
    First;
    repeat
      if UserID = FieldValues['UserID'] then
      begin
        Delete;
        isFound := true;
        LogService.WriteUserLog('User ' + Username + ' was deleted from the database');
      end
      else
      next;
    until EOF or isFound;
    Close;
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
          sFoodName := FieldValues['Foodname'];
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
  { Add 5 for males and subtract 161 for females }
  if Gender = 'Male' then
    rTotalCalories := (10*Weight) + (6.25 * Height) + (5*Age) +5
  else
    rTotalCalories := (10*Weight) + (6.25 * Height) + (5*Age) - 161;

  Result := rTotalCalories * ActivityLevel;
end;
{$ENDREGION}
end.
