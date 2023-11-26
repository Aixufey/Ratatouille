//
//  UnifiedModel.swift
//  Ratatouille
//
//  Created by Jack Xia on 25/11/2023.
//

import Foundation
// Union of all Models for easier display of search results
struct UnifiedModel {
    var meal: Meal?
    var category: Category?
    var ingredient: Ingredient?
    var area: Area?
    
    init(meal: Meal? = nil, category: Category? = nil, ingredient: Ingredient? = nil, area: Area? = nil) {
        self.meal = meal
        self.category = category
        self.ingredient = ingredient
        self.area = area
    }
}
