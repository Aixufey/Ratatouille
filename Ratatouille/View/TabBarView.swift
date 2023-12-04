//
//  TabBarView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        ZStack {
            if settings.isSplashView {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 1.5)) {
                                    settings.isSplashView.toggle()
                                }
                            }
                        }
                    SplashView()
                }
            } else {
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
