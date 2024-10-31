unit conDB;
// The database connection
// Main purpose is to fascilitate the connection
// of the database and back up the database on every run
// of the program

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
    procedure ConnectDB;
    procedure LocateDatabase;
  end;

// DL refers to the name of the database file when in use
const DBFILENAME = 'dbBites.mdb'; DLFILENAME = 'dbBites.ldb';
var
  dmData: TdmData;

  //Paths are stored in variables to allow
  //selective searching for the database file
  dbPath,dlPath : String;


  LogService : TLogService;
  FileUtils : TFileUtils;
  DatabaseExists : Boolean;

implementation

// Connect the database and its tables
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

  // When connecting the database each table is enabled
  // but they are not opened
  // Each table is only opened when it is needed in a particular
  // part of the application, this prevents write the creation of
  // the `.ldb` file which remains if the program crashes for one
  // reason or another
  tblFoods.Active := True;
  tblMeals.Active := true;
  tblUsers.Active := true;
  tblGoals.Active := True;
  tblProgress.Active := True;
end;

procedure TdmData.BackUpDB;
var
  isFailed : Boolean;
  isDeleted : Boolean;
begin

  { Only backup if the `database.ldb` file is NOT present,
    issues can come up when the database is backed up while still in use,
    I would rather back it up frequently but not when it is in use }


  if not FileUtils.CheckFileExists(dlPath) then
    isDeleted := DeleteFile(pChar(dbPath+'.backup'));

  if isDeleted then
    CopyFile(pChar(dbPath),pChar(dbPath+'.backup'),isFailed);

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
  // The database path is often two directories
  // higher than the path of the program, so I
  // need to check for the location of the database
  // to ensure we use the correct files
  isInCurrentDir := FileExists(DBFILENAME);
  isInUpperDir := FileExists('..\..\'+DBFILENAME);

  if isInCurrentDir then
  begin
    dbPath := DBFILENAME;
    dlPath := DLFILENAME;
  end;

  if isInUpperDir and not(isInCurrentDir) then
  begin
    dbPath := '..\..\'+DBFILENAME;
    dlPath := '..\..\'+DLFILENAME;
  end;

  // The database file should be in either directory, if not, we write a log
  // to show that it has not been found.
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

  // Locate the database file
  LocateDatabase;

  if DatabaseExists then
  begin
    ConnectDB;

    // Back up the database on every run, nice to prevent
    // potential data corruption
    BackUpDB;

    // Nice to keep the database backup up often, every 5 minutes, unless the `.ldb` file exists, which would mean the database is still in use
    // It should backup the database every 5 minutes, but the timer logic causes it to back up the database every second for five minutes
    // Hence this is disabled for the time being
    timeBackup.Interval := 300;
    timeBackup.Enabled := False;
    timeBackup.OnTimer := timeBackupTimer;
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
