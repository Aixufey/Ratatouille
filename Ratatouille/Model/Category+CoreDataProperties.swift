//
//  Category+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 01/12/2023.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    @NSManaged public var idCategory: String?
    @NSManaged public var timeStamp: Date
    @NSManaged public var isArchive: Bool
    @NSManaged public var strCategory: String?
    @NSManaged public var meals: NSSet?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.idCategory = UUID().uuidString
    }
    
    public var wrappedName: String {
        strCategory ?? "Unknown Category"
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
extension Category {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension Category : Identifiable {

}
