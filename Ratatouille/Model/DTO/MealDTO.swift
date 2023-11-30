//
//  Meal.swift
//  Ratatouille
//
//  Created by Jack Xia on 22/11/2023.
//

import Foundation

struct MealDTO: Codable, SearchResult {
    var meals: [MealItems]?
}

struct MealItems: Codable {
    var idMeal: String
    var strMeal: String
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strMealThumb: String
    var strYoutube: String
    var ingredients: [String?]
    // var strIngredient1.....20 is also possible but whatever works i guess..
    
    // JSON map keys for mealItems according to the model
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strYoutube
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
    }
    
    init(idMeal: String, strMeal: String, strCategory: String, strArea: String,
         strInstructions: String, strMealThumb: String, strYoutube: String,
         ingredients: [String?]) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strYoutube = strYoutube
        self.ingredients = ingredients
    }
    
    // Decode keys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strYoutube = try container.decode(String.self, forKey: .strYoutube)
        
        var temp = [String?]()
        // Decode all ingredient keys if exists
        for index in 1...20 {
            let key = CodingKeys(rawValue: "strIngredient\(index)")!
            if let ingredient = try container.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                temp.append(ingredient)
            }
        }
        self.ingredients = temp
    }
    // Encode back to jSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idMeal, forKey: .idMeal)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(strCategory, forKey: .strCategory)
        try container.encode(strArea, forKey: .strArea)
        try container.encode(strInstructions, forKey: .strInstructions)
        try container.encode(strMealThumb, forKey: .strMealThumb)
        try container.encode(strYoutube, forKey: .strYoutube)
        
        for (i, ingredient) in self.ingredients.enumerated() {
            let key = CodingKeys(rawValue: "strIngredient\(i + 1)")!
            try container.encode(ingredient, forKey: key)
        }
    }
    
}


struct Ingredients: Codable {
     var ingredients: [String?]
    // Json map keys read ingredients 1 .. 20
     enum CodingKeys: String, CodingKey {
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
    }
    // decode if exists
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var temp = [String]()
        for index in 1...20 {
            let key = CodingKeys(rawValue: "strIngredient\(index)")!
            if let ingredient = try container.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                temp.append(ingredient)
            }
        }
        self.ingredients = temp
    }
    // encode back to json
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (i, ingredient) in self.ingredients.enumerated() {
            let key = CodingKeys(rawValue: "strIngredient\(i + 1)")!
            try container.encode(ingredient, forKey: key)
        }
    }
}

