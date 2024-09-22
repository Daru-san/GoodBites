unit conDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,Windows,Utils_U;

type
  TdmData = class(TDataModule)
    dbConnect: TADOConnection;
    tblMeals: TADOTable;
    tblFoods: TADOTable;
    tblUsers: TADOTable;
    dscFoods: TDataSource;
    dscUsers: TDataSource;

    procedure BackUpDB;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ConnectDB;
  public
    { Public declarations }
  end;

var
  dmData: TdmData;
  logger : TLogs;

implementation

procedure TdmData.ConnectDB;
begin
  dbConnect := TADOConnection.Create(self);
  dbConnect.Connected := False;
  dbConnect.LoginPrompt := False;

  dbConnect.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dbBites.mdb;Mode=ReadWrite;Persist Security Info=False;Jet OLEDB:New Database Password="";';

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
end;

procedure TdmData.BackUpDB;
const FILENAME = 'dbBites.mdb';
var
  isFailed : Boolean;

begin
  logger := TLogs.Create;
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
end;

end.
