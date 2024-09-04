unit Dashboard_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,InfoBoard,Utils_U,User_u,
  Vcl.ComCtrls,Meals_U,conDBBites;

type
  TfrmDashboard = class(TForm)
    pnlCenter: TPanel;
    pnlHeader: TPanel;
    lblHeader: TLabel;
    pnlProgress: TPanel;
    lblHeading: TLabel;
    pnlNav: TPanel;
    lblEats: TLabel;
    pnlFoot: TPanel;
    btnLogOut: TButton;
    pnlUser: TPanel;
    lblUser: TLabel;
    dpcDay: TDateTimePicker;
    btnLoadData: TButton;
    pnlProgIndicator: TPanel;
    memMealLog: TMemo;
    lblDayCalorie: TLabel;
    edtCaloires: TEdit;
    cmbMeals: TComboBox;
    edtPortion: TEdit;
    btnEaten: TButton;
    pnlNewMeal: TPanel;
    lblCustomMeal: TLabel;
    cbxAddDB: TCheckBox;
    edtMealName: TEdit;
    edtNumCalories: TEdit;
    cbxNewFood: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnLogOutClick(Sender: TObject);
    procedure pnlInfoClick(Sender: TObject);
    procedure btnEatenClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
  private
    { Private declarations }
    procedure PopulateFoods;
  public
    { Public declarations }
    currentUser : TUser;
    currentMeal : TMeal;
  end;

var
  frmDashboard: TfrmDashboard;
  username : string;
  arrFoods : array of string;

implementation

{$R *.dfm}

procedure TfrmDashboard.btnEatenClick(Sender: TObject);
var
  selectedOpt,iCalories,iCheckInt : integer;
  sMealName : string;
  arrNutrients : array of string;
begin
  sMealName := cmbMeals.text;
  Val(edtCaloires.Text,iCalories,iCheckInt);
  selectedOpt := MessageDlg('Are you sure you want to enter this food item',mtConfirmation,mbYesNo,0);
  if selectedOpt = mrYes then
  begin
    if cbxNewFood.Checked then
      currentMeal.Create(sMealName,iCalories,false) else
      currentMeal.Create(sMealName,0,false);
  end;

end;

procedure TfrmDashboard.btnLoadDataClick(Sender: TObject);
var
  selectedDate : TDate;
  iTotalCalories,iNumMeals : integer;
  arrMealLog :  array of string;
  i: Integer;
begin
  selectedDate := dpcDay.Date;
  iTotalCalories := currentUser.GetDailyCalories(selectedDate);
  iNumMeals := currentUser.GetTotalMeals;
  for i := 1 to iNumMeals do
  begin
    arrMealLog[i] := currentUser.GetMeal(i);
    memMealLog.Lines.Add(arrMealLog[i]);
  end;

  edtCaloires.Text := IntToStr(iTotalCalories);
end;

procedure TfrmDashboard.btnLogOutClick(Sender: TObject);
begin
  // Get closing to work properly
  Application.MainForm.Visible := true;
  frmDashboard.Close;
  frmDashboard.Destroy;
  currentUser.Free;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
  TUtils.Create.SetLabel(lblHeading,'Dashboard',15);
  username := currentUser.Username;
  Tutils.Create.SetLabel(lblUser,'Logged in as ' + username,8);

  PopulateFoods;
end;

procedure TfrmDashboard.PopulateFoods;
var
 currentMeal : string;
 i : Integer;
begin
 i := 0;
 with dbmData.tblFoods do
 begin
  Open;
  First;
  repeat
    inc(i);
    currentMeal := FieldValues['Foodname'];
    arrFoods[i] := currentMeal;
    cmbMeals.Items.Add(currentMeal);
    Next;
  until Eof;
  Close;
 end;
end;

procedure TfrmDashboard.pnlInfoClick(Sender: TObject);
var
  infoForm : InfoBoard.TfrmInfo;
begin
 infoForm := TfrmInfo.Create(nil);
 try
  infoForm.ShowModal;
  self.hide;
 finally
   infoForm.Free;
//   Self.Show;
 end;

end;

end.
