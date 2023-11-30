//
//  Flag.swift
//  Ratatouille
//
//  Created by Jack Xia on 29/11/2023.
//

import Foundation

class FlagDTO: Identifiable {
    static let countriesMap: [String:String] =
    [
        "American": "US",
        "British": "GB",
        "Canadian": "CA",
        "Chinese": "CN",
        "Croatian": "HR",
        "Dutch": "NL",
        "Egyptian": "EG",
        "Filipino": "PH",
        "French": "FR",
        "Greek": "GR",
        "Indian": "IN",
        "Irish": "IE",
        "Italian": "IT",
        "Jamaican": "JM",
        "Japanese": "JP",
        "Kenyan": "KE",
        "Malaysian": "MY",
        "Mexican": "MX",
        "Moroccan": "MA",
        "Polish": "PL",
        "Portuguese": "PT",
        "Russian": "RU",
        "Spanish": "ES",
        "Thai": "TH",
        "Tunisian": "TN",
        "Turkish": "TR",
        "Vietnamese": "VN",
    ]
    
    /**
     Fetching based on name
     */
    static func countryCode(forArea area: String) -> String {
        //print("area is \(area)")
        if let value = countriesMap[area] {
            //print("value is \(value)")
            return "https://flagsapi.com/\(value)/shiny/64.png"
        } else {
            //print("invalid country \(area)")
            return "https://cdn-icons-png.flaticon.com/512/2072/2072130.png"
        }
    }
    
    /**
     Lazy fetching flags based on ID
     */
    static func getCountryCode(for idMeal: String) async throws -> String? {
        do {
            let meal = try await APIService.shared.getDetails(for: idMeal)
            let area = meal.meals?.first?.strArea
            return countryCode(forArea: area ?? "")
        } catch {
            throw APIService.Errors.unknown(underlying: error)
        }
    }
}
