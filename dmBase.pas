unit dmBase;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmData = class(TDataModule)
    conDB: TADOConnection;
    tblUsers: TADOTable;
    dscUsers: TDataSource;
    tblData: TADOTable;
    dscData: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
