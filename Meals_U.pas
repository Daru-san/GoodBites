unit Meals_U;

interface

uses conDBBites,System.Classes,System.SysUtils,User_U;
{ Display the meals in an image if possible}
type
  TMeal = class
    private
      FMealID : string;
      FFoodName : String;
      FCaloriePer100G : integer;
      FCalories : Integer;
      FProteinPer100G : integer;
      FCarbPer100G : integer;
      FFatPer100G : integer;
      FNumServings : Integer;

      procedure AddFoodToDB(sFoodname: string; numCalories : integer);
      procedure GetNutrients;
      procedure CalcCalories(portionSize:integer);
    public
      constructor Create(Foodname:string; portionSize : integer = 0; Calories:Integer = 0;NewMeal:Boolean = false);
      property Foodname :string read FFoodName write FFoodName;
      property Calories : Integer read FCalories write FCalories;

      procedure EatMeal(currentUser : TUser);

      function GetFoodInfo(FoodProperty:string; nutrientName : string = '') : Integer;
      function ValidateFood(sFoodname:string;Calories:Integer): boolean;
  end;

implementation

constructor TMeal.Create(Foodname: string; portionSize:integer = 0; Calories: Integer = 0;NewMeal:Boolean = false);
var
  sNutrients : string;
begin

  if NewMeal then
  begin
    AddFoodToDB(Foodname,Calories);
  end else
  begin
    GetNutrients;
  end;
  if Calories = 0 then
  CalcCalories(portionSize);
  FFoodName := Foodname;
end;

function TMeal.ValidateFood(sFoodname:string;Calories:Integer): boolean;
var
  nameCorrect,nutrientCorrect,calorieCorrect : Boolean;
  isLong : Boolean;
begin
  nameCorrect := utilObj.ValidateString(Foodname,'Meal',2,20);
  //Validate nutrients and calorie counts
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
      FieldValues['CarbsPer100g'] := FCarbPer100G;
      FieldValues['ProteinsPer100g'] := FProteinPer100G;
      FieldValues['FatPer100g'] := FFatPer100G;
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
  with dbmData.tblFoods do
  begin
    Open;
    First;
    repeat
      if Foodname = FieldValues['FoodName'] then    //Solve access violation issue     d
      begin
				isFoodFound := true;
        FProteinPer100G := FieldValues['ProteinsPer100g'];
        FCarbPer100G := FieldValues['CarbsPer100g'];
        FFatPer100G := FieldValues['FatsPer100g'];
        FCaloriePer100G := FieldValues['CaloriesPer100g'];
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

		Too much physics style calculation?
  }
  iTotalCalories := Round(
      (portionSize/100)*FCaloriePer100G
    )*FNumServings;

  Calories := iTotalCalories;

end;
end.
