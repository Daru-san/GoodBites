unit conDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,Windows,libUtils_U,
  Vcl.ExtCtrls,Dialogs;

type
  TdmData = class(TDataModule)
    dbConnect: TADOConnection;
    tblMeals: TADOTable;
    tblFoods: TADOTable;
    tblUsers: TADOTable;
    dscFoods: TDataSource;
    dscUsers: TDataSource;
    timeBackup: TTimer;
    tblGoals: TADOTable;
    tblProgress: TADOTable;

    procedure BackUpDB;
    procedure DataModuleCreate(Sender: TObject);
    procedure timeBackupTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure ConnectDB;
    procedure LocateDatabase;
  public
    { Public declarations }
  end;
// DL refers to the name of the database file when in use
const DBFILENAME = 'dbBites.mdb'; DLFILENAME = 'dbBites.ldb';
var
  dmData: TdmData;
  dbPath,dlPath : String;
  LogService : TLogService;
  FileUtils : TFileUtils;
  DatabaseExists : Boolean;

implementation

procedure TdmData.ConnectDB;
begin
  dbConnect := TADOConnection.Create(self);
  dbConnect.Connected := False;
  dbConnect.LoginPrompt := False;

  dbConnect.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+dbPath+';Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:New Database Password="";';

  dbConnect.Provider := 'Provider=Microsoft.Jet.OLEDB.4.0;';
  dbConnect.Open;

  tblUsers := TADOTable.Create(self);
  tblUsers.TableName := 'tblUsers';
  tblUsers.Connection := dbConnect;
  dscUsers.DataSet := tblUsers;

  tblMeals := TADOTable.Create(self);
  tblMeals.TableName := 'tblMeals';
  tblMeals.Connection := dbConnect;

  tblFoods := TADOTable.Create(self);
  tblFoods.TableName := 'tblFoods';
  tblFoods.Connection := dbConnect;
  dscFoods.DataSet := tblFoods;

  tblGoals := TADOTable.Create(self);
  tblGoals.TableName := 'tblGoals';
  tblGoals.Connection := dbConnect;

  tblProgress := TADOTable.Create(self);
  tblProgress.TableName := 'tblProgress';
  tblProgress.Connection := dbConnect;

  tblFoods.Active := True;
  tblMeals.Active := true;
  tblUsers.Active := true;
  tblGoals.Active := True;
  tblProgress.Active := True;
end;

procedure TdmData.BackUpDB;
var
  isFailed : Boolean;
  dbPathCharBK,dlPathCharBK : PWideChar;
  dbPathChar, dlPathChar : PWideChar;
begin

  { Only backup if the `database.ldb` file is NOT present,
    issues can come up when the database is backed up while still in use,
    I would rather back it up frequently but not when it is in use }

  // Converts the strings to widechar which can be read by DeleteFile()
  StringToWideChar(dbPath + '.backup',dbPathCharBK,(dbPath+'.backup').Length);
  StringToWideChar(dlPath + '.backup',dlPathCharBK,(dlPath+'.backup').Length);
  StringToWideChar(dbPath,dbPathChar,dbPath.Length);
  StringToWideChar(dlPath,dlPathChar,dlPath.Length);

  if not Utils.CheckFileExists(dlPath) then
  DeleteFile(dbPathCharBK);
  CopyFile(dbPathChar,dbPathCharBK,isFailed);

  if isFailed then
    LogService.WriteErrorLog('Error backing up the database')
  else
    LogService.WriteSysLog('Database backup successful!');
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmData.LocateDatabase;
var 
  isExist,isDebugExist : Boolean;
  isInCurrentDir,isInUpperDir : Boolean;
begin
  {
    A series of checks ensuring that the database file exists
    and stopping the app in the instance that it does not exist
  }
  isInCurrentDir := FileExists(DBFILENAME);
  isInUpperDir := FileExists('..\..\'+DBFILENAME);

  if isInUpperDir then
  begin
    dbPath := DBFILENAME;
    dlPath := DLFILENAME;
  end;

  if isInUpperDir and not(isInCurrentDir) then
  begin
    dbPath := '..\..\'+DBFILENAME;
    dlPath := '..\..\'+DLFILENAME;
  end;

  DatabaseExists := isInCurrentDir or isInUpperDir;

  if not DatabaseExists then
  begin
    LogService.WriteErrorLog('The database file is missing');
  end;
end;

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  FileUtils := TFileUtils.Create;
  LogService := TLogService.Create;

  LocateDatabase;
  if DatabaseExists then
  begin
    ConnectDB;
    {    ShowMessage('A');
    // Nice to keep the database backup up often, every 5 minutes, unless the `.ldb` file exists, which would mean the database is still in use
    timeBackup.Enabled := true;
    ShowMessage('b');
    timeBackup.Interval := 5*60;
    ShowMessage('c');}
  end;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  FileUtils.Free;
  LogService.Free;
end;

procedure TdmData.timeBackupTimer(Sender: TObject);
begin
  BackUpDB;
end;

end.
