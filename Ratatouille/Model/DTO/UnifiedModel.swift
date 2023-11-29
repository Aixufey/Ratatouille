//
//  UnifiedModel.swift
//  Ratatouille
//
//  Created by Jack Xia on 25/11/2023.
//

import Foundation
// Union of all Models for easier display of search results
struct UnifiedModel {
    var meal: MealDTO?
    var category: CategoryDTO?
    var ingredient: IngredientDTO?
    var area: AreaDTO?
    
    init(meal: MealDTO? = nil, category: CategoryDTO? = nil, ingredient: IngredientDTO? = nil, area: AreaDTO? = nil) {
        self.meal = meal
        self.category = category
        self.ingredient = ingredient
        self.area = area
    }
}
