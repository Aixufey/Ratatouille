//
//  Area.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

struct Area: Codable, SearchResult {
    var meals: [AreaItems]?
}

// May Decode specific Area or All Areas
struct AreaItems: Hashable, Codable, NameProvider {
    var getField: String {
        strArea ?? ""
    }
    var strArea: String?
    
    var idMeal: String?
    var strMeal: String?
    var strMealThumb: String?
}

extension Area {
    static let dummy = [
        AreaItems(strArea: "American"),
        AreaItems(strArea: "Jamaican"),
    ]
}
