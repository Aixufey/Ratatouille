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
    
    
    @NSManaged public var timeStamp: Date
    @NSManaged public var isArchive: Bool
    @NSManaged public var idIngredient: String?
    @NSManaged public var strIngredient: String?
    @NSManaged public var meals: NSSet?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.idIngredient = UUID().uuidString
    }
    
    public var wrappedName: String {
        strIngredient ?? "Unknown Ingredient"
    }

    public var mealsArray: [Meal] {
        let set = meals as? Set<Meal> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    public var wrappedTimeStamp: String {
        let df = DateFormatter()
        df.dateFormat = "d MMM, yyyy 'kl' hh:mm:ss a"
        df.locale = Locale(identifier: "en_US")
        return df.string(from: timeStamp)
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
