//
//  IngredientsView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct IngredientsView: View {
    @EnvironmentObject private var settings: AppSettings
    var body: some View {
        List {
            ForEach(Ingredient.dummy, id: \.hashValue) { ingredient in
                NavigationLink(destination: CategoryDetailView()) {
                    SettingsRowView(for: ingredient)
                }
            }
        }
        .imageScale(.large)
        .navigationTitle("Ingredienser")
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

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView().environmentObject(AppSettings().self)
    }
}
