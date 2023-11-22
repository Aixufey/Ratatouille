//
//  CategoriesView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var settings: AppSettings
    var body: some View {
        List {
            ForEach(Category.dummy) {category in
                NavigationLink(destination: CategoryDetailView()) {
                    SettingsRowView(for: category)
                }
            }
        }
        .imageScale(.large)
        .navigationTitle("Kategorier")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: settings.isDarkMode ? "plus.circle" : "plus.circle.fill")
                        .frame(width: 60, alignment: .center)
                }
                
            }
        }
    }
}

struct CategoryDetailView: View {
    var body: some View {
        Text("Detail View")
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView().environmentObject(AppSettings().self)
    }
}
