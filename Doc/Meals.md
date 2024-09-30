# Meal Overview

> NOTE: A food item is not a meal

## Use to the user

- Eaten by the user
- Searched for by the user to obtain information

## Navigation

### When eating

- User enters the food item and the meal type on the dashboard
  - The food item is created and given all necessary parameters
  - If new item than add it to database
  - The meal is created with its parameters
  - The food item in the meal is assigned the food item selected by the user
  - The meal is eaten by the current user

```none
FoodItem.Create -> if new -> FoodItem.AddFoodToDB  --
                -> else   -> Ensure it exists -- >  |
                                                    |
                <-----------------------------------|
                |
                -> Meal.Create -> Meal.FoodItem = FoodItem -> Meal.Eat
```

### When searching

- User enters the name of the food item
  - Food Item object is created
  - The existence of the item is checked, if not prompt the user
  - Information on the food item is fetched and displayed to the user

```none
FoodItem.Create -> FoodItem.Search -> if returns true -> else show food item not found
                                            |
                                            -> Fetch info from database -> Display in a memo
```

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
