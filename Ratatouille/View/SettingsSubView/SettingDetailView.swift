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
    @State private var isEdit: Bool = false
    @State private var showArchive: Bool = false
    @State private var isArea: Area?
    @State private var isCategory: Category?
    @State private var isIngredient: Ingredient?


    private var title: String
    init(for isSheet: Binding<Bool>, title: String = "") {
        self._isSheet = isSheet
        self.title = title
    }
    
    private func saveArea(for name: String ) throws {
        let newArea = Area(context: moc)
        newArea.strArea = name
        newArea.isArchive = false
        do {
            try moc.save()
            db.fetchArea()
            db.fetchArchivedArea()
        } catch {
            print("Error save area ",error)
        }
    }
    private func saveCategory(for name: String ) throws {
        let newCat = Category(context: moc)
        newCat.strCategory = name
        newCat.isArchive = false
        do {
            try moc.save()
            db.fetchCategory()
            db.fetchArchivedArea()
        } catch {
            print("Error save area ",error)
        }
    }
    private func saveIngredient(for name: String ) throws {
        let newIng = Ingredient(context: moc)
        newIng.strIngredient = name
        newIng.isArchive = false
        do {
            try moc.save()
            db.fetchIngredient()
            db.fetchArchivedArea()
        } catch {
            print("Error save area ",error)
        }
    }
    private func archiveIngredient(_ ingredient: Ingredient) {
        ingredient.isArchive.toggle()
        ingredient.timeStamp = Date()
        do {
            try moc.save()
            db.fetchIngredient()
            db.fetchArchivedIngredient()
        } catch {
            print("Error archiving ingredient ", error)
        }
    }
    private func archiveCategory(_ category: Category) {
        print("archive area \(category.wrappedName)")
        category.isArchive.toggle()
        category.timeStamp = Date()
        do {
            try moc.save()
            db.fetchCategory()
            db.fetchArchivedCategory()
        } catch {
            print("Error archiving category ", error)
        }
    }
    private func archiveArea(_ area: Area) {
        print("archive area \(area.wrappedName)")
        area.isArchive.toggle()
        area.timeStamp = Date()
        do {
            try moc.save()
            db.fetchArea()
            db.fetchArchivedArea()
        } catch {
            print("Error archiving area ", error)
        }
    }
    var body: some View {
        List {
            //  Show saved db or show searches
            if showArchive {
                // Show DATABASE
                if title == "Landområder", !db.areas.isEmpty {
                    ForEach(db.areas, id: \.self) { area in
                        Text(area.wrappedName)
                            .swipeActions(edge: .leading) {
                                Button {
                                    self.isArea = area
                                    self.isEdit.toggle()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    Task { @MainActor in
                                        //print("area \(area.wrappedName)")
                                        archiveArea(area)
                                    }
                                } label: {
                                    Image(systemName: "tray.and.arrow.down.fill")
                                }.tint(.accentColor)
                            }
                    }
                }
                if title == "Kategorier", !db.categories.isEmpty {
                    ForEach(db.categories, id: \.self) { cat in
                        Text(cat.wrappedName)
                            .swipeActions(edge: .leading) {
                                Button {
                                    self.isCategory = cat
                                    self.isEdit.toggle()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    Task { @MainActor in
                                        //print("category \(cat.wrappedName)")
                                        archiveCategory(cat)
                                    }
                                } label: {
                                    Image(systemName: "tray.and.arrow.down.fill")
                                }.tint(.accentColor)
                            }
                    }
                }
                if title == "Ingredienser", !db.ingredients.isEmpty {
                    ForEach(db.ingredients, id: \.self) { ing in
                        Text(ing.wrappedName)
                            .swipeActions(edge: .leading) {
                                Button {
                                    self.isIngredient = ing
                                    self.isEdit.toggle()
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    Task { @MainActor in
                                        //print("ingredient \(ing.wrappedName)")
                                        archiveIngredient(ing)
                                    }
                                } label: {
                                    Image(systemName: "tray.and.arrow.down.fill")
                                }.tint(.accentColor)
                            }
                    }
                }
            } else { // Else show searches from API
                
                if let areas: AreaDTO = searchObj.currentResult.area {
                    ForEach(areas.meals.indices, id: \.self) { index in
                        let area = areas.meals[index]
                        LazyHStack {
                            SettingsRowView(for: area)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task { @MainActor in
                                    try saveArea(for: area.strArea ?? "")
                                    searchObj.currentResult.area?.meals.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                            }.tint(.accentColor)
                        }
                    }
                } // if area
                if let categories: CategoryDTO = searchObj.currentResult.category,
                   let wrapped = categories.categories {
                    ForEach(wrapped.indices, id: \.self) { index in
                        let category = wrapped[index]
                        LazyHStack {
                            SettingsRowView(for: category)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task { @MainActor in
                                    try saveCategory(for: category.strCategory)
                                    searchObj.currentResult.category?.categories?.remove(at: index)
                                }
                            }  label: {
                                Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                            }.tint(.accentColor)
                        }
                    }
                } // if cat
                if let ingredients: IngredientDTO = searchObj.currentResult.ingredient,
                   let wrapped = ingredients.meals {
                    ForEach(wrapped.indices, id: \.self) { index in
                        let ing = wrapped[index]
                        LazyHStack {
                            SettingsRowView(for: ing)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task { @MainActor in
                                    try saveIngredient(for: ing.wrappedStrIngredient)
                                    searchObj.currentResult.ingredient?.meals?.remove(at: index)
                                }
                            }  label: {
                                Image(systemName: "square.grid.3x1.folder.fill.badge.plus")
                            }.tint(.accentColor)
                        }
                    }
                } // if ing
            }
            
        }
        .imageScale(.large)
        .navigationTitle(title)
        // TOOLBARS FOR SAVED MISC. AND ADD NEW MISC.
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showArchive.toggle()
                    //print(showArchive)
                } label: {
                    Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSheet.toggle()
                    //print(isSheet.description)
                    showArchive = false
                } label: {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "plus.circle" : "plus.circle.fill")
                            .frame(width: 60, alignment: .center)
                    }
                }
            }
        }// toolbar
        .sheet(isPresented: $isEdit) {
            SheetDetailView(isArea: $isArea, isCategory: $isCategory, isIngredient: $isIngredient, isEdit: $isEdit)
                .presentationDetents([.fraction(0.33)])
        }
        
    }
}

