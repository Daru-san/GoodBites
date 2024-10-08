unit frmAddFood_U;
{ Place for users to input their own food choices and add them to the database, the API search is done in the libFetchAPI_U unit}
interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, StrUtils, Dialogs,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, OKCANCL2, JSON, Vcl.ComCtrls,
  libFetchAPI_U, libUtils_U, libMeals_U, Vcl.Mask, Vcl.WinXCtrls, frmCustomFood_U;

type
  TfrmAddFood = class(TOKRightDlg)
    HelpBtn: TButton;
    cbxItems: TComboBox;
    btnQuery: TButton;
    cbxBranded: TCheckBox;
    redItems: TRichEdit;
    btnCustom: TButton;
    edtQuery: TLabeledEdit;
    lblSelectItem: TLabel;
    procedure HelpBtnClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure AcceptItem;
    procedure FormShow(Sender: TObject);
    procedure cbxItemsChange(Sender: TObject);
    procedure edtQueryChange(Sender: TObject);
    procedure btnCustomClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    procedure SortItems(pJsonResponse : TStringStream;pResponseLength : Integer);
    function GetNutrientValue(pJsonNutrient : TJSONValue) : real;
  public
  end;

var
  frmAddFood: TfrmAddFood;
  FoodItem : TFoodItem;
  StringUtils : TStringUtils;

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

procedure TfrmAddFood.OKBtnClick(Sender: TObject);
begin
  inherited;
  AcceptItem;
end;

{$REGION BUTTONS}
// Sending the query
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

  // Set a loading cursor
  Screen.Cursor := crHourGlass;

  // We validate the name before beginning the query
  if StringUtils.ValidateString(sQuery,'foodname',1,20,'letters,numbers') then
  begin
    FetchAPI := TFetchAPI.Create;

    redItems.Text := 'Searching for ' + sQuery + '...';

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

      // If the query was successful we obtain
      // the response and store it
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
      redItems.Text := 'Success!';
      Foodname := sQuery;
      cbxItems.Enabled := True;
      cbxItems.Items.clear;
      cbxItems.Text := 'Choose an item';
      cbxItems.SetFocus;

      OKBtn.Enabled := false;

      // Sorting items and populating the array
      SortItems(JSONResponse,iResponseLength);

      redItems.Text := 'Select an item from the items combo box';
    end; // end if fetched
  end // end if valid
  else
    ShowMessage('Food name must be between 1 to 20 characters and not have special characters');
  Screen.Cursor := crDefault;
end;

// Accepting the food item and adding it to the database
procedure TfrmAddFood.AcceptItem;
var
  iFoodIndex : integer;
  rCalories,rEnergy,rProtein,rCarbs,rFat,rSugar: real;
  sFoodDesc,sCategory : string;
