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
    
    private func deleteItem(at offsets: IndexSet) {
        print("deleted")
    }
    var body: some View {
        List {
            Section {
                Text("Arkiv")
            } header: {
                Text("Landområder")
            }
            
            Section {
                Text("Ingen arkiverte kategorier")
            } header: {
                Text("Kategorier")
            }
            
            Section {
                ForEach(dummies, id: \.self) { dummy in
                    Text(dummy)
                        .swipeActions(edge: .trailing) {
                            Button {
                                
                            } label: {
                                Image(systemName: "trash")
                
                            }.tint(.red)
                            Button {
                                
                            } label: {
                                Image(systemName: settings.isDarkMode ? "tray.and.arrow.up.fill" : "tray.and.arrow.up")
                            }
                            
                        }
                }
                .onDelete(perform: deleteItem)
                
                    
            } header: {
                Text("Kategorier")
            }
            
            
            Section {
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "fork.knife.circle" : "fork.knife.circle.fill")
                            .frame(width: 30, alignment: .center)
                        Text("Ingen arkiverte matoppskrifter")
                    }
                }
            } header: {
                HStack {
                    Text("Matoppskrifter")
                }
            }
        }
        .navigationTitle("Arkiv")
        .toolbar {
            EditButton()
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView().environmentObject(AppSettings().self)
    }
}
