//
//  MealIngredient+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 01/12/2023.
//
//

import Foundation
import CoreData


extension MealIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealIngredient> {
        return NSFetchRequest<MealIngredient>(entityName: "MealIngredient")
    }

    @NSManaged public var idIngredient: String?
    @NSManaged public var idMeal: String?
    @NSManaged public var ingredient: Ingredient?
    @NSManaged public var meal: Meal?
    

}

extension MealIngredient : Identifiable {

}
