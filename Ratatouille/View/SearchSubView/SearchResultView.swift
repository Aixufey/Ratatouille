//
//  SearchResultView.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import SwiftUI
import Kingfisher
/**
 Subscribing to 'DVModel' and pass in id to fetch more details for each item
 */
struct SearchResultView: View {
    @Binding var unifiedResult: UnifiedModel
    @StateObject private var DVModel = DetailViewModel()
    private let fallBackImg: String = "https://cdn-icons-png.flaticon.com/512/2276/2276931.png"
    init(currentSearchResult unifiedResult: Binding<UnifiedModel>) {
        self._unifiedResult = unifiedResult
    }
    var body: some View {
        VStack {
            Text("Søk")
                .font(.custom(CustomFont.ComicBold.name, size: 35))
            NavigationView {
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
                                        KFImage(URL(string: area.strMealThumb ?? fallBackImg))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        Text(area.strMeal ?? "")
                                            .padding(.leading)
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
                                    Text(cat.strMeal)
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
                                    Text(ing.strMeal ?? "")
                                }
                            }
                        }
                    }
                    if let meals = unifiedResult.meal?.meals {
                        Section(header: Text("Matrett\(meals.count <= 1 ? "":"er")")) {
                            ForEach(meals, id: \.idMeal) { meal in
                                NavigationLink {
                                    Button {
                                        print(meals.count)
                                    } label: {
                                        Text("click")
                                    }

                                    ScrollView {
                                        DetailView(forId: meal.idMeal, usingModel: DVModel, with: $unifiedResult)
                                    }
                                } label: {
                                    Text(meal.strMeal)
                                }
                            }
                        }
                    }
                    
                } // List
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
            SearchResultView(currentSearchResult: $unifiedResult)
        }
    }
    static var previews: some View {
        Wrapper()
            .environmentObject(AppSettings().self)
    }
}
