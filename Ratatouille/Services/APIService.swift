//
//  APIService.swift
//  Ratatouille
//
//  Created by Jack Xia on 22/11/2023.
//

import SwiftUI

@MainActor
struct APIService {
    // Singleton - No external instantiations
    static let shared = APIService()
    private init() {}
    
    // Endpoints
    enum EndpointTypes: String {
        case byName
        case byCategory
        case byArea
        case byIngredient
        case byId
        func constructUrl(with value: String) async throws -> String{
            let base = "https://www.themealdb.com/api/json/v1/1/"
            let endpoint: String
            let query = value.lowercased().trimmingCharacters(in: .whitespaces).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            //print("builder url: \(query)")
            switch self {
            case .byName:
                endpoint = "search.php?s="
            case .byCategory:
                endpoint = "filter.php?c="
            case .byArea:
                endpoint = "filter.php?a="
            case .byIngredient:
                endpoint = "filter.php?i="
            case .byId:
                endpoint = "lookup.php?i="
            }
            if query.isEmpty {
                throw Errors.emptyQuery
            }
            return "\(base)\(endpoint)\(query)"
        }
    }
    enum ListEndpoints: String {
        case allAreas
        case allIngredients
        case allCategories
        case randomMeal
        func constructUrl() async -> String {
            let base = "https://www.themealdb.com/api/json/v1/1/"
            let endpoint: String
            switch self {
            case .allAreas:
                endpoint = "list.php?a=list"
            case .allCategories:
                endpoint = "categories.php"
            case .allIngredients:
                endpoint = "list.php?i=list"
            case .randomMeal:
                endpoint = "random.php"
            }
            //print("list endpoint \(base)\(endpoint)")
            return "\(base)\(endpoint)"
        }
    }
    
    // Errors
    enum Errors: Error {
        case emptyQuery
        case statusCode(Int)
        case errorMessage(String)
        case unknown(underlying: Error)
        
        // Functions can decide which error to throw and caller may catch the specific thrown error
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
    /**
     Fetching all areas, categories, ingredients
     */
    func fetchList<T: Codable>(endpoint: ListEndpoints) async throws -> T {
        let request = await endpoint.constructUrl()
        // print("wth is \(request)")
        guard let url = URL(string: request) else {
            throw Errors.statusCode(400)
        }
        //print(url)
        let (data, resp) = try await URLSession.shared.data(from: url)
        if let statusCode = (resp as? HTTPURLResponse)?.statusCode, statusCode != 200 {
            throw Errors.statusCode(statusCode)
        }
        //print(resp)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            //print("here?")
            return decoded
        } catch {
            throw Errors.unknown(underlying: error)
        }
    }
    
    /**
     Generic type is inferred by context in Swift. When called, explicit state the return type i.e. let meal: Meal
     */
    func fetchWith<T: Codable>(endpoint: EndpointTypes, input value: String) async throws -> T {
        //print("fetch \(value)")
        let request = try await endpoint.constructUrl(with: value)
        //print(request)
        guard let url = URL(string: request) else {
            throw Errors.statusCode(400)
        }
        //print(url)
        let (data, resp) = try await URLSession.shared.data(from: url)
        if let statusCode = (resp as? HTTPURLResponse)?.statusCode,
           statusCode != 200 {
            throw Errors.statusCode(statusCode)
        }
        //print(data)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            //print(decoded)
            return decoded
        } catch {
            throw Errors.unknown(underlying: error)
        }
    }
    
    /**
     Fetch meal details by id
     */
    func getDetails(for idMeal: String) async throws -> MealDTO {
        // print("getDetail for: \(idMeal)")
        do {
            let mealItems: MealDTO = try await fetchWith(endpoint: .byId, input: idMeal)
            return mealItems
        } catch {
            throw Errors.unknown(underlying: error)
        }
    }
    
    func fetchIngredientImage(for ingredient: Ingredient) async throws -> String {
        guard let url = URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.wrappedName).png") else {
            throw Errors.errorMessage("Invalid URL")
        }
            
        let (_, resp) = try await URLSession.shared.data(from: url)
        
        guard let header = resp as? HTTPURLResponse else {
            throw Errors.statusCode(500)
        }
        
        guard let mime = header.mimeType, mime.contains("image") else {
            return "https://cdn-icons-png.flaticon.com/512/4636/4636408.png"
        }
        
        return url.absoluteString
    }
}
