//
//  Area.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

struct Area: Identifiable, Codable, NameProvider {
    var id: UUID = UUID()
    var area: String
    var getField: String { area }
}

extension Area {
    static let dummy = [
        Area.init(area: "American"),
        Area.init(area: "British")
    ]
}
