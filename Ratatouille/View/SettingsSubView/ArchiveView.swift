//
//  ArchiveView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct ArchiveView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var db: SharedDBData
    @EnvironmentObject var settings: AppSettings
    @State private var dummies = ["Item 1", "Item 2", "Item 3"]
    private func deleteMeal(_ meal: Meal) {
        moc.delete(meal)
        do {
            try moc.save()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
        db.fetchArchivedMeal()
    }
    private func deleteArea(_ area: Area) {
        moc.delete(area)
        do {
            try moc.save()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
        db.fetchArchivedArea()
    }
    private func restoreArea(_ area: Area) {
        area.isArchive.toggle()
        do {
            try moc.save()
        } catch {
            print("Error restoring ", error)
        }
        db.fetchArchivedArea()
        db.fetchArea()
    }
    private func restoreMeal(_ meal: Meal) {
        meal.isArchive.toggle()
        do {
            try moc.save()
        } catch {
            print("Error restoring ", error)
        }
        db.fetchArchivedMeal()
        db.fetchMeal()
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
                    ForEach(db.archivedAreas, id: \.id) { area in
                        VStack(alignment: .leading) {
                            Text(area.wrappedName)
                            Text("Arkivert: \(area.wrappedTimeStamp)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.33)) {
                                    DispatchQueue.main.async {
                                        deleteArea(area)
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        restoreArea(area)
                                    }
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
                    ForEach(db.archivedCategories, id: \.id) { cat in
                        VStack(alignment: .leading) {
                            Text(cat.wrappedName)
                            Text("Arkivert: \(cat.wrappedTimeStamp)")
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.33)) {
                                    DispatchQueue.main.async {
                                        
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        
                                    }
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
                                withAnimation(.easeInOut(duration: 0.33)) {
                                    DispatchQueue.main.async {
                                        
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        
                                    }
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.33)) {
                                    DispatchQueue.main.async {
                                        deleteMeal(meal)
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        restoreMeal(meal)
                                    }
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
    }
    
    private func deleteItem(at index: Int) {
        dummies.remove(at: index)
        print("deleted")
    }
    private func restoreItem(for item: String) {
        dummies.append(item)
        print("restore")
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
