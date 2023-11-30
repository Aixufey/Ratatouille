//
//  SearchView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI
import Kingfisher

class IsEmptyResult: ObservableObject {
    @Published var isEmpty: Bool = false
}
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
    var SheetItems: (title: String, apiType: APIService.EndpointTypes) {
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
    @StateObject private var isEmptyResult = IsEmptyResult()
    @EnvironmentObject private var unifiedData: UnifiedModelData
    @EnvironmentObject private var settings: AppSettings
    @State private var query: String = ""
    @State private var isShowingSheet: Bool = false
    @State private var isAlert: Bool = false
    @State private var currentError: APIService.Errors?
    @State private var currentEndpoint: APIService.EndpointTypes = .byName
    @State private var currentItem: SheetItem = .ByArea
    @State private var currentTitle: String = ""
    @State private var currentSearchResult: SearchResult?
    @State private var unifiedResult = UnifiedModel()
    // Dependency injection
    private let API: APIService
    init(_ API: APIService = APIService.shared) {
        self.API = API
    }
    /**
     This will be refactored IF I have to optimalize the props drilling.
     Alternative: use Binding to SearchView
     */
    private func handleResult(_ result: SearchResult) {
        self.currentSearchResult = result
        //print(currentSearchResult ?? "")
        switch result {
        case let area as AreaDTO:
            unifiedResult = UnifiedModel(area: area)
            unifiedData.unifiedModel.area = UnifiedModel(area: area).area
        case let meal as MealDTO:
            unifiedResult = UnifiedModel(meal: meal)
            unifiedData.unifiedModel = UnifiedModel(meal: meal)
        case let cat as CategoryDTO:
            unifiedResult = UnifiedModel(category: cat)
            unifiedData.unifiedModel = UnifiedModel(category: cat)
        case let ing as IngredientDTO:
            unifiedResult = UnifiedModel(ingredient: ing)
            unifiedData.unifiedModel = UnifiedModel(ingredient: ing)
        default: break
        }
    }
    private func handleDisplay(_ status: Bool) {
        self.isEmptyResult.isEmpty = status
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
            Text("Søk")
                .font(.custom(CustomFont.ComicBold.name, size: 35))
            Spacer()
            
            // Pass the binding generic protocol
            SearchResultView(currentSearchResult: $unifiedResult, API)
                .environmentObject(isEmptyResult)
            
            Spacer()
        } // VStack - Container
        .sheet(isPresented: $isShowingSheet) {
            SheetView(
                $currentTitle,
                $isShowingSheet,
                $currentEndpoint,
                // lifecycles escaped here
                callback1: {
                    self.handleDisplay($0)
                },
                callback2: {
                    self.handleResult($0)
                }
            )
            .environmentObject(settings)
        }
    }
}



