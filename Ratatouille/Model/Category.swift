//
//  Category.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

struct Category: Identifiable, Codable, NameProvider {
    var id: UUID = UUID()
    var category: String
    var getField: String { category }
}

extension Category {
    static let dummy = [
        Category.init(category: "italiano"),
        Category.init(category: "seafood"),
    ]
}
