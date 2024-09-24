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
  libUtils_U, libUser_U, conDB;

type
  TfrmAdmin = class(TForm)
    pnlFooter: TPanel;
    btnLogout: TButton;
    pageCtrl: TPageControl;
    tsUsers: TTabSheet;
    tsLogs: TTabSheet;
    memLogs: TMemo;
    pnlLogHeader: TPanel;
    lblLogs: TLabel;
    btnClear: TButton;
    edtFilter: TEdit;
    pnl: TPanel;
    lblUsers: TLabel;
    dbgUsers: TDBGrid;
    btnPrev: TButton;
    btnNext: TButton;
    btnFilter: TButton;
    btnUserDel: TButton;
    btnFirst: TButton;
    btnLast: TButton;
    pnlUserNav: TPanel;
    lblNav: TLabel;
    pnlMod: TPanel;
    lblRecMod: TLabel;
    edtField: TEdit;
    edtData: TEdit;
    btnFieldEdit: TButton;
    tsHome: TTabSheet;
    pnlHead: TPanel;
    pnlUser: TPanel;
    lblUser: TLabel;
    tsFoods: TTabSheet;
    dbgFoods: TDBGrid;
    procedure btnLogoutClick(Sender: TObject);
    procedure tsLogsShow(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure tsUsersShow(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFilterClick(Sender: TObject);
    procedure btnUserDelClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnFieldEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tsFoodsShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgFoodsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }

    procedure ClearLogs();
    procedure InitializeWidth(dbGrid:TDBGrid);

    // sSearch is empty by default to prevent filtering when not requiered
    procedure ShowLogs(sSearch:string='');
  public
    { Public declarations }

    // Obtained from the app form upon login
    currentAdmin : TUser;
  end;

var
  frmAdmin: TfrmAdmin;
  adminName : string;
  LoggerObj : TLogs;
  UtilObj : TUtils;

implementation

{$R *.dfm}

// TODO: Plot administator navigation
// TODO: Filter logs for specific patterns

procedure TfrmAdmin.btnClearClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear the log file?',mtConfirmation, mbYesNo, 0) = mrYes then
  ClearLogs();
end;

procedure TfrmAdmin.btnFieldEditClick(Sender: TObject);
var
  fieldName,fieldData : string;
begin
  fieldName := edtField.Text;
  fieldData := edtData.Text;
  if MessageDlg('Modify user data?',mtConfirmation,mbOKCancel,0) = mrOk then
  begin
    if fieldName = 'Username' then
    begin
     // UtilObj.EditInDB(fieldName,fieldData);
    end
    else
    if fieldName = 'isAdmin' then
    begin
      try
        if (StrToBool(fieldData) = true) or (StrToBool(fieldData) = false) then
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

procedure TfrmAdmin.btnFilterClick(Sender: TObject);
var
  sSearch : string;
  selectedOpt : integer;
begin
  sSearch := edtFilter.Text;
  if MessageDlg('Filter all logs follow the pattern: ' + sSearch+'?',mtConfirmation, mbOKCancel, 0) = mrOk then
  ShowLogs(sSearch);
end;

procedure TfrmAdmin.btnFirstClick(Sender: TObject);
begin
  dmData.tblUsers.first;
end;

procedure TfrmAdmin.btnLastClick(Sender: TObject);
begin
  dmData.tblUsers.Last;
end;

procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  frmAdmin.Close;
  frmAdmin.Destroy;
end;

procedure TfrmAdmin.btnNextClick(Sender: TObject);
begin
  dmData.tblUsers.Next;
end;

procedure TfrmAdmin.btnPrevClick(Sender: TObject);
begin
  dmData.tblUsers.Prior;
end;

procedure TfrmAdmin.btnUserDelClick(Sender: TObject);
begin
  currentAdmin.RemoveUser(dmData.tblUsers.FieldValues['UserID']);
end;

//TODO: Filter logs based on type
procedure TfrmAdmin.tsFoodsShow(Sender: TObject);
begin
  InitializeWidth(dbgFoods);
  LoggerObj.WriteSysLog('The database table `tblFoods` was accessed by administrator ' + adminName);
end;

procedure TfrmAdmin.tsLogsShow(Sender: TObject);
begin
  UtilObj.SetLabel(lblLogs,'Logs',20);
  memLogs.Lines.clear;
  ShowLogs();
end;

procedure TfrmAdmin.tsUsersShow(Sender: TObject);
begin
  UtilObj.SetLabel(lblUsers,'User Management',20);
  InitializeWidth(dbgUsers);
  LoggerObj.WriteSysLog('The database table `tblUsers` was accessed by administrator ' + adminName);
end;

procedure TfrmAdmin.ShowLogs;
const FILENAME = 'logs';
var
  logFile : textfile;
  isFileExist, isStrEmpty, doFilter : boolean;
  sLine : string;
  numLines : integer;
begin
  memLogs.clear;
  memLogs.Lines.TrailingLineBreak := false;

  AssignFile(logFile,FILENAME);

  isFileExist := UtilObj.CheckFileExists(FILENAME,true);

  // Only filter when the Search string has text, hence when filterig
  doFilter := false;
  if not (sSearch = '') then doFilter := true;

  if isFileExist then
  begin
    Reset(logFile);
    Repeat
      ReadLn(logFile,sLine);
      Trim(sLine);

      // The point is to only add a line to the memo if the line contains a character or string from the search string, only when filtering
      // otherwise just add the current line freely
      if doFilter then
      begin
        if ContainsText(sLine,sSearch) then
          memLogs.lines.Add(sLine)
      end
      else
        memLogs.Lines.Add(sLine)
    Until EOF(logFile);

    CloseFile(logFile);
  end
  else
  // Assuming the log file does not exist, logging is omitted here unlike most error cases
    memLogs.Lines.Add('Logs file is missing or corrupted');
end;

procedure TfrmAdmin.ClearLogs();
const FILENAME = 'logs';
var
  logFile : textfile;
begin
  FileMode := 2;
  AssignFile(logFile,FILENAME);
  if UtilObj.CheckFileExists(FILENAME,true) then
  begin
    try
      ReWrite(logFile);
      Writeln(logFile,'# Logs #');
    except
      on E: Exception do
      begin
        ShowMessage('There was an error clearing the log file: ' + #13 + E.Message);
        exit;
      end;
    end;
    CloseFile(logFile);

    // Logged in admin is still logged when clearing the log file to keep them accountable for the clearing
    // In case anything may come up and logs were needed or some ambiguous circumstance
    LoggerObj.WriteUserLog('The administrator ' + adminName + ' was logged in');
    ShowLogs;
  end
  else
    ShowMessage('An error occured: the log file is either missing or corrupted');
end;



{ Nicely deals with the width of the columns in the dbGrids
  Calculates the size of the dbgrid text based on the size of
  the longest item in the grid plus 5 }
procedure TfrmAdmin.dbgFoodsDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgUsers.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then column.Width := width;
end;

procedure TfrmAdmin.dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgUsers.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then column.Width := width;
end;

{
  Base the initial width of the dbGrid on the size of the header text
  The size is changed when the grid is loaded with items, since the items
  have their own dynamic lengths
}
procedure TfrmAdmin.InitializeWidth(dbGrid:TDBGrid);
var
  i : integer;
begin
  dbGrid.ReadOnly := true;
  for i := 0 to dbGrid.Columns.Count -1 do
  dbGrid.Columns[i].Width := 5+dbGrid.Canvas.TextWidth(dbGrid.Columns[i].Title.Caption);
end;

procedure TfrmAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {
    Not closing tables creates an issue where the database will retain the `.ldb` file
    which indicates that the database is still in use even when the app has been closed,
    rather only open the tables when needed and close when not
  }
  currentAdmin.Free;
  with dmData do
  begin
    tblUsers.Close;
    tblFoods.Close;
  end;
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
  adminName := currentAdmin.Username;
  LoggerObj := TLogs.Create;
  UtilObj := TUtils.Create;
  pageCtrl.TabIndex := 0;
  UtilObj.SetLabel(lblUser,'[Admin]Logged in as ' + adminName,7);

  { Open tables when opening but close them when the form closes, preventing `read` locks as I call them }
  with dmData do
  begin
    tblUsers.open;
    dbgUsers.DataSource := dscUsers;
    tblFoods.Open;
    dbgFoods.DataSource := dscFoods;
  end;
end;


end.

