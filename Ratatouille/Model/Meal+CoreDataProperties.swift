//
//  Meal+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 29/11/2023.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }
    
    @NSManaged public var timeStamp: Date
    @NSManaged public var isArchive: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var flagURL: String?
    @NSManaged public var idMeal: String?
    @NSManaged public var strMeal: String?
    @NSManaged public var strCategory: String?
    @NSManaged public var strArea: String?
    @NSManaged public var strMealThumb: String?
    @NSManaged public var strInstructions: String?
    @NSManaged public var strYoutube: String?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var area: Area?
    @NSManaged public var category: Category?
    
    
    public var wrappedName: String {
        strMeal ?? "Unknown Meal"
    }
    public var wrappedId: String {
        idMeal ?? "Impossible"
    }
    public var wrappedFlagURL: String {
        flagURL ?? "https://cdn-icons-png.flaticon.com/512/2072/2072130.png"
    }
    public var wrappedCategory: String {
        strCategory ?? "Unknown Category"
    }
    public var wrappedArea: String {
        strArea ?? "Unknown Area"
    }
    public var wrappedThumb: String {
        strMealThumb ?? Help.fallBackImg
    }
    public var wrappedtimeStamp: String {
        let df = DateFormatter()
        //df.dateStyle = .medium
        //df.timeStyle = .medium
        //df.dateFormat = "d MMM, yyyy 'kl' HH:mm:ss"
        df.dateFormat = "d MMM, yyyy 'kl' hh:mm:ss a"
        df.locale = Locale(identifier: "en_US")
        return df.string(from: timeStamp)
    }


    public var ingredientsArray: [Ingredient] {
        let set = ingredients as? Set<Ingredient> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for ingredients
extension Meal {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: MealIngredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: MealIngredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Meal : Identifiable {

}
