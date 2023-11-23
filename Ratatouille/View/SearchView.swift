//
//  SearchView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var isShowingSheet: Bool = false
    @State private var isAlert: Bool = false
    @State private var currentError: APIService.Errors?
    @State var meals: Meal?
    @State var categories: Category?
    // Dependency injection
    private let API: APIService
    init(_ _API: APIService = APIService.shared) {
        self.API = _API
    }
    
    var body: some View {
        VStack {
            Form {
                Text("Search View")
                TextField("Search name", text: $query)
                Button {
                    guard !query.isEmpty else {
                        currentError = .emptyQuery
                        return isAlert.toggle()
                    }
                    Task {
                        do {
                            let meal: Meal = try await API.fetchWith(endpoint: .name, input: query)

                            self.meals = meal
                        } catch {
                            // Specific error is decided from Service
                            currentError = .unknown(underlying: error)
                            return isAlert.toggle()
                        }
                        query = ""
                    }
                } label: {
                    Text("Search")
                }
                Button {
                    Task {
                        do {
                            let cat: Category = try await API.fetchWith(endpoint: .category, input: query)
                            self.categories = cat
                        } catch {
                            
                        }
                    }
                } label: {
                    Text("Category")
                }
                if let mealsArray = meals?.meals {
                    List(mealsArray, id: \.idMeal) { obj in
                        VStack(alignment: .leading) {
                            Text(obj.strMeal)
                        }
                    }
                }
                if let catArr = categories?.categories {
                    
                    List(catArr, id: \.idCategory) { obj in
                        VStack(alignment: .leading) {
                            Text(obj.strCategory)
                        }
                    }
                }
            } // form
            .autocorrectionDisabled(true)
        }// VStack
        .alert("Error!", isPresented: $isAlert) {
            Button("OK") {
                isAlert.toggle()
            }
        } message: {
            Text(currentError?.errorMessage ?? "")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}



