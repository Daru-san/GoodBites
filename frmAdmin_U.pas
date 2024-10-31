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
    edtUserField: TEdit;
    edtUserFieldData: TEdit;
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
  public
    { Public declarations }

    // Obtained from the app form upon login
    property AdminUser : TUser read FAdminUser write FAdminUser;
  end;

var
  frmAdmin: TfrmAdmin;
  LogService : TLogService;
  FileUtils : TFileUtils;
  ControlUtils : TControlUtils;

implementation

{$R *.dfm}

// User modificaiton
{$REGION USER MODIFICATION}
procedure TfrmAdmin.tsUsersShow(Sender: TObject);
begin
  // Resize the dbgrid and log administrator interaction with the databse table
  ControlUtils.ResizeDBGrid(dbgUsersTable);
  LogService.WriteSysLog('The database table `tblUsers` was accessed by administrator ' + AdminUser.Username);
end;

procedure TfrmAdmin.btnUserFieldEditClick(Sender: TObject);
var
  sFieldName,sFieldData : string;
begin
  sFieldName := edtUserField.Text;
  sFieldData := edtUserFieldData.Text;
  if MessageDlg('Modify user data?',mtConfirmation,mbOKCancel,0) = mrOk then
  begin
    if sFieldName = 'Username' then
    begin
     // UtilObj.EditInDB(fieldName,fieldData);
    end
    else
    if sFieldName = 'isAdmin' then
    begin
      try
        if (StrToBool(sFieldData) = true) or (StrToBool(sFieldData) = false) then
       //  UtilObj.EditInDB(fieldName,fieldData);
        except on E: Exception do
        begin
          ShowMessage('This field only takes boolean data');
          exit;
        end;
      end;
    end
    else ShowMessage('This data cannot be modified');
  end;
end;

procedure TfrmAdmin.btnUserDeleteClick(Sender: TObject);
var
  sUsername,sUserID : String;
  RemovedUser : TUser;
  slsDeleteMessage : TStringList;
begin
  sUsername := dmData.tblUsers.FieldValues['Username'];
  sUserID := dmData.tblUsers.FieldValues['UserID'];

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
    RemovedUser := TUser.Create(sUsername);

    // Try should catch any errors that may have occured during
    // user deletion and NOT log the user deletion as that would
    // create a false positive
    try
      RemovedUser.DeleteUser(sUserID);
    finally
      RemovedUser.Free;
      LogService.WriteSysLog(
        'Administrator ' + AdminUser.Username + ' uid ' + AdminUser.UserID
        + ' has deleted user ' + sUsername + ' uid ' + sUserID
      );
    end;
  end;

  // Memory management
  slsDeleteMessage.Free;

  // Reopen the users table and resize the db grid
  dmData.tblUsers.Open;
  ControlUtils.ResizeDBGrid(dbgUsersTable);
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
const LOGFILE = 'logs';
var
  tfLogs : textfile;
  doFilter : boolean;
  sLine : string;
  iNumLines : integer;
begin
  memLogs.clear;

  // Only filter when the Search string has text, hence when filterig
  doFilter := pSearch <> '';

  if FileUtils.CheckLogFile then
  try
    AssignFile(tfLogs,LOGFILE);
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

procedure TfrmAdmin.btnClearClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear the log file?',mtConfirmation, mbYesNo, 0) = mrYes then
    ClearLogs();
end;

procedure TfrmAdmin.ClearLogs;
var
	tfLogs : textfile;
	sLogPath : String;
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

    // Logged in admin is still logged when clearing the log file to keep them accountable for the clearing
    // In case anything may come up and logs were needed or some ambiguous circumstance
    LogService.WriteUserLog('The administrator ' + AdminUser.Username + ' was logged in');
    ShowLogs;
  end
  else
    ShowMessage('An error occured: the log file is either missing or corrupted');
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
