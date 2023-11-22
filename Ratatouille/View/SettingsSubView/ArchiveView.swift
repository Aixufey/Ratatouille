//
//  ArchiveView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var dummies = ["Item 1", "Item 2", "Item 3"]
    
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
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "fork.knife.circle" : "fork.knife.circle.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte matoppskrifter")
                    }.foregroundColor(.blue)
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
        ArchiveView().environmentObject(AppSettings().self)
    }
}
