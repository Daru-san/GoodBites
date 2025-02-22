﻿unit libMeals_U;
{ Provides the objects needed for meal (and food) creation and manipulation }
{
 I would rather these objects only be used once and destroyed immediately after, retaining them becomes confusing when
 having to deal with multiple food items at once and I do not yet understand memory management enough to know that may
 affect performance, unless their memory footprint is too small to make any difference
}
interface

uses conDB,System.Classes,System.SysUtils,Dialogs,StrUtils,libUtils_U;
{ Display the meals in an image if possible}
type
  TFoodItem = class(TObject)
  private
    FFoodname : String;
    FCategory : String;
    FCaloriePer100G : real;
    FProteinPer100G : real;
    FCarbPer100G : real;
    FFatPer100G : real;
    FEnergyPer100G : real;
    FSugarPer100G : real;

    procedure GetNutrients(pFoodname:string);

  public
    constructor Create(pFoodname:string);

    property Foodname : String read FFoodname write FFoodname;
    property Category : String read FCategory write FCategory;
    property CaloriePer100G : real read FCaloriePer100G write FCaloriePer100G;
    property ProteinPer100G : real read FProteinPer100G write FProteinPer100G;
    property CarbPer100G : real read FCarbPer100G write FCarbPer100G;
    property FatPer100G : real read FFatPer100G write FFatPer100G;
    property EnergyPer100G : real read FEnergyPer100G write FEnergyPer100G;
    property SugarPer100G : real read FSugarPer100G write FSugarPer100G;

    function CheckExists : Boolean;

    procedure AddFoodToDB;
    procedure AddNutrients(pCalories,pEnergy,pProtein,pCarb,pFat,pSugar:real);
    //function GetFoodname(sFoodname:string) : string;
  end;
  TMeal = class(TObject)
    private
      FMealID : string;
      FFood : String;
      FTotalCalories : real;
      FTotalEnergy : real;
      FMealType : String;
      FPortion : Real;
      FFoodItem : TFoodItem;

      procedure CalcTotals;
    public
      constructor Create(pFoodItem : TFoodItem; pPortion : Real;pMealType: string = 'Other');

      property TotalCalories : real read FTotalCalories write FTotalCalories;
      property TotalEnergy : real read FTotalEnergy write FTotalEnergy;
      property MealType : string read FMealType write FMealType;
      property FoodItem : TFoodItem read FFoodItem write FFoodItem;
      property PortionSize : Real read FPortion write FPortion;

      procedure EatMeal(pUserID : String;pTotalUserMeals:Integer);
  end;
  var
    LogService : TLogService;

implementation

{ Food procedures }

{$REGION FOODS }
constructor TFoodItem.Create(pFoodname: string);
begin
  Foodname := pFoodname;
  GetNutrients(pFoodname);
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
      if UpperCase(pFoodname) = UpperCase(FieldValues['FoodName']) then
      begin
        isFoodFound := true;
        Category := FieldValues['Category'];
        ProteinPer100G := FieldValues['ProteinPer100g'];
        CarbPer100G := FieldValues['CarbPer100g'];
        FatPer100G := FieldValues['FatPer100g'];
        CaloriePer100G := FieldValues['CaloriesPer100g'];
        SugarPer100G := FieldValues['SugarPer100G'];
        EnergyPer100G := FieldValues['EnergyPer100g'];
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
      SugarPer100G := 0;
      EnergyPer100G := 0;
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
			// Casing causes issues where the item may not be cased
			// the same but it still exists, this fixes that issue
			if UpperCase(Foodname) = UpperCase(FieldValues['Foodname']) then
			begin
				isFound := true;
			end
			else next;
		until isFound or EOF;
		Close;
	end;
	Result := isFound;
end;

{ Add the nutrients for any new food items }
procedure TFoodItem.AddNutrients(pCalories: Real; pEnergy: Real; pProtein: Real; pCarb: Real; pFat: Real; pSugar: Real);
begin
  CaloriePer100G := pCalories;
  EnergyPer100G := pEnergy;
  CarbPer100G := pCarb;
  FatPer100G := pFat;
  ProteinPer100G := pProtein;
  SugarPer100G := pSugar;
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
    FieldValues['Category'] := Category;
    Post;
  end;
  LogService.WriteSysLog('Item ' + Foodname + ' has been added to the database');
end;

{$ENDREGION}

{ Meal procedures}

{$REGION MEALS}
constructor TMeal.Create(pFoodItem : TFoodItem; pPortion : Real;pMealType: string = 'Other');
begin
  FoodItem := pFoodItem;
  PortionSize := pPortion;
  MealType := pMealType;
  CalcTotals;
end;

// Calculating our meal totals
procedure TMeal.CalcTotals;
begin
  TotalCalories := FoodItem.CaloriePer100G * (PortionSize/100);
  TotalEnergy := FoodItem.EnergyPer100G * (PortionSize/100);
end;

procedure TMeal.EatMeal(pUserID : String;pTotalUserMeals:Integer);
var
  sFoodname : string;
  iMealIndex : integer;
  isFound : Boolean;
begin

  // Increase the index of the meal for the specific user
  // Every user has an index for their meals
  // Making it possible to search through them for a specific one
  iMealIndex := pTotalUserMeals;
  inc(iMealIndex);

  isFound := False;


	// Loop through our foods table to obtain our food name
	// then add the item to our meals table
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
          FieldValues['DateEaten'] := Date;
          FieldValues['TimeEaten'] := Time;
          FieldValues['UserID'] := pUserID;
          FieldValues['UserMealID'] := iMealIndex;
          FieldValues['MealType'] := MealType;
          FieldValues['PortionSize'] := PortionSize;
          FieldValues['TotalCalories'] := TotalCalories;
          FieldValues['TotalEnergy'] := TotalEnergy;
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