/**
 Workaround with state showing
 Somehow sate are not persisted before sheet is "created" so one way to solve it is to bind it via View...
 Pretty funny you don't need to clean up
 */
struct SheetDetailView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var searchObj: SearchObject
    @EnvironmentObject private var db: SharedDBData
    @Binding var isArea: Area?
    @Binding var isCategory: Category?
    @Binding var isIngredient: Ingredient?
    @Binding var isEdit: Bool
    
    var body: some View {
        let sanitize = searchObj.currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
        
        VStack {
            HStack {
                Button {
                    isEdit.toggle()
                } label: {
                    Text("Avbryt")
                }
                Spacer()
                Image(systemName: "square.and.pencil")
            }.padding()
            if let area = isArea {
                Form {
                    Text("Original name: \(area.wrappedName)")
                    TextField("Area name", text: $searchObj.currentInput)
                    Button {
                        area.strArea = searchObj.currentInput
                        Task {
                            do {
                                try moc.save()
                                isEdit = false
                                searchObj.resetInput()
                            } catch {
                                print("Error saving: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Save")
                            Image(systemName: "paperplane.circle")
                        }
                    }.disabled(sanitize.isEmpty)
                }
            }
            
            if let cat = isCategory {
                Form {
                    Text("Original name: \(cat.wrappedName)")
                    TextField("Category name", text: $searchObj.currentInput)
                    Button {
                        cat.strCategory = searchObj.currentInput
                        Task {
                            do {
                                try moc.save()
                                isEdit = false
                                searchObj.resetInput()
                            } catch {
                                print("Error saving: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Save")
                            Image(systemName: "paperplane.circle")
                        }
                    }.disabled(sanitize.isEmpty)
                }
            }
            
            if let ing = isIngredient {
                Form {
                    Text("Original name: \(ing.wrappedName)")
                    TextField("Ingredient name", text: $searchObj.currentInput)
                    Button {
                        ing.strIngredient = searchObj.currentInput
                        Task {
                            do {
                                try moc.save()
                                isEdit = false
                                searchObj.resetInput()
                            } catch {
                                print("Error saving: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Save")
                            Image(systemName: "paperplane.circle")
                        }
                    }.disabled(sanitize.isEmpty)
                }
            }
        }
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
