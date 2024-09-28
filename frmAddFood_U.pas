unit frmAddFood_U;
{ Place for users to input their own food choices and add them to the database, the API search is done in the libFetchAPI_U unit}
interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, StrUtils, Dialogs,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, JSON, Vcl.ComCtrls,
  libFetchAPI_U, libUtils_U, libMeals_U, Vcl.Mask, Vcl.WinXCtrls;

type
  TfrmAddFood = class(TOKRightDlg)
    HelpBtn: TButton;
    cbxItems: TComboBox;
    btnQuery: TButton;
    btnAccept: TButton;
    cbxBranded: TCheckBox;
    redItems: TRichEdit;
    edtQuery: TLabeledEdit;
    actvLoad: TActivityIndicator;
    procedure HelpBtnClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxItemsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtQueryChange(Sender: TObject);
  private
    procedure SortItems(JSONResponse : TStringStream;ResponseLength : Integer);
    function GetNutrientValue(jsonNutrient : TJSONValue) : real;
  public
  end;

var
  frmAddFood: TfrmAddFood;
  FoodItem : TFoodItem;
  Util : TUtils;

  // Store the foods in arrays of 1 to 10, only taking 10 items from a single query
  // These arrays will be linked to each other
  Foodname : string;
  arrFood : array[1..10] of string;
  arrCategory : array[1..10] of string;
  arrCalories : array[1..10] of real;
  arrCarb : array[1..10] of real;
  arrFat : array[1..10] of real;
  arrProtein : array[1..10] of real;
  arrEnergy : array[1..10] of real;
  arrSugar : array[1..10] of real;

  numResults : integer;

implementation

{$R *.dfm}

procedure TfrmAddFood.HelpBtnClick(Sender: TObject);
begin
  //TODO: Add help screen or dialogue to explain how this would ne done
  Application.HelpContext(HelpContext);
end;

procedure TfrmAddFood.btnAcceptClick(Sender: TObject);
var
  FoodIndex : integer;
  Calories,Energy,Protein,Carbs,Fat,Sugar: real;
  FoodDesc : string;