/**
 SHEET VIEW
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
    @Binding private var endpoint: APIService.EndpointTypes
    @State private var indicatorEndpoint: APIService.ListEndpoints = .allAreas
    @State private var currentError: APIService.Errors?
    @State private var query: String = ""
    @State private var isAlert: Bool = false
    @State private var isTips: Bool = false
    @State private var categoryIndicators: CategoryDTO?
    @State private var areaIndicators: AreaDTO?
    @State private var ingredientsIndicators: IngredientDTO?
    @State private var mealIndicators: MealDTO?
    
    // Dependency injection
    private let API: APIService
    
    // Callbacks
    private let onEscape: (SearchResult) -> Void
    private let onEmpty: (Bool) -> Void
    // @escaping literally means outlives the lifecycle of this View for callbacks ....................💀
    init(_ title: Binding<String>, _ isShowing: Binding<Bool>, _ endpoint: Binding<APIService.EndpointTypes>, _ _API: APIService = APIService.shared, callback1: @escaping (Bool) -> Void, callback2 callBack2: @escaping (SearchResult) -> Void) {
        self._title = title
        self._isShowing = isShowing
        self._endpoint = endpoint
        self.API = _API
        self.onEmpty = callback1
        self.onEscape = callBack2
    }
    private func doFetchQueryTask() -> Void {
        Task {
            do {
                let sanitizedQuery = try Help.sanitize(this: query)
                switch self.endpoint {
                case .byName:
                    let result: MealDTO = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                    result.meals == nil ? onEmpty(true) : onEmpty(false)
                    onEscape(result as MealDTO)
                case .byCategory:
                    let result: CategoryDTO = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                    result.meals == nil ? onEmpty(true) : onEmpty(false)
                    onEscape(result as CategoryDTO)
                case .byArea:
                    let result: AreaDTO = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                    result.meals == nil ? onEmpty(true) : onEmpty(false)
                    onEscape(result as AreaDTO)
                case .byIngredient:
                    let result: IngredientDTO = try await API.fetchWith(endpoint: endpoint, input: sanitizedQuery)
                    result.meals == nil ? onEmpty(true) : onEmpty(false)
                    onEscape(result as IngredientDTO)
                case .byId:
                    let result: MealDTO = try await API.fetchWith(endpoint: .byId, input: sanitizedQuery)
                    result.meals == nil ? onEmpty(true) : onEmpty(false)
                    onEscape(result as MealDTO)
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
    }
    private func doFetchIndicatorsTask(_ with: APIService.ListEndpoints) -> Void {
        Task {
            do {
                switch with {
                case .allCategories:
                    let indicators: CategoryDTO = try await API.fetchList(endpoint: .allCategories)
                    self.categoryIndicators = indicators
                case .allAreas:
                    let indicators: AreaDTO = try await API.fetchList(endpoint: .allAreas)
                    self.areaIndicators = indicators
                case .allIngredients:
                    let indicators: IngredientDTO = try await API.fetchList(endpoint: .allIngredients)
                    self.ingredientsIndicators = indicators
                case .randomMeal:
                    let indicators: MealDTO = try await API.fetchList(endpoint: .randomMeal)
                    self.mealIndicators = indicators
                }
            }
        }
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
                    doFetchQueryTask()
                } label: {
                    Text("Søk")
                }
            } // HStack nav
            .padding()
            .padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5))
            Spacer()
            
            // Slider menus fetch on request
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isTips.toggle()
                        // Listening to SearchView current endpoint - two way binding and fetch upon request
                        if endpoint == .byArea {
                            self.indicatorEndpoint = .allAreas
                        } else if endpoint == .byCategory {
                            self.indicatorEndpoint = .allCategories
                        } else if endpoint == .byIngredient {
                            self.indicatorEndpoint = .allIngredients
                        } else {
                            self.indicatorEndpoint = .randomMeal
                        }
                        doFetchIndicatorsTask(indicatorEndpoint)
                    }
                } label: {
                    HStack {
                        Text(isTips ? "Close":"Tips?")
                        Image(systemName: isTips ? "arrow.left.and.line.vertical.and.arrow.right" : "arrow.right.and.line.vertical.and.arrow.left")
                    }
                }
                ScrollView([.horizontal], showsIndicators: false) {
                    LazyHStack {
                        if isTips {
                            if let areas = areaIndicators?.meals {
                                ForEach(areas, id: \.self) { area in
                                    Button {
                                        //print(cat.strCategory)
                                        self.query = area.strArea ?? ""
                                        doFetchQueryTask()
                                    } label: {
                                        Text(area.strArea ?? "")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(settings.isDarkMode ? Color.white : Color.black, lineWidth: 2)
                                                    .background(settings.isDarkMode ? Color.customPrimary : Color.customTertiary)
                                            )
                                            .cornerRadius(15)
                                    }
                                    
                                }
                                .padding(.leading)
                            }
                            if let cats = categoryIndicators?.categories {
                                ForEach(cats, id: \.idCategory) { cat in
                                    Button {
                                        //print(cat.strCategory)
                                        self.query = cat.strCategory
                                        doFetchQueryTask()
                                    } label: {
                                        Text(cat.strCategory)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(settings.isDarkMode ? Color.white : Color.black, lineWidth: 2)
                                                    .background(settings.isDarkMode ? Color.customPrimary : Color.customTertiary)
                                            )
                                            .cornerRadius(15)
                                    }
                                    
                                }
                                .padding(.leading)
                            }
                            if let ings = ingredientsIndicators?.meals {
                                ForEach(ings, id: \.idIngredient) { ing in
                                    Button {
                                        self.query = ing.strIngredient ?? ""
                                        doFetchQueryTask()
                                    } label: {
                                        Text(ing.strIngredient ?? "")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(settings.isDarkMode ? Color.white : Color.black, lineWidth: 2)
                                                    .background(settings.isDarkMode ? Color.customPrimary : Color.customTertiary)
                                            )
                                            .cornerRadius(15)
                                    }
                                    
                                }
                            }
                            if let random = mealIndicators?.meals {
                                ForEach(random, id: \.idMeal) { rnd in
                                    Button {
                                        self.query = rnd.strMeal
                                        doFetchQueryTask()
                                    } label: {
                                        Text(rnd.strMeal)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(settings.isDarkMode ? Color.white : Color.black, lineWidth: 2)
                                                    .background(settings.isDarkMode ? Color.customPrimary : Color.customTertiary)
                                            )
                                            .cornerRadius(15)
                                    }
                                    
                                }
                            }
                        }
                    } // lazy load
                    .padding()
                } // Slider - Scroll
            } // Slider - Hstack
            .padding()
            
            
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
            .environmentObject(IsEmptyResult().self)
            .environmentObject(UnifiedModelData().self)
            .environmentObject(AppSettings().self)
    }
}
struct SheetView_Previews: PreviewProvider {
    struct Wrapper : View {
        @State private var isShowing = true
        @State private var title = "Test"
        @State private var endpoint = APIService.EndpointTypes.byCategory
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

