//
//  Ingredient.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

struct Ingredient: Codable {
    var meals: [IngredientItems]?
}

// Specific Ingredient or All Ingredients
struct IngredientItems: Hashable, Codable, NameProvider {
    var getField: String {
        strIngredient ?? ""
    }
    var idIngredient: String?
    var strIngredient: String?
    
    var idMeal: String?
    var strMeal: String?
    var strMealThumb: String?
}

extension Ingredient {
    static let dummy = [
        IngredientItems(strIngredient: "پسته"),
        IngredientItems(strIngredient: "زعفران")
    ]
}
