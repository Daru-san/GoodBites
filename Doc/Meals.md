# Meal Overview

## Use to the user

- Eaten by the user
- Searched for by the user to obtain information

## Navigation

- User enters the meal on the dashboard
- If they are adding a new meal, then it is added to the database and eaten
- In this case, nutrient values will need to be either found or entered by the user
  so: Meal.Create -> Meal.AddToDB -> Meal.EatMeal
  -> When adding to DB, data validation is done to ensure validity
  - Name length is correct
  - Name has letters only
  - Calories are correct-looking
- If they are eating an existing meal, the meal is eaten
  (logged in the database table tblMeals)
  so: Meal.Create -> Meal.EatMeal
  - Meal Process in detail:
    - GetNutrients -> GetCalories -> EatMeal

## Current capabilities

- [ ] Eating
  - [x] Food from the database
    - [ ] Custom entered
    - [x] Combo box
  - [ ] Other food of their choice
- [ ] Saving new foods
  - [ ] Validation
    - [ ] Name
    - [ ] Nutrientent values
- [ ] Searching
  - [ ] Search works
  - [ ] Displaying information
- [x] Calculating nutrient values
