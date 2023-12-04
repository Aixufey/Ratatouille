//
//  ArchiveView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI
import Kingfisher

struct ArchiveView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var db: SharedDBData
    @EnvironmentObject private var settings: AppSettings
    @State private var isSheet: Bool = false
    @State var selectedMeal: Meal?
    
    private func deleteMeal(_ meal: Meal) {
        moc.delete(meal)
        do {
            try moc.save()
            db.fetchArchivedMeal()
            db.fetchMeal()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
    }
    private func restoreMeal(_ meal: Meal) {
        meal.isArchive.toggle()
        do {
            try moc.save()
            db.fetchArchivedMeal()
            db.fetchMeal()
        } catch {
            print("Error restoring ", error)
        }
    }
    private func deleteArea(_ area: Area) {
        moc.delete(area)
        do {
            try moc.save()
            db.fetchArchivedArea()
            db.fetchArea()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
    }
    private func restoreArea(_ area: Area) {
        area.isArchive.toggle()
        do {
            try moc.save()
            db.fetchArchivedArea()
            db.fetchArea()
        } catch {
            print("Error restoring ", error)
        }
    }
    private func deleteCategory(_ category: Category) {
        moc.delete(category)
        do {
            try moc.save()
            db.fetchArchivedCategory()
            db.fetchCategory()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
    }
    private func restoreCategory(_ category: Category) {
        category.isArchive.toggle()
        do {
            try moc.save()
            db.fetchArchivedCategory()
            db.fetchCategory()
        } catch {
            print("Error restoring ", error)
        }
    }
    private func deleteIngredient(_ ingredient: Ingredient) {
        moc.delete(ingredient)
        do {
            try moc.save()
            db.fetchArchivedIngredient()
            db.fetchIngredient()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
    }
    private func restoreIngredient(_ ingredient: Ingredient) {
        ingredient.isArchive.toggle()
        do {
            try moc.save()
            db.fetchArchivedIngredient()
            db.fetchIngredient()
        } catch {
            print("Error restoring ", error)
        }
    }
    var body: some View {
        List {
            Section(header: Text("Landområder")) {
                if db.archivedAreas.isEmpty {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte landområder")
                    }.foregroundColor(.blue)
                } else {
                    ForEach(db.archivedAreas, id: \.idArea) { area in
                        VStack(alignment: .leading) {
                            Text(area.wrappedName)
                            Text("Arkivert: \(area.wrappedTimeStamp)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                Task {
                                    deleteArea(area)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                Task {
                                    restoreArea(area)
                                }
                            } label: {
                                Image(systemName: "tray.and.arrow.up")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Kategorier")) {
                if db.archivedCategories.isEmpty {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "doc.plaintext" : "doc.plaintext.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte kategorier")
                    }.foregroundColor(.blue)
                } else {
                    ForEach(db.archivedCategories, id: \.idCategory) { cat in
                        VStack(alignment: .leading) {
                            Text(cat.wrappedName)
                            Text("Arkivert: \(cat.wrappedTimeStamp)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                Task {
                                    deleteCategory(cat)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                Task {
                                    restoreCategory(cat)
                                }
                            } label: {
                                Image(systemName: "tray.and.arrow.up")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Ingredienser")) {
                if db.archivedIngredients.isEmpty {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "carrot" : "carrot.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte ingredienser")
                    }.foregroundColor(.blue)
                } else {
                    ForEach(db.archivedIngredients, id: \.idIngredient) { ing in
                        VStack(alignment: .leading) {
                            Text(ing.wrappedName)
                            Text("Arkivert: \(ing.wrappedTimeStamp)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                Task {
                                    deleteIngredient(ing)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                Task {
                                    restoreIngredient(ing)
                                }
                            } label: {
                                Image(systemName: "tray.and.arrow.up")
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Matoppskrifter")) {
                if db.archivedMeals.isEmpty {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "fork.knife.circle" : "fork.knife.circle.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte matoppskrifter")
                    }.foregroundColor(.blue)
                } else {
                    ForEach(db.archivedMeals, id: \.idMeal) { meal in
                        VStack(alignment: .leading) {
                            Text(meal.wrappedName)
                            Text("Arkivert: \(meal.wrappedtimeStamp)")
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                isSheet.toggle()
                                self.selectedMeal = meal
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                Task {
                                    deleteMeal(meal)
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                Task {
                                    restoreMeal(meal)
                                }
                            } label: {
                                Image(systemName: "tray.and.arrow.up")
                            }
                        }
                    }
                }
            }
        }// List
        .navigationTitle("Arkiv")
        .sheet(isPresented: $isSheet) {
            ArchiveSheetView(current: $selectedMeal, isSheet: $isSheet)
                .presentationDetents([.fraction(0.7)])
        }
    }
}

struct ArchiveSheetView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var db: SharedDBData
    @EnvironmentObject private var searchObj: SearchObject
    @Binding var current: Meal?
    @Binding var isSheet: Bool
    @State private var isEditName: Bool = false
    @State private var isEditCategory: Bool = false
    @State private var isEditArea: Bool = false
    @State private var newName: String = ""
    @State private var newCategory: String = ""
    @State private var newArea: String = ""
    private let maxLength: Int = 25

    private var isSaveEnabled: Bool {
        !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !newArea.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func truncateTxt(for text: String) -> String {
        if text.count > maxLength {
            let i = text.index(text.startIndex, offsetBy: maxLength)
            return String(text[..<i]).appending("...")
        } else {
            return text
        }
    }

    var body: some View {
        if let meal = current {
            VStack {
                HStack {
                    Spacer()
                    Text("Redigere \(truncateTxt(for: meal.wrappedName))")
                        .offset(x: 20)
                    Spacer()
                    Button {
                        isSheet.toggle()
                    } label: {
                        Text("Avbryt")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                
                KFImage(URL(string: meal.wrappedThumb))
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 150, height: 150)
                    .overlay(Circle().stroke(Color(.systemPurple), lineWidth: 4))
                    .padding()
                    .padding(.top)
                
                
                Form {
                    HStack {
                        if isEditName {
                            TextField("New name..", text: $newName)
                        } else {
                            Text("Original name: \(meal.wrappedName)")
                        }
                        Spacer()
                        EditButton(isEditing: $isEditName)
                    }
                    HStack {
                        if isEditCategory {
                            TextField("New category..", text: $newCategory)
                        } else {
                            Text("Original category: \(meal.wrappedCategory)")
                        }
                        Spacer()
                        EditButton(isEditing: $isEditCategory)
                    }
                    HStack {
                        if isEditArea {
                            TextField("New area..", text: $newArea)
                        } else {
                            Text("Original area: \(meal.wrappedArea)")
                        }
                        Spacer()
                        EditButton(isEditing: $isEditArea)
                    }
                    SaveButton(meal: meal)
                        .disabled(!isSaveEnabled)
                }
            }
        }
    }

    private func EditButton(isEditing: Binding<Bool>) -> some View {
        Image(systemName: "rectangle.and.pencil.and.ellipsis.rtl")
            .onTapGesture {
                isEditing.wrappedValue.toggle()
            }
            .foregroundColor(Color.blue)
    }

    private func SaveButton(meal: Meal) -> some View {
        Button {
            meal.strMeal = searchObj.currentInput
            Task {
                do {
                    try moc.save()
                    db.fetchArchivedMeal()
                    isSheet = false
                    searchObj.resetInput()
                } catch {
                    print("Error saving: \(error.localizedDescription)")
                }
            }
        } label: {
            HStack(alignment: .center) {
                Text("Save")
                Image(systemName: "paperplane.circle")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(AppSettings().self)
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
            .environmentObject(SearchObject().self)
            .environmentObject(UnifiedModelData().self)
    }
}
