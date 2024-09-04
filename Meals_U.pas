unit Meals_U;

interface

uses conDBBites,System.Classes;

type
  TMeal = class
    private
      FMealName : String;
      FNumCalories : integer;
      FArrNutrients : array[1..6] of String;

      procedure AddMealToDB(sMealname:string;iNumNutrients:string);
      procedure EatMeal(sMealname:string;iNumNutrients:Integer;sUserID:string);
      procedure GetNutrients;
      procedure GetCalories;
    public
      constructor Create(Mealname:string;Calories:Integer = 0;NewMeal:Boolean = false);
      property Mealname :string read FMealName write FMealName;
      property Calories : Integer read FNumCalories write FNumCalories;

  end;
  var
   arrNutrients : array[1..6] of string;

implementation

constructor TMeal.Create(Mealname: string; Calories: Integer = 0;NewMeal:Boolean = false);
begin

 if NewMeal then
 begin

 end else
 begin
   GetNutrients;
 end;
 if Calories = 0 then
 GetCalories;
 FMealName := Mealname;
 FNumCalories := Calories;
end;

procedure TMeal.AddMealToDB(sMealname: string; iNumNutrients: string);
begin
end;

procedure TMeal.EatMeal(sMealname: string; iNumNutrients: Integer; sUserID: string);
begin

end;
procedure TMeal.GetNutrients;
begin
  {
    FArrNutrients[i] := arrNutrients[i];
    }
end;
procedure TMeal.GetCalories;
begin

end;
end.
