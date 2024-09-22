unit frmAddFood_U;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, StrUtils, Dialogs,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2,Meals_U,JSON,frmDataRequest,Utils_U;

type
  TfrmAddFood = class(TOKRightDlg)
    HelpBtn: TButton;
    edtName: TEdit;
    cbxItems: TComboBox;
    btnQuery: TButton;
    btnAccept: TButton;
    procedure HelpBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function FetchJson(sQuery:string) : string;

    procedure SortItems(jsonString:string);
  public
    { Public declarations }
  end;

var
  frmAddFood: TfrmAddFood;
  FoodItem : TFoodItem;
  Util : TUtils;

  // Store the foods in arrays of 1 to 10, only taking 10 items from a single query
  // These arrays will be linked to each other
  arrFood : array[1..10] of string;
  arrCalories : array[1..10] of real;
  arrCarb : array[1..10] of real;
  arrFat : array[1..10] of real;
  arrProtein : array[1..10] of real;
  arrEnergy : array[1..10] of real;

implementation

{$R *.dfm}

procedure TfrmAddFood.HelpBtnClick(Sender: TObject);
begin
  //TODO: Add help screen or dialogue to explain how this would ne done
  Application.HelpContext(HelpContext);
end;

procedure TfrmAddFood.OKBtnClick(Sender: TObject);
begin
  inherited;

end;

{
  Create the data fetcher form,
  Allows me to free the form once
  it has been used, and cleanly
}
procedure TfrmAddFood.btnAcceptClick(Sender: TObject);
var
  FoodIndex : integer;
  Foodname : string;
  Calories,Energy,Protein,Carbs,Fat: real;
begin
  inherited;
  FoodIndex := cbxItems.ItemIndex+1;

  Foodname := arrFood[FoodIndex];
  Calories := arrCalories[FoodIndex];
  Energy := arrEnergy[FoodIndex];
  Protein := arrProtein[FoodIndex];
  Carbs := arrCarb[FoodIndex];
  Fat := arrFat[FoodIndex];
  ShowMessage(
    'Please verify this data is correct ' + #13 +
    'Data for ' + Foodname + #13
    + 'Calories: ' + FloatToStrF(Calories,ffFixed,8,2) + 'kCal'
    + 'Energy: ' + FloatToStrF(Energy,ffFixed,8,2) + 'kJ' + #13
    + 'Protein: ' + FloatToStrF(Protein,ffFixed,8,2)+ 'g'
    + 'Carbs: ' + FloatToStrF(Carbs,ffFixed,8,2)+ 'g' + #13
    + 'Fat ' + FloatToStrF(Fat,ffFixed,8,2) + 'g'
  );

  //TODO: Add sugars
  if MessageDlg('Are you sure you want to enter this food item?',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    FoodItem.Create(Foodname);
    FoodItem.AddNutrients(Protein,Carbs,Fat,Energy,Calories);
    FoodItem.AddFoodToDB;
    FoodItem.Free;
    ShowMessage(Foodname + ' has been added to the database!' + #13 + 'Happy eating!');
    OKBtn.ModalResult := mrYes;
  end;
end;

procedure TfrmAddFood.btnQueryClick(Sender: TObject);
var
  Foodname : string;
  jsonString : string;
begin
  inherited;
  Foodname := edtName.Text;
//  if Utils.ValidateString(Foodname,'foodname',1,20,'letters,numbers') then
  begin
    jsonString := FetchJson(Foodname);
    SortItems(jsonString);
  end;
end;

function TfrmAddFood.FetchJson(sQuery: string): string;
var
  DataFetcher : TfrmFetcher;

begin
  DataFetcher := TfrmFetcher.Create(nil);

  { Having trailing spaces in the query could cause
    problems when fetching, rather prevent that from
    happening than deal with those problems }
  sQuery.Trim;

  Result := DataFetcher.GetJsonData(sQuery);
  DataFetcher.Free;
end;


procedure TfrmAddFood.FormShow(Sender: TObject);
begin
  inherited;
  Util := TUtils.Create;
end;

procedure TfrmAddFood.SortItems;
var
  foodJson,branchJson,nutrientJson: TJSONValue;
  jsonDataType : string;
  Protein,Carb,Energy,Fat : Real;
  valuename : string;
  i,j : integer;
  JSONObject : TJSONObject;
  itemFound,itemCorrect : Boolean;
begin
  JSONObject := TJSONObject.Create;
  foodJson := JsonObject.ParseJsonValue(jsonString);
  i := 0;
  repeat
    inc(i);
    nutrientJson := ((foodJson as TJsonArray).items[i] as TJsonObject);
    jsonDataType := (foodJson as TJSONObject).Get('dataType').jsonValue.value;
    j := 0;
    repeat
      inc(j);
      if jsonDataType.contains('Survery') or jsonDataType.contains('Branded') then
      begin
        Protein := 0;
        Fat := 0;
        Carb := 0;
        Energy := 0;
        itemCorrect := False;
        for j := 1 to branchJson.value.length do
        begin
          valuename := ((branchJson as TJsonArray).items[j] as TJsonObject).Get('name').JsonValue.Value;
          branchJson := (nutrientJson as TJSONObject).Get('foodNutrients').jsonValue;
          Case IndexStr(valuename,['Protein','Total lipid (fat)','Carbohydrate, by difference','Energy']) of
            0 : Protein := ((branchJson as TJSONObject).Get('amount').JsonValue.Value.ToExtended);
            1 : Fat := ((branchJson as TJSONObject).Get('amount').JsonValue.Value.ToExtended);
            2 : Carb := ((branchJson as TJSONObject).Get('amount').JsonValue.Value.ToExtended);
            3 : Energy := ((branchJson as TJSONObject).Get('amount').JsonValue.Value.ToExtended);
          End;
        end;
        if (Protein <> 0) and (Fat <> 0) and (Carb <> 0) and (Energy <> 0) then
        begin
          itemCorrect := true;
        end else itemCorrect := False;
      end;
    until itemCorrect or (j = 10);
  until (i = 10) or itemCorrect;

  //TODO: Handle issue where nutrients are not found
  JSONObject.Destroy;

  for i := 1 to Length(arrFood) do
  begin
    cbxItems.Items.Add(arrFood[i]);
  end;
end;


end.
 
