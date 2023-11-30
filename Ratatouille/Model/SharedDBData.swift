//
//  SharedDBData.swift
//  Ratatouille
//
//  Created by Jack Xia on 30/11/2023.
//

import Foundation
import CoreData

class SharedDBData: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var areas: [Area] = []
    @Published var categories: [Category] = []
    @Published var ingredients: [Ingredient] = []
    @Published var mealIngredients: [MealIngredient] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMeal()
        fetchArea()
        fetchCategory()
        fetchIngredient()
        fetchMealIngredient()
    }
    
    func fetchMeal() {
        let req: NSFetchRequest<Meal> = Meal.fetchRequest()
        do {
            meals = try context.fetch(req)
        } catch {
            print("Error fetching \(meals.description)", error)
        }
    }
    
    func fetchArea() {
        let req: NSFetchRequest<Area> = Area.fetchRequest()
        do {
            areas = try context.fetch(req)
        } catch {
            print("Error fetching \(areas.description)", error)
        }
    }
    
    func fetchCategory() {
        let req: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(req)
        } catch {
            print("Error fetching \(categories.description)", error)
        }
    }
    
    func fetchIngredient() {
        let req: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            ingredients = try context.fetch(req)
        } catch {
            print("Error fetching \(ingredients.description)", error)
        }
    }
    
    func fetchMealIngredient() {
        let req: NSFetchRequest<MealIngredient> = MealIngredient.fetchRequest()
        do {
            mealIngredients = try context.fetch(req)
        } catch {
            print("Error fetching \(mealIngredients.description)", error)
        }
    }
    
}
