//
//  SearchView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI
import Kingfisher

enum SheetItem: Int, CaseIterable {
    case ByArea = 0
    case ByCategory
    case ByIngredient
    case ByName
    var ItemIcon: String {
        switch self {
        case .ByArea:
            return "globe"
        case .ByCategory:
            return "doc.append"
        case .ByIngredient:
            return "carrot"
        case .ByName:
            return "magnifyingglass"
        }
    }
    var SheetItems: (title: String, apiType: APIService.Types) {
        switch self {
        case .ByArea:
            return ("Landområder", .byArea)
        case .ByCategory:
            return ("Kategorier", .byCategory)
        case .ByIngredient:
            return ("Ingredienser", .byIngredient)
        case .ByName:
            return ("Matrett", .byName)
        }
    }
}

struct SearchView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var query: String = ""
    @State private var isShowingSheet: Bool = false
    @State private var isAlert: Bool = false
    @State private var isEmpty: Bool = false
    @State private var currentError: APIService.Errors?
    @State private var currentEndpoint: APIService.Types = .byName
    @State private var currentItem: SheetItem = .ByArea
    @State private var currentTitle: String = ""
    @State private var currentSearchResult: SearchResult?
    @State private var unifiedResult = UnifiedModel()
    
    private func handleResult(_ result: SearchResult) {
        self.currentSearchResult = result
        //print(currentSearchResult ?? "")
        switch result {
        case let area as Area:
            unifiedResult = UnifiedModel(area: area)
        case let meal as Meal:
            unifiedResult = UnifiedModel(meal: meal)
        case let cat as Category:
            unifiedResult = UnifiedModel(category: cat)
        case let ing as Ingredient:
            unifiedResult = UnifiedModel(ingredient: ing)
        default: break
        }
    }
    private func handleDisplay(_ status: Bool) {
        self.isEmpty = status
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ForEach(SheetItem.allCases, id: \.self) { i in
                        let (title, endpoint) = i.SheetItems
                        Image(systemName: i.ItemIcon)
                            .frame(width: 75, height:50)
                            .background(Rectangle().foregroundColor(currentItem == i ? (settings.isDarkMode ? .white : .white) :  (settings.isDarkMode ? Color(.systemGray5) : Color(.systemGray5))))
                            .cornerRadius(10)
                            .foregroundColor(currentItem == i ? .blue : (settings.isDarkMode ? .white : .black))
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.33)) {
                                    self.currentItem = i
                                    self.currentEndpoint = endpoint
                                    self.currentTitle = title
                                    self.isShowingSheet.toggle()
                                    // Help.consoleLog("current endpoint : \(currentEndpoint)")
                                }
                            }
                    } //  Foreach
                    .imageScale(.large)
                } // HStack
                .padding()
            } // ZStack - Item tabs
            .frame(height: 55)
            .background(settings.isDarkMode ? Color(.systemGray5) : Color(.systemGray5))
            .cornerRadius(10)
            Spacer()
            if !isEmpty {
                // Pass the binding generic protocol
                SearchResultView(currentSearchResult: $unifiedResult)
            } else {
                VStack {
                    KFImage(URL(string: "https://cdn-icons-png.flaticon.com/512/6134/6134065.png"))
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                    Text("No result")
                }
            }
            Spacer()
        } // VStack - Container
        .sheet(isPresented: $isShowingSheet) {
            SheetView(
                $currentTitle,
                $isShowingSheet,
                $currentEndpoint,
                callback1: {
                    self.handleDisplay($0)
                    print(isEmpty)
                },
                callback2: {
                    // escaped here
                    self.handleResult($0)
                }
            )
            .environmentObject(settings)
        }
    }
}

/**
 All Model can conform to this protocol  for callback the generic result type
 */
protocol SearchResult: Codable {}
/**
 All Binding States auto wired by Parent
 */
private struct SheetView: View {
    @EnvironmentObject var settings: AppSettings
    @Binding private var isShowing: Bool
    @Binding private var title: String
    @Binding private var endpoint: APIService.Types
    @State private var currentError: APIService.Errors?
    @State private var query: String = ""
    @State private var isAlert: Bool = false
    // Dependency injection
    private let API: APIService
    
    // Callbacks
    private let onEscape: (SearchResult) -> Void
    private let onEmpty: (Bool) -> Void
    // @escaping literally means outlives the lifecycle of this View for callbacks ....................💀
    init(_ title: Binding<String>, _ isShowing: Binding<Bool>, _ endpoint: Binding<APIService.Types>, _ _API: APIService = APIService.shared, callback1: @escaping (Bool) -> Void, callback2 callBack2: @escaping (SearchResult) -> Void) {
        self._title = title
        self._isShowing = isShowing
        self._endpoint = endpoint
        self.API = _API
        self.onEmpty = callback1
        self.onEscape = callBack2
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isShowing.toggle()
                } label: {
                    Text("Avbryt")
                }
                Spacer()
                Text(title.capitalized)
                    .fontWeight(.heavy)
                Spacer()
                Button {
                    Task {
                        do {
                            let sanitizedQuery = try Help.sanitize(this: query)
                            switch endpoint {
                            case .byName:
                                let result: Meal = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result as Meal)
                            case .byCategory:
                                let result: Category = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result as Category)
                            case .byArea:
                                let result: Area = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result as Area)
                            case .byIngredient:
                                let result: Ingredient = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result as Ingredient)
                            case .byId:
                                let result: Meal = try await API.fetchWith(endpoint: .byId, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result as Meal)
                            case .allAreas:
                                let result: Meal = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result)
                            case .allIngredients:
                                let result: Meal = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result)
                            case .allCategories:
                                let result: Meal = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                                result.meals == nil ? onEmpty(true) : onEmpty(false)
                                onEscape(result)
                            }
                        } catch {
                            currentError = .unknown(underlying: error)
                            isAlert = true
                        }
                        if !isAlert {
                            self.query = ""
                            isShowing.toggle()
                        }
                    } // Async  batch
                } label: {
                    Text("Søk")
                }
            } // HStack nav
            .padding()
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5))
            Spacer()
            
            // Disclaimer - The "jumpy" effect is due to hidden Keyboard in simulation mode. Make sure to enable Keyboard CMD+K
            ZStack(alignment: .leading) {
                Text("Søk...")
                    .padding(.leading, 10)
                    .foregroundColor(settings.isDarkMode ? .white : .black)
                    .opacity(query.isEmpty ? 1 : 0)
                TextField("", text: $query)
                    .padding(.leading, 10)
                    .autocorrectionDisabled(true)
            }
            .frame(width: 300 , height: 60)
            .background(Rectangle().foregroundColor(Color(.systemGray5)))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding(.bottom, 15)
        }// VStack
        .presentationDetents([.fraction(0.3)])
        .alert("Error!", isPresented: $isAlert) {
            Button("OK") {}
        } message: {
            Text(currentError?.errorMessage ?? "")
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AppSettings().self)
    }
}
struct SheetView_Previews: PreviewProvider {
    struct Wrapper : View {
        @State private var isShowing = true
        @State private var title = "Test"
        @State private var endpoint = APIService.Types.byName
        var body: some View {
            SheetView($title, $isShowing, $endpoint, callback1: { _ in
            }, callback2: { _ in
            })
        }
    }
    static var previews: some View {
        Wrapper()
            .environmentObject(AppSettings().self)
    }
}

