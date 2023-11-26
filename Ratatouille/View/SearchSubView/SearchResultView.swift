//
//  SearchResultView.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import SwiftUI

/**
 Subscribing to 'DVModel' and pass in id to fetch more details for each item
 */
struct SearchResultView: View {
    @Binding private var unifiedResult: UnifiedModel
    @StateObject private var DVModel = DetailViewModel()
    init(_ unifiedResult: Binding<UnifiedModel>) {
        self._unifiedResult = unifiedResult

    }
    
    var body: some View {
        VStack {
            Text("Søk")
                .font(.custom(CustomFont.ComicBold.name, size: 50))
                .padding()
            NavigationView {
                List {
                    if let areas = unifiedResult.area?.meals {
                        Section(header:Text("Landområde")) {
                            ForEach(areas, id: \.idMeal) { i in
                                NavigationLink {
                                    VStack {
                                        AsyncImage(url: URL(string: i.strMealThumb ?? "")) { i in
                                            i.image?
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .frame(width: 250, height: 250)
                                                .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                        }
                                        Text(i.strMeal ?? "")
                                            .font(.custom(CustomFont.ComicRegular.name, size: 30))
                                        // display description
                                        Spacer()
                                    }
                                    DetailView(forId: i.idMeal ?? "", usingModel: DVModel)
                                } label: {
                                    Text(i.strMeal ?? "")
                                }
                            }
                        }
                    }
                    if let cats = unifiedResult.category?.meals {
                        Section(header: Text("Kategori\(cats.count>1 ? "":"er")")) {
                            ForEach(cats, id: \.idMeal) { i in
                                Text(i.strMeal)
                            }
                        }
                    }
                    if let ingredients = unifiedResult.ingredient?.meals {
                        Section(header: Text("Ingrediens\(ingredients.count>1 ? "":"er")")) {
                            ForEach(ingredients, id: \.idMeal) { i in
                                Text(i.strMeal ?? "")
                            }
                        }
                    }
                    if let meals = unifiedResult.meal?.meals {
                        Section(header: Text("Matrett\(meals.count>1 ? "":"er")")) {
                            ForEach(meals, id: \.idMeal) { i in
                                Text(i.strMeal)
                            }
                        }
                    }
                }
            } // list
        } // Vstack
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
            SearchResultView($unifiedResult)
        }
    }
    static var previews: some View {
        Wrapper()
            .environmentObject(AppSettings().self)
    }
}
