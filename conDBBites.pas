unit conDBBites;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdbmData = class(TDataModule)
    conDB: TADOConnection;
    tblUsers: TADOTable;
    dscUsers: TDataSource;
    tblMeals: TADOTable;
    dscMeals: TDataSource;
    tblFoods: TADOTable;
    dscFoods: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dbmData: TdbmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
