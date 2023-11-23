//
//  APIService.swift
//  Ratatouille
//
//  Created by Jack Xia on 22/11/2023.
//

import SwiftUI


struct APIService {
    // Singleton - No external instantiations
    static let shared = APIService()
    private init() {}
    
    // Endpoints
    enum Types: String {
        case name = "name"
        case area = "area"
        case category = "category"
        func constructUrl(with value: String) throws -> String{
            let base = "https://www.themealdb.com/api/json/v1/1/"
            let endpoint: String
            let query = value.lowercased().trimmingCharacters(in: .whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            switch self {
            case .name:
                endpoint = "search.php?s="
            case .area:
                endpoint = "filter.php?a="
            case .category:
                return "\(base)categories.php"
            }
            if query.isEmpty {
                throw Errors.emptyQuery
            }
            return "\(base)\(endpoint)\(query)"
        }
    }
    
    // Errors
    enum Errors: Error {
        case emptyQuery
        case statusCode(Int)
        case errorMessage(String)
        case unknown(underlying: Error)
        
        var errorMessage: String {
            switch self {
            case .emptyQuery:
                return "Search query cannot be empty!"
            case .statusCode(let code):
                return "Server responded with code: \(code)"
            case .errorMessage(let msg):
                return "\(msg)"
            case .unknown(let msg):
                return "An unknown error occurred: \(msg)"
            }
        }
    }
    // Generic type is inferred by context in Swift. When called, explicit state the return type i.e. let meal: Meal
    func fetchWith<T: Codable>(endpoint: Types, input value: String) async throws -> T {
        let request = try endpoint.constructUrl(with: value)
        guard let url = URL(string: request) else {
            throw Errors.statusCode(400)
        }
        print(request)
        let (data, resp) = try await URLSession.shared.data(from: url)
        if let statusCode = (resp as? HTTPURLResponse)?.statusCode,
           statusCode != 200 {
            throw Errors.statusCode(statusCode)
        }
        
        do {
            print("here?")
            let decoded = try JSONDecoder().decode(T.self, from: data)
            print(decoded)
            return decoded
        } catch {
            throw Errors.unknown(underlying: error)
        }
    }
}
