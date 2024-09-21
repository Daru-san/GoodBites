unit Meals_U;

interface
uses conDB,System.Classes,System.SysUtils,User_U,Dialogs,JSON,StrUtils,frmDataRequest;
{ Display the meals in an image if possible}
type
  TFoodItem = class(TObject)
  private
    FFoodname : String;
    FCaloriePer100G : integer;
    FProteinPer100G : integer;
    FCarbPer100G : integer;
    FFatPer100G : integer;
    //TODO: Add energy (maybe) FEnergyPer100G : real;

    function ValidateFood(sFoodname:string;Calories:Integer): boolean;

    procedure GetNutrients(sFoodname:string);
  public
    constructor Create(sFoodname:string);

    property Foodname : String read FFoodname write FFoodname;
    property CaloriePer100G : Integer read FCaloriePer100G write FCaloriePer100G;
    property ProteinPer100G : integer read FProteinPer100G write FProteinPer100G;
    property CarbPer100G : integer read FCarbPer100G write FCarbPer100G;
    property FatPer100G : integer read FFatPer100G write FFatPer100G;

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

      function CalcCalories(iCalories: Integer) : Integer;
    public
      constructor Create(FoodItem : TFoodItem;PortionSize:Integer; sMealType: string = 'Other');

      property Calories : Integer read FCalories write FCalories;
      property NumServings : Integer read FNumServings write FNumServings;
      property MealType : string read FMealType write FMealType;
      property FoodItem : TFoodItem read FFoodItem write FFoodItem;
      property PortionSize : Integer read FPortion write FPortion;

      procedure EatMeal(UserID : String);
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
  with dbData.tblFoods do
  begin
    Open;
    First;
    repeat
      if sFoodname = FieldValues['FoodName'] then
      begin
	isFoodFound := true;
        ProteinPer100G := FieldValues['ProteinPer100g'];
        CarbPer100G := FieldValues['CarbohydratePer100g'];
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
  with dbData.tblFoods do
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
function TFoodItem.ValidateFood(sFoodname:string;Calories:Integer): boolean;
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

  if (CaloriesPer100G < 0) or (CaloriesPer10G > 100000) then
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

{
  Get validated information from the user to add to the database
  these foods can then be eaten by the user afterwards.

  An idea I have is to allow users to search for the foods in some
  food database which can give them all of the nutrient values 
  given that the name is correct.
}
procedure TFoodItem.AddFoodToDB;
begin
  if ValidateFood(Foodname,CaloriePer100G) then
    with dbData.tblFoods do
    begin
      Open;
      Append;
      FieldValues['FoodName'] := Foodname;
      FieldValues['CaloriesPer100g'] := CaloriePer100G;
      FieldValues['CarbohydratePer100g'] := CarbPer100G;
      FieldValues['ProteinPer100g'] := ProteinPer100G;
      FieldValues['FatPer100g'] := FatPer100G;
      Post;
    end;
end;

{$ENDREGION}

{ Meal procedures}

{$REGION MEALS}
constructor TMeal.Create(FoodItem : TFoodItem; PortionSize : Integer;sMealType: string = 'Other');
begin
  Calories := CalcCalories(FoodItem.CaloriePer100G);
  MealType := sMealType;
end;

function TMeal.CalcCalories;
var
  iTotalCalories : Integer;
begin
  {
    Say calories are measured in cl, num calories would be 100 grams per cl
    x = (150/100)g*52cl.100g^-1 * 5, would be about 260 calories?
    That makes decent sense, I will stick to  this methodology for now

    Too many physics style calculation?
  }

  iTotalCalories := Round(
      (iCalories/100)*iPortionSize
  ); //*FNumServings;

  Result := iTotalCalories;
end;

procedure TMeal.EatMeal(UserID : String);
var
  sFoodname : string;
  iMealIndex : integer;
  isFound : Boolean;
begin

  // Increase the index of the meal for the specific user
  // Every user has an index for their meals
  // Making it possible to search through them for a specific one
  iMealIndex := currentUser.GetTotalMeals;
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
  with dbData.tblFoods do
  begin
    Open;
    First;
    repeat
      if FoodItem.Foodname = FieldValues['Foodname'] then
      begin
        isFound := true;
        sFoodname := FieldValues['Foodname'];
        with dbData.tblMeals do
        begin
          Open;
          Append;
          FieldValues['FoodName'] := sFoodname;
          FieldValues['TotalCalories'] := Calories;
          FieldValues['DateEaten'] := date;
          FieldValues['TimeEaten'] := Time;
          FieldValues['UserID'] := UserID;
          FieldValues['UserMealID'] := iMealIndex;
          FieldValues['MealType'] := MealType;
          FieldValues['PortionSize'] := PortionSize;
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
