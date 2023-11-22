//
//  Ingredient.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

struct Ingredient: Identifiable, Codable, NameProvider {
    var id: UUID = UUID()
    var ingredient: String
    var description: String = ""
    var getField: String { ingredient }
}

extension Ingredient {
    static let dummy = [
        Ingredient.init(ingredient: "پسته"),
        Ingredient.init(ingredient: "زعفران"),
    ]
}
