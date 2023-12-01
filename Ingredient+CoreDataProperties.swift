//
//  Ingredient+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 01/12/2023.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var idIngredient: String?
    @NSManaged public var strIngredient: String?
    @NSManaged public var meals: NSSet?
    
    public var wrappedName: String {
        strIngredient ?? "Unknown Ingredient"
    }

    public var mealsArray: [Meal] {
        let set = meals as? Set<Meal> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for meals
extension Ingredient {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: MealIngredient)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: MealIngredient)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension Ingredient : Identifiable {

}
