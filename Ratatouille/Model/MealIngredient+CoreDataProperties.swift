//
//  MealIngredient+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 29/11/2023.
//
//

import Foundation
import CoreData


extension MealIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealIngredient> {
        return NSFetchRequest<MealIngredient>(entityName: "MealIngredient")
    }

    @NSManaged public var idMeal: String?
    @NSManaged public var idIngredient: String?
    @NSManaged public var meal: Meal?
    @NSManaged public var ingredient: Ingredient?

}

extension MealIngredient : Identifiable {

}
