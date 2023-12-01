//
//  LandAreasView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct SettingDetailView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var searchObj: SearchObject
    @EnvironmentObject private var db: SharedDBData
    @Binding private var isSheet: Bool
    @State private var showArchive: Bool = false
    private var title: String
    init(for isSheet: Binding<Bool>, title: String = "") {
        self._isSheet = isSheet
        self.title = title
    }
    
    func saveArea(for name: String ) throws {
        let newArea = Area(context: moc)
        newArea.strArea = name
        do {
            try moc.save()
            db.fetchArea()
        } catch {
            print("Error save area ",error)
        }
    }
    func saveCategory(for name: String ) throws {
        
        let newCat = Category(context: moc)
        newCat.strCategory = name
        do {
            try moc.save()
            
            db.fetchCategory()
            
        } catch {
            print("Error save area ",error)
        }
    }
    func saveIngredient(for name: String ) throws {
        
        let newIng = Ingredient(context: moc)
        newIng.strIngredient = name
        do {
            try moc.save()
            
            db.fetchIngredient()
        } catch {
            print("Error save area ",error)
        }
    }
    var body: some View {
        List {
            //  Show saved db or show searches
            if showArchive {
                if title == "Landområder", !db.areas.isEmpty {
                    ForEach(db.areas, id: \.self) { area in
                        Text(area.wrappedName)
                    }
                }
                if title == "Kategorier", !db.categories.isEmpty {
                    ForEach(db.categories, id: \.self) { cat in
                        Text(cat.wrappedName)
                    }
                }
            } else {
                if let areas: AreaDTO = searchObj.currentResult.area {
                    ForEach(areas.meals, id: \.self) { area in
                        LazyHStack {
                            SettingsRowView(for: area)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    try saveArea(for: area.strArea ?? "")
                                }
                            } label: {
                                Image(systemName: "tray.and.arrow.down.fill")
                            }.tint(.accentColor)
                        }
                    }
                } // if area
                if let categories: CategoryDTO = searchObj.currentResult.category,
                   let wrapped = categories.categories {
                    ForEach(wrapped, id: \.id) { category in
                        NavigationLink(destination: Text(category.strCategory)) {
                            LazyHStack {
                                SettingsRowView(for: category)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    try saveCategory(for: category.strCategory)
                                }
                            }  label: {
                                Image(systemName: "tray.and.arrow.down.fill")
                            }.tint(.accentColor)
                        }
                    }
                } // if cat
                if let ingredients: IngredientDTO = searchObj.currentResult.ingredient,
                   let wrapped = ingredients.meals {
                    ForEach(wrapped, id: \.idIngredient) { ing in
                        NavigationLink(destination: Text(ing.wrappedStrIngredient)) {
                            LazyHStack {
                                SettingsRowView(for: ing)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    try saveIngredient(for: ing.wrappedStrIngredient)
                                }
                            }  label: {
                                Image(systemName: "tray.and.arrow.down.fill")
                            }.tint(.accentColor)
                        }
                    }
                } // if ing
            }
            
        }
        .imageScale(.large)
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showArchive.toggle()
                        print(showArchive)
                    }
                } label: {
                    Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSheet.toggle()
                    //print(isSheet.description)
                    
                } label: {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "plus.circle" : "plus.circle.fill")
                            .frame(width: 60, alignment: .center)
                    }
                }
            }
        }// toolbar
    }
}

struct LandAreasView_Previews: PreviewProvider {
    static var previews: some View {
        SettingDetailView(for: Binding.constant(false))
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
            .environmentObject(SearchObject())
            .environmentObject(AppSettings())
    }
}
