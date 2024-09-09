unit Meals_U;

interface

uses conDBBites,System.Classes,System.SysUtils,User_U;
{ Display the meals in an image if possible}
type
  TMeal = class
    private
      FMealID : string;
      FMealName : String;
      FNumCalories : integer;
      FProtein : integer;
      FCarbohydrate : integer;
      FFats : integer;

      procedure AddMealToDB(sMealname: string; sNutrients: string;numCalories : integer);
      procedure GetNutrients;
      procedure GetCalories(portionSize:integer);
    public
      constructor Create(Mealname:string; portionSize : integer = 0; Calories:Integer = 0;NewMeal:Boolean = false);
      property Mealname :string read FMealName write FMealName;
      property Calories : Integer read FNumCalories write FNumCalories;

      procedure EatMeal(currentUser : TUser);

      function GetMealInfo(MealProperty:string; nutrientName : string = '') : Integer;
  end;

implementation

constructor TMeal.Create(Mealname: string; portionSize:integer = 0; Calories: Integer = 0;NewMeal:Boolean = false);
var
  sNutrients : string;
begin

  if NewMeal then
  begin
    AddMealToDB(Mealname,sNutrients,Calories);
  end else
  begin
    GetNutrients;
  end;
  if Calories = 0 then
  GetCalories(portionSize);
  FMealName := Mealname;
  FNumCalories := Calories;
end;

procedure TMeal.AddMealToDB(sMealname: string; sNutrients: string;numCalories : integer);
begin
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
    FieldValues['MealName'] := Mealname;
    FieldValues['TotalCalories'] := Calories;
    FieldValues['DateEaten'] := currentDate;
    FieldValues['CarbsPer100g'] := FCarbohydrate;
    FieldValues['ProteinsPer100g'] := FProtein;
    FieldValues['FatPer100g'] := FFats;
    FieldValues['UserID'] := currentUser.UserID;
    FieldValues['MealIndex'] := iMealIndex;
    Post;
    Close;
  end;
end;
procedure TMeal.GetNutrients;
var
  isMealFound : Boolean;
begin
  with dbmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if UpperCase(Mealname) = UpperCase(FieldValues['Mealname']) then
      begin
        isMealFound := true;
        FProtein := FieldValues['ProteinsPer100g'];
        FCarbohydrate := FieldValues['CarbsPer100g'];
        FFats := FieldValues['FatsPer100g'];
      end;
    until EOF or isMealFound;
    Close;
  end;
end;

function TMeal.GetMealInfo(MealProperty:string; nutrientName : string = '') : Integer;
var
  returnString : Integer;
begin
  if MealProperty = 'Nutrient' then
  begin
    if nutrientName = 'Protein' then
      returnString := FProtein else
    if nutrientName = 'Carbohydrate' then
      returnString := FCarbohydrate else
    if nutrientName = 'Fat' then
      returnString := FFats;
  end else
  if MealProperty = 'Calories' then
   returnString := FNumCalories;
  Result := returnString;
end;

procedure TMeal.GetCalories;
begin
{ Somehow calculate the number of calories in food based on it's portion size}
end;
end.
