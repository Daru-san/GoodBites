unit frmAdmin_U;
{ Administator dashboard that provides administrator users with the ability to:
  - View the database tables
  - Edit the database tables
  - View the application logs for any errors or strange behavior in the program or just general program usage
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  libUtils_U, libUser_U, conDB, Vcl.ToolWin,frmSettings_U, Vcl.WinXCtrls,
  Vcl.NumberBox, Vcl.Mask, Vcl.WinXPanels;

type
  TfrmAdmin = class(TForm)
    btnLogout: TButton;
    pageCtrl: TPageControl;
    tsUsers: TTabSheet;
    tsLogs: TTabSheet;
    memLogs: TMemo;
    pnlLogHeader: TPanel;
    btnClear: TButton;
    edtFilter: TEdit;
    btnUserPrevious: TButton;
    btnUserNext: TButton;
    btnFilter: TButton;
    btnUserDelete: TButton;
    btnUserFirst: TButton;
    btnUserLast: TButton;
    pnlUserNav: TPanel;
    lblUserRecordNav: TLabel;
    pnlMod: TPanel;
    lblUserRecordMod: TLabel;
    edtUserData: TEdit;
    btnUserFieldEdit: TButton;
    tsFoods: TTabSheet;
    dbgFoodsTable: TDBGrid;
    svSidebar: TSplitView;
    pnlUserHead: TPanel;
    pnlUsersCenter: TPanel;
    pnlUsersBottom: TPanel;
    pnlFoodTop: TPanel;
    pnlFoodCenter: TPanel;
    pnlFoodBottom: TPanel;
    lblUser: TLabel;
    pnlFoodRecordMod: TPanel;
    lblFoodRecordMod: TLabel;
    edtFoodField: TEdit;
    edtFoodFieldData: TEdit;
    btnFoodEdit: TButton;
    pnlFoodRecordNav: TPanel;
    lblFoodRecordNav: TLabel;
    btnFoodFirst: TButton;
    btnFoodLast: TButton;
    btnFoodPrev: TButton;
    btnFoodNext: TButton;
    pnlLogsCenter: TPanel;
    pnlLogsBottom: TPanel;
    btnUnfilter: TButton;
    btnBackupDB: TButton;
    dbgUsersTable: TDBGrid;
    cbxUserField: TComboBox;

    procedure btnLogoutClick(Sender: TObject);
    procedure tsLogsShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure tsUsersShow(Sender: TObject);
    procedure btnUserNextClick(Sender: TObject);
    procedure btnUserPreviousClick(Sender: TObject);
    procedure dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFilterClick(Sender: TObject);
    procedure btnUserDeleteClick(Sender: TObject);
    procedure btnUserFirstClick(Sender: TObject);
    procedure btnUserLastClick(Sender: TObject);
    procedure btnUserFieldEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tsFoodsShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgFoodsTableDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFoodFirstClick(Sender: TObject);
    procedure btnFoodLastClick(Sender: TObject);
    procedure btnFoodPrevClick(Sender: TObject);
    procedure btnFoodNextClick(Sender: TObject);
    procedure btnUnfilterClick(Sender: TObject);
    procedure btnBackupDBClick(Sender: TObject);
  private
    { Private declarations }
    FAdminUser : TUser;

    procedure ClearLogs;

    // sSearch is empty by default to prevent filtering when not requiered
    procedure ShowLogs(pSearch:string='');
    // Edit a field in the users database
		procedure EditUserTable(pFieldName,pFieldData : string);

    // Validating our data
		function ValidateUserData(pFieldName,pFieldData : String) : Boolean;
    function ValidateNum(pNum : String ; pNumName : String; pMin,pMax : Real) : Boolean;
		function ValidateBool(pValue,pBoolName : String): Boolean;

  public
    { Public declarations }

    // Obtained from the app form upon login
    property AdminUser : TUser read FAdminUser write FAdminUser;
  end;

const
	USERFIELDS : array[1..9] of String = (
		'UserID','Username','Fullname','Gender','ActivityLevel','Age','Weight','Height','isAdmin'
	);
var
  frmAdmin: TfrmAdmin;
  LogService : TLogService;
  FileUtils : TFileUtils;
  ControlUtils : TControlUtils;
	StringUtils : TStringUtils;

implementation

{$R *.dfm}

// User modificaiton
{$REGION USER MODIFICATION}
procedure TfrmAdmin.tsUsersShow(Sender: TObject);
begin
  // Resize the dbgrid and log administrator interaction with the databse table
  ControlUtils.ResizeDBGrid(dbgUsersTable);

  // Only log the opening of the users table once, else it will show every time the tab is shown
	if not isUserTableOpen then
	begin
		LogService.WriteSysLog('The database table `tblUsers` was accessed by administrator ' + AdminUser.Username);
		isUserTableOpen := true;
	end;
end;

procedure TfrmAdmin.btnUserDeleteClick(Sender: TObject);
var
	sUsername,sUserID : String;
	iUserIndex : Integer;
	RemovedUser : TUser;
	slsDeleteMessage : TStringList;
begin
	sUsername := dmData.tblUsers.FieldValues['Username'];
	sUserID := dmData.tblUsers.FieldValues['UserID'];
	iUserIndex := dmData.tblUsers.FieldValues['UserIndex'];

  // Creating the message with a string list makes it easy to
  // add multiple lines at once with #13
  slsDeleteMessage := TStringList.Create;
  with slsDeleteMessage do
  begin
    Add('Are you sure you would like to delete user ' + sUsername + ' uid ' + sUserID);
    Add('Once they have been deleted their data cannot be recovered');
    Add('Please ensure that you are completely sure about this');
  end;

  // We ensure confirmation to prevent accidental deletions in some cases
  // Although data can be recovered since the database is backed up on every run
  if MessageDlg(slsDeleteMessage.Text,mtConfirmation,mbYesNo,0) = mrYes then
	begin
		// Creates a user that logs in automatically,
		// allowing administrators to delete them based on
		// their data that is copied from the database on login
		RemovedUser := TUser.Create(sUsername,sUserID);

		// Prevents the deletion of an administrator
		if RemovedUser.isAdmin then
		begin
			ShowMessage('Cannot delete an administrator user');
			RemovedUser.Free;
		end
		else
    try
      RemovedUser.DeleteUser(sUserID);
    finally
      RemovedUser.Free;
      LogService.WriteSysLog(
        'Administrator ' + AdminUser.Username + ' uid ' + AdminUser.UserID
        + ' has deleted user ' + sUsername + ' uid ' + sUserID
			);
			ShowMessage('User ' + sUsername + ' was deleted successfully!');
    end;
  end;

  // Memory management
  slsDeleteMessage.Free;

  // Reopen the users table and resize the db grid
  dmData.tblUsers.Open;
  ControlUtils.ResizeDBGrid(dbgUsersTable);
end;

procedure TfrmAdmin.btnUserFieldEditClick(Sender: TObject);
var
	sFieldName,sFieldData : string;
	isValid : Boolean;
begin
	sFieldName := cbxUserField.Text;
	sFieldData := edtUserData.Text;

	// Obtain confirmation, validate and edit data
	if MessageDlg('Modify user data?',mtConfirmation,mbYesNo,0) = mrYes then
	begin
		isValid := ValidateUserData(sFieldName,sFieldData);
		if isValid then
			EditUserTable(sFieldName,sFieldData)
		else
			ShowMessage('Table tblUsers was not modified');
	end;
end;

function TfrmAdmin.ValidateUserData(pFieldName: string; pFieldData: string): Boolean;
var
	isValid : Boolean;
	i : Integer;
	sParamList : String;
begin
	// We list all of our user parameters so that
	// we can display a message one is incorrect
	sParamList := USERFIELDS[1];
	for i := 2 to Length(userFIELDS) do
		sParamList := sParamList + ',' + USERFIELDS[I];

	isValid := false;

	// Validate each feild separately, the array index makes this easy to
	// do without many if statements
	case IndexStr(pFieldName,USERFIELDS) of
		0: isValid := StringUtils.ValidateString(pFieldData,'UserID',6,6,'numbers,letters');
		1: isValid := StringUtils.ValidateString(pFieldData,'Username',3,12);
		2: isValid := StringUtils.ValidateString(pFieldData,'Full name',3,20);
		3: begin
			isValid := (LowerCase(pFieldData) = 'male') or (LowerCase(pFieldData) = 'female');
			if not isValid then ShowMessage('Enter either male or female');
		end;
		4: isValid := ValidateNum(pFieldData,'ActivityLevel',1.0,2.0);
		5: isValid := ValidateNum(pFieldData,'Age',7,150);
		6: isValid := ValidateNum(pFieldData,'Weight',15,999);
		7: isValid := ValidateNum(pFieldData,'Height',60,299);

		// Administrators should not be able to remove administrators
		8: begin
			isValid := false;
			ShowMessage('You cannot change the `isAdmin` field of another user');
		end;
	else
		// Showing a message when none of provided options are selected
		ShowMessage('Please pick one of ' + sParamList);
	end;
	Result := isValid;
end;

// Boolean field validation
function TfrmAdmin.ValidateBool(pValue: string; pBoolName: String): Boolean;
var
	isValid,isPresent,bValue : Boolean;
	iCheckInt : Integer;
begin
	// Make sure our value is actually present
	if pValue <> '' then
		isPresent := true
	else
		isPresent := false;

	isValid := true;

	// A convert error would tell us that
	// the value is not a boolean
	// allowing the entrance of true, false, 1 or 0
	try
		// We try to convert the string to a boolean
		// catching the excpetion in the case that it cannot be converted
		bValue := StrToBool(pValue);
	except on E: EConvertError do
		isValid := false;
	end;

	if not isValid then
		ShowMessage(pBoolName + ' must be a valid boolean value');

	if not isPresent then
		ShowMessage('Please enter a valid boolean value');

	// Ensuring validity and presence at the same time
	Result := isValid and isPresent;
end;

// Numeric field data validation
function TfrmAdmin.ValidateNum(pNum: String; pNumName: string; pMin: Real; pMax: Real): Boolean;
var
	isValid,isNum,isPresent : Boolean;
	iCheckInt : Integer;
  rNumber : Real;
begin
	if pNum <> '' then
		isPresent := true
	else
		isPresent := false;

	Val(pNum,rNumber,iCheckInt);

	// A zero would mean that the string cannot be
	// converted to a number
	// zero indicates the position of any non-number
	// values in the string
  if iCheckInt = 0 then
    isNum := true
  else
    isNum := false;

	// Min-max checking
  if (rNumber > pMin) and (rNumber < pMax) then
    isValid := true
  else
    isValid := false;

	if (not isPresent) or (not isNum) then
		ShowMessage('Please enter a valid number for field ' + pNumName);

	if not isValid then
		ShowMessage(pNumName + ' must be a number between ' + FloatToStr(pMin) + ' and ' + FloatToStr(pMax));

	// We want to ensure validity, numerical `correctness` and presence
	Result := isValid and isNum and isPresent;
end;

procedure TfrmAdmin.EditUserTable(pFieldName: string; pFieldData: string);
var
	isChanged : Boolean;
begin
	isChanged := false;

	with dmData.tblUsers do
	begin
		// An administrator should not be able to change the `isAdmin` field
		// of their own user when they are logged in, so we prevent that
		if (FieldValues['UserID'] = AdminUser.UserID) and (pFieldName = 'isAdmin') then
		begin
			ShowMessage('Cannot change this personal isAdmin field while logged in');
			exit;
		end;

		Edit;

		// This should hopefully catch any last minute errors that I cannot
		// prepare for such as on-the-stop database deletion or any corruption
		// errors, others I do not know of may occur as well
		try

		// The item indexes of 4 to 7 contains all number values which should be converted
		// back into floats before entering them into the database
		case IndexStr(pFieldName,USERFIELDS) of
			4..7: FieldValues[pFieldName] := StrToFloat(pFieldData);
		else
			FieldValues[pFieldName] := pFieldData;
		end;
		finally
			Post;
			Refresh;
			isChanged := true;
		end;
	end;

	// Display upon success or failure
	if isChanged then
	begin
		ShowMessage('Field ' + pFieldName + ' was changed successfully!');
		LogService.WriteSysLog('Field ' + pFieldName + ' of tblUsers was updated by administrator ' + AdminUser.Username + ' uid ' + AdminUser.UserID);
	end
	else
		ShowMessage('Change of field ' + pFieldName + ' failed, an unknown error has occured');
end;

// Navigating the table
procedure TfrmAdmin.btnUserFirstClick(Sender: TObject);
begin
  dmData.tblUsers.first;
end;

procedure TfrmAdmin.btnUserLastClick(Sender: TObject);
begin
  dmData.tblUsers.Last;
end;


procedure TfrmAdmin.btnUserNextClick(Sender: TObject);
begin
  dmData.tblUsers.Next;
end;

procedure TfrmAdmin.btnUserPreviousClick(Sender: TObject);
begin
  dmData.tblUsers.Prior;
end;
{$ENDREGION}

// Logs
{$REGION LOGFILE}
procedure TfrmAdmin.tsLogsShow(Sender: TObject);
begin
  ShowLogs();
end;

procedure TfrmAdmin.btnUnfilterClick(Sender: TObject);
begin
  edtFilter.Text := '';
  ShowLogs;
end;

//Applying our filter
procedure TfrmAdmin.btnFilterClick(Sender: TObject);
var
  sSearch : string;
  selectedOpt : integer;
begin
  sSearch := edtFilter.Text;
  if MessageDlg('Filter all logs follow the pattern: ' + sSearch+'?',mtConfirmation, mbOKCancel, 0) = mrOk then
    ShowLogs(sSearch);
end;

procedure TfrmAdmin.ShowLogs;
var
	tfLogs : textfile;
	doFilter : boolean;
	sLine,sLogPath : string;
	iNumLines : integer;
begin
	memLogs.clear;

	// Only filter when the Search string has text, hence when filterig
	doFilter := pSearch <> '';
	
	// The log path is stores in the logService object
	sLogPath := LogService.LogPath;

	if FileUtils.CheckLogFile then
	try
		AssignFile(tfLogs,sLogPath);
		Reset(tfLogs);
		Repeat
			ReadLn(tfLogs,sLine);
			Trim(sLine);

			// Show a line containing the filtered string as a regex
			// If not filtering we just show every single line
			if doFilter then
			begin
				if ContainsText(sLine,pSearch) then
					memLogs.lines.Add(sLine)
			end
			else
				memLogs.Lines.Add(sLine)
		Until EOF(tfLogs);
	finally
		 CloseFile(tfLogs);
	end
	else
	// Assuming the log file does not exist, logging is omitted here unlike most error cases
		memLogs.Lines.Add('Logs file is missing or corrupted');
end;

// Clearing out log file
procedure TfrmAdmin.btnClearClick(Sender: TObject);
begin
	if MessageDlg('Are you sure you want to clear the log file?',mtConfirmation, mbYesNo, 0) = mrYes then
		ClearLogs();
end;

procedure TfrmAdmin.ClearLogs;
var
	tfLogs : textfile;
	sLogPath : String;
begin
	sLogPath := LogService.LogPath;
	if FileUtils.CheckLogFile then
	begin
		try
			AssignFile(tfLogs,sLogPath);
			ReWrite(tfLogs);
			Writeln(tfLogs,'# Logs #');
		finally
			CloseFile(tfLogs);
		end;

		// Logged in admin is still logged when clearing the log file to keep them accountable for the clearing
		// In case anything may come up and logs were needed or some ambiguous circumstance
		LogService.WriteUserLog('The administrator ' + AdminUser.Username + ' was logged in');
		ShowLogs;
	end
	else
		ShowMessage('An error occured: the log file is either missing or corrupted');
end;
begin

end;

{$ENDREGION}

// Sidebar
{$REGION SIDEBAR}
procedure TfrmAdmin.btnBackupDBClick(Sender: TObject);
begin
  dmData.BackUpDB;
  ShowLogs;
end;

procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  self.ModalResult := mrClose;
end;

{$ENDREGION}
// Food
{$REGION FOOD}
// Table navigation
procedure TfrmAdmin.btnFoodFirstClick(Sender: TObject);
begin
  dmData.tblFoods.First;
end;

procedure TfrmAdmin.btnFoodLastClick(Sender: TObject);
begin
  dmData.tblFoods.Last;
end;

procedure TfrmAdmin.btnFoodNextClick(Sender: TObject);
begin
  dmData.tblFoods.Next;
end;

procedure TfrmAdmin.btnFoodPrevClick(Sender: TObject);
begin
  dmData.tblFoods.Prior;
end;

procedure TfrmAdmin.tsFoodsShow(Sender: TObject);
begin
  // Resize the food dbgrid and log administrator interaction with the table
  ControlUtils.ResizeDBGrid(dbgFoodsTable);
  LogService.WriteSysLog('The database table `tblFoods` was accessed by administrator ' + AdminUser.Username);
end;
{$ENDREGION}

// Formatting the DBGRIDS
{$REGION DBGRIDS}
// These procedures format the size of each dbgrid making the size
// of each field equal to the length of the heading + 5 units
// Once the original size is calculated, we call ResizeDBGrid() to
// change size based on the length of the items in the grid

procedure TfrmAdmin.dbgFoodsTableDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgFoodsTable.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then
    column.Width := width;
end;

procedure TfrmAdmin.dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgUsersTable.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then
    column.Width := width;
end;
{$ENDREGION}

// Form navigation
{$REGION FORM NAVIGATION}
procedure TfrmAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Freeing our objects from memory
  AdminUser.Free;
  FileUtils.Free;
  LogService.Free;
  ControlUtils.Free;

  {Not closing tables creates an issue where the database will retain the `.ldb` file
    which indicates that the database is still in use even when the app has been closed,
    rather only open the tables when needed and close when not}
  with dmData do
  begin
    tblUsers.Close;
    tblFoods.Close;
  end;
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  //Initializing our objects
  LogService := TLogService.Create;
  FileUtils := TFileUtils.Create;
  ControlUtils := TControlUtils.Create;

  // Ensuring we start on the first tab every time
  pageCtrl.TabIndex := 0;

  // Greeting
  lblUser.Caption := 'Hello, ' + AdminUser.Username;

  // I choose to open database tables only when they are needed
  // hence they are opened upon opening this form
  // They are not open automatically

  with dmData do
  begin
    tblUsers.open;
    tblFoods.Open;
    dbgFoodsTable.DataSource := dscFoods;
    dbgUsersTable.DataSource := dscUsers;
  end;

  // Call the OnShow() of the tab to get the dbgrid resized
  tsUsers.OnShow(nil);
end;
{$ENDREGION}
end.
