﻿unit libMeals_U;
{ Provides the objects needed for meal (and food) creation and manipulation }
{
 I would rather these objects only be used once and destroyed immediately after, retaining them becomes confusing when
 having to deal with multiple food items at once and I do not yet understand memory management enough to know that may
 affect performance, unless their memory footprint is too small to make any difference
}
interface

uses conDB,System.Classes,System.SysUtils,libUser_U,Dialogs,StrUtils;
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
    FSugarPer100G : real;

    procedure GetNutrients(sFoodname:string);

  public
    constructor Create(sFoodname:string);

    property Foodname : String read FFoodname write FFoodname;
    property CaloriePer100G : real read FCaloriePer100G write FCaloriePer100G;
    property ProteinPer100G : real read FProteinPer100G write FProteinPer100G;
    property CarbPer100G : real read FCarbPer100G write FCarbPer100G;
    property FatPer100G : real read FFatPer100G write FFatPer100G;
    property EnergyPer100G : real read FEnergyPer100G write FEnergyPer100G;
    property SugarPer100G : real read FSugarPer100G write FSugarPer100G;

    function CheckExists : Boolean;

    procedure AddFoodToDB(FoodDesc:string = 'Lorem ipsum');
    procedure AddNutrients(Calories:Real;Protein: Real; Carb: Real; Fat: Real; Energy: Real; Sugar:real);
    //function GetFoodname(sFoodname:string) : string;
  end;
  TMeal = class(TObject)
    private
      FMealID : string;
      FFood : String;
      FCalories : real;
      FNumServings : Integer;
      FMealType : String;
      FPortion : Integer;
      FFoodItem : TFoodItem;

      function CalcCalories(iCalories: Real) : real;
      function CalcEnergy: real;
    public
      constructor Create(F : TFoodItem; P : Integer;M: string = 'Other');

      property Calories : real read FCalories write FCalories;
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

{ Obtain food nutrients from the database }
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
        SugarPer100G := FieldValues['SugarPer100G'];
      end else Next;
    until EOF or isFoodFound;
    Close;

    { Assign default values, in case the items are somehow accesed even after validating that the
      food item does not exist, preventing access violations in that rare case }
    if not isFoodFound then
    begin
      ProteinPer100G := 0;
      CarbPer100G := 0;
      FatPer100G := 0;
      CaloriePer100G := 0;
    end;
  end;
end;

{ Used best when `eating` or adding new foods,
  it prevents an issue where a user may be able to eat food
  that does not exist in the database, or add new foods that
  are already existant in the database }
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

{ Add the nutrients for any new food items }
procedure TFoodItem.AddNutrients(Calories:real;Protein: Real; Carb: Real; Fat: Real; Energy: Real; Sugar:real);
begin
  CaloriePer100G := Calories;
  EnergyPer100G := Energy;
  CarbPer100G := Carb;
  FatPer100G := Fat;
  ProteinPer100G := Protein;
  SugarPer100G := Sugar;
end;

{ Get validated information from the user to add to the database
  these foods can then be eaten by the user afterwards.}
procedure TFoodItem.AddFoodToDB;
begin
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
    FieldValues['SugarPer100G'] := SugarPer100G;
    FieldValues['Desc'] := FoodDesc;
    Post;
  end;
  loggerObj.WriteSysLog('Item ' + Foodname + ' has been added to the database');
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
  rTotalCalories : Real;
begin
  { Calories per 100g are multiplied by 100 to
    convert them to calories, then multiplied
    by the portion size to obtain the total
    caloires }

  rTotalCalories := FoodItem.CaloriePer100G*(PortionSize/100);

  Result := rTotalCalories;
end;

function TMeal.CalcEnergy: Real;
begin

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
