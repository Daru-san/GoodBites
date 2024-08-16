unit AdminDash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, dmBase,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Utils;

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
    procedure btnLogoutClick(Sender: TObject);
    procedure tsLogsShow(Sender: TObject);
    procedure ShowLogs();
    procedure ClearLogs();
    procedure btnClearClick(Sender: TObject);
    procedure tsUsersShow(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure InitializeWidth();
    procedure dbgUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
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
  selectedOpt := MessageDlg('Are you sure you want to clear the log file?',mtError, mbOKCancel, 0);
  if selectedOpt = mrOk then
      ClearLogs();
end;

procedure TfrmAdmin.btnLogoutClick(Sender: TObject);
begin
  Application.MainForm.Visible := true;
  FrmAdmin.CloseQuery;
end;

procedure TfrmAdmin.btnNextClick(Sender: TObject);
begin
  dmBase.dmData.tblUsers.Next;
end;

procedure TfrmAdmin.btnPrevClick(Sender: TObject);
begin
  dmData.tblUsers.Prior;
end;

//TODO: Filter logs based on type
procedure TfrmAdmin.tsLogsShow(Sender: TObject);
begin
  with lblLogs do
  begin
    font.Name := 'Noto Sans';
    font.size := 20;
    Layout := tlCenter;
  end;
  memLogs.Lines.clear;
  ShowLogs();
end;

procedure TfrmAdmin.tsUsersShow(Sender: TObject);
begin
  with lblUsers do
  begin
    font.Name := 'Noto Sans';
    font.Size := 20;
    Layout := tlCenter;
    Caption := 'User Management';
  end;
  with dmBase.dmData do
  begin
    tblUsers.open;
    dbgUsers.DataSource := dmBase.dmData.dscUsers;
  end;
  InitializeWidth;

  WriteSysLog('The database table `tblUsers` was accessed by an administrator.');
end;

procedure TfrmAdmin.ShowLogs();
const FILENAME = '.logs';
var
  logFile : textfile;
  isFileExist, isStrEmpty : boolean;
  lineString : string;
begin
  memLogs.clear;
  AssignFile(logFile,FILENAME);
  isFileExist := CheckFileExists(FILENAME,true);
  if isFileExist then
  begin
    Reset(logFile);
    Repeat
      ReadLn(logFile,lineString);
      Trim(lineString);
      memLogs.lines.Add(lineString);
    Until EOF(logFile);
    CloseFile(logFile);
  end
  else
    memLogs.Lines.Add('Logs file is missing or corrupted');
end;

//TODO: Clear the log file successfully
procedure TfrmAdmin.ClearLogs();
const FILENAME = '.logs';
var
  logFile : textfile;
begin
  FileMode := 2;
  AssignFile(logFile,FILENAME);
  if CheckFileExists(FILENAME,true) then
  begin
    Reset(logFile);
//    Truncate(logFile);
    Writeln(logFile,'# Logs #');
    CloseFile(logFile);
    memLogs.clear;
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

procedure TfrmAdmin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  dmBase.dmData.tblUsers.Close;
  Canclose := true;
  FrmAdmin.DoExit;
end;

procedure TfrmAdmin.InitializeWidth();
var
  i : integer;
begin
  for i := 0 to dbgUsers.Columns.Count -1 do
  dbgUsers.Columns[i].Width := 5+dbgUsers.Canvas.TextWidth(dbgUsers.Columns[i].Title.Caption);
end;

end.
