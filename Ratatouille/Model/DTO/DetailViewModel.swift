//
//  DetailViewModel.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import Foundation

/**
 The 'Item' returned from a search does not include extra details I wanted to display e.g. instructions or links etc.
 Problem: Have to fetch from another API to retrieve data
 Solution: Publish an object that can dynamically fetch using an id and map it to self
 Usage observe this class by calling this fn and pass in the meal id i.e. dynamically way foreach loop from Parent View
 */
class DetailViewModel: ObservableObject {
    @Published var itemDetails: [String:MealDTO] = [:]
    func getDetails(for idMeal: String, using API: APIService) async {
        //print("getDetail for: \(idMeal)")
        do {
            // JSON are serialized as Meal Model
            let mealItems: MealDTO = try await API.getDetails(for: idMeal)
            DispatchQueue.main.async {
                // Published is always on Main Thread for async
                self.itemDetails[idMeal] = mealItems
            }
        } catch {
            print("Error getting details for \(idMeal)")
        }
        
    }
}
