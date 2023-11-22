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
                .tabItem {
                    Label("Innstillinger", systemImage: "gearshape")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView().environmentObject(AppSettings().self)
    }
}
