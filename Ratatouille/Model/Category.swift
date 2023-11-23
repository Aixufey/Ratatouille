//
//  Category.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

//struct Category: Identifiable, Codable, NameProvider {
//    var id: UUID = UUID()
//    var category: String
//    var getField: String { category }
//}
//
//extension Category {
//    static let dummy = [
//        Category.init(category: "italiano"),
//        Category.init(category: "seafood"),
//    ]
//}
struct Category: Codable {
    var categories: [Items]?
}

struct Items: Identifiable, Codable, NameProvider {
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
        Items(idCategory: "1", strCategory: "italiano"),
        Items(idCategory: "2", strCategory: "seafood"),
    ]
}
