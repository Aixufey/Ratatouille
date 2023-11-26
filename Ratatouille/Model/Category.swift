//
//  Category.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

// May serialise neither protocls
struct Category: Codable, SearchResult {
    var meals: [CategoryItems]?
    var categories: [AllCategories]?
}
// Specific category
struct CategoryItems: Identifiable, Codable, NameProvider {
    var id: String {
        idMeal
    }
    var getField: String {
        strMeal
    }
    var idMeal: String
    var strMeal: String
    var strMealThumb: String?
}

// All categories version with pic?
struct AllCategories: Identifiable, Codable, NameProvider {
    var id: String {
        idCategory
    }
    var getField: String {
        strCategory
    }
    var idCategory: String
    var strCategory: String
    var strCategoryThumb: String?
    var strCategoryDescription: String?
}

extension Category {
    static let dummy = [
        AllCategories(idCategory: "1" ,strCategory: "italiano"),
        AllCategories(idCategory: "2" ,strCategory: "seafood"),
    ]
}
