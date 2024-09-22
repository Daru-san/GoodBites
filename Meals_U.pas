unit Meals_U;

interface
uses conDB,System.Classes,System.SysUtils,User_U,Dialogs,JSON,StrUtils,frmDataRequest;
{ Display the meals in an image if possible}
type
  TFoodItem = class(TObject)
  private
    FFoodname : String;
    FCaloriePer100G : real;
    FProteinPer100G : real;
    FCarbPer100G : real;
    FFatPer100G : real;
    FEnergyPer100G : real;

    function ValidateFood: boolean;
    function FetchFood(query:string):string;

    procedure GetNutrients(sFoodname:string);
    procedure FetchNutrients;

  public
    constructor Create(sFoodname:string);

    property Foodname : String read FFoodname write FFoodname;
    property CaloriePer100G : real read FCaloriePer100G write FCaloriePer100G;
    property ProteinPer100G : real read FProteinPer100G write FProteinPer100G;
    property CarbPer100G : real read FCarbPer100G write FCarbPer100G;
    property FatPer100G : real read FFatPer100G write FFatPer100G;
    property EnergyPer100G : real read FEnergyPer100G write FEnergyPer100G;

    function CheckExists : Boolean;

    procedure AddFoodToDB;
    //function GetFoodname(sFoodname:string) : string;
  end;
  TMeal = class(TObject)
    private
      FMealID : string;
      FFood : String;
      FCalories : Integer;
      FNumServings : Integer;
      FMealType : String;
      FPortion : Integer;
      FFoodItem : TFoodItem;

      function CalcCalories(iCalories: Real) : Integer;
      function CalcEnergy: real;
    public
      constructor Create(F : TFoodItem; P : Integer;M: string = 'Other');

      property Calories : Integer read FCalories write FCalories;
      property NumServings : Integer read FNumServings write FNumServings;
      property MealType : string read FMealType write FMealType;
      property FoodItem : TFoodItem read FFoodItem write FFoodItem;
      property PortionSize : Integer read FPortion write FPortion;

      procedure EatMeal(UserID : String;TotalUserMeals:Integer);
  end;

implementation

{ Food procedures }

{$REGION FOODS }
constructor TFoodItem.Create(sFoodname: string);
begin
  Foodname := sFoodname;
  GetNutrients(sFoodname);
end;

procedure TFoodItem.GetNutrients;
var
  isFoodFound : Boolean;
begin
  isFoodFound := False;
  with dmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if sFoodname = FieldValues['FoodName'] then
      begin
	      isFoodFound := true;
        ProteinPer100G := FieldValues['ProteinPer100g'];
        CarbPer100G := FieldValues['CarbPer100g'];
        FatPer100G := FieldValues['FatPer100g'];
        CaloriePer100G := FieldValues['CaloriesPer100g'];
      end else Next;
    until EOF or isFoodFound;
    Close;

    {
      My idea here is that it is better to assign the food
      item with `default` values in the case where it is not
      found in the database, ensuring that the values do
      in fact exist (solves no problem now that I think about it)
    }
    if not isFoodFound then
    begin
      ProteinPer100G := 0;
      CarbPer100G := 0;
      FatPer100G := 0;
      CaloriePer100G := 0;
    end;
  end;
end;

function TFoodItem.CheckExists : boolean;
var isFound : boolean;
begin
  isFound := false;
  with dmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if Foodname = FieldValues['Foodname'] then
	      isFound := true
        else next;
    until isFound or EOF;
    Close;
  end;
  Result := isFound;
end;

// So far the idea here is to check if the values of nutrients are
// numbers above 0 and below an unexpected number
// Preventing odd values, so far I only plan to prompt the user in this case
// Asking them for confirmation, validation will be done in another way

//TODO: Complete validateFood() function
function TFoodItem.ValidateFood: boolean;
var
  nameCorrect,nutCheck : Boolean;
  proteinCheck,carbCheck,fatCheck,calCheck : boolean;
begin
  nameCorrect := utilObj.ValidateString(Foodname,'Meal',2,20);

  {
    This is still an early prototype of the thing I want to do
    but it attempts to validate whether the food item has the correct
    amount of each nutrient value
    It can probably be improved
  }
  calCheck := false;
  proteinCheck := false;
  carbCheck := false;
  fatCheck := false;

  if (CaloriePer100G < 0) or (CaloriePer100G > 100000) then
  begin
    calCheck := true;
  end;

  if (ProteinPer100G < 0) or (ProteinPer100G > 100000) then
  begin
    proteinCheck := true;
  end;

  if (CarbPer100G < 0) or (CarbPer100G > 100000) then
  begin
    carbCheck := true;
  end;

  if (FatPer100G < 0) or (FatPer100G > 100000) then
  begin
    fatCheck := true;
  end;

  nutCheck := calCheck and proteinCheck and carbCheck and fatCheck;

  Result := nutCheck and nameCorrect;
