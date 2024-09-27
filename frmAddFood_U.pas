unit frmAddFood_U;
{ Place for users to input their own food choices and add them to the database, the API search is done in the libFetchAPI_U unit}
interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, StrUtils, Dialogs,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, JSON, Vcl.ComCtrls,
  libFetchAPI_U, libUtils_U, libMeals_U;

type
  TfrmAddFood = class(TOKRightDlg)
    HelpBtn: TButton;
    edtName: TEdit;
    cbxItems: TComboBox;
    btnQuery: TButton;
    btnAccept: TButton;
    cbxBranded: TCheckBox;
    redItems: TRichEdit;
    procedure HelpBtnClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxItemsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function FetchJson(sQuery:string;isBranded:Boolean) : string;

    procedure SortItems(jsonString:string);
  public
    { Public declarations }
  end;

var
  frmAddFood: TfrmAddFood;
  FoodItem : TFoodItem;
  Util : TUtils;
  Fetcher : TFetchAPI;

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
  jsonString : string;
begin
  inherited;
  Foodname := edtName.Text;

//  if Utils.ValidateString(Foodname,'foodname',1,20,'letters,numbers') then
  begin

    if cbxBranded.Checked then
    jsonString := FetchJson(Foodname,true)
    else jsonString := FetchJson(Foodname,false);

    SortItems(jsonString);
  end;
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

  Foodname := edtName.Text;
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
    ScrollBars := ssBoth;
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

procedure TfrmAddFood.edtNameChange(Sender: TObject);
begin
  inherited;
  if edtName.Text <> '' then
  begin
    btnQuery.Enabled := True;
    cbxBranded.Enabled := True;
    cbxItems.Enabled := true;
  end
  else
  begin
    btnQuery.Enabled := False;
    cbxBranded.Enabled := false;
    cbxItems.Enabled := false;
  end;
end;
function TfrmAddFood.FetchJson(sQuery: string;isBranded: Boolean): string;
begin
  Fetcher := TFetchAPI.Create;

  { Having trailing spaces in the query could cause
    problems when fetching, rather prevent that from
    happening than deal with those problems }
  sQuery.Trim;


  { The default argument is foundation, which is basic food items
  }
  if isBranded then
    Fetcher.SendQuery(sQuery,'Branded')
  else
    Fetcher.SendQuery(sQuery);

  Result := Fetcher.GetJson;

  Fetcher.free;
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
  edtName.SetFocus;
end;

procedure TfrmAddFood.SortItems;
var
  i,j : integer;
  jsonObj : TJSONObject;
  jsonArrFoods,jsonArrNutrients : TJSONArray;
  jsonFood : TJSONValue;
  jsonValue,jsonNutrientValue : TJSONValue;
  jsonData,jsonNutrients : TJSONValue;
begin

  {
    This allows us to parse json data easily
    Destroying the object immediately after conversion
    as a way of freeing memory
  }

//    When data is retrieved it is in a json file format
//    Looking something like this
//    ```json
//    {
//      "description": "item-desc";
//      "foodNutrients : [
//          {
//            nutrientName: "";
//            value: "";
//          }
//      ];
//     }
//     ``` end json
//  
//    
//	Thus we need to navigate the file going doing the heiarchy each time
//	through looping through each json array
//	Each food item as an item in the json array, the same goes for the nutrients


  jsonObj := TJSONObject.Create;
  jsonData := jsonObj.ParseJSONValue(jsonString);
  jsonObj.Destroy;


  { I hope to prevent type casting errors that may come up when the json
    file does not come out as expected, exiting seems to prevent any issues
    from arising very quickly }
  if (jsonData as TJSONObject).Get('foods').JsonValue is TJSONArray then
  begin
    jsonArrFoods := (jsonData as TJSONObject).Get('foods').JsonValue as TJSONArray;
  end
  else
  begin
    ShowMessage('Something weird happened..');
    exit;
  end;

  { Better to count on the number of actual results based on the json array and not the maximum size of the arrays(delphi arrays) }
  numResults := jsonArrFoods.size;


  for i := 1 to numResults do
  begin
    for jsonFood in jsonArrFoods do
    begin

      jsonValue := jsonFood.FindValue('description');

      { The nil check on every value prevents instances where values are assigned to nil, causing errors down the line }
      if jsonValue <> nil then
        arrFood[i] := jsonValue.GetValue<string>;

      jsonValue := jsonFood.FindValue('foodCategory');

      if jsonValue <> nil then
        arrCategory[I] := jsonValue.GetValue<string>;

      jsonNutrients := (jsonFood as TJSONObject).Get('foodNutrients').JsonValue;

      jsonArrNutrients := jsonNutrients as TJSONArray;

      for jsonNutrients in jsonArrNutrients do
      begin
        // Each nutrient has a name value that I can use to get the position in the json array
        // where I can find the nutrient values I am looking for
        jsonValue := jsonNutrients.FindValue('nutrientName');

        if (jsonValue.ToString = 'Total lipid (fat)') or (LowerCase(jsonValue.ToString).Contains('lipid')) then
        begin
          jsonNutrientValue := jsonNutrients.FindValue('value');

          if jsonNutrientValue <> nil then
          arrFat[i] := jsonNutrientValue.GetValue<Extended>;
        end;

        if (jsonValue.ToString = 'Carbohydrate, by difference') or (LowerCase(jsonValue.ToString).Contains('carbohydrate')) then
        begin
          jsonNutrientValue := jsonNutrients.FindValue('value');

          if jsonNutrientValue <> nil then
          arrCarb[i] := jsonNutrientValue.GetValue<Extended>;
        end;

        if (jsonValue.ToString = 'Protein') or (LowerCase(jsonValue.ToString).Contains('protein')) then
        begin
          jsonNutrientValue := jsonNutrients.FindValue('value');

          if jsonNutrientValue <> nil then
          arrProtein[i] := jsonNutrientValue.GetValue<Extended>;
        end;

        if (jsonValue.ToString = 'Energy (Atwater General Factors)') or (LowerCase(jsonValue.ToString).Contains('energy')) then
        begin
          jsonNutrientValue := jsonNutrients.FindValue('value');

          if jsonNutrientValue <> nil then
          arrEnergy[i] := jsonNutrientValue.GetValue<Extended>;
        end;

        if (jsonValue.ToString = 'Sugars, Total') or (LowerCase(jsonValue.ToString).Contains('sugar') and LowerCase(jsonValue.ToString).Contains('total')) then
        begin
          jsonNutrientValue := jsonNutrients.FindValue('value');

          if jsonNutrientValue <> nil then
          arrSugar[i] := jsonNutrientValue.GetValue<Extended>;
        end;
      end;

      // Calculate calories since they are not provided by the API
      {
        Their values may not be absolutely accurate due to lack of total coverage
        in terms of nutrients - I do not plan on adding the dozens of micronutrients in some formula :(
        The though is that they may be accurate enough by a small margin of error
      }
      { Formula: Calories = protein*4 + carbohydrate*4 + lipid*9 }
      arrCalories[i] := arrProtein[i]*4+arrCarb[i]*4+arrFat[i]*9;
    end;
  end;

  for i := 1 to numResults do
  begin
    cbxItems.clear;
    cbxItems.Items.Add(arrFood[i]);
  end;

end;


end.
 

