unit Meals_U;

interface

uses conDBBites,System.Classes;
{ Display the meals in an image if possible}
type
  TMeal = class
    private
      FMealID;
      FMealName : String;
      FNumCalories : integer;
      FProtein : integer;
      FCarbohydrate : integer;
      FFats : integer;

      procedure AddMealToDB(sMealname:string;iNumNutrients:string);
      procedure EatMeal(sUserID:string);
      procedure GetNutrients;
      procedure GetCalories;
    public
      constructor Create(Mealname:string; portionSize : integer = 0; Calories:Integer = 0;NewMeal:Boolean = false);
      property Mealname :string read FMealName write FMealName;
      property Calories : Integer read FNumCalories write FNumCalories;

  end;
  var
   arrNutrients : array[1..6] of string;

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

procedure TMeal.EatMeal(sUserID: string);
var
  currentDate : TDate;
begin
  currentDate := now;

  with dbmDase.tblMeals do
  begin
    Open;
    Append;
    FieldValues['MealName'] := Mealname;
    FieldValues['TotalCalories'] := Calories;
    FieldValues['DateEaten'] := currentDate;
    FieldValues['Nutrients'] := sNutrients;
    Post;
    Close;
  end;
end;
procedure TMeal.GetNutrients;
begin
  {
    FArrNutrients[i] := arrNutrients[i];
    }
end;
procedure TMeal.GetCalories;
begin
{ Somehow calculate the number of calories in food based on it's portion size}
end;
end.
