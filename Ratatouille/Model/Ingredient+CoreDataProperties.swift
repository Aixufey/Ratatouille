//
//  Ingredient+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 29/11/2023.
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