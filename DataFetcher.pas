unit DataFetcher;

interface

uses Vcl.Dialogs;
type
  TDataFetcher = class(TObject)

  public
    procedure FetchData(filename:string);
  private
    procedure EditFile(filename:string);
  end;

implementation

procedure TDataFetcher.FetchData;
begin
//  EditFile
  ShowMessage('The file ' + filename + ' will be edited');
end;

procedure TDataFetcher.EditFile(filename: string);
begin

end;

end.
