//
//  RecipesListView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI
import Kingfisher
import CoreData
struct RecipesListView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var db: SharedDBData
    
    @EnvironmentObject private var unifiedData: UnifiedModelData
    @State private var isShowing: Bool = false
    @State private var isRecipes: Bool = false
    @State private var isInstruction: Bool = false
    @State private var isIngredient: Bool = false
    private func toggleFavoriteMeal(_ meal: Meal) {
        meal.isFavorite.toggle()
        do {
            try moc.save()
        } catch {
            print("Error toggle meal", error)
        }
        db.fetchMeal()
    }
    private func archiveMeal(_ meal: Meal) {
        meal.isArchive.toggle()
        meal.timeStamp = Date()
        do {
            try moc.save()
        } catch {
            print("Error archiving meal ", error)
        }
        db.fetchMeal()
        db.fetchArchivedMeal()
    }
    var body: some View {
        VStack {
            VStack {
                Image(ImageAsset.Logo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.13)) {
                            isShowing.toggle()
                        }
                    } label: {
                        Text(isShowing ? "Mine oppskrifter" : "Historikk")
                        Image(systemName: isShowing ? "lightswitch.on":"lightswitch.off")
                    }
                }.padding()
            }
            Spacer()
            Divider().padding(.horizontal)
            NavigationView {
                if isShowing {
                    Text("Søk historikk")
                    LazyVStack {
                        SearchResultView(currentSearchResult: $unifiedData.unifiedModel)
                            .environmentObject(SearchObject())
                            .environmentObject(AppSettings())
                            .environmentObject(UnifiedModelData())
                    }.padding(.top)
                } else {
                    if db.activeMeals.isEmpty {
                        VStack(alignment: .center) {
                            Image(systemName: "square.3.layers.3d.slash")
                                .imageScale(.large).font(.system(size: 65))
                            Text("Ingen matoppskrifter")
                        }
                    } else {
                        List {
                            ForEach(db.activeMeals, id: \.idMeal) { meal in
                                NavigationLink {
                                    ScrollView {
                                        VStack {
                                            KFImage(URL(string: meal.wrappedThumb))
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .frame(width: 250, height: 250)
                                                .overlay(Circle().stroke(Color(.systemPurple), lineWidth: 4))
                                                .padding()
                                                .padding(.top)
                                            Text(meal.wrappedName)
                                                .font(.custom(CustomFont.ComicRegular.name, size: 30))
                                            Divider().padding()
                                            HStack {
                                                Text("Meal ID \(meal.wrappedId) - \(meal.wrappedArea)")
                                                    .padding()
                                                KFImage(URL(string: meal.wrappedFlagURL))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 44)
                                            }
                                            Divider().padding()
                                            VStack {
                                                Section(header: LazyHStack {
                                                    Text("Instructions")
                                                    Image(systemName: "\(isInstruction ? "arrow.down.forward.and.arrow.up.backward":"arrow.up.backward.and.arrow.down.forward")")
                                                }.onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        self.isInstruction.toggle()
                                                    }
                                                }) {
                                                    if isInstruction {
                                                        Text(meal.strInstructions ?? "")
                                                            .padding()
                                                            .padding(.horizontal)
                                                    }
                                                } // sect 1
                                                .padding()
                                                Divider().padding()
                                                Section(header: LazyHStack {
                                                    Text("Ingredients")
                                                    Image(systemName: "\(isIngredient ? "arrow.down.forward.and.arrow.up.backward":"arrow.up.backward.and.arrow.down.forward")")
                                                }.onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        self.isIngredient.toggle()
                                                    }
                                                }) {
                                                    if isIngredient {
                                                        ForEach(db.ingredients, id: \.idIngredient) { ingredient in
                                                            LazyHStack {
                                                                KFImage(URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.wrappedName).png"))
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 50, height: 50)
                                                                Text(ingredient.wrappedName)
                                                            }
                                                        }
                                                    }
                                                } // sect 2
                                                .padding()
                                                .padding(.bottom)
                                            }
                                        }
                                    }
                                } label: {
                                    LazyHStack {
                                        KFImage(URL(string: meal.wrappedThumb))
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .frame(width: 85, height: 85)
                                            .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                                            .padding(.trailing)
                                        
                                        HStack {
                                            Text(meal.wrappedName)
                                                .multilineTextAlignment(SwiftUI.TextAlignment.center)
                                            Spacer()
                                                
                                            if meal.isFavorite {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color(.systemYellow))
                                                    .offset(x: 10)
                                            }
                                        }
                                        .padding()
                                        .frame(width: 200)
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            DispatchQueue.main.async {
                                                toggleFavoriteMeal(meal)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "star.fill")
                                    }.tint(Color(.systemYellow))
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            DispatchQueue.main.async {
                                                archiveMeal(meal)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "tray.and.arrow.down")
                                    }.tint(Color.accentColor)
                                }
                            } // foreach
                        } // List
                    }
                }
            } // ScrollView
            
            
        } // VStack
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView()
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
            .environmentObject(SearchObject())
            .environmentObject(AppSettings())
            .environmentObject(UnifiedModelData())
    }
}
