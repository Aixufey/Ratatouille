//
//  Helper.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import Foundation

class Help {
    static let fallBackImg: String = "https://cdn-icons-png.flaticon.com/512/2276/2276931.png"
    static func findFirstCharacter(of input: String) -> String {
        guard let firstChar = input.first else {
            return ""
        }
        return String(firstChar).capitalized
    }
    
    static func consoleLog(_ input: Any) {
        print(input)
    }
    
    static func sanitize(this input: String) throws -> String{
        guard !input.isEmpty else {
            throw APIService.Errors.emptyQuery
        }
        return input.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
