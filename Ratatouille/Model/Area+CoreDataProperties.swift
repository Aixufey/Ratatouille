//
//  Area+CoreDataProperties.swift
//  Ratatouille
//
//  Created by Jack Xia on 01/12/2023.
//
//

import Foundation
import CoreData


extension Area {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Area> {
        return NSFetchRequest<Area>(entityName: "Area")
    }

    @NSManaged public var timeStamp: Date
    @NSManaged public var strArea: String?
    @NSManaged public var isArchive: Bool
    @NSManaged public var meals: NSSet?
    
    public var wrappedName: String {
        strArea ?? "Unknown Area"
    }
    
    public var mealsArray: [Meal] {
        // Safe typecast as Set
        let set = meals as? Set<Meal> ?? []
        // When sorted it will be an array
        // Compare the lexicographical order in a closure with Meal 1 and Meal 2.
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
extension Area {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension Area : Identifiable {

}
