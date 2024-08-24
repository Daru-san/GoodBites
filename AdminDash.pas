unit AdminDash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, conDBBites,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Utils,UserMod;

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
    tsNutrients: TTabSheet;
    dbgNutrients: TDBGrid;
    pnlNutrientHeader: TPanel;
    lblNutrient: TLabel;
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

  private
    { Private declarations }
    procedure btnLogoutClick(Sender: TObject);
    procedure tsLogsShow(Sender: TObject);
    procedure ShowLogs(filterString:string='');
    procedure ClearLogs();
    procedure btnClearClick(Sender: TObject);
    procedure tsUsersShow(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure InitializeWidth(dbGrid:TDBGrid);
    procedure dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure tsNutrientsShow(Sender: TObject);
    procedure dbgNutrientsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnFilterClick(Sender: TObject);
    procedure btnUserDelClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnFieldEditClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

implementation

{$R *.dfm}

// TODO: Plot administator navigation
// TODO: Filter logs for specific patterns

procedure TfrmAdmin.btnClearClick(Sender: TObject);
var
  selectedOpt : integer;
begin
  selectedOpt := MessageDlg('Are you sure you want to clear the log file?',mtConfirmation, mbOKCancel, 0);
  if selectedOpt = mrOk then ClearLogs();
end;

procedure TfrmAdmin.btnFieldEditClick(Sender: TObject);
var
  selectedOpt : integer;
  fieldName,fieldData : string;
begin
  fieldName := edtField.Text;
  fieldData := edtData.Text;
  selectedOpt := MessageDlg('Modify user data?',mtConfirmation,mbOKCancel,0);
  if selectedOpt = mrOk then
  begin
    if fieldName = 'Username' then
    begin
      TUtils.Create.EditInDB(fieldName,fieldData);
    end
    else
    if fieldName = 'isAdmin' then
    begin
      try
        if (StrToBool(fieldData) = true) or (StrToBool(fieldData) = false) then
          TUtils.Create.EditInDB(fieldName,fieldData);
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
  filterString : string;
  selectedOpt : integer;
begin
  filterString := edtFilter.Text;
  selectedOpt := MessageDlg('Filter all logs follow the pattern: ' + filterString+'?',mtConfirmation, mbOKCancel, 0);
  if selectedOpt = mrOk then
  ShowLogs(filterString);
end;

procedure TfrmAdmin.btnFirstClick(Sender: TObject);
begin
  dbmData.tblUsers.first;
end;

procedure TfrmAdmin.btnLastClick(Sender: TObject);
begin
  dbmData.tblUsers.Last;
end;

procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  Application.MainForm.Visible := true;
  with dbmData do
  begin
    tblUsers.Close;
    tblNutrients.Close;
  end;
  frmAdmin.Close;
  frmAdmin.Destroy;
end;

procedure TfrmAdmin.btnNextClick(Sender: TObject);
begin
  dbmData.tblUsers.Next;
end;

procedure TfrmAdmin.btnPrevClick(Sender: TObject);
begin
  dbmData.tblUsers.Prior;
end;

procedure TfrmAdmin.btnUserDelClick(Sender: TObject);
begin
  TUsers.Create.RemoveUser(dbmData.tblUsers.FieldValues['UserID']);
end;

//TODO: Filter logs based on type
procedure TfrmAdmin.tsLogsShow(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblLogs,'Logs');
  memLogs.Lines.clear;
  ShowLogs();
end;

procedure TfrmAdmin.tsNutrientsShow(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblNutrient,'Manage Nutrients');
  with dbmData do
  begin
    tblNutrients.Open;
    dbgNutrients.DataSource := dscNutrients;
  end;
  InitializeWidth(dbgNutrients);
  TUtils.Create.WriteSysLog('The database table `tblNutrients` was accessed by an administrator.');
end;

procedure TfrmAdmin.tsUsersShow(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblUsers,'User Management');
  with dbmData do
  begin
    tblUsers.open;
    dbgUsers.DataSource := dscUsers;
  end;
  InitializeWidth(dbgUsers);

  TUtils.Create.WriteSysLog('The database table `tblUsers` was accessed by an administrator.');
end;

procedure TfrmAdmin.ShowLogs;
const FILENAME = 'logs';
var
  logFile : textfile;
  isFileExist, isStrEmpty, doFilter : boolean;
  lineString : string;
  numLines : integer;
begin
  memLogs.clear;
  memLogs.Lines.TrailingLineBreak := false;
  AssignFile(logFile,FILENAME);
  isFileExist := TUtils.Create.CheckFileExists(FILENAME,true);

  doFilter := false;
  if not (filterString = '') then doFilter := true;

  if isFileExist then
  begin
    Reset(logFile);
    Repeat
      ReadLn(logFile,lineString);
      Trim(lineString);
      if not doFilter then
        memLogs.Lines.Add(lineString)
      else
        if ContainsText(lineString,filterString) then
          memLogs.lines.Add(lineString);
    Until EOF(logFile);

    CloseFile(logFile);
  end
  else
    memLogs.Lines.Add('Logs file is missing or corrupted');
end;

//TODO: Clear the log file successfully
procedure TfrmAdmin.ClearLogs();
const FILENAME = 'logs';
var
  logFile : textfile;
begin
  FileMode := 2;
  AssignFile(logFile,FILENAME);
  if TUtils.Create.CheckFileExists(FILENAME,true) then
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
    TUtils.Create.WriteUserLog('An administrator logged in');
    ShowLogs;
  end
  else
    ShowMessage('An error occured: the log file is either missing or corrupted');
end;

// Dealing with the width of the columns in the grid
procedure TfrmAdmin.dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgUsers.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then column.Width := width;
end;

procedure TfrmAdmin.dbgNutrientsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  width : integer;
begin
  width := 5+dbgNutrients.Canvas.TextExtent(Column.Field.DisplayText).cx;
  if width>column.width then column.Width := width;
end;

procedure TfrmAdmin.InitializeWidth(dbGrid:TDBGrid);
var
  i : integer;
begin
  dbGrid.ReadOnly := true;
  for i := 0 to dbGrid.Columns.Count -1 do
  dbGrid.Columns[i].Width := 5+dbGrid.Canvas.TextWidth(dbGrid.Columns[i].Title.Caption);
end;

end.