end;

function TFoodItem.FetchFood(query:string) : string;
var DataFetcher : TfrmFetcher;
begin
  DataFetcher := TfrmFetcher.Create(nil);
  Result := DataFetcher.GetJsonData(query);
  DataFetcher.Free;
end;

procedure TFoodItem.FetchNutrients;
var
  foodJson,branchJson,nutrientJson: TJSONValue;
  jsonString,jsonDataType : string;
  Protein,Carb,Energy,Fat : Real;
  valuename : string;
  i,j : integer;
  JSONObject : TJSONObject;
  itemFound,itemCorrect : Boolean;
begin
  jsonString := FetchFood(Foodname);
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

  ProteinPer100G := Protein;

  // VERY INACCURATE
  CaloriePer100G := Fat + Carb + Protein;

  FatPer100G := Fat;
  CarbPer100G := Carb;
  EnergyPer100G := Energy;
end;
{
  Get validated information from the user to add to the database
  these foods can then be eaten by the user afterwards.

  An idea I have is to allow users to search for the foods in some
  food database which can give them all of the nutrient values 
  given that the name is correct.
}
procedure TFoodItem.AddFoodToDB;
begin
  if ValidateFood then
  begin
    FetchNutrients;
    with dmData.tblFoods do
    begin
      Open;
      Append;
      FieldValues['FoodName'] := Foodname;
      FieldValues['CaloriesPer100g'] := CaloriePer100G;
      FieldValues['CarbPer100g'] := CarbPer100G;
      FieldValues['ProteinPer100g'] := ProteinPer100G;
      FieldValues['FatPer100g'] := FatPer100G;
      FieldValues['EnergyPer100G'] := EnergyPer100G;
      Post;
    end;
  end;
end;

{$ENDREGION}

{ Meal procedures}

{$REGION MEALS}
constructor TMeal.Create(F : TFoodItem; P : Integer;M: string = 'Other');
begin
  FoodItem := F;
  PortionSize := P;
  MealType := M;
  Calories := CalcCalories(FoodItem.CaloriePer100G);
end;

function TMeal.CalcCalories;
var
  iTotalCalories : Integer;
begin
  {
    Calories per 100g are multiplied by 100 to
    convert them to calories, then multiplied
    by the portion size to obtain the total
    caloires
  }

  iTotalCalories := Round(
      (FoodItem.CaloriePer100G)*(PortionSize/100)
  );

  Result := iTotalCalories;
end;

function TMeal.CalcEnergy: Real;
begin
  This in the case that I am able to obtain energy values
  Result := FoodItem.EnergyPer100G * (PortionSize/100);
end;

procedure TMeal.EatMeal(UserID : String;TotalUserMeals:Integer);
var
  sFoodname : string;
  iMealIndex : integer;
  isFound : Boolean;
begin

  // Increase the index of the meal for the specific user
  // Every user has an index for their meals
  // Making it possible to search through them for a specific one
  iMealIndex := TotalUserMeals;
  inc(iMealIndex);

  isFound := False;

  {
    Steps:
    1. Loop through the food table to find the meal name
    - If found then:
    1.1. Open the meals table to create a new record
    1.2. Add record with all relevent data
    1.3. Close Meal table
    1.4. Stop the loop
    1.5. Close the foods table
  }
  with dmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if FoodItem.Foodname = FieldValues['Foodname'] then
      begin
        isFound := true;
        sFoodname := FieldValues['Foodname'];
        with dmData.tblMeals do
        begin
          Open;
          Append;
          FieldValues['FoodName'] := sFoodname;
          FieldValues['TotalCalories'] := Calories;
          FieldValues['DateEaten'] := Date;
          FieldValues['TimeEaten'] := Time;
          FieldValues['UserID'] := UserID;
          FieldValues['UserMealID'] := iMealIndex;
          FieldValues['MealType'] := MealType;
          FieldValues['PortionSize'] := PortionSize;
          FieldValues['TotalEnergy'] := CalcEnergy;
          Post;
          Close;
        end;  // end tblMeals with
      end else next; // endif
    until EOF or isFound;
    Close;
  end; // end tblFoods with
end;

{$ENDREGION}
end.
