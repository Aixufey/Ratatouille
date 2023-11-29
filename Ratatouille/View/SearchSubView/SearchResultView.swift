//
//  SearchResultView.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import SwiftUI
import Kingfisher


private struct TransformTest: Hashable {
    var idMeal: String
    var strMeal: String
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strMealThumb: String
    var strYoutube: String
}
/**
 Subscribing to 'DVModel' and pass in id to fetch more details for each item
 */
struct SearchResultView: View {
    @EnvironmentObject var search: IsEmptyResult
    @Binding private var unifiedResult: UnifiedModel
    @StateObject private var DVModel = DetailViewModel()
    @State private var hashTable = Set<[TransformTest]>()
    @State private var API: APIService
    @State private var countryISO: String = ""
    private let fallBackImg: String = "https://cdn-icons-png.flaticon.com/512/2276/2276931.png"
    init(currentSearchResult unifiedResult: Binding<UnifiedModel> = .constant(.init()), _ API: APIService = APIService.shared) {
        self._unifiedResult = unifiedResult
        self.API = API
    }
    private func fetchDetails(for id: String) async {
        do {
            let detailed = try await API.getDetails(for: id)
            let mapped = detailed.meals?.compactMap { i in
                return TransformTest(idMeal: i.idMeal, strMeal: i.idMeal, strCategory: i.strCategory, strArea: i.strArea, strInstructions: i.strInstructions, strMealThumb: i.strMealThumb, strYoutube: i.strYoutube)
            } ?? []
            hashTable.insert(mapped)
            let uniques = Array(hashTable)
            print("my cached obj: \(uniques.count)")
        } catch {
            print("Error in getting details")
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                
                if search.isEmpty {
                    VStack {
                        Spacer()
                        KFImage(URL(string: "https://cdn-icons-png.flaticon.com/512/6134/6134065.png"))
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                        Text("No result")
                        Spacer()
                    }
                } else {
                    List {
                        if let areas = unifiedResult.area?.meals {
                            Section(header:Text("Landområde\(areas.count <= 1 ? "":"r")")) {
                                ForEach(areas, id: \.idMeal) { area in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: area.idMeal ?? "", usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        LazyHStack {
                                            ZStack(alignment: .bottom) {
                                                KFImage(URL(string: area.strMealThumb ?? fallBackImg))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipShape(Circle())
                                                    .frame(width: 85, height: 85)
                                                .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                                KFImage(URL(string: countryISO))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 33)
                                            }.onAppear {
                                                Task {
                                                    let meal: Meal = try await API.getDetails(for: area.idMeal ?? "")
                                                    let id = meal.meals?.first?.idMeal
                                                    self.countryISO = try await Flag.getCountryCode(for: id ?? "") ?? fallBackImg
                                                    //print($countryISO.wrappedValue)
                                                }
                                            }
                                            LazyVStack(alignment: .center) {
                                                Text(area.strMeal ?? "")
                                                    .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                            }
                                            .padding()
                                            .frame(width: 200)
                                            
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                Task {
                                                    await fetchDetails(for: area.idMeal ?? "")
                                                }
                                            } label: {
                                                Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                                            }.tint(.accentColor)
                                        }
                                    }
                                }
                            }
                        }
                        if let cats = unifiedResult.category?.meals {
                            Section(header: Text("Kategori\(cats.count <= 1 ? "":"er")")) {
                                ForEach(cats, id: \.idMeal) { cat in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: cat.idMeal, usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        KFImage(URL(string: cat.strMealThumb ?? fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        
                                        LazyVStack(alignment: .center) {
                                            Text(cat.strMeal)
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                }
                            }
                        }
                        if let ingredients = unifiedResult.ingredient?.meals {
                            Section(header: Text("Ingrediens\(ingredients.count <= 1 ? "":"er")")) {
                                ForEach(ingredients, id: \.idMeal) { ing in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: ing.idMeal ?? "", usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        KFImage(URL(string: ing.strMealThumb ?? fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        
                                        LazyVStack(alignment: .center) {
                                            Text(ing.strMeal ?? "")
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                }
                            }
                        }
                        if let meals = unifiedResult.meal?.meals {
                            Section(header: Text("Matrett\(meals.count <= 1 ? "":"er")")) {
                                ForEach(meals, id: \.idMeal) { meal in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: meal.idMeal, usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        KFImage(URL(string: meal.strMealThumb))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        
                                        LazyVStack(alignment: .center) {
                                            Text(meal.strMeal)
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                }
                                
                            }
                        }
                    } // List
                } // ELSE bracket
            } // Navigation
        } // VStack
    }
}

struct SearchResultView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State private var unifiedResult = UnifiedModel(
            area: Area(meals: [
                AreaItems(strArea: "Russian", idMeal: "52834",strMeal: "Beef stroganoff", strMealThumb: "https://www.themealdb.com/images/media/meals/svprys1511176755.jpg")
            ])
        )
        var body: some View {
            SearchResultView(currentSearchResult: $unifiedResult, APIService.shared)
        }
    }
    static var previews: some View {
        Wrapper()
            .environmentObject(IsEmptyResult().self)
            .environmentObject(AppSettings().self)
    }
}
