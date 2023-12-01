//
//  TabBarView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        
        TabView {
            RecipesListView()
                .tabItem {
                    Label("Mine oppskrifter", systemImage: "fork.knife.circle")
                }
            SearchView()
                .tabItem {
                    Label("Søk", systemImage: "magnifyingglass.circle")
                }
            SettingsView()
                .environmentObject(SearchObject().self)
                .tabItem {
                    Label("Innstillinger", systemImage: "gearshape")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(SearchObject().self)
            .environmentObject(AppSettings().self)
            .environmentObject(UnifiedModelData().self)
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
    }
}
