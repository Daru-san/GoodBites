unit Meals_U;

interface

uses conDBBites,System.Classes,System.SysUtils,User_U,Dialogs;
{ Display the meals in an image if possible}
type
  TMeal = class(TObject)
    private
      FMealID : string;
      FFood : String;
      FCaloriePer100G : integer;
      FCalories : Integer;
      FProteinPer100G : integer;
      FCarbPer100G : integer;
      FFatPer100G : integer;
      FNumServings : Integer;
      FPortion : Integer;

      procedure AddFoodToDB(sFoodname: string; numCalories : integer);
      procedure GetNutrients(sFoodname:string);

      function CalcCalories(iPortionSize:integer; numCalories: Integer) : Integer;
      function GetFoodname(sFoodname:string) : string;
    public
      constructor Create(sFoodname:string; sMealType:string = 'Other'; iportionSize : integer = 0; iCalories:Integer = 0;NewMeal:Boolean = false);

      property Foodname : string read FFood write FFood;
      property Calories : Integer read FCalories write FCalories;
      property CaloriePer100G : Integer read FCaloriePer100G write FCaloriePer100G;
      property ProteinPer100G : integer read FProteinPer100G write FProteinPer100G;
      property CarbPer100G : integer read FCarbPer100G write FCarbPer100G;
      property FatPer100G : integer read FFatPer100G write FFatPer100G;
      property NumServings : Integer read FNumServings write FNumServings;
      property PortionSize : Integer read FPortion write FPortion;

      procedure EatMeal(currentUser : TUser);

      function GetFoodInfo(FoodProperty:string; nutrientName : string = '') : Integer;
      function ValidateFood(sFoodname:string;Calories:Integer): boolean;
  end;

implementation

constructor TMeal.Create(sFoodname : string; sMealType: string = 'Other'; iPortionSize:integer = 0; iCalories: Integer = 0;NewMeal:Boolean = false);
begin
  sFoodname.Trim;

  if NewMeal then
  begin
    AddFoodToDB(sFoodname,Calories);
  end else
  begin
    sFoodname := GetFoodname(sFoodname);
    GetNutrients(sFoodname);
  end;
  if iCalories = 0 then
    Calories := CalcCalories(iPortionSize,CaloriePer100G)
  else
    Calories := 0;
  Foodname := sFoodname;
  PortionSize := iPortionSize;
end;

function TMeal.ValidateFood(sFoodname:string;Calories:Integer): boolean;
var
  nameCorrect,nutrientCorrect,calorieCorrect : Boolean;
  isLong : Boolean;
begin
  nameCorrect := utilObj.ValidateString(Foodname,'Meal',2,20);
  //Validate nutrients and calorie counts
end;

function TMeal.GetFoodname(sFoodname: string): string;
var
  sFinalFoodname : string;
  isFound : Boolean;
begin
  isFound := False;
  with dbmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if UpperCase(sFoodname) = UpperCase(FieldValues['Foodname']) then
      begin
        isFound := true;
        sFinalFoodname := FieldValues['Foodname'];
      end else next;
    until Eof or isFound;
    Close;
  end;
  Result := sFinalFoodname;
end;

procedure TMeal.AddFoodToDB(sFoodname: string; numCalories : integer);
begin
  if ValidateFood(sFoodname,numCalories) then
    with dbmData.tblFoods do
    begin
      Open;
      Append;
      FieldValues['FoodName'] := Foodname;
      FieldValues['CaloriesPer100g'] := numCalories;
      FieldValues['CarbohydratePer100g'] := CarbPer100G;
      FieldValues['ProteinPer100g'] := ProteinPer100G;
      FieldValues['FatPer100g'] := FatPer100G;
      Post;
    end;
end;

procedure TMeal.EatMeal(currentUser : TUser);
var
  currentDate : TDate;
  iMealIndex : integer;
begin
  currentDate := now;
  iMealIndex := currentUser.GetTotalMeals;
  inc(iMealIndex);

  with dbmData.tblMeals do
  begin
    Open;
    Append;
    FieldValues['FoodName'] := Foodname;
    FieldValues['TotalCalories'] := Calories;
    FieldValues['DateEaten'] := currentDate;
    FieldValues['UserID'] := currentUser.UserID;
    FieldValues['MealIndex'] := iMealIndex;
    Post;
    Close;
  end;
end;
procedure TMeal.GetNutrients;
var
  isFoodFound : Boolean;
begin
  isFoodFound := False;
  with dbmData.tblFoods do
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
  end;
end;

function TMeal.GetFoodInfo(FoodProperty:string; nutrientName : string = '') : Integer;
var
  returnString : Integer;
begin
  if FoodProperty = 'Nutrient' then
  begin
    if nutrientName = 'Protein' then
      returnString := FProteinPer100G else
    if nutrientName = 'Carbohydrate' then
      returnString := FCarbPer100G else
    if nutrientName = 'Fat' then
      returnString := FFatPer100G;
  end else
  if FoodProperty = 'Calories' then
   returnString := CaloriePer100G;
  Result := returnString;
end;

function TMeal.CalcCalories;
var
  iTotalCalories : Integer;
begin
  {
    Say calories are measured in cl, num calories would be 100 grams per cl
    x = (150/100)g*52cl.100g^-1 * 5, would be about 260 calories?
    That makes decent sense, I will stick to  this methodology for now

		Too much physics style calculation?
  }

  iTotalCalories := Round(
      (numCalories/100)*iPortionSize
  ); //*FNumServings;

  Result := iTotalCalories;
end;
end.
