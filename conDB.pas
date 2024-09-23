unit conDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,Windows,libUtils_U,
  Vcl.ExtCtrls;

type
  TdmData = class(TDataModule)
    dbConnect: TADOConnection;
    tblMeals: TADOTable;
    tblFoods: TADOTable;
    tblUsers: TADOTable;
    dscFoods: TDataSource;
    dscUsers: TDataSource;
    timeBackup: TTimer;

    procedure BackUpDB;
    procedure DataModuleCreate(Sender: TObject);
    procedure timeBackupTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure ConnectDB;
  public
    { Public declarations }
  end;

var
  dmData: TdmData;
  logger : TLogs;
  Util : TUtils;

implementation

procedure TdmData.ConnectDB;
begin
  dbConnect := TADOConnection.Create(self);
  dbConnect.Connected := False;
  dbConnect.LoginPrompt := False;

  dbConnect.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=..\..\dbBites.mdb;Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:New Database Password="";';

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

  tblFoods.Active := True;
  tblMeals.Active := true;
  tblUsers.Active := true;

  {
    Nice to keep the database backup up often, every 5 minutes, unless the `.ldb` file exists, which would mean the database is still in use
  }
  timeBackup.Enabled := true;
  timeBackup.Interval := 5*60;
end;

procedure TdmData.BackUpDB;
const FILENAME = 'dbBites.mdb';
var
  isFailed : Boolean;

begin

  { Only backup if the `database.ldb` file is NOT present,
    issues can come up when the database is backed up while still in use,
    I would rather back it up frequently but not when it is in use }
  if not Util.CheckFileExists('dbBites.ldb') then
  DeleteFile(FILENAME + '.backup');
  CopyFile(FILENAME,FILENAME+'.backup',isFailed);
  if isFailed then
    logger.WriteErrorLog('Error backing up the database')
	else
		logger.WriteErrorLog('Database backup successful!');
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  ConnectDB;
  Util.Create;
  logger := TLogs.Create;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  Util.Free;
  logger.Free;
end;

procedure TdmData.timeBackupTimer(Sender: TObject);
begin
  BackUpDB;
end;

end.
