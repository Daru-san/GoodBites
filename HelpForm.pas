unit HelpForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Utils;

type
  TfrmHelp = class(TForm)
    pcHelp: TPageControl;
    tsExplain: TTabSheet;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    memPurpose: TMemo;
    pnlFoot: TPanel;
    btnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tsExplainShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    procedure ShowInfo(filename:string;memoComp : TMemo);
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.dfm}

procedure TfrmHelp.btnExitClick(Sender: TObject);
begin
  Self.ModalResult := mrClose;
  Self.CloseModal;
  Application.MainForm.show;
end;

procedure TfrmHelp.FormCreate(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblHeader,'Help',20);

end;

procedure TfrmHelp.tsExplainShow(Sender: TObject);
begin
  ShowInfo('help\purpose.txt',memPurpose);
end;
procedure TfrmHelp.ShowInfo;
var
  infoFile : textfile;
  lineString : string;
begin
  memoComp.Lines.Clear;
  if TUtils.Create.CheckFileExists(filename) then
  begin
    AssignFile(infoFile,filename);
    Reset(infoFile);
    repeat
      ReadLn(infoFile,lineString);
      memoComp.Lines.Add(lineString);
    until EOF(infoFile);
    CloseFile(infoFile);
  end else
  memoComp.Lines.Add('An unknown error occured');

end;

end.
