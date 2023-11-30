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
    private func deleteItem(_ meal: Meal) {
        moc.delete(meal)
        do {
            try moc.save()
        } catch {
            print("Error deleting ", error)
            moc.rollback()
        }
        db.fetchArchive()
    }
    private func restoreItem(_ meal: Meal) {
        meal.isArchive.toggle()
        do {
            try moc.save()
        } catch {
            print("Error restoring ", error)
        }
        db.fetchArchive()
        db.fetchMeal()
    }
    var body: some View {
        List {
            Section(header: Text("Landområder")) {
                HStack {
                    Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                        .frame(width: 30, alignment: .center)
                    Text("Arkiv")
                }.foregroundColor(.blue)
            }
            
            Section(header: Text("Kategorier")) {
                HStack {
                    Image(systemName: settings.isDarkMode ? "doc.plaintext" : "doc.plaintext.fill")
                        .frame(width: 30, alignment: .center)
                    Text("Ingen arkiverte kategorier")
                }.foregroundColor(.blue)
            }
            
            Section(header: Text("Ingredienser")) {
                if !dummies.isEmpty {
                    ForEach(dummies.indices, id: \.self) { index in
                        Text(dummies[index])
                            .swipeActions(edge: .trailing) {
                                Button {
                                    deleteItem(at: index)
                                } label: {
                                    Image(systemName: "trash")
                                    
                                }.tint(.red)
                                Button {
                                    restoreItem(for: dummies[index])
                                } label: {
                                    Image(systemName: settings.isDarkMode ? "tray.and.arrow.up.fill" : "tray.and.arrow.up")
                                }
                            }
                    }
                } else {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "carrot" : "carrot.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte ingredienser")
                    }.foregroundColor(.blue)
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
                                        deleteItem(meal)
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.red)
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    DispatchQueue.main.async {
                                        restoreItem(meal)
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
            .environmentObject(IsEmptyResult().self)
            .environmentObject(UnifiedModelData().self)
    }
}