begin
  inherited;
  FoodIndex := cbxItems.ItemIndex+1;
  FoodDesc := arrFood[FoodIndex];
  Calories := arrCalories[FoodIndex];
  Energy := arrEnergy[FoodIndex];
  Protein := arrProtein[FoodIndex];
  Carbs := arrCarb[FoodIndex];
  Fat := arrFat[FoodIndex];
  Sugar := arrSugar[FoodIndex];


  if MessageDlg('Are you sure you want to enter this food item?',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    FoodItem := TfoodItem.Create(Foodname);
    FoodItem.AddNutrients(Calories,Protein,Carbs,Fat,Energy,Sugar);
    FoodItem.AddFoodToDB(FoodDesc);
    FoodItem.Free;
    ShowMessage(Foodname + ' has been added to the database!' + #13 + 'Happy eating!');
    OKBtn.ModalResult := mrYes;
  end;
end;

procedure TfrmAddFood.btnQueryClick(Sender: TObject);
var
  sQuery : string;
  JSONResponse : TStringStream;
  FetchAPI : TFetchAPI;
  isFetched : Boolean;
  iResponseLength : Integer;
begin
  inherited;

  sQuery := edtQuery.Text;
  Trim(sQuery);

  actvLoad.StartAnimation;
  if Util.ValidateString(sQuery,'foodname',1,20,'letters,numbers') then
  begin
    FetchAPI := TFetchAPI.Create;
    try
      if cbxBranded.Checked then
      begin
        // Send the `branded` search parameter in the case of searching
        // for foods that are branded, like pizzas.
        // Default is `foundation`, which is basic everyday food items like apples
        FetchAPI.SendQuery(sQuery,'Branded');
      end
        else
      begin
        FetchAPI.SendQuery(sQuery);
      end; // end if
      isFetched := FetchAPI.QuerySuccessful;

      if isFetched then
      begin
        JSONResponse := FetchAPI.JSONResponse;
        iResponseLength := FetchAPI.ResponseLength;
      end; // end if
    finally
      FetchAPI.Free;
    end; // end try

    if isFetched then
    begin
      Foodname := sQuery;
      cbxItems.Enabled := True;
      cbxItems.Items.clear;
      cbxItems.Text := 'Choose an item';

      btnAccept.Enabled := false;

      SortItems(JSONResponse,iResponseLength);
    end; // end if fetched
  end // end if valid
  else
    ShowMessage('Food name must be between 1 to 20 characters and not have special characters');
  actvLoad.StopAnimation;
end;

procedure TfrmAddFood.cbxItemsChange(Sender: TObject);
var
  FoodIndex : integer;
  Foodname,FoodDesc,FoodCat : string;
  Calories,Energy,Protein,Carbs,Fat,Sugar: real;
begin
  inherited;
  if cbxItems.ItemIndex <> -1 then
    btnAccept.Enabled := true
  else btnAccept.Enabled := false;
  FoodIndex := cbxItems.ItemIndex+1;

  Foodcat := arrCategory[FoodIndex];
  FoodDesc := arrFood[FoodIndex];
  Calories := arrCalories[FoodIndex];
  Energy := arrEnergy[FoodIndex];
  Protein := arrProtein[FoodIndex];
  Carbs := arrCarb[FoodIndex];
  Fat := arrFat[FoodIndex];
  Sugar := arrSugar[FoodIndex];

  with redItems do
  begin
    Clear;
    ScrollBars := ssVertical;
    with Paragraph do
    begin
      TabCount := 2;
      Tab[0] := 100;
      Tab[1] := 150;
    end;
    with lines do
    begin
      Add('Data on ' + Foodname + #13);
      Add('Description' + #9 + FoodDesc);
      Add('Category' + #9 + FoodCat);
      Add('');
      Add('Nutrients:');
      Add('Calories(Calculated):' + #9 + FloatToStrF(Calories,ffFixed,8,2) + 'kCal');
      Add('Energy:' + #9 + FloatToStrF(Energy,ffFixed,8,2) + 'kJ');
      Add('Protein:' + #9 + FloatToStrF(Protein,ffFixed,8,2)+ 'g');
      Add('Carbs:' + #9 + FloatToStrF(Carbs,ffFixed,8,2)+ 'g');
      Add('Fat:' + #9 + FloatToStrF(Fat,ffFixed,8,2) + 'g');
      Add('Sugar:' + #9 + FloatToStrF(Sugar,ffFixed,8,2) + 'g');
    end;
  end;
end;

procedure TfrmAddFood.edtQueryChange(Sender: TObject);
var
  isEditEmpty : Boolean;
begin
  inherited;

  isEditEmpty := (edtQuery.text = '');

  if not isEditEmpty then
  begin
    btnQuery.Enabled := True;
    cbxBranded.Enabled := True;
  end
  else
  begin
    btnQuery.Enabled := False;
    cbxBranded.Enabled := false;
  end;
end;

procedure TfrmAddFood.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Util.Free;
end;

procedure TfrmAddFood.FormShow(Sender: TObject);
begin
  inherited;
  Util := TUtils.Create;
  edtQuery.SetFocus;
  redItems.Text := 'Food information goes here';
end;

procedure TfrmAddFood.SortItems;
var
  j,P : integer;
  jsonArrFoods,jsonArrNutrients : TJSONArray;
  jsonFood : TJSONValue;
  jsonValue,jsonNutrientValue : TJSONValue;
  JsonFile,jsonNutrient : TJSONValue;
  sJsonResponse : String;
  isEmpty : Boolean;
  sNutrientName : String;
begin
  {
    We need to navigate the json text, going down the heiarchy each time
    and loop through each sub-array until we find the required values.

    Each food item as an item in the json array, the same goes for the nutrients as a sub-array
    of foodNutrients.
  }


  sJsonResponse := JSONResponse.ReadString(ResponseLength);
  JSONResponse.Free;

  isEmpty := (sJsonResponse = '');
  if isEmpty then exit;

  // Ensuring we can catch any last minute exceptions while parsing the json text
	try
    JsonFile := TJSONObject.ParseJSONValue(sJsonResponse);

    // I hope to avoid keeping large strings in memory for a long time
    sJsonResponse := '';
  except on E: Exception do
    exit;
  end;


  { I hope to prevent type casting errors that may come up when the json
    file does not come out as expected, exiting seems to prevent any issues
    from arising very quickly }
  if (JsonFile as TJSONObject).Get('foods').JsonValue is TJSONArray then
  begin
    jsonArrFoods := (JsonFile as TJSONObject).Get('foods').JsonValue as TJSONArray;
  end
  else
  begin
    ShowMessage('Something weird happened..');
    exit;
  end;

  numResults := jsonArrFoods.Count;

  for j := 1 to numResults do
  begin
    jsonFood := jsonArrFoods[j] as TJSONValue;

    arrFood[j] := JsonFood.FindValue('description').GetValue<string>;
    arrCategory[j] := jsonFood.FindValue('foodCategory').GetValue<String>;

    jsonArrNutrients := (jsonFood as TJSONObject).Get('foodNutrients').JsonValue as TJSONArray;

    for p := 1 to jsonArrNutrients.Count do
    begin
      jsonNutrient := jsonArrNutrients.Items[p] as TJSONValue;

      sNutrientName := LowerCase(jsonNutrient.FindValue('name').ToString);

      case IndexStr(sNutrientName,['total lipid (fat)','carbohydrate, by difference','protein','energy','sugars, total']) of
      0: arrFat[j] := GetNutrientValue(jsonNutrient);
      1: arrCarb[j] := GetNutrientValue(jsonNutrient);
      2: arrProtein[j] := GetNutrientValue(jsonNutrient);
      3: arrEnergy[j] := GetNutrientValue(jsonNutrient);
      4: arrSugar[j] := GetNutrientValue(jsonNutrient);
      end;

      { Formula: Calories = protein*4 + carbohydrate*4 + lipid*9 }
      arrCalories[j] := arrProtein[j]*4+arrCarb[j]*4+arrFat[j]*9;
    end;
  end;

  for j := 1 to numResults do
  begin
    cbxItems.Items.Add(arrFood[j]);
  end;
end;

function TfrmAddFood.GetNutrientValue(jsonNutrient: TJSONValue): Real;
begin
  Result := jsonNutrient.FindValue('value').GetValue<extended>;
end;

end.
