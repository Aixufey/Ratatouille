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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var db: SharedDBData
    @FetchRequest(sortDescriptors: [.init(key: "strMeal", ascending: true)]) var mealsdb: FetchedResults<Meal>
    
    @EnvironmentObject var search: IsEmptyResult
    @Binding private var unifiedResult: UnifiedModel
    @StateObject private var DVModel = DetailViewModel()
    @State private var hashTable = Set<[TransformTest]>()
    @State private var countryISO: String = ""
    @State private var isFavorite: Bool = false
    private var API: APIService
    
    init(currentSearchResult unifiedResult: Binding<UnifiedModel> = .constant(.init()), _ API: APIService = APIService.shared) {
        self._unifiedResult = unifiedResult
        self.API = API
    }

    func saveFavoriteToDatabase(for id: String) throws {
        let request = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "idMeal == %@", id)
        if let meal = try? moc.fetch(request), let mealToUpdate = meal.first {
            //print(meal)
            mealToUpdate.isFavorite.toggle()
            try? moc.save()
        }
    }
    func saveRecipeToDatabase(for id: String) async throws {
        let request = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "idMeal == %@", id)
        let exist = try moc.fetch(request)
        if exist.isEmpty {
            do {
                let saveMeal = Meal(context: moc)
                let details: MealDTO = try await API.getDetails(for: id)
                if details.meals?.first != nil {
                    let meal = details.meals?.first
                    let flagURL = FlagDTO.countryCode(forArea: meal?.strArea ?? "")
                    saveMeal.idMeal = meal?.idMeal
                    saveMeal.strMeal = meal?.strMeal
                    saveMeal.strMealThumb = meal?.strMealThumb
                    saveMeal.flagURL = flagURL
                    saveMeal.strArea = meal?.strArea
                    saveMeal.strCategory = meal?.strCategory
                    saveMeal.strInstructions = meal?.strInstructions
                    saveMeal.strYoutube = meal?.strYoutube
                }
                try? moc.save()
                db.fetchMeal()
            } catch {
                throw APIService.Errors.unknown(underlying: error)
            }
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
                                        KFImage(URL(string: area.strMealThumb ?? Help.fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        VStack {
                                            Text(area.strMeal ?? "")
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                if let id = area.idMeal {
                                                    try? await saveRecipeToDatabase(for: id)
                                                }
                                                if let id = area.idMeal {
                                                    try? saveFavoriteToDatabase(for: id)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "star.fill")
                                        }.tint(Color(.systemYellow))
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                if let id = area.idMeal {
                                                    try? await saveRecipeToDatabase(for: id)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                                        }.tint(.accentColor)
                                    }
                                } // Foreach
                            } // Section
                        }
                        if let cats = unifiedResult.category?.meals {
                            Section(header: Text("Kategori\(cats.count <= 1 ? "":"er")")) {
                                ForEach(cats, id: \.idMeal) { cat in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: cat.idMeal, usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        KFImage(URL(string: cat.strMealThumb ?? Help.fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        VStack(alignment: .center) {
                                            Text(cat.strMeal)
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: cat.idMeal)
                                                try? saveFavoriteToDatabase(for: cat.idMeal)
                                            }
                                        } label: {
                                            Image(systemName: "star.fill")
                                        }.tint(Color(.systemYellow))
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: cat.idMeal)
                                            }
                                        } label: {
                                            Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                                        }.tint(.accentColor)
                                    }
                                } // foreach
                            } // section
                        }
                        if let ingredients = unifiedResult.ingredient?.meals {
                            Section(header: Text("Ingrediens\(ingredients.count <= 1 ? "":"er")")) {
                                ForEach(ingredients, id: \.idMeal) { ing in
                                    NavigationLink {
                                        ScrollView {
                                            DetailView(forId: ing.idMeal ?? "", usingModel: DVModel, with: $unifiedResult)
                                        }
                                    } label: {
                                        KFImage(URL(string: ing.strMealThumb ?? Help.fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        
                                        VStack(alignment: .center) {
                                            Text(ing.strMeal ?? "")
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: ing.idMeal ?? "")
                                                try? saveFavoriteToDatabase(for: ing.idMeal ?? "")
                                            }
                                        } label: {
                                            Image(systemName: "star.fill")
                                        }.tint(Color(.systemYellow))
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: ing.idMeal ?? "")
                                            }
                                        } label: {
                                            Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                                        }.tint(.accentColor)
                                    }
                                } // foreach
                            } // section
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
                                        
                                        VStack(alignment: .center) {
                                            Text(meal.strMeal)
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: meal.idMeal)
                                                try? saveFavoriteToDatabase(for: meal.idMeal)
                                            }
                                        } label: {
                                            Image(systemName: "star.fill")
                                        }.tint(Color(.systemYellow))
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button {
                                            Task {
                                                try? await saveRecipeToDatabase(for: meal.idMeal)
                                            }
                                        } label: {
                                            Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                                        }.tint(.accentColor)
                                    }
                                } // foreach
                                
                            } // section
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
            area: AreaDTO(meals: [
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