begin
  inherited;
  // Combo box indices begin at zero so we
  // increase this index by one to match with the arrays
  iFoodIndex := cbxItems.ItemIndex+1;
  sFoodDesc := arrFood[iFoodIndex];
  sCategory := arrCategory[iFoodIndex];
  rCalories := arrCalories[iFoodIndex];
  rEnergy := arrEnergy[iFoodIndex];
  rProtein := arrProtein[iFoodIndex];
  rCarbs := arrCarb[iFoodIndex];
  rFat := arrFat[iFoodIndex];
  rSugar := arrSugar[iFoodIndex];


  // Confirmation
  if MessageDlg('Are you sure you want to enter this food item?',mtConfirmation,mbYesNo,0) = mrYes then
  begin
    // We supply the food item with all necessary information and add it to the database
    FoodItem := TfoodItem.Create(sFoodDesc);
    FoodItem.AddNutrients(rCalories,rEnergy,rProtein,rCarbs,rFat,rSugar);
    FoodItem.Category := sCategory;
    FoodItem.AddFoodToDB;
    FoodItem.Free;
    ShowMessage(Foodname + ' has been added to the database!' + #13 + 'Happy eating!');
    OKBtn.ModalResult := mrYes;
  end;
end;

// Opening the `custom foods` form where users
// can add their own select food choices
procedure TfrmAddFood.btnCustomClick(Sender: TObject);
var
  CustomFoods : TfrmCustomFood;
  isAdded : Boolean;
begin
  inherited;
  CustomFoods := TfrmCustomFood.Create(nil);
  try
    Self.Hide;
    CustomFoods.ShowModal;
    isAdded := CustomFoods.ModalResult = mrYes;
  finally
    CustomFoods.Free;
  end;

  if isAdded then
    self.ModalResult := mrYes
  else
    self.Show;
end;
{$ENDREGION}

// Displaying food information
{$REGION DISPLAYING}
procedure TfrmAddFood.cbxItemsChange(Sender: TObject);
var
  iFoodIndex : integer;
  sFoodDesc,sFoodCat : string;
  rCalories,rEnergy,rProtein,rCarbs,rFat,rSugar: real;
begin
  inherited;
  if cbxItems.ItemIndex <> -1 then
  begin
    OKBtn.Enabled := true;
    OKBtn.Default := true;
    btnQuery.Default := false;
  end
  else OKBtn.Enabled := false;
  iFoodIndex := cbxItems.ItemIndex+1;

  sFoodCat := arrCategory[iFoodIndex];
  sFoodDesc := arrFood[iFoodIndex];
  rCalories := arrCalories[iFoodIndex];
  rEnergy := arrEnergy[iFoodIndex];
  rProtein := arrProtein[iFoodIndex];
  rCarbs := arrCarb[iFoodIndex];
  rFat := arrFat[iFoodIndex];
  rSugar := arrSugar[iFoodIndex];

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
      Add('Food item on ' + Foodname);
      Add('===========================');
      Add('Description' + #9 + sFoodDesc);
      Add('Category' + #9 + sFoodCat);
      Add('');
      Add('Nutrients:');
      Add('Calories(Calculated):' + #9 + FloatToStrF(rCalories,ffFixed,8,2) + 'cal');
      Add('Energy:' + #9 + FloatToStrF(rEnergy,ffFixed,8,2) + 'kJ');
      Add('Protein:' + #9 + FloatToStrF(rProtein,ffFixed,8,2)+ 'g');
      Add('Carbs:' + #9 + FloatToStrF(rCarbs,ffFixed,8,2)+ 'g');
      Add('Fat:' + #9 + FloatToStrF(rFat,ffFixed,8,2) + 'g');
      Add('Sugar:' + #9 + FloatToStrF(rSugar,ffFixed,8,2) + 'g');
      Add('');
      Add('Hit accept if everything looks good');
    end;
  end;
end;
{$ENDREGION}

// Form control
{$REGION FORM CONTROL}
procedure TfrmAddFood.FormShow(Sender: TObject);
begin
  inherited;
  StringUtils := TStringUtils.Create;
  edtQuery.SetFocus;

  with redItems.Lines do
  begin
    Clear;
    Add('Enter a food item and click the `query` button');
    Add('Check `branded` if the food item is branded or not a basic food item');
    Add('Add a custom food item by clicking `custom item`');
  end;
end;

// Dynamically enable components when the query is entered
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
    btnQuery.Default := true;
    OKBtn.Default := false;
  end
  else
  begin
    btnQuery.Enabled := False;
    cbxBranded.Enabled := false;
  end;
end;
{$ENDREGION}

// Parsing JSON and sorting food items
{$REGION PARSING AND SORTING}
procedure TfrmAddFood.SortItems(pJsonResponse: TStringStream; pResponseLength: Integer);
var
  j,P,i : integer;
  jsonArrFoods,jsonArrNutrients : TJSONArray;
  jsonFood : TJSONValue;
  jsonValue,jsonNutrientValue : TJSONValue;
  JsonFile,jsonNutrient : TJSONValue;
  sJsonResponse : String;
  isEmpty : Boolean;
  sNutrientName : String;
  iNutrientID : integer;
begin
  { We need to navigate the json text, going down the heiarchy each time
    and loop through each sub-array until we find the required values.

    Each food item as an item in the json array, the same goes for the nutrients as a sub-array
    of foodNutrients. }

  sJsonResponse := pJsonResponse.ReadString(pResponseLength);
  pJsonResponse.Free;

  isEmpty := (sJsonResponse = '');
  if isEmpty then exit;

  // Ensuring we can catch any last minute exceptions while parsing the json text
	try
    JsonFile := TJSONObject.ParseJSONValue(sJsonResponse);

    // I hope to avoid keeping large strings in memory for a long time
    sJsonResponse := '';
  except on E: Exception do
    begin
      ShowMessage('An unkown error occured, please try again');
      exit;
    end;
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
    ShowMessage('Error in retrieving results, please try again.');
    exit;
  end;

  numResults := jsonArrFoods.Count;

  // Start with j and use i as j+1, it makes
  // it easier for me to understand where the loop is
  for j := 0 to numResults - 1 do
  begin
    // i has to be one higher than j because json arrays begin their indexes at 0
    // but the others begin at one
    i := j+1;
    jsonFood := jsonArrFoods[j] as TJSONValue;

    // Getting our values from the current item in the `foods` json array
    arrFood[i] := JsonFood.FindValue('description').GetValue<string>;
    arrCategory[i] := jsonFood.FindValue('foodCategory').GetValue<String>;

    // Get our `jsonNutrients` json array and assign it as a TJSONArray
    jsonArrNutrients := (jsonFood as TJSONObject).Get('foodNutrients').JsonValue as TJSONArray;

    // p loops through each `jsonNutrient` in the jsonNutrients json array
    for p := 0 to jsonArrNutrients.Count - 1 do
    begin
      jsonNutrient := jsonArrNutrients.Items[p] as TJSONValue;

      // We use nutrient IDs to obtain specific values based on identifiers
      // that each nutrient is set in the API
      iNutrientID := jsonNutrient.FindValue('nutrientId').GetValue<integer>;

      case iNutrientID of
      1003: arrProtein[i] := GetNutrientValue(jsonNutrient);
      1004: arrFat[i] := GetNutrientValue(jsonNutrient);
      1005: arrCarb[i] := GetNutrientValue(jsonNutrient);
      1010: arrSugar[i] := GetNutrientValue(jsonNutrient);
      end;
    end;

    { Formula: Calories = protein*4 + carbohydrate*4 + lipid*9 }
    arrCalories[i] := (arrProtein[i] * 4) + (arrCarb[i] * 4) + (arrFat[i] * 9);

    // Energy being calories x 4.18
    arrEnergy[i] := arrCalories[i] * 4.18;
  end;

  // Populating our food combo box
  for j := 1 to numResults do
  begin
    cbxItems.Items.Add(arrFood[j]);
  end;
end;

// We use this function to get the value of the `value` key of the
// current item in the `jsonNutrients` json array
// Returned as a floating point number
function TfrmAddFood.GetNutrientValue(pJsonNutrient: TJSONValue): Real;
begin
  Result := pJsonNutrient.FindValue('value').GetValue<extended>;
end;
{$ENDREGION}
end.
