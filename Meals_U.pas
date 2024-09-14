unit Meals_U;

interface

uses conDBBites,System.Classes,System.SysUtils,User_U;
{ Display the meals in an image if possible}
type
  TMeal = class
    private
      FMealID : string;
      FMealName : String;
      FCaloriePer100G : integer;
      FCalories : Integer;
      FProteinPer100G : integer;
      FCarbPer100G : integer;
      FFatPer100G : integer;
      FNumServings : Integer;

      procedure AddMealToDB(sMealname: string; sNutrients: string;numCalories : integer);
      procedure GetNutrients;
      procedure CalcCalories(portionSize:integer);
    public
      constructor Create(Mealname:string; portionSize : integer = 0; Calories:Integer = 0;NewMeal:Boolean = false);
      property Mealname :string read FMealName write FMealName;
      property Calories : Integer read FCalories write FCalories;

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
  CalcCalories(portionSize);
  FMealName := Mealname;
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
        FProteinPer100G := FieldValues['ProteinsPer100g'];
        FCarbPer100G := FieldValues['CarbsPer100g'];
        FFatPer100G := FieldValues['FatsPer100g'];
        FCaloriePer100G := FieldValues['CaloriesPer100g'];
      end else Next;
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
      returnString := FProteinPer100G else
    if nutrientName = 'Carbohydrate' then
      returnString := FCarbPer100G else
    if nutrientName = 'Fat' then
      returnString := FFatPer100G;
  end else
  if MealProperty = 'Calories' then
   returnString := FCaloriePer100G;
  Result := returnString;
end;

procedure TMeal.CalcCalories;
var
  iTotalCalories : Integer;
begin
  {
    Say calories are measured in cl, num calories would be 100 grams per cl
    x = (150/100)g*52cl.100g^-1 * 5, would be about 260 calories?
    That makes decent sense, I will stick to  this methodology for now
  }
  iTotalCalories := Round(
      (portionSize/100)*FCaloriePer100G
    )*FNumServings;

  Calories := iTotalCalories;

end;
end.
