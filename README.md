# Ratatouille
## PG5602 iOS Exam 2023 - Candidate 2054
## Grade A

---

## Framework

- Code running on Xcode 15
- UI/UX is displayed in Norwegian
- Simulator is compatible with iPhone XR
- Database is empty on initial start

---

## API

- Food recipes are from `theMealDb.com`
- Flag API `flagsapi.com/`
- This application is intended to:
- Download recipes
- Save your favorite recipe
- Filter search recipes
- Search by Name
- Search by Region
- Search by Country
- Search by Ingredient

---

## Core Data

- Every meal has many ingredients, and every ingredient can be in many meals
- Cardinality is a many-to-many relationship.
- To solve the issue, we use a join table as MealIngredients
- The relationship will be 2 x one-to-many
- Meal: Chicken -> Pepper, Salt, Onion
- Ingredient: Pepper -> Chicken, Beef 
